%% Compare QoE by sampled chunks
% Comparison among methods nonQoE, nonCoop, and coop agents.
% Chen Wang
% compareQoEs.m

clc;
clear all;
close all;

dataDir = '~/weiyun/code/ist_repo/data_exp9/';

sces = {'Sce0', 'Sce1', 'Sce2'};

window = 12;
a = 1;
b = (1./window) .* ones(1, window);


for s = 2 : length(sces)
    scenario = sces{s};

    disp(['Data Folder: ' dataDir]);
    disp(['Scenario: ' scenario]);

    non_qoe_dir = strcat(dataDir, 'nonQoE', scenario, '/');
    non_cooperation_dir = strcat(dataDir, 'nonCoop', scenario, '/');
    cooperation_dir = strcat(dataDir, 'coop', scenario, '/');
    client_files = dir([non_qoe_dir 'Client*_rst.csv']);

    numClients = size(client_files, 1);
    splsNum = 50;

    % Load nonQoE QoE data for clients
    non_qoe_spls = [];
    non_qoe_mean = zeros(numClients, 1);
    non_qoe_std = zeros(numClients, 1);

    for i = 1 : numClients
       dat = csvimport([non_qoe_dir client_files(i).name], 'noHeader', true);
       curQoE = cell2mat(dat(:, 4));
       
       % Moving average of QoE in one minute
       qoeAverage = filter(b, a, curQoE);
       qoeSpls = datasample(qoeAverage, splsNum);
       
       non_qoe_spls = [non_qoe_spls; qoeSpls];
       non_qoe_mean(i) = mean(curQoE);
       non_qoe_std(i) = std(curQoE);
    end

    % Load noCooperation QoE data
    non_cooperation_qoe_spls = [];
    non_cooperation_qoe_mean = zeros(numClients, 1);
    non_cooperation_qoe_std = zeros(numClients, 1);

    for i = 1 : numClients
       dat = csvimport([non_cooperation_dir client_files(i).name], 'noHeader', true);
       curQoE = cell2mat(dat(:, 4));
       
       % Moving average of QoE in one minute
       qoeAverage = filter(b, a, curQoE);
       qoeSpls = datasample(qoeAverage, splsNum);

       non_cooperation_qoe_spls = [non_cooperation_qoe_spls;qoeSpls];
       non_cooperation_qoe_mean(i) = mean(curQoE);
       non_cooperation_qoe_std(i) = std(curQoE);
    end

    % Load cooperation QoE data
    cooperation_qoe_spls = [];
    cooperation_qoe_mean = zeros(numClients, 1);
    cooperation_qoe_std = zeros(numClients, 1);

    for i = 1 : numClients
       dat = csvimport([cooperation_dir client_files(i).name], 'noHeader', true);
       curQoE = cell2mat(dat(:, 4));
       
       % Moving average of QoE in one minute
       qoeAverage = filter(b, a, curQoE);
       qoeSpls = datasample(qoeAverage, splsNum);
       
       cooperation_qoe_spls = [cooperation_qoe_spls; qoeSpls];
       cooperation_qoe_mean(i) = mean(curQoE);
       cooperation_qoe_std(i) = std(curQoE);
    end


    clr = jet(2);
    h1 = figure(1);
    hold on;
    h_non_qoe = cdfplot(non_qoe_spls);
    set(h_non_qoe,'LineStyle', '-', 'Color', 'b', 'LineWidth',2)
    h_non_cooperate = cdfplot(non_cooperation_qoe_spls);
    set(h_non_cooperate,'LineStyle', '--', 'Color', 'r', 'LineWidth',2)
    h_cooperate = cdfplot(cooperation_qoe_spls);
    set(h_cooperate,'LineStyle', ':', 'Color', 'g', 'LineWidth',2)
    lg = legend('Non-QoE', 'Non-Cooperation', 'Cooperation', 2);
    set(lg,'FontSize',14);
    ylabel({'Percentage of users whose average QoE'; 'is below the value'}, 'FontSize',14);
    xlabel('Average QoE of a video session', 'FontSize',14);
    title('CDF of average QoEs', 'FontSize',16);
    hold off;
    print(h1, '-dpng', ['./rstImgs/compQoECDF-' scenario '.png']);

    clear h1;
    close all;
end
