from matplotlib.pyplot import plot, show, figure
from numpy import linspace

C_10u = 10e-6  # F
C_100n = 100e-9  # F
R_10k = 10e3  # Ohm
V_cc = 3  # V

w = linspace(0.1, 440, 1000)
V_REF = V_cc / (1 + 1.0j * w * R_10k * (C_100n + C_10u))

figure(0).set_figwidth(12)
plot(w, V_REF)
show()
