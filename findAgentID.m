%% Find the targe server ID from a list of server IDs.
% Chen Wang
% findAgentID.m

function agentInd = findAgentID(srvNames, serverID)
    agentInd = 1;
    for i = 1 : length(srvNames)
        curID = regexp(srvNames{i}, '[0-9]+', 'match');
        curID = curID{1, 1};
        if length(curID) == length(serverID)
            if curID == serverID
                agentInd = i;
                break;
            end
        end
    end
end