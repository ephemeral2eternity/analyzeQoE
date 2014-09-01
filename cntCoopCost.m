%% Count Cooperation Traffic Cost.
% Use QoE update records to count the cooperation traffic
% Chen Wang
% cntCoopCost.m

clc;
clear all;
close all;

scales = {'leaf32', 'leaf64', 'leaf256', 'leaf400', 'leaf900', 'leaf1024'};
scaleNames = {'32', '64', '256', '400', '900', '1024'};
scs = [32; 64; 256; 400; 900; 1024];
dataDir = '~/weiyun/code/ist_repo/data/data_expScale/';
period = 10;
num_scales = size(scales, 2);

plotLines = {'-b', ':r', ':g', '-.k', '-ob', '-*r', '-.oy', '-+r', '-sb', '-dg'};

trafficMat = zeros(num_scales, 3);
trafficSTD = zeros(num_scales, 1);
peakTraffic = zeros(num_scales, 1);
t = 0 : 10 : 500;

figure(1), hold on;
for s = 1 : num_scales
    traffic_file_name = [dataDir scales{s} '/Server_0_qoe.csv'];
    
    dat = csvimport(traffic_file_name, 'delimiter', ',');
    ts_dat = cell2mat(dat(2:end, end));

    traffic = hist(ts_dat(ts_dat<500), t) .* 2 / period;
%     if (s == 1)
%         tMin = t;
%         trafficMin = traffic;
%     elseif (s == num_scales)
%         tMax = t;
%         trafficMax = traffic;
%     end
    plot(t, traffic, plotLines{s}, 'LineWidth', 4);
    
    mnTraffic = mean(traffic);
    stdTraffic = std(traffic);
    peakTraffic(s) = max(traffic);
    trafficSTD(s) = stdTraffic;
    trafficMat(s, 1) = mnTraffic;
    trafficMat(s, 2) = min(traffic);
    trafficMat(s, 3) = max(traffic);
end
legend(scaleNames);
ylabel('Message Received', 'fontsize',20);
xlabel('Time', 'fontsize',20);
set(gca,'fontsize',20);
hold off;

h1 = figure(num_scales + 1);
hold on;
plot(scs, trafficMat(:, 1), '-xr', 'LineWidth', 4, 'MarkerSize', 20);
plot(scs, trafficSTD, '--ob', 'LineWidth', 4, 'MarkerSize', 20);
plot(scs, trafficMat(:, 3), ':dg', 'LineWidth', 4, 'MarkerSize', 20);
axis([10 1300 -5 100]);
legend('Mean', 'Standard Deviation', 'Peak')
ylabel('Message Received per Second', 'fontsize',20);
xlabel('Number of Nodes per AS', 'fontsize',20);
set(gca,'fontsize',20);
hold off;
