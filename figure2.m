function figure2
%% stimulus-responsive

condition={'cCT1','cBB1','cMB1','sCT1','sBB1','sMB1'};
code1=[1,2,3,4,5,6];
datasets={'H-2','PHC-21'};
group='stimulus-responsive';

resultStim=rasterAndHistogramPre(datasets,condition,code1,group);

%% novelty and familiarity
condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'};
code1=[2,3,4];
code2=[1];
datasets={'H-3','H-4','H-14','PHC-24'};
group='novelty or familiarity units';

resultNov=rasterAndHistogram(datasets,condition,code1,code2,group);

%% memory item
condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'};
code1=[2,3,4];
code2=[5];
datasets={'EC-28','PHC-9'};
group='memory-retrieval item';

resultItem=rasterAndHistogram(datasets,condition,code1,code2,group);

%% memory source
condition={'cCT3','cBB3','cMB3','sCT3','sBB3','sMB3'};
code1=[2];
code2=[3,4];
datasets={'A-20','EC-32'};
group='memory-retrieval source';

resultSource=rasterAndHistogram(datasets,condition,code1,code2,group);

%% beats
condition2={'cCT1','sCT3'}; % ctrl stimulation
condition1={'cBB1','sBB3'}; % bb stimulation
condition3={'cMB1','sMB3'}; % mb stimulation
code1=[1,2,3,4,5,6];
datasets={'A-10','EC-1'};
group='auditory beat stimulation';

resultBeat=rasterAndHistogramBeat(datasets,condition1,condition2,condition3,code1,group);

%% color
condition={'cCT1','cBB1','cMB1'}; % encoding
code=[1,2,3,4,5,6];
datasets={'PHC-7','PHC-11'};
source=[1,2];
group='associative color';

resultColor=rasterAndHistogramAssociation(datasets,condition,code,source,group);

%% scene
condition={'sCT1','sBB1','sMB1'}; % encoding
code=[1,2,3,4,5,6]; 
datasets={'A-10','H-2'};
source=[3,4];
group='associative scene';

resultScene=rasterAndHistogramAssociation(datasets,condition,code,source,group);
end