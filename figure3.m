function figure3
clear
 
condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'};
Rplus=[2];
Rminus=[3,4];
FN=[5];
FP=[6];
TN=[1];
decode={'1001','2002','3003','4004','5005','6006','NA'};
duration=[-500 0; 0 500; 500 1000; 1000 1500; 1500 2000];
d=length(duration);

%familiarity
datasetsFam={'LA1','LA4','LA5','LAH4','LAH5','LEC1','LECa1','LMH2','LPHC2','LPHC2','LPHC2','LPHC2','LPHC2','RAH3','RAH3','RPHC2','RPHC2','RPHC4'};
clusterFam=[5,4,2,4,9,5,2,2,4,6,16,18,19,9,10,1,4,3];

for k=1:length(datasetsFam)
    
    load(['./Spikes/' datasetsFam{k}])
    load(['./Spikes/info' datasetsFam{k}(end)])
    
    [~,~,~,firingRplus]= calculate_firing(spikesTrigger, condition, Rplus, duration,trials,trigger);
    [~,~,~,firingRminus]= calculate_firing(spikesTrigger, condition, Rminus, duration,trials,trigger);
    [~,~,~,firingFN]= calculate_firing(spikesTrigger, condition, FN, duration,trials,trigger);
    [~,~,~,firingFP]= calculate_firing(spikesTrigger, condition, FP, duration,trials,trigger);
    [~,~,~,firingTN]= calculate_firing(spikesTrigger, condition, TN, duration,trials,trigger);
    [~,~,~,firingNew]= calculate_firing(spikesTrigger, condition, [TN,FP], duration,trials,trigger);
    
    c=clusterFam(k);
    
    firingRp = cell2mat(cellfun(@(x) x/0.5,firingRplus(c,:),'UniformOutput',false)'); %fr=count/duration
    firingRm = cell2mat(cellfun(@(x) x/0.5,firingRminus(c,:),'UniformOutput',false)');
    firingmiss = cell2mat(cellfun(@(x) x/0.5,firingFN(c,:),'UniformOutput',false)');
    firingfa = cell2mat(cellfun(@(x) x/0.5,firingFP(c,:),'UniformOutput',false)');
    firingnew = cell2mat(cellfun(@(x) x/0.5,firingTN(c,:),'UniformOutput',false)');
    firingAllNew = cell2mat(cellfun(@(x) x/0.5,firingNew(c,:),'UniformOutput',false)');
    
    baselineMean=mean([firingRp(1,:),firingRm(1,:),firingmiss(1,:),firingfa(1,:),firingnew(1,:)]); 
    
    RpF(k)=mean(mean(firingRp(2:5,:)))/baselineMean;
    RmF(k)=mean(mean(firingRm(2:5,:)))/baselineMean;
    missF(k)=mean(mean(firingmiss(2:5,:)))/baselineMean;
    faF(k)=mean(mean(firingfa(2:5,:)))/baselineMean;
    newF(k)=mean(mean(firingnew(2:5,:)))/baselineMean;
    allNewF(k)=mean(mean(firingAllNew(2:5,:)))/baselineMean;
end

clearvars -except RpF RmF missF faF newF allNewF

condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'};
Rplus=[2];
Rminus=[3,4];
FN=[5];
FP=[6];
TN=[1];
decode={'1001','2002','3003','4004','5005','6006','NA'};
duration=[-500 0; 0 500; 500 1000; 1000 1500; 1500 2000];
d=length(duration);

%novelty
datasetsFam={'LAH3','LAH3','LEC1','LEC2','LEC2','LEC4','LPHC2','LPHC2','LPHC2','LPHC2','RA4','RAH4','REC2','REC2','REC4','RPHC4','RPHC4','RPHC4','RPHC4'};
clusterFam=[3,4,30,4,7,21,1,2,11,12,6,11,2,7,7,1,2,6,8];

for k=1:length(datasetsFam)
    
    load(['./Spikes/' datasetsFam{k}])
    load(['./Spikes/info' datasetsFam{k}(end)])
    
    [~,~,~,firingRplus]= calculate_firing(spikesTrigger, condition, Rplus, duration,trials,trigger);
    [~,~,~,firingRminus]= calculate_firing(spikesTrigger, condition, Rminus, duration,trials,trigger);
    [~,~,~,firingFN]= calculate_firing(spikesTrigger, condition, FN, duration,trials,trigger);
    [~,~,~,firingFP]= calculate_firing(spikesTrigger, condition, FP, duration,trials,trigger);
    [~,~,~,firingTN]= calculate_firing(spikesTrigger, condition, TN, duration,trials,trigger);
    [~,~,~,firingNew]= calculate_firing(spikesTrigger, condition, [TN,FP], duration,trials,trigger);
    
    c=clusterFam(k);
    
    firingRp = cell2mat(cellfun(@(x) x/0.5,firingRplus(c,:),'UniformOutput',false)'); %fr=count/duration
    firingRm = cell2mat(cellfun(@(x) x/0.5,firingRminus(c,:),'UniformOutput',false)');
    firingmiss = cell2mat(cellfun(@(x) x/0.5,firingFN(c,:),'UniformOutput',false)');
    firingfa = cell2mat(cellfun(@(x) x/0.5,firingFP(c,:),'UniformOutput',false)');
    firingnew = cell2mat(cellfun(@(x) x/0.5,firingTN(c,:),'UniformOutput',false)');
    firingAllNew = cell2mat(cellfun(@(x) x/0.5,firingNew(c,:),'UniformOutput',false)');
    
    baselineMean=mean([firingRp(1,:),firingRm(1,:),firingmiss(1,:),firingfa(1,:),firingnew(1,:)]); 
    
    Rp(k)=mean(mean(firingRp(2:5,:)))/baselineMean;
    Rm(k)=mean(mean(firingRm(2:5,:)))/baselineMean;
    miss(k)=mean(mean(firingmiss(2:5,:)))/baselineMean;
    fa(k)=mean(mean(firingfa(2:5,:)))/baselineMean;
    new(k)=mean(mean(firingnew(2:5,:)))/baselineMean;
    allNew(k)=mean(mean(firingAllNew(2:5,:)))/baselineMean;
end

figure
b=bar([mean([-1*Rp RpF])-mean([-1*allNew allNewF]),mean([-1*Rm RmF])-mean([-1*allNew allNewF]),mean([-1*miss missF])-mean([-1*allNew allNewF]),mean([-1*fa faF])-mean([-1*allNew allNewF]),mean([-1*new newF])-mean([-1*allNew allNewF])],'BarWidth', 1);
ylabel('response index')
xticklabels({'R+','R-','FN','FP','TN'})

RPs=[-1*Rp RpF]-[-1*allNew allNewF]; 
RMs=([-1*Rm RmF])-([-1*allNew allNewF]); 
FN=([-1*miss missF])-([-1*allNew allNewF]); 
FP=([-1*fa faF])-([-1*allNew allNewF]); 
TN=([-1*new newF])-([-1*allNew allNewF]);

signrank(RPs,RMs)
signrank(RPs,FN)
signrank(RPs,FP)
signrank(RPs,TN)
signrank(RMs,FN)
signrank(RMs,FP)
signrank(RMs,TN)
signrank(FN,FP)
signrank(FN,TN)
signrank(FP,TN)
end