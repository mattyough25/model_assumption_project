function [nMoveRange] = setMoveRange(idDOFlist_move,nRangelist_move,nIC,nRange)

nMoveRange                   = [nIC,nIC];
for iDOF = 1:numel(idDOFlist_move)
    if nRangelist_move(iDOF)>0 % movement into positive direction
        nRange_max = nRange(idDOFlist_move(iDOF),2)-nIC(idDOFlist_move(iDOF)); % maximal range
        nRangeI = nRange_max*nRangelist_move(iDOF)+nIC(idDOFlist_move(iDOF)); % available range relative to IC
        nMoveRange(idDOFlist_move(iDOF),:) = [nIC(idDOFlist_move(iDOF)),nRangeI]; % elbow at 0 deg
    elseif nRangelist_move(iDOF)<0 % movement into negative direction
        nRange_max = nIC(idDOFlist_move(iDOF))+nRange(idDOFlist_move(iDOF),1); % maximal range
        nRangeI = nRange_max*abs(nRangelist_move(iDOF)); % available range relative to IC
        nMoveRange(idDOFlist_move(iDOF),:) = [nIC(idDOFlist_move(iDOF)),nRangeI]; % elbow at 0 deg
    end
end
