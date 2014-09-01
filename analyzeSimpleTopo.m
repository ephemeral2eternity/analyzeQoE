%% Analyze the results for simpleTopology described in section III
% Chen Wang
% analyzeSimpleTopo.m

clc;
clear all;
close all;

%% Logistics
plotLines = {'-b', '--r', ':g', '-.k', '-*y', '-.ob', ':+r', '-sb', '-dg'};

dataDir = '~/weiyun/code/ist_repo/simgrid_data/simpleTopologyData/';
non_qoe_file = strcat(dataDir, 'nonQoEData/Client_A_rst.csv');
qoe_file = strcat(dataDir, 'qoeData/Client_A_rst.csv');

%% Draw QoE curves over time
% load non-qoe qoes
dat = csvimport(non_qoe_file,  'noHeader', true);
nonQoE_qoe = cell2mat(dat(:, 4));

% load qoe qoes
dat2 = csvimport(qoe_file,  'noHeader', true);
QoE_qoe = cell2mat(dat2(:, 4));

t = (1 : length(nonQoE_qoe)).*5;

range = 1 : 60;

h1 = figure(1);
hold on;
plot(t(range), nonQoE_qoe(range), plotLines{1}, 'LineWidth', 4);
plot(t(range), QoE_qoe(range), plotLines{7}, 'LineWidth', 4);
xlabel('Time (Seconds)', 'FontSize', 22);
ylabel('QoE(t) \in [0, 5]', 'FontSize', 22);
axis([0 300 0 6]);
lg = legend('Static Server Selection', 'QoE driven Server Selection', 4);
set(lg,'FontSize',22);
hold off;
print(h1, '-dpng', './imgSimpleTopo/QoEComparison.png');

%% Draw capacity changes on two candidate servers
bw_A = ones(length(nonQoE_qoe), 1) .* 10;
bw_B = ones(length(nonQoE_qoe), 1) .* 5;
bw_A(21 : 40) = 1;

h2 = figure(2);
hold on;
plot(t(range), bw_A(range), plotLines{1}, 'LineWidth', 4);
plot(t(range), bw_B(range), plotLines{7}, 'LineWidth', 4);
xlabel('Time (Seconds)', 'FontSize', 22);
ylabel('Link Capacity (Mbps)', 'FontSize', 22);
axis([0 300 0 15]);
lg = legend('Link to Server\_A', 'Link to Server\_B');
set(lg,'FontSize',22);
hold off;
print(h2, '-dpng', './imgSimpleTopo/capacitySetting.png');

