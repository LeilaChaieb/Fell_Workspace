function result=rasterAndHistogramBeat(datasets,condition1,condition2,condition3,code1,gr)

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
    
    [~,~,~,firingBB]= calculate_firing(spikesTrigger, condition1, code1, duration,trials,trigger);
    [~,~,~,firingC]= calculate_firing(spikesTrigger, condition2, code1, duration,trials,trigger);
    [~,~,~,firingMB]= calculate_firing(spikesTrigger, condition3, code1, duration,trials,trigger);
    BB=cellfun(@sum,firingBB(cluster,:))/length(firingBB{1,1})/0.5;
    MB=cellfun(@sum,firingMB(cluster,:))/length(firingMB{1,1})/0.5;
    ctrl=cellfun(@sum,firingC(cluster,:))/length(firingC{1,1})/0.5;
    
    for m=2:d
        group=[repmat(1,1,length(firingBB{1,1})),repmat(2,1,length(firingMB{1,1})),repmat(3,1,length(firingC{1,1}))];
        p=kruskalwallis([firingBB{cluster,m},firingMB{cluster,m},firingC{cluster,m}],group,'off'); %on
        result(idx,:)={p,datasets,duration(m,1),duration(m,2),sum(firingBB{cluster,m})/length(firingBB{cluster,m})/0.5,sum(firingMB{cluster,m})/length(firingMB{cluster,m})/0.5,sum(firingC{cluster,m})/length(firingC{cluster,m})/0.5};
        idx=idx+1;
        %p=ranksum(firingBB{cluster,m},firingMB{cluster,m});
        %result((k-1)*(d-1)+m-1,:)={p,datasets{k},duration(m,1),duration(m,2),sum(firingBB{cluster,m})/length(firingBB{cluster,m}),sum(firingMB{cluster,m})/length(firingMB{cluster,m})};
    end
    
    result.Properties.VariableNames = {'pValue' 'channel' 'start' 'stop' 'firing1' 'firing2' 'firing3'};
    
    subplot(3,1,2)
    b=bar(-0.250:0.500:1.750,BB,'BarWidth', 1,'FaceAlpha',0.2,'FaceColor','b');
    
    hold on
    b=bar(-0.250:0.500:1.750,MB,'BarWidth', 1,'FaceAlpha',0.2,'FaceColor','r');
    b=bar(-0.250:0.500:1.750,ctrl,'BarWidth', 1,'FaceAlpha',0.2,'FaceColor','g');
    axis([0,2,0,ceil(max([BB,MB,ctrl]))])
    xlabel('t[s]')
    ylabel('FR [Hz]')

    %% rasterplot
    trigger1 = trigger(ismember(trigger.code,decode(code1)),:);
    trigger1 = trigger1(ismember(trigger1.condition,condition1),1);
    
    spikes1 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes1 = spikes1(ismember(spikes1.condition,condition1),:);
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
    
    trigger2=trigger(ismember(trigger.code,decode(code1)),:);
    trigger2 = trigger2(ismember(trigger2.condition,condition2),1);
    spikes2 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes2 = spikes2(ismember(spikes2.condition,condition2),:);
    spikes2 = [spikes2.trialID spikes2.relativeTime];
    u=unique(spikes2(:,1));
    try
        for m=1:length(u)
            sp{u(m)} = spikes2(spikes2(:,1)==u(m),2);
        end
        spikes2=sp;
    catch
        spikes2={};
    end
    clear sp
    
    trigger3=trigger(ismember(trigger.code,decode(code1)),:);
    trigger3 = trigger3(ismember(trigger3.condition,condition3),1);
    spikes3 = spikesTrigger(ismember(spikesTrigger.code,decode(code1)),:);
    spikes3 = spikes3(ismember(spikes3.condition,condition3),:);
    spikes3 = [spikes3.trialID spikes3.relativeTime];
    u=unique(spikes3(:,1));
    try
        for m=1:length(u)
            sp{u(m)} = spikes3(spikes3(:,1)==u(m),2);
        end
        spikes3=sp;
    catch
        spikes3={};
    end
    clear sp
    resolution = 0.001; % one millisecond
    mints = -500;
    maxts = 2000;
    x = (floor(mints/100)*100)/1000:resolution:(ceil(maxts/100)*100)/1000;
    
    ntrials1 = height(trigger1);
    ntrials2 = height(trigger2);
    ntrials3 = height(trigger3);
    
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
    for t =1:ntrials2
        try
            % convert to seconds
            y_ = (spikes2{trigger2.trialID(t)}./1000)';
            % bin spikes in 1 ms bins
            ys(t,:) = histc(y_, x);
            h=plot(x,ys(t,:)*(t+ntrials1),'.g');
            set(h,'MarkerSize',5)
            hold on
        catch
        end
    end
    for t =1:ntrials3
        try
            % convert to seconds
            y_ = (spikes3{trigger3.trialID(t)}./1000)';
            % bin spikes in 1 ms bins
            ys(t,:) = histc(y_, x);
            h=plot(x,ys(t,:)*(t+ntrials1+ntrials2),'.r');
            set(h,'MarkerSize',5)
            hold on
        catch
        end
    end
    axis([0,x(end),0.1,ntrials1+ntrials2+ntrials3+1])
    title([gr ' \newline ' datasets{k}])
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