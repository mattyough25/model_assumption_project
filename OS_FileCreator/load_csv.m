% function TABLE = load_csv( PROPERTIES )
% READ COMMA-SEPARATED-VALUES (CSV) IN ASCII FILES
% 
% PROPERTIES --------------------------------------------------------------
%  sPath        <str> file path                    (default: cd)
%  sFile        <str> file name; ask, if empty     (default: '');
%  sMessage     <str> prompt message           (default: 'Pick data files')
%  sPathWork    <str> file path                (default: cd)
%  nSampleStart <num> read from this sample    (default: 1)
%  nSampleEnd   <num> read to this sample      (default: NaN = end of file)
%
% NOTE --------------------------------------------------------------------
%  Exception is made for columns containing "List" in their names. The data
%  may contain number arrays and cannot be 'numeric' type.
%  
% OUTPUT ------------------------------------------------------------------
%  TABLE        <struc> data in the form TABLE.(sColumnName) = ColumnValues
% 
% EXAMPLE -----------------------------------------------------------------
%  TABLE = load_csv;
%
% EXAMPLE 2: set & get CSV table
%  Table.name     = {'Peter','Jane','Spock','Kate'}; 
%  Table.id       = 1:4;
%  Table.bLogical = [false false true false]; 
%  save_csv(Table,'sFile','mytable.csv');
%  Table2         = load_csv('sFile','mytable.csv')
%
% See also: setCSV, setTable
 
% S.Yakovenko ©2011
% Last Modified: 10-Jul-2012

% Last Modified: 17-Feb-2019 by Trevor Moon
% Added bSingle - convert numeric values to double (default: single)

function TABLE = load_csv(varargin)
in.sPathWork   = cd;
in.sPath       = in.sPathWork;
in.sFile       = '';
in.sEmptyValue = ''; % replaced with NaN
in.sMessage    = 'Pick data files';
in.nSampleStart = 1;
in.nSampleEnd  = nan;
in.bCSVraw     = false;
in.bVerbose    = 1;
in.bSingle     = true;
% Assign inputs
if ~isempty(varargin)
   for i = 1:numel(varargin)/2
      in.(varargin{(i-1)*2+1}) = varargin{i*2};
   end
end

if isempty(in.sFile)
   [in.sPath,in.sFile] = getPath(...
      'sPath'     ,in.sPath,...
      'sPathWork' ,in.sPathWork,...
      'sExt'      ,'csv',...
      'sMessage'  ,in.sMessage);
end
if isempty(in.sFile)
   disp('ERROR: file load cancelled')
   TABLE = [];
   return
end

%%  READ FILE
try
    cd(in.sPath)
catch
    disp(['NO FOLDER FOUND: ',in.sPath])
    return
end

fid         = fopen(in.sFile); % e.g. in.sFile = 'Asymmetric_EMG_Check_Rep_1.0.hpf.csv';
if fid==-1 
   disp(['ERROR OPENING FILE: ',in.sFile])
   error('JANE ERROR CHECK THAT THE PATH IS CORRECT & FILE IS ON THE PATH');
end
sScript     = textscan(fid, '%s', 2, 'Delimiter','\n');
sScript     = sScript{1};
frewind(fid);

% DESCRIBE FIELDS ---------------------------------------------------------
% - Assuming that Row 1 contains field names
sFieldList  = textscan(sScript{1},'%s','Delimiter',',');
sFieldList  = sFieldList{1};
nField      = numel(sFieldList);
sFieldList  = check_field_validity(sFieldList);

% CHECK FOR MS EXPORT PROBLEM
bCSVfix = numel(sFieldList{end})==0;
if bCSVfix
    bNeedFix = zeros(1,nField);
    for iField = 1:nField
        bNeedFix(iField) = numel(sFieldList{iField})==0;
    end
    sFieldList  = sFieldList(~bNeedFix);
    nField      = numel(sFieldList);
end

% FIND VAR TYPE FOR EACH FIELD
sValue      = textscan(sScript{2},'%s','Delimiter',',');
sValue      = sValue{1};
bNumeric    = zeros(1,nField);
bList       = contains(sFieldList,'List'); % special exception for number lists
for iField = 1:nField
   % CHECK FIELD NAME IF EMPTY VALUE
   if numel(sValue)<iField || isempty(sValue{iField})
      if sFieldList{iField}(1) == 's'
         sValue{iField} = '';
      else
         sValue{iField} = '0';
      end
   end
   
   nValue   = str2double(sValue{iField});
   if ~isnan(nValue) && ~bList(iField)   % not a number & not a list
      bNumeric(iField) = 1;
   end
