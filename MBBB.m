%% Encoding and Retrieval as well as Item and Source have to be commented/uncommented according to searched correlation 
%% correlation can be calculated for channels of left and right hemisphere
%% prestimulus interval can also be included by changing duration to duration=[-500 0];
%% normalized FR BB-MB

%ENC
condition1={'cBB1'}; %BB
condition2={'cMB1'}; %MB
load encoding
load info
% %RET 
% condition1={'sBB3'}; %BB
% condition2={'sMB3'}; %MB
% load retrieval
% load info

code=[1,2,3,4,5,6];
duration=[0 500; 500 1000; 1000 1500; 1500 2000];

for k=1:length(data)
    spikes=data{k};
    n=str2double(spikes.channel{1}(end));
    info=infos{n};
    trigger=triggers{n};
[~,~,~,firing]= calculate_firing(spikes, condition1, code, duration,info,trigger);
firingBB=firing(spikes.clusterID(1),:);
[~,~,~,firing]= calculate_firing(spikes, condition2, code, duration,info,trigger);
firingMB=firing(spikes.clusterID(1),:);

% multiplizieren mit wirklicher Differenz
BB=cellfun(@sum,firingBB)/length(firingBB{1,1})/0.5;
MB=cellfun(@sum,firingMB)/length(firingMB{1,1})/0.5;
normFR_beat(k,:)=(BB-MB)/mean((BB+MB)/2);
end

%% normalized FR rem-forg
code=[1,2,3,4,5,6];
duration=[0 500; 500 1000; 1000 1500; 1500 2000];
% ENC item
condition={'cCT1','cBB1','cMB1','sCT1','sBB1','sMB1'}; %color and scene
code1=[2,3,4];
code2=5;
load encoding
load info
% % ENC source
% condition={'cCT1','cBB1','cMB1','sCT1','sBB1','sMB1'}; %encoding
% code1=[2]; %SR
% code2=[3,4]; %IR incl. unsure
% load encoding
% load info
% % RET item
% condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'}; %color and scene
% code1=[2,3,4];
% code2=5;
% load retrieval
% load info
% % RET source
% condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'}; %retrieval
% code1=[2]; %SR
% code2=[3,4]; %IR incl. unsure
% load retrieval
% load info

for k=1:length(data)
    spikes=data{k};
    n=str2double(spikes.channel{1}(end));
    info=infos{n};
    trigger=triggers{n};
[~,~,~,firing]= calculate_firing(spikes, condition, code1, duration,info,trigger);
firingRem=firing(spikes.clusterID(1),:);
[~,~,~,firing]= calculate_firing(spikes, condition, code2, duration,info,trigger);
firingForg=firing(spikes.clusterID(1),:);

% multiplizieren mit wirklicher Differenz
Rem=cellfun(@sum,firingRem)/length(firingRem{1,1})/0.5;
Forg=cellfun(@sum,firingForg)/length(firingForg{1,1})/0.5;
normFR_memory(k,:)=(Rem-Forg)/mean((Rem+Forg)/2);
end

%% correlation
% encoding
left=1:30;
right=31:41;
% retrieval
% left=1:52;
% right=53:75;

[rhoP_l,pval_l]=corr(normFR_beat(left,:),normFR_memory(left,:),'type','Pearson');
[rhoP_r,pval_r]=corr(normFR_beat(right,:),normFR_memory(right,:),'type','Pearson');