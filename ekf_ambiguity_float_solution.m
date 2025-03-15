function [x, P] = ekf_ambiguity_float_solution(dd_obs, x, P, F, H, Q, R)
    % EKF_AMBIGUITY_FLOAT_SOLUTION 使用扩展卡尔曼滤波器进行整周模糊度浮点解计算。
    %
    % 输入:
    %   dd_obs - 双差分观测值（通常为载波相位测量）
    %   x - 状态向量 (初始状态向量或上一次迭代的结果)
    %   P - 估计误差协方差矩阵 (初始协方差矩阵或上一次迭代的结果)
    %   F - 状态转移矩阵
    %   H - 观测矩阵
    %   Q - 过程噪声协方差矩阵
    %   R - 观测噪声协方差矩阵
    %
    % 输出:
    %   x - 更新后的状态向量
    %   P - 更新后的估计误差协方差矩阵

    % 预测步骤
    x_pred = F * x; % 状态预测
    P_pred = F * P * F' + Q; % 协方差预测

    % 更新步骤
    y = dd_obs(:) - H * x_pred; % 测量残差（将dd_obs转换为列向量）

    % 计算卡尔曼增益
    S = H * P_pred * H' + R; % 残差协方差
    K = P_pred * H' / S; % 卡尔曼增益

    % 状态更新
    x = x_pred + K * y;

    % 协方差更新
    P = (eye(length(x)) - K * H) * P_pred;
end