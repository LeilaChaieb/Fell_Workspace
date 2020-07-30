function result=instantaneousFiringPre(datasets,condition,code1,group)

decode={'1001','2002','3003','4004','5005','6006','NA'};
duration=[-500 0; 0 500; 500 1000; 1000 1500; 1500 2000];
d=length(duration);

result=table;

for k=1:length(datasets)
    figure
    load(datasets{k})
    if isempty(str2num(datasets{k}(end-2:end)))
        cluster=str2num(datasets{k}(end));
    else
        cluster=str2num(datasets{k}(end-1:end));
    end
    
    %% rasterplot
    spikes1 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes1 = spikes1(ismember(spikes1.condition,condition),:);
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
    for m=1:length(condition)
        try
            eval(['t=[t trials.' condition{m} '(code1)];'])
        catch
        end
    end
    t=sum(sum(t));
    
    plot(-0.5:0.001:2,sum(ys)/t,'LineWidth',3) 
    axis([-0.5,2,0,max(sum(ys)/t)])
    xlabel('t[s]')
    ylabel('FR[Hz]')
    title([group '\newline' datasets{k}])
    clear ys sp
end
end