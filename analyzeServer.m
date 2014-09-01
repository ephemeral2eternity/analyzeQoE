%% Analyze the data collected from simgrid simulations on a hierarchical  
% node topology.
% Comparison workload from servers
% Chen Wang
% analyzeServer.m

clc;
clear all;
close all;
nBin = 100;

scenario = 'Sce0';

dataDir = '~/weiyun/code/ist_repo/data/data_expD/';
non_qoe_dir = strcat(dataDir, 'nonQoE', scenario, '/');
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');

server_files = dir([non_qoe_dir 'Server*traffic.csv']);

plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', '-+r', '-sb', '-dg'};
numServers = size(server_files, 1);

serverNames = {};
mn_load_non_qoe = [];
std_load_non_qoe = [];
h1 = figure(1);
hold on;
% load server traffic files
for i = 1 : numServers
    try
        dat = csvimport([non_qoe_dir server_files(i).name], 'noHeader', true);
    catch
        mn_load_non_qoe = [mn_load_non_qoe; 0];
        std_load_non_qoe = [std_load_non_qoe; 0];
        break;
    end
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    srvName = strcat('Server_', lgNumStr);
    serverNames = [serverNames, srvName];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    std_load = std(load);
    mn_load_non_qoe = [mn_load_non_qoe; mn_load];
    std_load_non_qoe = [std_load_non_qoe; std_load];
end
errorbar(mn_load_non_qoe, std_load_non_qoe);
set(gca, 'XTick', 1:length(serverNames), 'XTickLabel', serverNames);
title('Server load for non-qoe server selection.', 'FontSize',16);
hold off;
print(h1, '-dpng', ['./rstImgs/sLoads_Error_nonQoE_' scenario '.png']);

serverNames = {};
mn_load_non_coop = [];
std_load_non_coop = [];
h2 = figure(2);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([non_cooperation_dir server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    srvName = strcat('Server_', lgNumStr);
    serverNames = [serverNames, srvName];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    std_load = std(load);
    mn_load_non_coop = [mn_load_non_coop; mn_load];
    std_load_non_coop = [std_load_non_coop; std_load];
    if length(load) > 400
	load = load(1:400);
    end
    % plot(load, plotLines{i}, 'LineWidth', 2);
end
% legend(legendStrs);
errorbar(mn_load_non_coop, std_load_non_coop);
set(gca, 'XTick', 1:length(serverNames), 'XTickLabel', serverNames);
title('Server load for non-cooperation qoe driven server selection.', 'FontSize',16);
hold off;
print(h2, '-dpng', ['./rstImgs/sLoads_Error_nonCoop' scenario '.png']);

serverNames = {};
mn_load_coop = [];
std_load_coop = [];
h3 = figure(3);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([cooperation_dir server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    srvName = strcat('Server_', lgNumStr);
    serverNames = [serverNames, srvName];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    std_load = std(load);
    mn_load_coop = [mn_load_coop; mn_load];
    std_load_coop = [std_load_coop; std_load];
%     if length(load) > 400
% 	load = load(1:400);
%     end
%     plot(load, plotLines{i}, 'LineWidth', 1);
end
% legend(legendStrs);
errorbar(mn_load_non_coop, std_load_non_coop);
set(gca, 'XTick', 1:length(serverNames), 'XTickLabel', serverNames);
title('Server load for cooperation enabled qoe driven server selection.', 'FontSize',16);
hold off;
print(h3, '-dpng', ['./rstImgs/sLoads_Error_coop' scenario '.png']);


mn_load_mat = [mn_load_non_qoe mn_load_non_coop mn_load_coop];
std_load_mat = [std_load_non_qoe std_load_non_coop std_load_coop];
h4 = figure(4);
hold on;
barwitherr(mn_load_mat, std_load_mat);
legend('Non QoE Driven', 'Non Cooperation', 'Cooperation');
set(gca, 'XTick', 1:length(serverNames), 'XTickLabel', serverNames, 'FontSize',16);
ylabel('Traffic load (mean, std) on all servers (Mbps)', 'FontSize',16);
title('Average server load', 'FontSize',16);
hold off;
print(h3, '-dpng', ['./rstImgs/serverLoad_bars' scenario '.png']);
