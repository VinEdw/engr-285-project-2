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

= Runge-Kutta Four (RK4) Method

= Interdependence of Horizontal and Vertical Motion

= Trajectory Shapes

= Firing Range

== As a Function of Firing Angle

== As a Function of Initial Speed

= Extension

