import projectile
import numpy as np
import matplotlib.pyplot as plt

g = 1
v_0 = [2.0, 0.75]
v_0x, v_0y = v_0
N = 100

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$x$")
ax.tick_params(
    axis="both",
    which="both",
    labelbottom=False,
    bottom=False,
    labelleft=False,
    left=False,
)
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

# No drag
t_f = 2 * v_0y / g
t = np.linspace(0, t_f, N)
x = v_0x * t
y = v_0y * t - g * t**2 / 2
ax.plot(x, y, label="No Drag")

# Quadratic drag
t, u = projectile.launch(v_0)
x = u[:, 0]
y = u[:, 1]
ax.plot(x, y, label="Quadratic Drag")

fig.legend()
fig.tight_layout()
fig.savefig("media/thumbnail.svg")
