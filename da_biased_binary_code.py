from distutils.command.config import config

from fxpmath import Fxp
import numpy as np
import math

N = 16
FRAC = N - 3
K = 8

ADDRtype = Fxp(val=None, signed=False, n_word=int(np.log2(2 ** (int(K / 2)))), n_frac=0)
DATA = Fxp(val=None, signed=True, n_word=N, n_frac=FRAC)

a = np.array([0.99, 0.99, 0.99, 0.99, 0.99, 0.99, 0.99, 0.99])
x = np.array([0.99, 0.24499512, 0.30554199, 0.38122559, 0.47558594, 0, 0, 0,])
# 0000.0111100111000
assert (x.size == a.size)

xf = Fxp(x).like(DATA)

LUT1 = Fxp(np.array([
    -0.5 * (a[4] + a[5] + a[6] + a[7]),
    -0.5 * (a[4] + a[5] + a[6] - a[7]),
    -0.5 * (a[4] + a[5] - a[6] + a[7]),
    -0.5 * (a[4] + a[5] - a[6] - a[7]),
    -0.5 * (a[4] - a[5] + a[6] + a[7]),
    -0.5 * (a[4] - a[5] + a[6] - a[7]),
    -0.5 * (a[4] - a[5] - a[6] + a[7]),
    -0.5 * (a[4] - a[5] - a[6] - a[7]),
])).like(DATA)

LUT0 = Fxp(np.array([
    -0.5 * (a[0] + a[1] + a[2] + a[3]),
    -0.5 * (a[0] + a[1] + a[2] - a[3]),
    -0.5 * (a[0] + a[1] - a[2] + a[3]),
    -0.5 * (a[0] + a[1] - a[2] - a[3]),
    -0.5 * (a[0] - a[1] + a[2] + a[3]),
    -0.5 * (a[0] - a[1] + a[2] - a[3]),
    -0.5 * (a[0] - a[1] - a[2] + a[3]),
    -0.5 * (a[0] - a[1] - a[2] - a[3]),
])).like(DATA)

addrzero = Fxp(0).like(ADDRtype)
ACC0 = LUT0[addrzero.val]
ACC0.config.shifting = 'trunc'

ACC0.rounding = 'trunc'

for i in reversed(range(0, N)):   # From LSB
    Ts = 1 if 0 == i else 0
    addr_str = "0b0"  # Fxp ignores unsigned type while converting str to number, 1 in MSB causes an error
    for j in range(0, int(K/2)):
        addr_str += xf[j].bin()[i]

    xn1bit = int(xf[0].bin()[i])

    xn1 = ~addrzero if xn1bit == 1 else addrzero
    addr = Fxp(addr_str).like(ADDRtype) ^ xn1

    LUTval = LUT0[addr.val]

    sign = xn1bit ^ Ts
    if sign:
        ACC0.equal(ACC0 - LUTval)
    else:
        ACC0.equal(ACC0 + LUTval)
    # print('\n\n')
    # print("ACC0: " + str(ACC0.bin(frac_dot=True)))

    if 0 != i:
        ACC0.equal(ACC0 >> 1)  # Shift until last iteration

    # print("ACC0: " + str(ACC0.bin(frac_dot=True)))
    # print('\n\n')

    print("ACC0: " + str(ACC0.hex()) +
          " ACC(d): " + str(ACC0) +
          "| LUT: " + LUTval.bin() +
          "| addr_str: " + addr_str +
          "| xf[0]: " + xf[0].bin()[i] +
          "| xor: " + addr.bin() +
          "| Ts: " + str(Ts))

# 1.01

ACC1 = LUT1[addrzero.val]
ACC1.rounding = 'trunc'
ACC1.config.shifting = 'trunc'

for i in reversed(range(0, N)):   # From LSB
    Ts = 1 if 0 == i else 0
    addr_str = "0b0"  # Fxp ignores unsigned type while converting str to number, 1 in MSB causes an error
    for j in range(int(K/2), K):
        addr_str += xf[j].bin()[i]

    xn1bit = int(xf[int(K/2)].bin()[i])

    xn1 = ~addrzero if xn1bit == 1 else addrzero
    addr = Fxp(addr_str).like(ADDRtype) ^ xn1

    LUTval = LUT1[addr.val]

    sign = xn1bit ^ Ts
    if sign:
        ACC1.equal(ACC1 - LUTval)
    else:
        ACC1.equal(ACC1 + LUTval)

    if 0 != i:
        ACC1.equal(ACC1 >> 1)  # Shift until last iteration

    print("ACC1: " + str(ACC1.hex()) +
          " ACC(d): " + str(ACC1) +
          "| LUT: " + LUTval.bin() +
          "| addr_str: " + addr_str +
          "| xf[0]: " + xf[0].bin()[i] +
          "| xor: " + addr.bin() +
          "| Ts: " + str(Ts))

print(ACC0 == ACC1)

ACC = ACC0 + ACC1
print('result')
print(ACC.bin(frac_dot=True))
print("ACC: ", ACC, "accurate: ", np.dot(a, x))
ACC.info()
print('LUT0')
print(LUT0.bin())
print('LUT1')
print(LUT1.bin())
print('X')
print(xf.bin())

str = '0001100101'
a=0.5
res = 0
for i in range(0, 10):
    if str[i] == '1':
        res = res + a
    a = a / 2
print(res)

str2 = '0001010100'
a=0.5
res = 0
for i in range(0, 10):
    if str2[i] == '1':
        res = res + a
    a = a / 2

print(res)