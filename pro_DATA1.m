subNum = 29;

for id=1:subNum
    startup_bbci_toolbox('DataDir','Your DataDir',...
        'TmpDir','Your TmpDir');
    BTB.History = 0;
    DataDir = 'Your DataDir';
    subdir_list = {'\subject 01','\subject 02','\subject 03','\subject 04','\subject 05','\subject 06',...
        '\subject 07','\subject 08','\subject 09','\subject 10','\subject 11','\subject 12','\subject 13'...
        ,'\subject 14','\subject 15','\subject 16','\subject 17','\subject 18','\subject 19','\subject 20'...
        ,'\subject 21','\subject 22','\subject 23','\subject 24','\subject 25','\subject 26','\subject 27'...
        ,'\subject 28','\subject 29'};
    loadDir = fullfile(DataDir, subdir_list{id});
    cd(loadDir);
    load cnt; load mrk, load mnt;
    cd('Your WorkDir')

    %% 合并MI数据
    cnt_temp = cnt; mrk_temp = mrk;
    clear cnt mrk;
    [cnt.imag, mrk.imag] = proc_appendCnt({cnt_temp{1}, cnt_temp{3}, cnt_temp{5}},...
        {mrk_temp{1}, mrk_temp{3}, mrk_temp{5}});

    %% 选择需要使用的通道
    MotorChannel = {'FCC5h','FCC6h','FCC3h','FCC4h','Cz','CCP5h','CCP6h','CCP3h','CCP4h'};
    cnt.imag = proc_selectChannels(cnt.imag, MotorChannel);

    %% 原始数据分段
    ival_epo  = [0 10]*1000;
    epo.imag = proc_segmentation(cnt.imag, mrk.imag, ival_epo);
    
    %% 8-30Hz滤波
    Wp = [8 30]/200*2;
    Ws = [5 33]/200*2;
    Rp = 3;
    Rs = 30;
    [n, Ws] = cheb2ord(Wp, Ws, Rp, Rs);
    [b,a] = cheby2(n,Rs,Ws);
    epo.imag = proc_filtfilt(epo.imag, b, a);
    
    %% 保存
    dataDir = 'Your DataSaveDir';
    EEG_MI_10s_Data = epo.imag.x;
    save(dataDir, 'EEG_MI_10s_Data');
    
    labelDir = 'Your LabelSaveDir';
    EEG_MI_10s_Label = epo.imag.y(1,:);
    save(labelDir, 'EEG_MI_10s_Label');
    
    clear
end









