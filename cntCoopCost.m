%% Count Cooperation Traffic Cost.
% Use QoE update records to count the cooperation traffic
% Chen Wang
% cntCoopCost.m

clc;
clear all;
close all;

scenario = 'Sce0';

dataDir = '~/weiyun/code/ist_repo/simgrid_data/data/';
cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
server_files = dir([cooperation_dir 'Server*qoe.csv']);

plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', '-+r', '-sb', '-dg'};
numServers = size(server_files, 1);

srvNames = {};
srvLegends = {};
period = 10;
t = 0 : period : 4000;

coopTraffic = [];
for i = 1 : numServers
    fileName = server_files(i).name;
    filePath = [cooperation_dir fileName];
    srvID = regexp(fileName, '[0-9]+', 'match');
    srvID = srvID{1};
    if length(srvID) ~= 1
        srvName = strcat('Server_', srvID);
        srvLg = strcat('Server\_', srvID);
        srvLegends = [srvLegends, srvLg];
        srvNames = [srvNames, srvName];

        dat = csvimport(filePath, 'delimiter', '\t');
        ts_dat = cell2mat(dat(2:end, end));
        traffic = hist(ts_dat, t) .* 2 / period;
        coopTraffic = [coopTraffic; traffic];
    end
end

h1 = figure(1);
hold on;
for i = 1 : size(coopTraffic, 1)
    plot(coopTraffic(i, :), plotLines{i});
end
legend(srvNames);
hold off;
print(h1, '-dpng', ['./rstImgs/coopTraffic-' scenario '.png']);

mn_traffic = mean(coopTraffic, 2);
std_traffic = std(coopTraffic, 0, 2);
h2 = figure(2);
errorbar(mn_traffic, std_traffic);
set(gca, 'XTick', 1:length(srvNames), 'XTickLabel', srvNames);
legend(srvNames);
hold off;