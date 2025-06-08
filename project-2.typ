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
$ <drag_eq>

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
t_(i+1) &= t_i + h \
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

The derivatives of $x$ and $y$ with respect to time are simply $v_x$ and $v_y$ respectively.
$ (d x)/(d t) = v_x $
$ (d y)/(d t) = v_y $
The derivatives of $v_x$ and $v_y$ with respect to time must be determined by finding the $x$ and $y$ components of @drag_eq.
Using the formula for a unit vector, $hat(v)$ can be rewritten as
$
hat(v) = arrow(v)/v = (v_x hat(i) + v_y hat(j))/v
$
Substituting that expression for $hat(v)$ into @drag_eq yields
$
(d^2 arrow(r))/(d t^2) = arrow(g) - k v^2 ((v_x hat(i) + v_y hat(j))/v) = -g hat(j) - k v (v_x hat(i) + v_y hat(j))
$
Since $(d^2 arrow(r))/(d t^2) = (d arrow(v))/(d t)$, the components of that equation represent the derivatives of $v_x$ and $v_y$ with respect to time.
$ (d v_x)/(d t) = - k v  v_x $
$ (d v_y)/(d t) = - g - k v  v_y $
This results in the following equations for $arrow(u)$ and its derivative.
$
arrow(u) &= vec(x, y, v_x, v_y) \
(d arrow(u))/(d t) &= vec(v_x, v_y, -k v v_x, -g - k v v_y)
$

The `launch()` function simulates launching a projectile from the origin with the given initial velocity `v_0`, and it returns arrays containing $t$ and $arrow(u)$ values.
By default the `should_exit` parameter is set to the `below_ground()` function, which returns `True` when the projectile falls below the ground ($y < 0$).

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
With greater horizontal velocity, the air drag experienced in the vertical direction increases.
This causes the vertical velocity to decrease to 0 sooner, reducing the max height.
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
The trajectories appear more symmetric for launch angles that are closer to 0#sym.degree or 90#sym.degree.
When the launch angle is smaller, the projectile does not stay in the air for very long, reducing the time drag has to impact the trajectory.
When the launch angle is larger, the projectile has a relatively low horizontal velocity, so the drag will not reduce the horizontal velocity as much to shift the trajectory.

When using a model that neglects air drag, 45#sym.degree is the launch angle that achieves maximum range.
Of the trajectories tested in this figure, 45#sym.degree did achieve the highest range.
However, as will be seen later in @R_vs_theta, the optimal launch angle shifts leftward as the launch speed increases.
Thus, 45#sym.degree only appeared to be the optimal launch angle because not enough angles were tested. 

#figure(
  image("media/xy_vs_theta.svg", width: 80%),
  caption: [Trajectory as $theta$ Varies],
) <xy_vs_theta>

@xy_vs_v plots the projectile's trajectory as the launch speed varies.
The launch angle was kept constant.
The trajectories for smaller launch speeds appear more symmetric than for higher launch velocities.
When the launch speed is higher, the projectile experiences higher drag force on average.
As a result, the trajectory is more noticeably impacted with the right side of the parabola dropping more steeply than the left side rises.
When the launch speed is lower, the projectile experiences lower drag force on average and its trajectory is less noticeably impacted, so the parabolic shape is maintained more in these conditions.

#figure(
  image("media/xy_vs_v.svg", width: 80%),
  caption: [Trajectory as $v_0$ Varies],
) <xy_vs_v>

= Firing Range

The `horizontal_range()` function in `projectile.py` was used to determine the horizontal range for a projectile launched with the given initial velocity `v_0`.
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

#py_script("firing_range", put_output: false, put_fname: false)

@R_vs_theta plots the firing range of the projectile versus the launch angle for different launch speeds.
Regardless of launch speed, the range is zero if the launch angle is 0#sym.degree or 90#sym.degree.
The projectile cannot move horizontally it if does not have any initial horizontal velocity ($theta = 90 degree$), nor can it do so if it has no time in the air ($theta = 0 degree$).
Each curve is concave downward.
For low launch speeds, the optimal angle that achieves maximum range is close to 45#sym.degree, which matches what is expected when air drag is negligible.
As the launch speed increases, that optimal angle decreases.
It becomes more efficient to reduce the air time slightly in exchange for greater horizontal velocity.

