import matlab.engine

try:
    eng = matlab.engine.start_matlab()
    print("MATLAB engine started successfully.")
# 执行一个简单的 MATLAB 命令
    result = eng.eval('1+1')
    print("Result of 1+1 in MATLAB:", result)
except Exception as e:
    print("Failed to start MATLAB engine:", str(e))