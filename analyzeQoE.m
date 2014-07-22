%% Analyze the data collected from simgrid simulations on a hierarchical  
% node topology.
% Comparison qoe assessment from servers
% Chen Wang
% analyzeQoe.m

clc;
clear all;
close all;
nBin = 100;

scenario = 'Sce0';

dataDir = '~/weiyun/code/ist_repo/simgrid_data/rsts/';
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');
non_cooperate_server_files = dir([non_cooperation_dir 'Server*qoe.csv']);
cooperate_server_files = dir([cooperation_dir 'Server*qoe.csv']);

plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', '-+r', '-sb', '-dg'};
numServers = size(non_cooperate_server_files, 1);
numAgents = numServers - 1;

legendStrs = {};
mn_load_non_coop = [];

fileID = 2;

h1 = figure(1);
hold on;
% load server traffic files
fileName = cooperate_server_files(fileID).name;
filePath = [cooperation_dir cooperate_server_files(fileID).name];
agentID = regexp(fileName, '[0-9]+', 'match');
agentID = agentID{1, 1};

title(['QoE Assessment of all candidate servers on Server\_' agentID]);

dat = csvimport(filePath, 'delimiter', '\t');
srvNames = dat(1, 1 : end - 1);
agentRange = 1 : length(srvNames);
peerRange = 1 : length(srvNames);
agentInd = findAgentID(srvNames, agentID); 
rootInd = findAgentID(srvNames, '0');
rootID = regexp(srvNames{rootInd}, '[0-9]+', 'match');
rootID = rootID{1,1};

peerRange([agentInd rootInd]) = [];
agentRange(rootInd) = [];
peerInd = randsample(peerRange, 1);
peerID = regexp(srvNames{peerInd}, '[0-9]+', 'match');
peerID = peerID{1, 1};

srvQoE = cell2mat(dat(2:end, agentInd));
plot(srvQoE, plotLines{1});

srvQoE = cell2mat(dat(2:end, rootInd));
plot(srvQoE, plotLines{2});

srvQoE = cell2mat(dat(2:end, peerInd));
plot(srvQoE, plotLines{3});

selectedSrvs = {strcat('CacheAgent: Server\_', agentID)  ...
                strcat('RootServer: Server\_', rootID)  ...
                strcat('PeerServer: Server\_', peerID)};

legend(selectedSrvs, 'NorthEastOutside');
hold off;
print(h1, '-dpng', ['./rstImgs/sQoE_coop' scenario '.png']);


numAgents = 4;
mn_qoe_mat = zeros(numAgents, numServers);
agentLgs = {};
h2 = figure(2);
hold on;
% load server traffic files
for i = 1 : numAgents
    agentIdx = agentRange(i);
    fileName = cooperate_server_files(agentIdx).name;
    filePath = [cooperation_dir cooperate_server_files(agentIdx).name];
    agentID = regexp(fileName, '[0-9]+', 'match');
    agentID = agentID{1, 1};
    agentLgs = [agentLgs strcat('Server\_', agentID)];
    
    dat = csvimport(filePath, 'delimiter', '\t');
    serverNames = dat(1, 1 : end - 1);
    
    for k = 1 : length(srvNames)
        targetID = regexp(srvNames{k}, '[0-9]+', 'match');
        targetID = targetID{1, 1};
        foundInd = findAgentID(serverNames, targetID);
        srvQoE = cell2mat(dat(2 : end, foundInd));
        mnQoE = mean(srvQoE);
        mn_qoe_mat(i, k) = mnQoE;
    end
end
bar(mn_qoe_mat');
set(gca, 'XTick', 1:length(srvNames), 'XTickLabel', srvNames);
legend(agentLgs);
hold off;
print(h2, '-dpng', ['./rstImgs/sQoE_coopBar' scenario '.png']);

