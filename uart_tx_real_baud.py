import math

def baud_cauculator(input_freq, baud):
    max_cycles = math.floor(float(input_freq) / float(baud))
    periodo = (1.0 / input_freq)
    real_baud = 1.0 /(max_cycles * periodo)
    print(f"Real baud rate calculated: {real_baud}")

# Chamando a função com as entradas 50e6 e 9600
baud_cauculator(27e6, 9600)