end

if bCSVfix % RUN FIX IF NEEDED
    bNumeric    = bNumeric(~bNeedFix);
    TABLE       = fix_fields(fid, sFieldList, bNumeric);
    fclose(fid);
    cd(in.sPathWork)
    return
end

% --------------------------------------------------------- DESCRIBE FIELDS

% CREATE READING MASK
sMask       = '';
for iField = 1:nField
   if bNumeric(iField) 
      sMask = [sMask,'%f32 ']; % 16bit by default
   else
      sMask = [sMask,'%s '];
   end
end

% COUNT NUMBER OF LINES ---------------------------------------------------
frewind(fid);
chunksize   = 1e6; % read chuncks of 1MB at a time
nLine       = 0; % inlcuding the header line
while ~feof(fid)
    ch      = fread(fid, chunksize, '*uchar');
    if isempty(ch)
        break
    end
    nLine   = nLine + sum(ch == newline | ch == sprintf('\r'));
end
if ch(end)~=newline % when the last is "return"
   nLine = nLine+1;
end
% --------------------------------------------------- COUNT NUMBER OF LINES


% READ DATA BETWEEN SPECIFIED SAMPLES -------------------------------------
frewind(fid);
if isnan(in.nSampleEnd)
   in.nSampleEnd = nLine-1; % end of file minus header
end
nSampleToRead = in.nSampleEnd - in.nSampleStart + 1;
CSV      = textscan(fid, sMask, nSampleToRead,...
      'delimiter'    , ',', ...
      'HeaderLines'  , in.nSampleStart);
% ------------------------------------- READ DATA BETWEEN SPECIFIED SAMPLES



% PREASSIGN VARIABLE SIZE
for iField = 1:nField
   if isempty(CSV{iField})
      if bNumeric(iField)
         TABLE.(sFieldList{iField}) = NaN;
      else
         TABLE.(sFieldList{iField}) = '';
      end
   else
       if isnumeric(CSV{iField}) && ~in.bSingle
           TABLE.(sFieldList{iField}) = double(CSV{iField});
       else
           TABLE.(sFieldList{iField}) = CSV{iField};
       end
   end
end

fclose(fid);
cd(in.sPathWork)

% CHECK EMPTY VALUES
if in.bVerbose
   for iField = 1:nField
      if numel(TABLE.(sFieldList{iField})) ~= nSampleToRead
         disp(['WARNING: EMPTY VALUES IN ',in.sFile,'|',(sFieldList{iField})])
      end
   end
end

% CHECK ID FIELD
sID = table_get_id(TABLE);
if isempty(sID)
    TABLE.id    = 1:numel(TABLE.(sFieldList{1}));
end


function  sFieldList = check_field_validity(sFieldList)
nField      = numel(sFieldList);
for iField = 1:nField
   % do the check & replace as needed
   sFieldList{iField} (sFieldList{iField}=='"') = '';
   sFieldList{iField} (sFieldList{iField}==':') = '';
   sFieldList{iField} (sFieldList{iField}==' ') = '_';
end

function CSV = fix_fields(fid, sFieldList, bNumeric)
% Fix Microsoft output nonsense with multiple empty values in non-existant columns.
frewind(fid);
sScript     = textscan(fid, '%s', 'Delimiter','\n');
sScript     = sScript{1};
nLine       = numel(sScript);

nField = numel(sFieldList);
for iLine = 1:nLine-1
    sLine  = textscan(sScript{iLine+1},'%s','Delimiter',',');
    sLine = sLine{1};
    for iField = 1:nField
        if bNumeric(iField)
            if numel(sLine)<iField || isempty(sLine{iField})
                 CSV.(sFieldList{iField})(iLine) = NaN;
            else
                CSV.(sFieldList{iField})(iLine) = eval( sLine{iField} );
            end
        else
            CSV.(sFieldList{iField})(iLine) = sLine(iField);
        end
    end
end



% HISTORY
% 18-Jul-2013 --- help improved, bVerbose property added
% 10-Jul-2012 --- speed improvement x70
% 09-Apr-2012 --- speed improvement x2
% 06-Apr-2012 --- help update 














