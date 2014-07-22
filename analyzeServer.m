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

dataDir = '~/weiyun/code/ist_repo/simgrid_data/data/';
non_qoe_dir = strcat(dataDir, 'nonQoE', scenario, '/');
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');

server_files = dir([non_qoe_dir 'Server*traffic.csv']);

plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', '-+r', '-sb', '-dg'};
numServers = size(server_files, 1);

legendStrs = {};
mn_load_non_qoe = [];
std_load_non_qoe = [];
h1 = figure(1);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([non_qoe_dir server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    lgStr = strcat('String\_', lgNumStr);
    legendStrs = [legendStrs, lgStr];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    std_load = std(load);
    mn_load_non_qoe = [mn_load_non_qoe; mn_load];
    std_load_non_qoe = [std_load_non_qoe; std_load];
    if length(load) > 400
	load = load(1:400);
    end
    % plot(load, plotLines{i}, 'LineWidth', 2);
end
errorbar(mn_load_non_qoe, std_load_non_qoe);
set(gca, 'XTick', 1:length(legendStrs), 'XTickLabel', legendStrs);
title('Server load for non-qoe server selection.', 'FontSize',16);
hold off;
print(h1, '-dpng', ['./rstImgs/sLoads_Error_nonQoE_' scenario '.png']);

legendStrs = {};
mn_load_non_coop = [];
std_load_non_coop = [];
h2 = figure(2);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([non_cooperation_dir server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    lgStr = strcat('String\_', lgNumStr);
    legendStrs = [legendStrs, lgStr];
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
set(gca, 'XTick', 1:length(legendStrs), 'XTickLabel', legendStrs);
title('Server load for non-cooperation qoe driven server selection.', 'FontSize',16);
hold off;
print(h2, '-dpng', ['./rstImgs/sLoads_Error_nonCoop' scenario '.png']);

legendStrs = {};
mn_load_coop = [];
std_load_coop = [];
h3 = figure(3);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([cooperation_dir server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(server_files(i).name, '[0-9]+', 'match');
    lgStr = strcat('Server\_', lgNumStr);
    legendStrs = [legendStrs, lgStr];
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
set(gca, 'XTick', 1:length(legendStrs), 'XTickLabel', legendStrs);
title('Server load for cooperation enabled qoe driven server selection.', 'FontSize',16);
hold off;
print(h3, '-dpng', ['./rstImgs/sLoads_Error_coop' scenario '.png']);


mn_load_mat = [mn_load_non_qoe mn_load_non_coop mn_load_coop];
h4 = figure(4);
hold on;
bar(mn_load_mat);
legend('Non QoE Driven', 'Non Cooperation', 'Cooperation');
set(gca, 'XTick', 1:length(legendStrs), 'XTickLabel', legendStrs);
title('Average server load', 'FontSize',16);
hold off;
print(h3, '-dpng', ['./rstImgs/serverLoad_bars' scenario '.png']);
