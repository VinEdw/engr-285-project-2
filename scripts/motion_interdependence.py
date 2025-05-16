import projectile
import numpy as np
import matplotlib.pyplot as plt

# Plot horizontal position over time as vertical velocity changes
v_0x = 0.5
v_0y_values = np.linspace(0, 1.5, 7)
t_f = 2.0

fig, ax = plt.subplots()
ax.set(ylabel="$x$", xlabel="$t$", title=f"$v_{{0x}}$ = {v_0x:.2f}")

for v_0y in v_0y_values:
    t, u = projectile.launch([v_0x, v_0y], lambda t, u: t >= t_f)
    x = u[:, 0]
    ax.plot(t, x)

fig.legend(v_0y_values, title="$v_{0y}$", loc="center right")
fig.tight_layout()
fig.savefig("media/x_vs_t.svg")


# Plot vertical position over time as horizontal velocity changes
v_0y = 0.5
v_0x_values = np.linspace(0, 1.5, 7)

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$t$", title=f"$v_{{0y}}$ = {v_0y:.2f}")

for v_0x in v_0x_values:
    t, u = projectile.launch([v_0x, v_0y])
    y = u[:, 1]
    ax.plot(t, y)

fig.legend(v_0x_values, title="$v_{0x}$")
fig.tight_layout()
fig.savefig("media/y_vs_t.svg")
