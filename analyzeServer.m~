%% Analyze the data collected from simgrid simulations on a hierarchical  
% node topology.
% Comparison qoe assessment from servers
% Chen Wang
% analyzeServer.m

clc;
clear all;
close all;
nBin = 100;

non_cooperation_dir = './exp512/cap300nonCoopBWDrop/';
cooperation_dir = './exp512/cap300CoopBWDrop/';
non_cooperate_server_files = dir([non_cooperation_dir 'Server*traffic.csv']);
cooperate_server_files = dir([cooperation_dir 'Server*traffic.csv']);

numServers = size(non_cooperate_server_files, 1);

% load server traffic files
for i = 1 : numServers
%    dat = csvimport([non_cooperation_dir non_cooperate_server_files(i).name], 'noHeader', true);
%    sentMsgs = cell2mat(dat(:, 3));
%    sentTS = cell2mat(dat(:, 1));
%    msgDat = [sentTS sentMsgs];
   traffic = computeTraffic(msgDat, tMax, nBin);
end