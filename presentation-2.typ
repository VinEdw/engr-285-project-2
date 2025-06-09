#import "engr-conf.typ": py_script
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/cetz:0.3.4"

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Realistic Projectiles],
    subtitle: [Quadratic Drag],
    author: [Vincent Edwards, Julia Corrales, Rachel Gossard],
    date: datetime(year: 2025, month: 6, day: 9),
    institution: [Mt. SAC],
    logo: emoji.face.cool,
  ),
)

#set heading(numbering: "1.1")

#title-slide()

#components.adaptive-columns(outline())

= Background

== Quadratic Drag Equation

$
(d^2 arrow(r))/(d t^2) = arrow(g) - k v^2 hat(v)
$

$
pause arrow(r) &= vec(x, y) quad&("position") \
pause arrow(v) &= (d arrow(r))/(d t) quad&("velocity") \
pause arrow(g) &= vec(0, -g) quad&("gravitation acceleration") \
pause k &= "\"constant\"" quad&("drag constant") \
$

#pause Let $g=1$, $k=1$, & $v_oo=1$ to focus on scale-independent features

== RK4 Method for Systems

$
(d arrow(u))/(d t) &= arrow(f)(t, arrow(u)) \
pause arrow(k)_1 &= arrow(f)(t_i, arrow(u)_i) \
arrow(k)_2 &= arrow(f)(t_i + h/2, arrow(u)_i + h/2 arrow(k)_1) \
arrow(k)_3 &= arrow(f)(t_i + h/2, arrow(u)_i + h/2 arrow(k)_2) \
arrow(k)_4 &= arrow(f)(t_i + h, arrow(u)_i + h arrow(k)_3) \
pause arrow(u)_(i+1) &= arrow(u)_i + h/6 (arrow(k)_1 + 2 arrow(k)_2 + 2 arrow(k)_3 + arrow(k)_4) quad t_(i+1) &= t_i + h \
$

#pagebreak()

#[
  #set text(size: 20pt)
  ```py
  def calculate(t_0, u_0, h, diff, should_exit):
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
  ```
]

== Projectile Equations

$
arrow(u) &= vec(x, y, v_x, v_y) \
(d arrow(u))/(d t) &= vec(v_x, v_y, -k v v_x, -g - k v v_y)
$

#pagebreak()

== Equation Implementation

#[
  #set text(size: 20pt)
  ```py
  def u_prime(t, u):
      k = 1
      g = 1

      x, y, v_x, v_y = u
      speed = np.sqrt(v_x**2 + v_y**2)
      drag_part = k * speed
      drag_x = drag_part * v_x
      drag_y = drag_part * v_y

      return np.array([
          v_x,
          v_y,
          -drag_x,
          -g - drag_y,
      ])
  ```
]

== Launching Projectiles

#[
  #set text(size: 25pt)
  ```py
  def below_ground(t, u):
      y = u[1]
      return y < 0

  def launch(v_0, should_exit=below_ground):
      t_0 = 0.0
      h = 0.001
      v_x, v_y = v_0
      u_0 = np.array([0, 0, v_x, v_y])
  
      t, u = rk4.calculate(t_0, u_0, h, u_prime, should_exit)
  
      return t, u
  ```
]

= Interdependence of Motion Components

== Equations

- Conditions for independence
  - $(d v_x)/(d t)$ does not depend on $y$ or $v_y$

  - $(d v_y)/(d t)$ does not depend on $x$ or $v_x$

- That is not the case for quadratic drag

$ (d v_x)/(d t) = -k v v_x = -k v_x sqrt(v_x^2 + v_y^2) $

$ (d v_y)/(d t) = -g - k v v_y = -g - k v_y sqrt(v_x^2 + v_y^2) $

== $x$ vs $t$ as $v_(0y)$ Varies

#figure(
  image("media/x_vs_t.svg", width: 70%),
)

== $y$ vs $t$ as $v_(0x)$ Varies

#figure(
  image("media/y_vs_t.svg", width: 70%),
)

= Trajectory Shapes

== Trajectory as $theta$ Varies

#figure(
  image("media/xy_vs_theta.svg", width: 70%),
)

== Trajectory as $v_0$ Varies

#figure(
  image("media/xy_vs_v.svg", width: 70%),
)

= Firing Range

== Diagram

#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(content: (padding: 0.2))
    set-style(circle: (radius: 0.1, fill: black))

    // Draw a line for the ground
    line((-4, 0), (10, 0), name: "ground")

    // Draw the line connecting the last two points of the projectile path
    let p_2 = (2, 2)
    let p_1 = (8, -4)
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

== $R$ vs $theta$ as $v_0$ Varies

#figure(
  image("media/R_vs_theta.svg", width: 70%),
)

== $R$ vs $v_0$ as $theta$ Varies

#figure(
  image("media/R_vs_v.svg", width: 70%),
)

= Hitting a Fixed Target

== Over/Under-Shooting the Target

#figure(
  image("media/over-under-shooting-sketch.jpg", width: 70%),
)

== $v$ vs $theta$ as Target Angle Varies

#figure(
  image("media/hitting_target_varied_angle.svg", width: 70%),
)

== $v$ vs $theta$ as Target Distance Varies

#figure(
  image("media/hitting_target_varied_distance.svg", width: 70%),
)
