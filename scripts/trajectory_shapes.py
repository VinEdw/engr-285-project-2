import projectile
import numpy as np
import matplotlib.pyplot as plt

# Plot trajectories as launch angle changes
v_0 = 1.5
deg_theta_values = np.linspace(0, 90, 7)

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$x$", title=f"$v_0$ = {v_0:.2f}")

for rad_theta in np.radians(deg_theta_values):
    v_x = v_0 * np.cos(rad_theta)
    v_y = v_0 * np.sin(rad_theta)
    t, u = projectile.launch([v_x, v_y])
    x = u[:, 0]
    y = u[:, 1]
    ax.plot(x, y)

fig.legend(deg_theta_values, title="$\\theta$ (°)")
fig.tight_layout()
fig.savefig("media/xy_vs_theta.svg")


# Plot trajectories as launch speed changes
deg_theta = 45
rad_theta = np.radians(deg_theta)
v_0_values = np.linspace(0, 1.5, 7)

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$x$", title=f"$\\theta$ = {deg_theta}°")

for v_0 in v_0_values:
    v_x = v_0 * np.cos(rad_theta)
    v_y = v_0 * np.sin(rad_theta)
    t, u = projectile.launch([v_x, v_y])
    x = u[:, 0]
    y = u[:, 1]
    ax.plot(x, y)

fig.legend(v_0_values, title="$v_0$")
fig.tight_layout()
fig.savefig("media/xy_vs_v.svg")
