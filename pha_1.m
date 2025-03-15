% 打开文件以读取二进制数据
fid = fopen('1231pha.dat', 'r'); % 打开文件进行读取
if fid == -1
    error('无法打开文件');
end

% 假设每个复数是由两个 float32 数字组成 (4 字节)
% 读取数据，假设文件中存储的是连续的复数数据
data = fread(fid, [2, inf], 'float32');  % 读取所有数据，按两列存储（实部，虚部）
size(data)
% 关闭文件
fclose(fid);

% 将数据分割为实部和虚部
I = data(1, :); % 实部
Q = data(2, :); % 虚部

% 将实部和虚部合并为复数数据
iq_data = I + 1i * Q;


% 假设已知采样率 fs 和复数数据 iq_data（包含实部和虚部）
fs = 1e6;  % 采样率，例如 1000 Hz

N = length(iq_data);  % 数据点数

% 计算频率轴
f = (0:N-1) * (fs / N);  % 频率从 0 到 fs-1（对于一个单边频谱）

% 计算相位谱
phase_data = angle(iq_data);  % 计算相位

% 绘制相位谱图，横坐标是频率
figure;
plot(f, phase_data);
title('Phase Spectrum');
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
grid on;

% 3. 绘制时域波形
figure;

% 绘制实部
subplot(2,1,1);
plot(real(iq_data));
title('Time Domain Waveform (Real Part)');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;


