function nRMSE = calcRMSE(nData1,nData2)

nRMSE = sqrt(sum((nData1-nData2).^2)./numel(nData1));