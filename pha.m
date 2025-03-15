%% 打开文件以读取二进制数据
fid = fopen('1231pha.dat', 'r'); % 打开文件进行读取
if fid == -1
    error('无法打开文件');
end

try
    % 假设每个复数是由两个 float32 数字组成 (4 字节)
    % 读取数据，假设文件中存储的是连续的复数数据
    data = fread(fid, [2, inf], 'float32');  % 读取所有数据，按两列存储（实部，虚部）
    
    % 将数据分割为实部和虚部
    I = data(1, :); % 实部
    Q = data(2, :); % 虚部
    
    % 将实部和虚部合并为复数数据
    iq_data = I + 1i * Q;
    
    % 关闭文件
    fclose(fid);
    
    % 假设已知采样率 fs 和复数数据 iq_data（包含实部和虚部）
    fs = 1e6;  % 采样率，例如 1MHz
    
    N = length(iq_data);  % 数据点数
    

    
    % 设计15kHz低通滤波器，提高滤波器的选择性和性能
Fpass = 15e3; % 通带截止频率为15kHz
Fstop = 15.5e3; % 阻带开始频率稍微高于通带截止频率
Apass = 1; % 通带纹波（dB）
Astop = 60; % 阻带衰减（dB）

d = designfilt('lowpassfir', 'PassbandFrequency', Fpass, ...
    'StopbandFrequency', Fstop, ... 
    'PassbandRipple', Apass, 'StopbandAttenuation', Astop, 'SampleRate', fs);

    % 应用滤波器到复数IQ数据上
    filtered_iq_data = filtfilt(d, iq_data);
    
    % 计算频率轴
    f = (0:N-1) * (fs / N);  % 频率从 0 到 fs-1（对于一个单边频谱）
    
    % 计算相位谱
    phase_data_filtered = angle(filtered_iq_data);  % 计算相位
    
    % 绘制滤波后的相位谱图，横坐标是频率
    figure;
    plot(f(1:N/2), phase_data_filtered(1:N/2)); % 只绘制正频率部分
    title('Filtered Phase Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    grid on;
    
   
      
catch ME
    % 确保在发生错误时关闭文件
    fclose(fid);
    rethrow(ME);
end