#figure(
  image("media/R_vs_theta.svg", width: 80%),
  caption: [$R$ vs $theta$ as $v_0$ Varies],
) <R_vs_theta>

@R_vs_v plots the firing range of the projectile versus the launch speed for different launch angles.
For low launch speeds, projectiles launched at complementary angles achieve similar range, which matches what is expected when air drag is negligible.
As the launch speed increases, the lower angle trajectories start to achieve greater range than the higher angle trajectories.
As observed earlier, it becomes more efficient to prioritize having a greater initial horizontal velocity than trying to increase air time with a greater initial vertical velocity.

#figure(
  image("media/R_vs_v.svg", width: 80%),
  caption: [$R$ vs $v_0$ as $theta$ Varies],
) <R_vs_v>

= Hitting a Fixed Target

When launching projectiles, often the goal is to hit a fixed target with a known location.
This requires determining an appropriate launch speed and launch angle.
Note that for the projectile to have a chance of hitting the target, it must be launched at an angle greater than the target angle.
The target angle is the angle of the line of sight, the imaginary line between the target and the launch locations.
For targets not located directly above the origin, the launch angle must be kept below 90#sym.degree.

For a chosen launch angle, an initial guess at a launch speed is made.
The projectile is launched with that velocity, and iterations are stopped when the projectile falls below the line of sight.
The distance of the projectile from the target when it crossed the line of sight is determined, with negative values corresponding to undershooting and positive values corresponding to overshooting.
Determining this distance involves finding the intersection point between the line of sight and the line connecting the last two points of the projectile's motion, then taking the difference in distance from the origin for the intersection point and the target location.
@over_under_shooting depicts what the paths might look like for overshooting and undershooting the target, as well as the intersection points with the line of sight.

If the launch speed guess undershoots, then launch speeds that are twice as large are tried until one is found that overshoots.
If the launch speed guess overshoots, then launch speeds that are half as large are tried until one is found that undershoots.
With one launch speed that overshoots and another that undershoots, the bisection method is used to narrow in on a launch speed that achieves zero distance from the target.
The projectile is launched with the average of the overshooting and undershooting speeds, and this speed replaces the upper or lower bound depending on whether it overshoots or undershoots.
This process repeats until the launch speed range has an acceptable tolerance.
The middle launch speed from the last iteration is returned as the launch speed required to hit the target.

#figure(
  image("media/over-under-shooting-sketch.jpg", width: 60%),
  caption: [Overshooting and Undershooting the Target When Solving for Launch Speed]
) <over_under_shooting>

#py_script("hitting_fixed_target", put_output: false, put_fname: false)

@hitting_target_varied_angle plots the launch speed versus launch angle for different target angles.
The target distance was kept constant.
For each curve, the launch speed required decreases initially then increases as the launch angle increases.
When the launch angle is too low, the projectile gets relatively little time in the error before crossing the line of sight, so it needs to be launched with greater speed to compensate.
When the launch angle is too high, the projectile gets relatively little horizontal velocity, so it needs to be launched with greater speed to compensate.

As the target angle increases, the curve shifts up and to the right and gets horizontally compressed.
Increasing the target angle increases the minimum viable launch angle, as the projectile must be launched above the line of sight.
This shifts the curve to the right and compresses it horizontally to fit within the angle restrictions.
Since increasing the target angle also increases the target elevation, the projectile must be given more starting kinetic energy in order to attain a larger ending gravitational potential energy.
This shifts the curve upward, corresponding to higher launch speeds and greater initial kinetic energy.

#figure(
  image("media/hitting_target_varied_angle.svg", width: 80%),
  caption: [$v$ vs $theta$ as Target Angle Varies],
) <hitting_target_varied_angle>

@hitting_target_varied_distance plots the launch speed versus launch angle for different target distances.
The target angle was kept constant.
As the target distance increases, the curve shifts upward, reflecting the requirement for more starting kinetic energy as the final gravitational potential energy increases.
In addition, as the target distance increases, the launch angle corresponding to the minimum launch speed decreases.
With a further target, it becomes more important to prioritize horizontal velocity rather than air time.

#figure(
  image("media/hitting_target_varied_distance.svg", width: 80%),
  caption: [$v$ vs $theta$ as Target Distance Varies],
) <hitting_target_varied_distance>

= Cover Image

The following script was use to create the cover image.

#py_script("create_thumbnail", put_output: false, put_fname: false)
