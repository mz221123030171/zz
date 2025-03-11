import numpy as np
import matplotlib.pyplot as plt

def int_to_qpsk(value):
    # 将整数转换为 8 位二进制字符串
    binary_str = format(value, '08b')

    # 每 2 位一组进行 QPSK 调制
    qpsk_symbols = []
    for i in range(0, 8, 2):
        bits = binary_str[i:i + 2]
        if bits == '00':
            qpsk_symbols.append(1.41421 + 1.41421j)
        elif bits == '01':
            qpsk_symbols.append(1.41421 - 1.41421j)
        elif bits == '11':
            qpsk_symbols.append(-1.41421 - 1.41421j)
        elif bits == '10':
            qpsk_symbols.append(-1.41421 + 1.41421j)

    return qpsk_symbols


# 给定的 PN 序列
pn_sequence = [140, 4, 121, 53, 118, 156, 254, 225, 178, 162, 88, 192]

# 将 PN 序列进行 QPSK 调制
qpsk_modulated = []
for value in pn_sequence:
    qpsk_modulated.extend(int_to_qpsk(value))

# 生成高斯噪声
noise = np.random.normal(0, 0.3, len(qpsk_modulated)) + 1j * np.random.normal(0, 0.1, len(qpsk_modulated))

# 生成带噪声的输入信号
input_signal = np.array(qpsk_modulated) + noise

# 打印带噪声的输入信号
print("带噪声的输入信号:")
print(input_signal)


# LMS 滤波器类
class LMSFilter:
    def __init__(self, mu=0.1, N=64, known_signal=None):
        self.mu = mu  # 步长参数
        self.N = N  # 滤波器长度
        self.w = np.zeros(N, dtype=np.complex64)  # 初始化滤波器系数为零
        self.known_signal = known_signal  # 已知信号
        self.known_signal_index = 0  # 已知信号的当前索引

    def process(self, input_signal):
        output_signal = np.zeros(len(input_signal), dtype=np.complex64)

        for i in range(len(input_signal)):
            # 构建输入样本向量 x，确保它的长度总是 N
            if i >= self.N - 1:
                x = input_signal[i - self.N + 1:i + 1][::-1]
            else:
                x = np.pad(input_signal[:i + 1][::-1], (self.N - i - 1, 0), 'constant', constant_values=0)

            # 获取已知信号的当前值
            desired = self.known_signal[self.known_signal_index]
            self.known_signal_index = (self.known_signal_index + 1) % len(self.known_signal)

            # 计算输出和误差，确保 e 是一个标量
            y = np.dot(x, self.w)
            e = desired - y

            # 更新滤波器系数
            self.w += self.mu * e * x


            output_signal[i] = y  # 将输出写入输出信号数组

        return output_signal


# 创建 LMS 滤波器实例
lms_filter = LMSFilter(mu=0.1, N=128, known_signal=qpsk_modulated)

# 处理带噪声的输入信号
output_signal = lms_filter.process(input_signal )

# 打印处理后的输出信号
print("处理后的输出信号:")
print(output_signal)