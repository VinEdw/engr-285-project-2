#import "engr-conf.typ": conf, py_script
#import "@preview/cetz:0.3.4"

#show: conf.with(
  title: [Realistic Projectiles],
  authors: (
    (first_name: "Vincent", last_name: "Edwards"),
    (first_name: "Julia", last_name: "Corrales"),
    (first_name: "Rachel", last_name: "Gossard"),
  ),
  date: datetime(year: 2025, month: 5, day: 25),
)

#image("media/thumbnail.svg")

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

The `horizontal_range()` function was used to determine the horizontal range for a projectile launched with the given initial velocity `v_0`.
It does so by calculating the intersection between the ground and the line connecting the last two points of the projectile's motion.
If the last point is labeled $(x_(-1), y_(-1))$ and the second to last point is labeled $(x_(-2), y_(-2))$, then the slope of the line connecting them is $ m = (y_(-2) - y_(-1))/(x_(-2) - x_(-1)) $
The equation for that line can be written as $ y = m (x - x_(-1)) + y_(-1) $
The $x$-value where the line intersects the ground ($y = 0$) corresponds to the range $R$.
Solving for that intersection yields
$
0 &= m (R - x_(-1)) + y_(-1) \
R &= -y_(-1)/m + x_(-1)
$

Note that if the line is vertical, which occurs when $x_(-2) = x_(-1)$, then the range is simply equal to the $x$-value of either of the last two points.

#figure(
  caption: [Intersection Between Ground and Last Two Points],
  cetz.canvas({
    import cetz.draw: *
    set-style(content: (padding: 0.2))
    set-style(circle: (radius: 0.1, fill: black))

    // Draw a line for the ground
    line((-2, 0), (5, 0), name: "ground")

    // Draw the line connecting the last two points of the projectile path
    let p_2 = (1, 1)
    let p_1 = (4, -2)
    set-style(line: (stroke: (dash: "dashed")))
    line(p_2, p_1, name: "path")
    content("path.mid", anchor: "north-east", $y = m (x - x_(-1)) + y_(-1)$)

    // Draw the end points
    let point_radius = 0.1
    circle(p_2, name: "p_2")
    circle(p_1, name: "p_1")
    content("p_2.north", anchor: "south", $(x_(-2), y_(-2))$)
    content("p_1.south", anchor: "north", $(x_(-1), y_(-1))$)

    // Draw the intersection point
    intersections("i", "ground", "path")
    circle("i.0")
    content("i.0", anchor: "south-west", $(R, 0)$)

  })
)

#py_script("projectile", put_output: false, put_fname: true)

= Interdependence of Horizontal and Vertical Motion

When modeling projectiles with no drag or linear drag, one property that emerges is the independence of horizontal and vertical motion.
This occurs because $(d v_x)/(d t)$ does not depend on $y$ or $v_y$, and similarly $(d v_y)/(d t)$ does not depend on $x$ or $v_x$.

With the quadratic drag model, $(d v_x)/(d t)$ depends on $v_y$.
$ (d v_x)/(d t) = -k v v_x = -k v_x sqrt(v_x^2 + v_y^2) $
Similarly, $(d v_y)/(d t)$ depends on $v_x$.
$ (d v_y)/(d t) = -g - k v v_y = -g - k v_y sqrt(v_x^2 + v_y^2) $
Increasing $v_x$ or $v_y$ causes the drag experienced in both the $x$ and $y$ directions to increase.
This leads to the interdependence of horizontal and vertical motion.

#py_script("motion_interdependence", put_output: false, put_fname: false)

@x_vs_t plots the horizontal position of the projectile over time as the initial vertical velocity varies.
The initial horizontal velocity was kept constant.
Each launch was kept going for the same amount of time.
If $x$ and $y$ motion were independent, then each plot for a different $v_(0y)$ value would be identical.
Since the plots vary as $v_(0y)$ changes, this demonstrates the interdependence of $x$ and $y$ motion.

#figure(
  image("media/x_vs_t.svg", width: 80%),
  caption: [$x$ vs $t$ as $v_(0y)$ Varies],
) <x_vs_t>

@y_vs_t plots the vertical position of the projectile over time as the initial horizontal velocity varies.
The initial vertical velocity was kept constant.
Each launch was kept going until the projectile hit the ground ($y = 0$).
Notice that the max height and time in the air decrease as $v_(0x)$ increases.
If $x$ and $y$ motion were independent, then each plot for a different $v_(0x)$ value would be identical.
Since the plots vary as $v_(0x)$ changes, this demonstrates the interdependence of $x$ and $y$ motion.

#figure(
  image("media/y_vs_t.svg", width: 80%),
  caption: [$y$ vs $t$ as $v_(0x)$ Varies],
) <y_vs_t>

= Trajectory Shapes

Projectiles that experience no drag follow parabolic trajectories.
In contrast, projectiles that experience quadratic drag follow trajectories that are approximately parabolic.
These trajectories are asymmetric and drop more steeply than they rise.
The horizontal velocity continuously decreases towards zero, since the drag always opposes the motion and decreases as the horizontal velocity decreases.
The vertical velocity decreases to zero initially, then decreases towards the negative of the terminal speed.
Thus, the angle of descent approaches -90#sym.degree as the projectile falls for a long time.

#py_script("trajectory_shapes", put_output: false, put_fname: false)

@xy_vs_theta plots the projectile's trajectory as the launch angle varies.
The launch speed was kept constant.
The trajectories for smaller launch angles appear more symmetric than for higher launch angles (excluding $theta = 90 degree$, as that path is a vertical line regardless of drag).
This could be due to larger launch angles providing more air time, allowing drag to have more of an impact on the trajectory.

#figure(
  image("media/xy_vs_theta.svg", width: 80%),
  caption: [Trajectory as $theta$ Varies],
) <xy_vs_theta>

@xy_vs_v plots the projectile's trajectory as the launch speed varies.
The launch angle was kept constant.
The trajectories for smaller launch speeds appear more symmetric than for higher launch velocities.
When the launch speed is higher, the projectile experiences higher drag force on average and its trajectory is more noticeably impacted.
When the launch speed is lower, the projectile experiences lower drag force on average and its trajectory is less noticeably impacted.

#figure(
  image("media/xy_vs_v.svg", width: 80%),
  caption: [Trajectory as $v_0$ Varies],
) <xy_vs_v>

= Firing Range

#py_script("firing_range", put_output: false, put_fname: false)

#figure(
  image("media/R_vs_theta.svg", width: 80%),
  caption: [$R$ vs $theta$ as $v_0$ Varies],
)

#figure(
  image("media/R_vs_v.svg", width: 80%),
  caption: [$R$ vs $v_0$ as $theta$ Varies],
)

= Hitting a Fixed Target

#py_script("hitting_fixed_target", put_output: false, put_fname: false)

#figure(
  image("media/test_hitting_target.svg", width: 80%),
  caption: [Test Hitting Target],
)

= Cover Image

The following script was use to create the cover image.

#py_script("create_thumbnail", put_output: false, put_fname: false)
