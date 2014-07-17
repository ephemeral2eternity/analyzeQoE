%% Compute Traffic out of server by msg sent out data
% Chen Wang
% computeTraffic.m

function traffic = computeTraffic(msgData)
    ts = msgData(:, 1);
    msgSz = msgData(:, 2);
    tEnd = ceil(ts(end));
    traffic = zeros(tEnd, 1);
    for t = 1 : tEnd
        traffic(t) = sum(msgSz((ts < t) & (ts >= t - 1)));
    end
end