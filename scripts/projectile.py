import rk4
import numpy as np

def u_prime(t, u):
    """
    Return an array of derivatives with respect to t for each component of the vector u.
    u consists of x, y, v_x, and v_y.
    """
    k = 1
    g = 1

    x, y, v_x, v_y = u
    speed = np.sqrt(v_x**2 + v_y**2);
    drag_part = k * speed
    if speed == 0:
        drag_x = 0
        drag_y = 0
    else:
        drag_x = drag_part * v_x
        drag_y = drag_part * v_y

    return np.array([
        v_x,
        v_y,
        -drag_x,
        -g - drag_y,
    ])

def below_ground(t, u):
    y = u[1]
    return y < 0

def launch(v_0, should_exit=below_ground):
    """
    Launch a projectile from the origin with the given launch velocity.
    By default, stop after the projectile hits the ground (when y < 0).
    If desired, an alternate function t and u can be passed.
    This function should return True when the exit condition is met.

    Return the arrays of t and u.
    Note that u consists of x, y, v_x, and v_y.
    """
    t_0 = 0.0
    h = 0.001
    v_x, v_y = v_0
    u_0 = np.array([0, 0, v_x, v_y])

    t, u = rk4.calculate(t_0, u_0, h, u_prime, should_exit)

    return t, u

def horizontal_range(v_0):
    """
    Launch a projectile from the origin with the given launch velocity.
    Return the horizontal range of the projectile.
    Approximate the range as the x-intercept of the line connecting the last two points of the projectile's path.
    """
    t, u = launch(v_0)
    x = u[:, 0]
    y = u[:, 1]

    if x[-2] == x[-1]:
        distance = x[-1]
    else:
        slope = (y[-2] - y[-1]) / (x[-2] - x[-1])
        distance = -y[-1]/slope + x[-1]
    return distance
