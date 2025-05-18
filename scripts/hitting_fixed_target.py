import projectile
import numpy as np
import matplotlib.pyplot as plt

def distance_from_target(v_0, target_pos):
    """
    Launch a projectile from the origin with the given launch velocity.
    Stop simulating when the projectile falls below the line of sight to the target.
    Return position of the projectile relative to the target when it crossed the line of sight.
    Approximate where the projectile crossed the line of sight as the intersection between that line and the line connecting the last two points of the projectile's path.

    If the target is straight up, then return the distance of the projectile from the target when it was at its peak.
    If the target is straight down, then return the distance of the projectile from the target when it fell below the target.
    """
    target_x, target_y = target_pos

    # If the target is straight up, exit when the projectile turns around
    # If the target is straight down, exit when the projectile falls below the target
    if target_x == 0:
        if target_y > 0:
            exit_condition = lambda t, u: u[3] < 0
        else:
            exit_condition = lambda t, u: u[1] < target_y

    # Otherwise, exit when the projectile falls below the line of sight
    else:
        target_slope = target_y / target_x
        exit_condition = lambda t, u: u[1] < target_slope * u[0]

    t, u = projectile.launch(v_0, exit_condition)
    x = u[:, 0]
    y = u[:, 1]

    if target_x == 0:
        if target_y > 0:
            distance_y = y[-1] - target_y
            distance = np.sign(distance_y) * np.sqrt((distance_y)**2 + (x[-1])**2)
        else:
            if x[-2] == x[-1]:
                distance = x[-1]
            else:
                projectile_slope = (y[-2] - y[-1]) / (x[-2] - x[-1])
                distance = (target_y - y[-1])/projectile_slope + x[-1]
    else:
        target_slope = target_y / target_x
        if x[-2] == x[-1]:
            intersection_x = x[-1]
        else:
            projectile_slope = (y[-2] - y[-1]) / (x[-2] - x[-1])
            intersection_x = (y[-1] - projectile_slope*x[-1]) / (target_slope - projectile_slope)
        intersection_y = target_slope * intersection_x
        target_r = np.sqrt(target_x**2 + target_y**2)
        intersection_r = np.sqrt(intersection_x**2 + intersection_y**2)
        distance = intersection_r - target_r

    return distance

def bisection(a, b, f, atol=1e-8):
    """
    Use the bisection method to find a root of the given function on the interval [a, b].
    The root returned will have the given absolute tolerance.
    f(a) and f(b) must have opposite signs.
    """
    f_a = f(a)
    f_b = f(b)
    assert max(f_a, f_b) > 0 and min(f_a, f_b) < 0, "f(a) and f(b) must have opposite signs"

    while True:
        error_bound = (b - a) / 2
        mid = (a + b) / 2
        if error_bound < atol:
            return mid

        f_mid = f(mid)
        if (f_a >= 0 and f_mid >= 0) or (f_a <= 0 and f_mid <= 0):
            a = mid
            f_a = f_mid
        else:
            b = mid
            f_b = mid

def find_launch_speed(rad_launch_theta, target_pos, launch_speed_guess=1.0):
    """
    Find the launch speed required to hit the target at the given position using the given launch angle. 
    Optionally provide a launch speed guess to help pinpoint where the needed launch speed might be.
    """
    target_x, target_y = target_pos
    min_target_theta = np.atan2(target_y, target_x)
    assert rad_launch_theta >= min_target_theta, "The launch angle must be greater than the line of sight angle"

    v_hat = np.array([np.cos(rad_launch_theta), np.sin(rad_launch_theta)])
    distance_func = lambda v: distance_from_target(v * v_hat, target_pos)

    # Find an upper and lower bound for the needed launch speed
    d_guess = distance_func(launch_speed_guess)
    if d_guess <= 0:
        launch_speed_low = launch_speed_guess
        dist_low = d_guess
        launch_speed_high = launch_speed_guess
        while True:
            launch_speed_high *= 2
            dist_high = distance_func(launch_speed_high)
            if dist_high >= 0:
                break
            launch_speed_low = launch_speed_high
    else:
        launch_speed_high = launch_speed_guess
        dist_high = d_guess
        launch_speed_low = launch_speed_guess
        while True:
            launch_speed_low /= 2
            dist_low = distance_func(launch_speed_low)
            if dist_low <= 0:
                break
            launch_speed_high = launch_speed_low

    return bisection(launch_speed_low, launch_speed_high, distance_func)

N = 50
deg_pad_low = 3
deg_launch_values = np.linspace(0, 90, N)

# Plot launch velocity vs launch angle as the target angle varies
max_launch_speed = 5
deg_target_values = np.linspace(0, 45, 4)
target_distance = 1.0

fig, ax = plt.subplots()
ax.set(ylabel="$v_0$", xlabel="$\\theta$ (°)", title=f"Target Distance = {target_distance}")

for deg_target in deg_target_values:
    deg_launch_above_target = deg_launch_values[deg_launch_values > deg_target + deg_pad_low]
    rad_launch_above_target = np.radians(deg_launch_above_target)

    rad_target = np.radians(deg_target)
    target_pos = (target_distance * np.cos(rad_target), target_distance * np.sin(rad_target))

    launch_speed_values = []
    launch_speed_guess = 1.0
    for rad_launch in rad_launch_above_target:
        launch_speed = find_launch_speed(rad_launch, target_pos, launch_speed_guess=launch_speed_guess)
        launch_speed_values.append(launch_speed)
        launch_speed_guess = launch_speed

        if launch_speed > max_launch_speed:
            launch_speed_values.pop()
            deg_launch_above_target = deg_launch_above_target[:len(launch_speed_values)]
            break

    ax.plot(deg_launch_above_target, launch_speed_values, ".")

fig.legend(deg_target_values, title="Target Angle (°)")
fig.tight_layout()
fig.savefig("media/hitting_target_varied_angle.svg")

# Plot launch velocity vs launch angle as the target distance varies
max_launch_speed = 30
deg_target = 15
target_distance_values = np.linspace(1, 3, 3)

fig, ax = plt.subplots()
ax.set(ylabel="$v_0$", xlabel="$\\theta$ (°)", title=f"Target Angle = {deg_target}°")

for target_distance in target_distance_values:
    deg_launch_above_target = deg_launch_values[deg_launch_values > deg_target + deg_pad_low]
    rad_launch_above_target = np.radians(deg_launch_above_target)

    rad_target = np.radians(deg_target)
    target_pos = (target_distance * np.cos(rad_target), target_distance * np.sin(rad_target))

    launch_speed_values = []
    launch_speed_guess = 1.0
    for rad_launch in rad_launch_above_target:
        launch_speed = find_launch_speed(rad_launch, target_pos, launch_speed_guess=launch_speed_guess)
        launch_speed_values.append(launch_speed)
        launch_speed_guess = launch_speed

        if launch_speed > max_launch_speed:
            launch_speed_values.pop()
            deg_launch_above_target = deg_launch_above_target[:len(launch_speed_values)]
            break

    ax.plot(deg_launch_above_target, launch_speed_values, ".")

fig.legend(target_distance_values, title="Target Distance")
fig.tight_layout()
fig.savefig("media/hitting_target_varied_distance.svg")
