function result=instantaneousFiringBeat(datasets,condition1,condition2,condition3,code1,gr)

decode={'1001','2002','3003','4004','5005','6006','NA'};
duration=[-500 0; 0 500; 500 1000; 1000 1500; 1500 2000];
d=length(duration);

result=table;
idx=1;
for k=1:length(datasets)
    
    figure
    load(datasets{k})
    if isempty(str2num(datasets{k}(end-2:end)))
        cluster=str2num(datasets{k}(end));
    else
        cluster=str2num(datasets{k}(end-1:end));
    end

    %% 
    spikes1 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes1 = spikes1(ismember(spikes1.condition,condition1),:);
    spikes1 = [spikes1.trialID spikes1.relativeTime];
    u=unique(spikes1(:,1));
    for m=1:length(u)
        sp{m} = spikes1(spikes1(:,1)==u(m),2);
    end
    spikes1=sp;
    %% instantaneous firing_rate
    kern_width = 0.1; %s
    resolution = 0.001; % one millisecond
    
    kern_length = kern_width*5;
    kernel = normpdf(-kern_length:resolution:kern_length, 0, kern_width);
    
    mints = -500;
    maxts = 2000;
    x = (floor(mints/100)*100)/1000:resolution:(ceil(maxts/100)*100)/1000;
    
    ntrials = length(spikes1);
    
    for t =1:ntrials
        % convert to seconds
        y_ = (spikes1{t}./1000)';
        % bin spikes in 1 ms bins
        y_ = histc(y_, x);
        % convolve with kernel
        ys(t,:) = conv(y_, kernel, 'same');
    end
    %%
    t=[];
    for m=1:length(condition1)
        try
            eval(['t=[t trials.' condition1{m} '(code1)];'])
        catch
        end
    end
    t=sum(sum(t));
    hold on
    plot(-0.5:0.001:2,sum(ys)/t,'LineWidth',3,'Color','b') 
    ys1=max(sum(ys)/t);
    clear sp ys
    
    spikes2 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes2 = spikes2(ismember(spikes2.condition,condition2),:);
    spikes2 = [spikes2.trialID spikes2.relativeTime];
    u=unique(spikes2(:,1));
    for m=1:length(u)
        sp{m} = spikes2(spikes2(:,1)==u(m),2);
    end
    spikes1=sp;
    %% instantaneous firing_rate
    kern_width = 0.1; %s
    resolution = 0.001; % one millisecond
    
    kern_length = kern_width*5;
    kernel = normpdf(-kern_length:resolution:kern_length, 0, kern_width);
    
    mints = -500;
    maxts = 2000;
    x = (floor(mints/100)*100)/1000:resolution:(ceil(maxts/100)*100)/1000;
    
    ntrials = length(spikes1);
    
    for t =1:ntrials
        % convert to seconds
        y_ = (spikes1{t}./1000)';
        % bin spikes in 1 ms bins
        y_ = histc(y_, x);
        % convolve with kernel
        ys(t,:) = conv(y_, kernel, 'same');
    end
    %%
    t=[];
    for m=1:length(condition3)
        try
            eval(['t=[t trials.' condition2{m} '(code1)];'])
        catch
        end
    end
    t=sum(sum(t));
    hold on
    plot(-0.5:0.001:2,sum(ys)/t,'LineWidth',3,'Color','g') 
    ys3=max(sum(ys)/t);
    clear sp ys
    
    spikes3 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes3 = spikes3(ismember(spikes3.condition,condition3),:);
    spikes3 = [spikes3.trialID spikes3.relativeTime];
    u=unique(spikes3(:,1));
    for m=1:length(u)
        sp{m} = spikes3(spikes3(:,1)==u(m),2);
    end
    spikes1=sp;
    
    %% instantaneous firing_rate
    kern_width = 0.1; %s
    resolution = 0.001; % one millisecond
    
    kern_length = kern_width*5;
    kernel = normpdf(-kern_length:resolution:kern_length, 0, kern_width);
    
    mints = -500;
    maxts = 2000;
    x = (floor(mints/100)*100)/1000:resolution:(ceil(maxts/100)*100)/1000;
    
    ntrials = length(spikes1);
    
    for t =1:ntrials
        % convert to seconds
        y_ = (spikes1{t}./1000)';
        % bin spikes in 1 ms bins
        y_ = histc(y_, x);
        % convolve with kernel
        ys(t,:) = conv(y_, kernel, 'same');
    end
    %%
    t=[];
    for m=1:length(condition2)
        try
            eval(['t=[t trials.' condition3{m} '(code1)];'])
        catch
        end
    end
    t=sum(sum(t));
    
    plot(-0.5:0.001:2,sum(ys)/t,'LineWidth',3,'Color','r') 
    ys2=max(sum(ys)/t);
    axis([0,2,0,ceil(max([ys2,ys1,ys3]))])
    xlabel('t[s]')
    ylabel('FR[Hz]')
    clear sp ys
    title([gr ' \newline ' datasets{k}])
    
end
end