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
