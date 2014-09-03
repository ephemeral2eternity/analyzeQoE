%% Analyze the data collected from simgrid simulations on a hierarchical 64 
% node topology.
% Comparison among methods with and without cooperations between agents.
% Chen Wang
% compCooperation.m

clc;
clear all;
close all;

scenario = 'Sce4';
expNo = 'expRd2';
dataDir = '../data/data_expRd2/';

disp(['Data Folder: ' dataDir]);
disp(['Scenario: ' scenario]);

non_qoe_dir = strcat(dataDir, scenario, '/nonQoE/');
non_cooperation_dir = strcat(dataDir, scenario, '/nonCoop/');
cooperation_dir = strcat(dataDir, scenario, '/coop/');
non_qoe_client_files = dir([non_qoe_dir 'Client*_rst.csv']);
non_coop_client_files = dir([non_cooperation_dir 'Client*_rst.csv']);
coop_client_files = dir([cooperation_dir 'Client*_rst.csv']);

% Load nonQoE QoE data for clients
non_qoe_clients_num = size(non_qoe_client_files, 1);
non_qoe_mat = [];
non_qoe_mean = zeros(non_qoe_clients_num, 1);
non_qoe_std = zeros(non_qoe_clients_num, 1);

for i = 1 : non_qoe_clients_num
   dat = csvimport([non_qoe_dir non_qoe_client_files(i).name], 'noHeader', true);
   curQoE = cell2mat(dat(:, 4));
   non_qoe_mat = [non_qoe_mat; curQoE'];
   non_qoe_mean(i) = mean(curQoE);
   non_qoe_std(i) = std(curQoE);
end
[~, minInd] = min(non_qoe_mean);
min_non_qoe = non_qoe_mat(minInd, :);
[~, maxInd] = max(non_qoe_mean);
max_non_qoe = non_qoe_mat(maxInd, :);
sort_non_qoe = sort(non_qoe_mean);

% Load noCooperation QoE data
non_coopClients_num = size(non_coop_client_files, 1);
non_cooperation_qoe_mat = [];
non_cooperation_qoe_mean = zeros(non_coopClients_num, 1);
non_cooperation_qoe_std = zeros(non_coopClients_num, 1);

for i = 1 : non_coopClients_num
   dat = csvimport([non_cooperation_dir non_coop_client_files(i).name], 'noHeader', true);
   curQoE = cell2mat(dat(:, 4));
   % disp(i);
   non_cooperation_qoe_mat = [non_cooperation_qoe_mat; curQoE'];
   non_cooperation_qoe_mean(i) = mean(curQoE);
   non_cooperation_qoe_std(i) = std(curQoE);
end

[~, minInd] = min(non_cooperation_qoe_mean);
min_non_cooperation_qoe = non_cooperation_qoe_mat(minInd, :);
[~, maxInd] = max(non_cooperation_qoe_mean);
max_non_cooperation_qoe = non_cooperation_qoe_mat(maxInd, :);
sort_non_coop = sort(non_cooperation_qoe_mean);


% Load cooperation QoE data
coop_clients_num = size(coop_client_files, 1);
cooperation_qoe_mat = [];
cooperation_qoe_mean = zeros(coop_clients_num, 1);
cooperation_qoe_std = zeros(coop_clients_num, 1);

for i = 1 : coop_clients_num
   dat = csvimport([cooperation_dir coop_client_files(i).name], 'noHeader', true);
   curQoE = cell2mat(dat(:, 4));
   cooperation_qoe_mat = [cooperation_qoe_mat; curQoE'];
   cooperation_qoe_mean(i) = mean(curQoE);
   cooperation_qoe_std(i) = std(curQoE);
end

[~, minInd] = min(cooperation_qoe_mean);
min_cooperation_qoe = cooperation_qoe_mat(minInd, :);
[~, maxInd] = max(cooperation_qoe_mean);
max_cooperation_qoe = cooperation_qoe_mat(maxInd, :);
sort_coop = sort(cooperation_qoe_mean);


clr = jet(2);
h1 = figure(1);
hold on;
h_non_qoe = cdfplot(non_qoe_mean);
set(h_non_qoe,'LineStyle', '-', 'Color', 'b', 'LineWidth',4)
h_non_cooperate = cdfplot(non_cooperation_qoe_mean);
set(h_non_cooperate,'LineStyle', '--', 'Color', 'r', 'LineWidth',4)
h_cooperate = cdfplot(cooperation_qoe_mean);
set(h_cooperate,'LineStyle', ':', 'Color', 'g', 'LineWidth',4)
plot([0:0.01:5], 0.2, '-k');
lg = legend('Static', 'QoE Driven', 'Cooperation', 2);
set(lg,'FontSize',20);
ylabel('Percentile of users', 'FontSize',20);
xlabel('Individual User QoE for a video session', 'FontSize',20);
title('CDF of average QoEs', 'FontSize',20);
axis([2 5 0 1]);

ind90 = round(length(sort_non_qoe) * 0.1);
ind80 = round(length(sort_non_qoe) * 0.2);
% Create textarrow for non_qoe_mean 90 percentile
annotation(h1,'textarrow',[0.3 0.2],...
    [0.3 0.2], 'TextEdgeColor','none',...
    'String',{'80% QoE:', num2str(sort_non_qoe(ind80))}, ...
    'FontSize',20);

annotation(h1,'textarrow',[0.4 0.3],...
    [0.4 0.3], 'TextEdgeColor','none',...
    'String',{'80% QoE:', num2str(sort_non_coop(ind80))}, ...
    'FontSize',20);

annotation(h1,'textarrow',[0.5 0.4],...
    [0.5 0.4], 'TextEdgeColor','none',...
    'String',{'80% QoE:', num2str(sort_coop(ind80))}, ...
    'FontSize',20);

set(gca, 'FontSize', 20);
hold off;
print(h1, '-depsc2', ['./rstImgs/cdfComparison-' scenario '-' expNo '.eps']);
print(h1, '-dpng', ['./rstImgs/cdfComparison-' scenario '-' expNo '.png']);

disp(['80% percentile nonQoE: ' num2str(sort_non_qoe(ind80))]);
disp(['80% percentile nonCoop: ' num2str(sort_non_coop(ind80))]);
disp(['80% percentile nonCoop: ' num2str(sort_coop(ind80))]);

h2 = figure(2);
hold on;
plot(min_non_qoe, '-b', 'LineWidth', 4);
plot(min_non_cooperation_qoe, '--r', 'LineWidth', 4);
plot(min_cooperation_qoe, ':g', 'LineWidth', 4);
lg = legend('Static', 'QoE Driven', 'Cooperation', 4);
set(lg,'FontSize',20);
ylabel({'QoE'}, 'FontSize',20);
xlabel('Time', 'FontSize',20);
title('The worst client behavior', 'FontSize',20);
set(gca, 'FontSize', 20);
axis([0 80 0 6]);
hold off;
print(h2, '-depsc2', ['./rstImgs/worstComparison-' scenario '-' expNo '.eps']);
print(h2, '-dpng', ['./rstImgs/worstComparison-' scenario '-' expNo '.png']);

h3 = figure(3);
hold on;
plot(max_non_qoe, '-b', 'LineWidth', 4);
plot(max_non_cooperation_qoe, '--r', 'LineWidth', 4);
plot(max_cooperation_qoe, ':g', 'LineWidth', 4);
lg = legend('Static', 'QoE Driven', 'Cooperation', 4);
set(lg,'FontSize',20);
axis([0 80 2 6]);
ylabel({'QoE'}, 'FontSize',20);
xlabel('Time', 'FontSize',20);
title('The best client behavior', 'FontSize',20);
set(gca, 'FontSize', 20);
hold off;
print(h3, '-depsc2', ['./rstImgs/bestComparison-' scenario '-' expNo '.eps']);
print(h3, '-dpng', ['./rstImgs/bestComparison-' scenario '-' expNo '.png']);
