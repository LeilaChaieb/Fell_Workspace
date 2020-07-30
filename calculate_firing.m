function [fr,sd,info,firing]= calculate_firing(data, condition, code, duration, trials,trigger)

% compute the mean firing rate (fr) in Hz (sd: standard deviation)
% gives info for multi(1) or single(2) unit and number of spikes

%condition
% ENC: 1, RET 3, e.g.{'cCT1','cBB1','cMB1'} or {'sCT3','sBB3','sMB3'}

%codes e.g. code={'1001','6006'}; for new trials
% 1 - 1001 CR - NEW
% 2 - 2002 SR - OLD
% 3 - 3003 IR - OLD
% 4 - 4004 unsure - OLD
% 5 - 5005 miss - OLD
% 6 - 6006 FA - NEW
% 7 - NA no answer

% duration: length of trial intervals in ms
% e.g. [-500 0; 0 500; 500 1000; 1000 1500; 1500 2000]

decode={'1001','2002','3003','4004','5005','6006','NA'};

t=[];

for k=1:length(condition)
    try
        eval(['t=[t trials.' condition{k} '(code)];'])
    catch
    end
end

t=sum(sum(t)); %number of trials for selected condition and code

trigger = trigger(ismember(trigger.condition,condition),:); %select condition e.g. ENC
trigger = trigger(ismember(trigger.code,decode(code)),:); %select trigger e.g. new
idx(trigger.trialID)=1:size(trigger,1);

% duration = duration / 1000; % seconds

anzClust = max(data.clusterID); %number of cluster in channel
fr = NaN(size(duration,1),anzClust,1);
sd = NaN(size(duration,1),anzClust,1);
info = NaN(size(duration,1),anzClust,2);

% data = data(data.trialID~=0,:); %select spikes that lie in trials

data = data(ismember(data.condition,condition),:); %select condition e.g.ENC

data = data(ismember(data.code,decode(code)),:); %select specific trials e.g.new

% anzClust = max(data.clusterID); %number of cluster left in channel
for k=1:anzClust %calculate firing rate per cluster
    for d=1:size(duration,1)
        cluster = data.trialID(data.clusterID==k & data.relativeTime>=duration(d,1) & data.relativeTime<duration(d,2)); %chose cluster
        % count occurence of same trials (=number of spikes in this trial)
        % hist starts with 0 to make sure there is a vector,
        % has to be removed later
        
        count = hist(cluster,[0;unique(cluster)]);
        count = count(2:end);
        %     sd(k) = std(count./duration);
        %     fr(k) = mean(count)/ duration;
        sd(d,k) = std(count./t);
        fr(d,k) = sum(count)/t;
        
        try
            info(d,k,1) = data.mu_si(find(data.clusterID==k,1));
            info(d,k,2) = length(count);
            info(d,k,3) = sum(count);
        catch
        end
        f=zeros(1,t);%spikes per trial
        c=unique(cluster);
        f(idx(c))=count;
        firing{k,d}=f;%spikes per trial
    end
end

end