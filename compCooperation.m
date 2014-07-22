%% Analyze the data collected from simgrid simulations on a hierarchical 64 
% node topology.
% Comparison among methods with and without cooperations between agents.
% Chen Wang
% compCooperation.m

clc;
clear all;
close all;

scenario = 'Sce0';
dataDir = '~/chenw/matlab/simgrid_data/data/'
non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
cooperation_dir = strcat(dataDir, 'coop', scenario, '/');
non_cooperate_client_files = dir([non_cooperation_dir 'Client*_rst.csv']);
cooperate_client_files = dir([cooperation_dir 'Client*_rst.csv']);

numClients = size(non_cooperate_client_files, 1);

% Load noCooperation QoE data
non_cooperation_qoe_mat = [];
non_cooperation_qoe_mean = zeros(numClients, 1);
non_cooperation_qoe_std = zeros(numClients, 1);

for i = 1 : numClients
   dat = csvimport([non_cooperation_dir non_cooperate_client_files(i).name], 'noHeader', true);
   curQoE = cell2mat(dat(:, 4));
   non_cooperation_qoe_mat = [non_cooperation_qoe_mat; curQoE'];
   non_cooperation_qoe_mean(i) = mean(curQoE);
   non_cooperation_qoe_std(i) = std(curQoE);
end

[minMnQoE, minInd] = min(non_cooperation_qoe_mean);
min_non_cooperation_qoe = non_cooperation_qoe_mat(minInd, :);
[maxMnQoE, maxInd] = max(non_cooperation_qoe_mean);
max_non_cooperation_qoe = non_cooperation_qoe_mat(maxInd, :);


% Load cooperation QoE data
cooperation_qoe_mat = [];
cooperation_qoe_mean = zeros(numClients, 1);
cooperation_qoe_std = zeros(numClients, 1);

for i = 1 : numClients
   dat = csvimport([cooperation_dir cooperate_client_files(i).name], 'noHeader', true);
   curQoE = cell2mat(dat(:, 4));
   cooperation_qoe_mat = [cooperation_qoe_mat; curQoE'];
   cooperation_qoe_mean(i) = mean(curQoE);
   cooperation_qoe_std(i) = std(curQoE);
end

[minMnQoE, minInd] = min(cooperation_qoe_mean);
min_cooperation_qoe = cooperation_qoe_mat(minInd, :);
[maxMnQoE, maxInd] = max(cooperation_qoe_mean);
max_cooperation_qoe = cooperation_qoe_mat(maxInd, :);


clr = jet(2);
h1 = figure(1),hold on;
h_non_cooperate = cdfplot(non_cooperation_qoe_mean);
set(h_non_cooperate,'LineStyle', '-', 'Color', 'b', 'LineWidth',4)
h_cooperate = cdfplot(cooperation_qoe_mean);
set(h_cooperate,'LineStyle', '--', 'Color', 'r', 'LineWidth',4)
lg = legend('Non-Cooperation', 'Cooperation', 2);
set(lg,'FontSize',14);
ylabel({'Percentage of users whose average QoE'; 'is below the value'}, 'FontSize',14);
xlabel('Average QoE of a video session', 'FontSize',14);
title('CDF of average QoEs', 'FontSize',16);
hold off;
print(h1, '-dpng', ['./rstImgs/cdfComparison' scenario '.png']);

h2 = figure(2), hold on;
plot(min_non_cooperation_qoe, '-b', 'LineWidth', 2);
plot(min_cooperation_qoe, '-+r', 'LineWidth', 2);
lg = legend('Non-Cooperation', 'Cooperation');
set(lg,'FontSize',14);
ylabel({'QoE'}, 'FontSize',14);
xlabel('Time', 'FontSize',14);
title('The worst client behavior', 'FontSize',16);
hold off;
print(h2, '-dpng', ['./rstImgs/worstComparison' scenario '.png']);

h3 = figure(3), hold on;
plot(max_non_cooperation_qoe, '-b', 'LineWidth', 2);
plot(max_cooperation_qoe, '-+r', 'LineWidth', 2);
lg = legend('Non-Cooperation', 'Cooperation', 4);
set(lg,'FontSize',14);
ylabel({'QoE'}, 'FontSize',14);
xlabel('Time', 'FontSize',14);
title('The best client behavior', 'FontSize',16);
hold off;
print(h3, '-dpng', ['./rstImgs/bestComparison' scenario '.png']);
