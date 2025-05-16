#import "engr-conf.typ": conf, py_script
#show: conf.with(
  title: [Realistic Projectiles],
  authors: (
    (first_name: "Vincent", last_name: "Edwards"),
    (first_name: "Julia", last_name: "Corrales"),
    (first_name: "Rachel", last_name: "Gossard"),
  ),
  date: datetime(year: 2025, month: 5, day: 25),
)

// #image("media/thumbnail.png")

// Table of contents
#pagebreak()
#outline()
#pagebreak()

= Quadratic Drag Equation

In introductory physics, projectiles are typically modeled as experiencing negligible air drag.
For this project, projectiles were modeled as experiencing _quadratic drag_.
$
(d^2 arrow(r))/(d t^2) = arrow(g) - k v^2 hat(v)
$

The terms in this equation are as follows:
$
arrow(r) &= vec(x, y) quad&("position") \
arrow(v) &= (d arrow(r))/(d t) quad&("velocity") \
arrow(g) &= vec(0, -g) quad&("gravitation acceleration") \
k &= "\"constant\"" quad&("drag constant") \
$
The $y$ axis points straight up, and the $x$ axis points horizontally along the plane of motion of the projectile.
This keeps the motion in 2 dimensions.
Projectiles were started on the ground at $(x, y) = (0, 0)$.

To focus on scale-independent features of the motion, units of distance and time were used such that $g = 1$ and $k = 1$.
This makes the terminal speed $v_oo = 1$.

= Runge-Kutta Four (RK4) Method for Systems

To solve the system of differential equations, the RK4 method for systems was used.

$
(d arrow(u))/(d t) &= arrow(f)(t, arrow(u)) \
arrow(k)_1 &= arrow(f)(t_i, arrow(u)_i) \
arrow(k)_2 &= arrow(f)(t_i + h/2, arrow(u)_i + h/2 arrow(k)_1) \
arrow(k)_3 &= arrow(f)(t_i + h/2, arrow(u)_i + h/2 arrow(k)_2) \
arrow(k)_4 &= arrow(f)(t_i + h, arrow(u)_i + h arrow(k)_3) \
arrow(u)_(i+1) &= arrow(u)_i + h/6 (arrow(k)_1 + 2 arrow(k)_2 + 2 arrow(k)_3 + arrow(k)_4) \
$

The `rk4.py` file contains a `calculate()` function that implements the RK4 method for systems in Python.
`calculate()` returns arrays containing $t$ and $arrow(u)$ values, and it takes the following parameters:
- `t_0`: a starting $t$ value
- `u_0`: an array containing the initial value for each variable in the system $arrow(u)_0$
- `h`: a step size
- `diff`: a function that takes `t` and `u` as inputs and returns an array containing the result of the differential equation $arrow(f)(t, arrow(u))$
- `should_exit`: a function that takes `t` and `u` as inputs and returns `True` when the iterations should stop

#py_script("rk4", put_output: false, put_fname: true)

The `projectile.py` file contains functions to help simulate the motion of a projectile experiencing quadratic drag.
The `u_prime()` function implements the system of differential equations that describe the motion of the projectile.

$
arrow(u) &= vec(x, y, v_x, v_y) \
(d arrow(u))/(d t) &= vec(v_x, v_y, -k v v_x, -g - k v v_y)
$

The `launch()` function simulates launching a projectile from the origin with the given initial velocity `v_0`, and it returns arrays containing $t$ and $arrow(u)$ values.
By default the `should_exit` parameter is set to the `below_ground()` function, which returns `True` when the projectile falls below the ground ($y < 0$).
#py_script("projectile", put_output: false, put_fname: true)

= Interdependence of Horizontal and Vertical Motion

#py_script("motion_interdependence", put_output: false, put_fname: false)

#figure(
  image("media/x_vs_t.svg", width: 80%),
  caption: [$x$ vs $t$ as $v_(0y)$ Varies],
)

#figure(
  image("media/y_vs_t.svg", width: 80%),
  caption: [$y$ vs $t$ as $v_(0x)$ Varies],
)

= Trajectory Shapes

#py_script("trajectory_shapes", put_output: false, put_fname: false)

#figure(
  image("media/xy_vs_theta.svg", width: 80%),
  caption: [Trajectory as $theta$ Varies],
)

#figure(
  image("media/xy_vs_v.svg", width: 80%),
  caption: [Trajectory as $v_0$ Varies],
)

= Firing Range

#py_script("firing_range", put_output: false, put_fname: false)

#figure(
  image("media/R_vs_theta.svg", width: 80%),
  caption: [$R$ vs $theta$ as $v_0$ Varies],
)

#figure(
  image("media/xy_vs_v.svg", width: 80%),
  caption: [$R$ vs $v_0$ as $theta$ Varies],
)

= Extension

#py_script("hitting_fixed_target", put_output: false, put_fname: false)

#figure(
  image("media/test_hitting_target.svg", width: 80%),
  caption: [Test Hitting Target],
)

