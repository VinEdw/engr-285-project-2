import numpy as np

def calculate(t_0, u_0, h, diff, should_exit):
    """
    Calculate t values & u vectors using the vector RK4 method on a system of 1st order ODEs.
    Return an array of t values, and an array of u vectors.

    - t_0: starting t value
    - u_0: starting u vector
    - h: step size
    - diff: function that takes t and u as arguments and returns du/dt
    - should_exit: function that takes t and u as arguments and returns True if no more steps should be taken
    """
    t = [t_0]
    u = [u_0]

    while not should_exit(t[-1], u[-1]):
        k_1 = diff(t[-1], u[-1])
        k_2 = diff(t[-1] + h/2, u[-1] + h/2 * k_1)
        k_3 = diff(t[-1] + h/2, u[-1] + h/2 * k_2)
        k_4 = diff(t[-1] + h, u[-1] + h * k_3)

        u_next = u[-1] + h/6 * (k_1 + 2*k_2 + 2*k_3 + k_4)
        u.append(u_next)
        t_next = t[-1] + h
        t.append(t_next)

    return np.array(t), np.array(u)
