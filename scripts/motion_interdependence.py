import projectile
import numpy as np
import matplotlib.pyplot as plt

# Plot horizontal position over time as vertical velocity changes
v_x = 0.5
v_y_values = np.linspace(0, 1.5, 7)

fig, ax = plt.subplots()
ax.set(ylabel="$x$", xlabel="$t$", title=f"$v_x$ = {v_x:.2f}")

for v_y in v_y_values:
    t, u = projectile.launch([v_x, v_y])
    x = u[:, 0]
    ax.plot(t, x)

fig.legend(v_y_values, title="$v_y$", loc="center right")
fig.tight_layout()
fig.savefig("media/x_vs_t.svg")


# Plot vertical position over time as horizontal velocity changes
v_y = 0.5
v_x_values = np.linspace(0, 1.5, 7)

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$t$", title=f"$v_y$ = {v_y:.2f}")

for v_x in v_x_values:
    t, u = projectile.launch([v_x, v_y])
    y = u[:, 1]
    ax.plot(t, y)

fig.legend(v_x_values, title="$v_x$")
fig.tight_layout()
fig.savefig("media/y_vs_t.svg")
