%% Analyze the client QOE collected from simgrid simulations on a hierarchical  
% node topology.
% Comparison qoe assessment from clients
% Chen Wang
% analyzeClientQoE.m

clc;
clear all;
close all;
nBin = 100;

scenario = 'Sce1';

dataDir = '~/weiyun/code/ist_repo/simgrid_data/rsts/';
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');
client_files = dir([non_cooperation_dir 'Client*qoe.csv']);

plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', '-+r', '-sb', '-dg'};
numClients = size(client_files, 1);

fileID = randi(numClients);
fileName = client_files(fileID).name;
filePath = [non_cooperation_dir client_files(fileID).name];

disp(['The randomly selected client qoe file is :' fileName]);

h1 = figure(1);
hold on;
% Parse client ID
clientID = regexp(fileName, '[0-9]+', 'match');
clientID = clientID{1, 1};
title(['Non-Cooperate QoE Assessment of all candidate servers on Client\_' clientID]);

% load server traffic files
dat = csvimport(filePath, 'delimiter', '\t');
srvNames = dat(1, 1 : end - 1);
lgSrvNames = processSrvNames(srvNames);
qoeMat = cell2mat(dat(2:end, 1 : end - 1));

numServers = length(srvNames);

for i = 1 : numServers
    plot(qoeMat(:, i), plotLines{i});
end

legend(lgSrvNames, 'NorthEastOutside');
hold off;
print(h1, '-dpng', ['./rstImgs/client-' clientID '-nonCoop-' scenario '.png']);

%% Show cooperate client qoe assessments
coop_fileID = randi(numClients);
coop_fileName = client_files(coop_fileID).name;
coop_filePath = [cooperation_dir client_files(coop_fileID).name];
disp(['The randomly selected clientQoEfile for cooperation enabled control is :' coop_fileName]);

h2 = figure(2);
hold on;
% Parse client ID
clientID = regexp(coop_fileName, '[0-9]+', 'match');
clientID = clientID{1, 1};
title(['Cooperation enabled QoE Assessment of all candidate servers on Client\_' clientID]);

% load server traffic files
dat = csvimport(coop_filePath, 'delimiter', '\t');
srvNames = dat(1, 1 : end - 1);
lgSrvNames = processSrvNames(srvNames);
qoeMat = cell2mat(dat(2:end, 1 : end - 1));

numServers = length(srvNames);

for i = 1 : numServers
    plot(qoeMat(:, i), plotLines{i});
end

legend(lgSrvNames, 'NorthEastOutside');
hold off;
print(h2, '-dpng', ['./rstImgs/client-' clientID '-coop-' scenario '.png']);
