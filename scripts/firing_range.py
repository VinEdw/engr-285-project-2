import projectile
import numpy as np
import matplotlib.pyplot as plt

N = 100

# Plot firing range vs launch angle as launch speed changes
v_0_values = np.linspace(0, 2.0, 9)
deg_theta_values = np.linspace(0, 90, N)

fig, ax = plt.subplots()
ax.set(ylabel="$R$", xlabel="$\\theta$ (°)")

for v_0 in v_0_values:
    firing_range_values = []
    for rad_theta in np.radians(deg_theta_values):
        v_x = v_0 * np.cos(rad_theta)
        v_y = v_0 * np.sin(rad_theta)
        firing_range = projectile.horizontal_range([v_x, v_y])
        firing_range_values.append(firing_range)
    ax.plot(deg_theta_values, firing_range_values)

fig.legend(v_0_values, title="$v_0$")
fig.tight_layout()
fig.savefig("media/R_vs_theta.svg")


# Plot firing range vs launch speed as launch angle changes
deg_theta_values = np.linspace(0, 90, 7)
v_0_values = np.linspace(0, 4, N)

fig, ax = plt.subplots()
ax.set(ylabel="$R$", xlabel="$v_0$")

for rad_theta in np.radians(deg_theta_values):
    firing_range_values = []
    for v_0 in v_0_values:
        v_x = v_0 * np.cos(rad_theta)
        v_y = v_0 * np.sin(rad_theta)
        firing_range = projectile.horizontal_range([v_x, v_y])
        firing_range_values.append(firing_range)
    ax.plot(v_0_values, firing_range_values)

fig.legend(deg_theta_values, title="$\\theta$ (°)", ncols=2, loc="upper center")
fig.tight_layout()
fig.savefig("media/R_vs_v.svg")
