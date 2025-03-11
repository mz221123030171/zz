import numpy as np
import matplotlib.pyplot as plt

# 如果相位数据存储在一个文件中，使用以下方法读取
# 假设文件名为 'phase_data.dat'，并且是以二进制浮点数形式保存
phase_data=np.fromfile('/home/mz/文档/1.15pha',dtype=np.float32)

try:
    # 读取二进制浮点数形式保存的数据

    phase_data = np.fromfile('/home/mz/文档/1.15pha', dtype=np.float32)
    # 对相位数据进行无折叠处理
    unwrapped_phase_data = np.unwrap(phase_data)

    # 绘制原始相位数据与无折叠后的相位数据对比图
    plt.figure(figsize=(14, 7))

    plt.subplot(1, 2, 1)
    plt.plot(phase_data[:1000])
    plt.title('Original Phase Data')
    plt.xlabel('Sample Index')
    plt.ylabel('Phase (radians)')
    plt.grid(True)

    plt.subplot(1, 2, 2)
    plt.plot(unwrapped_phase_data)
    plt.title('Unwrapped Phase Data')
    plt.xlabel('Sample Index')
    plt.ylabel('Phase (radians)')
    plt.grid(True)

    plt.tight_layout()
    plt.show()

except FileNotFoundError:
    print(f"Error: The file at path {filename} was not found.")
except Exception as e:
    print(f"An error occurred while reading the file: {e}")