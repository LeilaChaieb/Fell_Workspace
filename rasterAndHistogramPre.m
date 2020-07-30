function result=rasterAndHistogramPre(datasets,condition,code1,group)

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
    
    [~,~,~,firingO]= calculate_firing(spikesTrigger, condition, code1, duration,trials,trigger);
    old=cellfun(@sum,firingO(cluster,:))/length(firingO{1,1})/0.5;
    
    for m=2:d
        p=ranksum(firingO{cluster,1},firingO{cluster,m});
        result((k-1)*(d-1)+m-1,:)={p,datasets{k},duration(m,1),duration(m,2),sum(firingO{cluster,1})/length(firingO{cluster,1})/0.5,sum(firingO{cluster,m})/length(firingO{cluster,m})/0.5};
    end
    
    result.Properties.VariableNames = {'pValue' 'channel' 'start' 'stop' 'firingPre' 'firingPost'};
    
    a1=table(result.channel,result.start/500+2,result.pValue);
    
    subplot(3,1,2)
    b=bar(-0.250:0.500:1.750,old,'BarWidth', 1,'FaceAlpha',0.2,'FaceColor','b');
    xlabel('t[s]')
    ylabel('FR [Hz]')
    axis([-0.5,2,0,ceil(max(old))])

    %% rasterplot
    trigger1 = trigger(ismember(trigger.code,decode(code1)),:);
    trigger1 = trigger1(ismember(trigger1.condition,condition),1);
    
    spikes1 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes1 = spikes1(ismember(spikes1.condition,condition),:);
    spikes1 = [spikes1.trialID spikes1.relativeTime];
    u=unique(spikes1(:,1));
    try
        for m=1:length(u)
            sp{u(m)} = spikes1(spikes1(:,1)==u(m),2);
        end
        spikes1=sp;
    catch
        spikes1={};
    end
    clear sp
    
    resolution = 0.001; % one millisecond
    mints = -500;
    maxts = 2000;
    x = (floor(mints/100)*100)/1000:resolution:(ceil(maxts/100)*100)/1000;
    
    ntrials1 = height(trigger1);
    
    subplot(3,1,1)
    for t =1:ntrials1
        try
            % convert to seconds
            y_ = (spikes1{trigger1.trialID(t)}./1000)';
            % bin spikes in 1 ms bins
            ys = histc(y_, x);
            h=plot(x,ys*t,'.b');
            set(h,'MarkerSize',5)
            hold on
        catch
        end
    end
    
    axis([x(1),x(end),0.1,ntrials1+1])
    title([group ' \newline ' datasets{k}])
    set (gca,'YDir','reverse')
    xlabel('t[s]')
    ylabel('trial number')
    
    %density
    subplot(3,1,3)
    density_plot(spikes)
    colormap(jet)
    caxis([0,0.07*length(spikes)])
end
end