featDim = 3;
DataDir = 'Your allDataDir';
cd(DataDir);
load('allEEG_MI_10s_Data'); load('allEEG_MI_10s_Label');
cd('Your WorkDataDir');

[ CSP_F, cspFeature, cspLabel ] = CspFeature( allData, allLabel, featDim );

saveDataDir = 'Your saveDataDir';
labelDir = 'Your saveLabelDir';
save(saveDataDir, 'cspFeature'); save(labelDir, 'cspLabel');







