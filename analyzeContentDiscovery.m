%% Analyze the scalability of content discovery algorithm
% Chen Wang
% analyzeContentDiscovery.m

clc;
clear all;
close all;

scales = {'nodes64', 'nodes256','nodes512', 'nodes1024'};
scs = [64; 256; 512; 1024];
dataDir = '~/weiyun/code/ist_repo/data/data_expContentDiscovery/';
plotLines = {'-b', '--or', ':g', '-.k', '-ob', '-*r', '-.oy', '-+r', '-sb', '-dg'};

msgInNumMat = zeros(size(scales, 2), 2);
msgOutNumMat = zeros(size(scales, 2), 2);
trafficInMat = zeros(size(scales, 2), 2);
trafficOutMat = zeros(size(scales, 2), 2);

for s = 1 : length(scales)
    curScale = scales{s};
    curScaleDir = [dataDir curScale '/'];
    servers = dir([curScaleDir 'Server*recv.csv']);
    
    trafficInAllClients = zeros(size(servers, 1), 1);
    trafficOutAllClients = zeros(size(servers, 1), 1);
    msgInAllClients = zeros(size(servers, 1), 1);
    msgOutAllClients = zeros(size(servers, 1), 1);
    
    for f = 1 : (size(servers, 1))
        strs = strsplit(servers(f).name, '_');
        srvName = strcat(strs{1}, '_', strs{2});

        loadInFName = strcat(srvName, '_recv.csv');
        loadOutFName = strcat(srvName, '_send.csv');

        %% Load inbound traffic file
        dat = csvimport(strcat(curScaleDir, loadInFName), 'noHeader', true);
        trafficIn = cell2mat(dat(:, 3));
        totalTrafficIn = sum(trafficIn);
        trafficInAllClients(f) = totalTrafficIn;
        % Msgs In
        inMsgNum = size(dat, 1);
        msgInAllClients(f) = inMsgNum;    

        %% Load outBound traffic file
        dat = csvimport(strcat(curScaleDir, loadOutFName), 'noHeader', true);
        trafficOut = cell2mat(dat(:, 2));
        totalTrafficOut = sum(trafficOut);
        trafficOutAllClients(f) = totalTrafficOut;
        outMsgNum = size(dat, 1);
        msgOutAllClients(f) = outMsgNum; 
    end
    
    trafficInMat(s, 1) = mean(trafficInAllClients);
    trafficInMat(s, 2) = std(trafficInAllClients);
    trafficOutMat(s, 1) = mean(trafficOutAllClients);
    trafficOutMat(s, 2) = std(trafficOutAllClients);
    
    msgInNumMat(s, 1) = mean(msgInAllClients);
    msgInNumMat(s, 2) = std(msgInAllClients);
    msgOutNumMat(s, 1) = mean(msgOutAllClients);
    msgOutNumMat(s, 2) = std(msgOutAllClients);
end

%% Error bar analysis of Traffic
figure(1), hold on;
errorbar(trafficInMat(:, 1), trafficInMat(:, 2), plotLines{1}, 'LineWidth', 2);
errorbar(trafficOutMat(:, 1), trafficOutMat(:, 2), plotLines{2}, 'LineWidth', 2);
set(gca, 'XTick', 1:length(scales), 'XTickLabel', scales);
axis([0.5 4.5 9000 9400]);
ylabel('Traffic per Cache Agent', 'FontSize',20);
legend('Inbound Traffic', 'Outbound Traffic', 'FontSize',20);
set(gca,'fontsize',20);
hold off;

figure(2), hold on;
errorbar(msgInNumMat(:, 1), msgInNumMat(:, 2), plotLines{1}, 'LineWidth', 2);
errorbar(msgOutNumMat(:, 1), msgOutNumMat(:, 2), plotLines{2}, 'LineWidth', 2);
set(gca, 'XTick', 1:length(scales), 'XTickLabel', scales);
axis([0.5 4.5 30 50]);
ylabel('Messages per agent', 'FontSize',20);
legend('Received Messages', 'Sent Messages', 'FontSize',20);
set(gca,'fontsize',20);
hold off;
% figure(2), hold on;
% plot(scs, msgNumMat(:, 1), plotLines{5}, 'LineWidth', 2,'MarkerSize',20);
% plot(scs, msgNumMat(:, 2), plotLines{6}, 'LineWidth', 2, 'MarkerSize',20);
% legend('Numbr of Received Messages', 'Number of Sent Messages', 'FontSize',16);
% axis([20 1200 0 50]);
% xlabel('Number of cache locations in the VoD', 'FontSize',16)
% ylabel({'Message Sent/Received per Cache' 'Content Discovery Algorith'}, 'FontSize',16);
% title('Scalability of Content Discovery', 'FontSize',16);
% hold off;

