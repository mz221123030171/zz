clear all
close all
clc

MS1=[1,0.5]*100;
BS = [0,0;
    3, 0;
    0, 1;
    3, 1
]*100;
bochang1=0.36;




% 指定要生成的基站坐标数量（包含初始点）
num_stations = 5; % 这里示例生成10个坐标（算上初始点），你可以按需修改

% 初始位置的横坐标和纵坐标
initial_x = 2;
initial_y = 0.5;

% 步进值（沿x方向负半轴，所以为负数）
step_size_x = 0.001; % 注意这里是负数，表示向x负半轴步进
step_size_y = 0.001; % y方向不进行步进，保持初始值

% 用于存储生成的基站坐标的矩阵，多预留一行用于存放初始点
MS = zeros(num_stations, 2);

% 先将初始点存入数组第一行
MS(1, 1) = initial_x;
MS(1, 2) = initial_y;

for i = 2:num_stations
    % 计算横坐标，从第二个点开始按照负向步进值计算
    MS(i, 1) = initial_x + (i - 1) * step_size_x;
    MS(i, 2) = initial_y +(i - 1) * step_size_x;
end
for j = num_stations+1:num_stations+num_stations
       MS(j, 1) = initial_x + (j - 1) * step_size_y;
    MS(j, 2) = initial_y+ (j - 1) * step_size_y;
end


% 初始化状态向量（假设初始整周模糊度为零）
num_ambiguities = size(BS, 1) - 1; % 减去参考基站点

%x0 = zeros(num_ambiguities, 1); % 初始整周模糊度设为0

x0_nonoise=1.0e+02 *[-5.599638451224713  -2.707181823883646  -6.048858058503067];

%加噪
% 定义噪声的均值和标准差
mean_noise = 0; % 高斯噪声的均值
std_dev_noise = 0.1; % 高斯噪声的标准差
mean_noise2=0;
std_dev_noise2 =sqrt(4*(0.3*pi)^2);
% 生成与 v 相同长度的高斯噪声向量
noise = mean_noise + std_dev_noise * randn(size(x0_nonoise));
noise2 = mean_noise2 + std_dev_noise2 * randn(size(3,10));
% 将噪声添加到原始列向量上

x0 = (x0_nonoise*bochang1+noise)/bochang1;
disp(x0);
x0=x0(:);

ambiguity_uncertainty=0.031;

% 初始化协方差矩阵
P0 = eye(num_ambiguities) * ambiguity_uncertainty^2;

% 状态转移矩阵（假设静态情况）
F = eye(num_ambiguities);

% 观测矩阵（仅与整周模糊度相关）
H = eye(num_ambiguities);

% 过程噪声协方差矩阵
Q = eye(num_ambiguities) * 0^2;

% 观测噪声协方差矩阵
%R = eye(num_ambiguities) * 0.6^2;
%2D
R=[1 0.5 0.5 ;0.5 1 0.5  ;0.5 0.5 1 ]*4*0.1^2;

% 获取双差分观测值（包含波长信息）
dd_obs = generate_double_difference_observations(BS, MS, MS1);
disp(dd_obs/bochang1)

disp('双差相位归一化:');

dd_obs=mod(dd_obs/bochang1 ,1);
dd_obs=(dd_obs*2*pi+noise2)/(2*pi);
disp(dd_obs)
%  disp(['dd_obs size: ', num2str(size(dd_obs))]);
%  disp(['x0 size: ', num2str(size(x0))]);
%  disp(['P0 size: ', num2str(size(P0))]);
%  disp(['F size: ', num2str(size(F))]);
%  disp(['H size: ', num2str(size(H))]);
%  disp(['Q size: ', num2str(size(Q))]);
%  disp(['R size: ', num2str(size(R))]);

% EKF更新步骤

for ii =1 :10

[x, P] = ekf_ambiguity_float_solution(dd_obs(ii,:), x0, P0, F, H, Q, R);
disp(['整周模糊度: ', num2str(x'+fix(dd_obs(ii,:)))]);
end

% 显示结果
disp('浮点解:');
disp(['整周模糊度: ', num2str(x')]);
disp('方差协方差:');
disp(P)