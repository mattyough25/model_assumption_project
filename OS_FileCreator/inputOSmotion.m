function inputOSmotion(time,nMotion,sDOF,varargin)
in.filename = [date,'_Trial'];

if ~isempty(varargin)
   for i = 1:numel(varargin)/2
      in.(varargin{(i-1)*2+1}) = varargin{i*2};
   end
end

nDataList = ['time';sDOF];
nData = [time;nMotion]';

stoWriter(nDataList,nData,[date,in.filename,'.mot'])