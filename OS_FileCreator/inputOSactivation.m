function inputOSactivation(time,nAct,sMuscle,varargin)
in.filename = [date,'_Trial'];

if ~isempty(varargin)
   for i = 1:numel(varargin)/2
      in.(varargin{(i-1)*2+1}) = varargin{i*2};
   end
end

% nScale = [0 ...                                                         %1
%           0 0 0 0 0 0 0 0 0 0 ...                                       %2        
%           0 ...                                                         %3                                           
%           0 0 ...                                                       %4                                       
%           0 0 0 0 0 0 0 0 0 0 0 0 ...                                   %5
%           0 0 0 ...                                                     %6               
%           0 0 ...                                                       %7   
%           0 0 0 ...                                                     %8
%           0 0 ...                                                       %9   
%           0.5 0.5 0.5 0.5 ...                                           %10
%           0 0 ...                                                       %11    
%           0 0 0 0 0 ...                                                 %12   
%           0 0 0 0 0];                                                   %13


nDataList = ['time';sMuscle];
nData = [time;nAct]';

stoWriter(nDataList,nData,[date,in.filename,'.sto'])