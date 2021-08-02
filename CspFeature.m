function [ F, csp_feature, csp_label ] = CspFeature( inputData, inputLabel, featDim )
% -----------------------------------
% 求取输入数据的CSP特征
% -----------------------------------
% Output:
% F -- 空间滤波器
% csp_feature -- inputData提取的CSP特征，(采样点数,样本数)
% csp_label -- csp_feature对应的标签
% Input:
% inputData -- 输入数据，(采样点数,通道数,样本数)
% inputLabel -- inputData对应的标签，0/left，1/right
% featDim -- 提取特征对数

    channels = size(inputData, 2);
    trials = size(inputData, 3);
    CovData = zeros(channels, channels, trials);
    for i = 1:trials
        sigData = inputData(:,:,i);
        sigDataX = sigData'*sigData;
        CovData(:,:,i) = sigDataX/trace(sigDataX);
    end
    C_left = sum(CovData(:, :, inputLabel == 0), 3);
    C_right = sum(CovData(:, :, inputLabel == 1), 3);
    C = C_left + C_right;
    
    [Vc, Dc] = eig(C);
    P = diag(diag(Dc).^(-1/2))*Vc';
    S_left = P*C_left*P';
    [Vs, Ds] = eig(S_left);
    [~, index] = sort(diag(Ds), 'descend');
    Vs = Vs(:, index);
    F = P'*Vs;
    F = F(:, [1:featDim channels-featDim+1:channels]);
    
    data_left = inputData(:, :, inputLabel == 0);
    data_right = inputData(:, :, inputLabel == 1);
    left_num = size(data_left ,3);
    right_num = size(data_right ,3);
    csp_left = zeros(featDim*2, left_num);
    csp_right = zeros(featDim*2, right_num);
    for i=1:left_num
        csp_left(:, i) = log(var(data_left(:, :, i)*F));
    end
    for i=1:right_num
        csp_right(:, i) = log(var(data_right(:, :, i)*F));
    end
    csp_feature = [csp_left, csp_right];
    csp_label = [zeros(1, left_num), ones(1, right_num)];

end