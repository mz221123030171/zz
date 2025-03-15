clear all
close all
clc

MS1=[50,10,5];
BS = [0,0,0;
    0, 20, 10;
    50, 20, 10;
    100, 0, 10;
    60, 0, 10
];
MS=[40,0,0;
    40.11,0,0;
    ];
rho=[[45.8258,24.4949,60.8276,22.3607];
      [45.9218,24.4502,60.7191,22.2623]];


% 初始化状态向量（假设初始整周模糊度为零）
num_ambiguities = size(BS, 1) - 1; % 减去参考基站点

%x0 = zeros(num_ambiguities, 1); % 初始整周模糊度设为0
x0=[-305,50,-555,85];
%加噪
% 定义噪声的均值和标准差
mean_noise = 0; % 高斯噪声的均值
std_dev_noise = 0.1; % 高斯噪声的标准差

% 生成与 v 相同长度的高斯噪声向量
noise = mean_noise + std_dev_noise * randn(size(x0));

% 将噪声添加到原始列向量上
x0 = x0 + noise;
x0=x0(:);

ambiguity_uncertainty=0.01;

% 初始化协方差矩阵
P0 = eye(num_ambiguities) * ambiguity_uncertainty^2;

% 状态转移矩阵（假设静态情况）
F = eye(num_ambiguities);

% 观测矩阵（仅与整周模糊度相关）
H = eye(num_ambiguities);

% 过程噪声协方差矩阵
Q = eye(num_ambiguities) * 0^2;

% 观测噪声协方差矩阵
%R = eye(num_ambiguities) * 0.5^2;

R=[1 0.5 0.5 0.5;0.5 1 0.5 0.5 ;0.5 0.5 1 0.5;0.5 0.5 0.5 1]*4*0.1^2;
% 获取双差分观测值（包含波长信息）
dd_obs = generate_double_difference_observations(BS, MS, MS1);
disp(dd_obs)
disp('双差相位归一化:');

dd_obs=abs(dd_obs)-floor(abs(dd_obs));
dd_obs=dd_obs+noise;
disp(dd_obs)
% disp(['dd_obs size: ', num2str(size(dd_obs))]);
% disp(['x0 size: ', num2str(size(x0))]);
% disp(['P0 size: ', num2str(size(P0))]);
% disp(['F size: ', num2str(size(F))]);
% disp(['H size: ', num2str(size(H))]);
% disp(['Q size: ', num2str(size(Q))]);
% disp(['R size: ', num2str(size(R))]);

% EKF更新步骤
for ii =1 :1
[x, P] = ekf_ambiguity_float_solution(dd_obs(ii,:), x0, P0, F, H, Q, R);

% 显示结果
disp('浮点解:');
disp(['整周模糊度: ', num2str(x')]);

end
disp('方差协方差:');
disp(P)
