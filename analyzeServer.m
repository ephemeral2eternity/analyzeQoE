%% Analyze the data collected from simgrid simulations on a hierarchical  
% node topology.
% Comparison qoe assessment from servers
% Chen Wang
% analyzeServer.m

clc;
clear all;
close all;
nBin = 100;

scenario = 'Sce0'
dataDir = '~/chenw/matlab/simgrid_data/data/'
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');
non_cooperate_server_files = dir([non_cooperation_dir 'Server*traffic.csv']);
cooperate_server_files = dir([cooperation_dir 'Server*traffic.csv']);

plotLines = {'-b', '--r', '-+g', '-.k', '-*y', '-.ob', ':r', '-sb', '-dg'};
numServers = size(non_cooperate_server_files, 1);

legendStrs = {};
mn_load_non_coop = [];
h1 = figure(1);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([non_cooperation_dir non_cooperate_server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(non_cooperate_server_files(i).name, '[0-9]+', 'match');
    lgStr = strcat('String\_', lgNumStr);
    legendStrs = [legendStrs, lgStr];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    mn_load_non_coop = [mn_load_non_coop; mn_load];
    if length(load) > 400
	load = load(1:400);
    end
    plot(load, plotLines{i}, 'LineWidth', 2);
end
legend(legendStrs);
hold off;
print(h1, '-dpng', ['./rstImgs/sLoads_nonCoop_' scenario '.png']);

legendStrs = {};
mn_load_coop = [];
h2 = figure(2);
hold on;
% load server traffic files
for i = 1 : numServers
    dat = csvimport([cooperation_dir cooperate_server_files(i).name], 'noHeader', true);
    lgNumStr = regexp(cooperate_server_files(i).name, '[0-9]+', 'match');
    lgStr = strcat('String\_', lgNumStr);
    legendStrs = [legendStrs, lgStr];
    load = cell2mat(dat(:, 2));
    mn_load = mean(load);
    mn_load_coop = [mn_load_coop; mn_load];
    if length(load) > 400
	load = load(1:400);
    end
    plot(load, plotLines{i}, 'LineWidth', 2);
end
legend(legendStrs);
hold off;
print(h2, '-dpng', ['./rstImgs/sLoads_coop_' scenario '.png']);

mn_load_mat = [mn_load_non_coop mn_load_coop];
h3 = figure(3);
hold on;
bar(mn_load_mat);
legend('Non Cooperation', 'Cooperation');
hold off;
print(h3, '-dpng', ['./rstImgs/serverLoad_bars_' scenario '.png']);
