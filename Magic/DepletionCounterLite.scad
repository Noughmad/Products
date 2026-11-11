include <BOSL2 / std.scad>
include <BOSL2 / hinges.scad>

$fn = 180;
thickness = 6;
clearance = 0.4;
length = 200;
width = 36;

extra_ends = false;

close_angle = 135;

cartouche_width = 36;
cartouche_height = 18;
cartouche_depth = 2;
cartouche_clearance = 0.15;

use_cartouche = true;
cartouche_rounding = 5;

cutout_height = 9;

start_pos = -thickness / 3 + thickness + clearance;
end_pos = length;

cartouche_to_edge = (width - cutout_height - cartouche_height) / 2;
last_cartouche_offset = cartouche_width / 2 + cartouche_to_edge;

dice_size = cartouche_height - 4;
pip_size = 3;
pip_scale = 3;

module cartouche_frame(clr = 0, depth_cut = 0) {
  cuboid([cartouche_width + 2 * clr, cartouche_height + 2 * clr, cartouche_depth + 2 * clr - depth_cut], rounding = cartouche_rounding, edges = "Z");
}

cutout_start_pos = start_pos + 10;
cutout_step = (length - 10) / (extra_ends ? 2.5 : 2);

include_magnets = true;
magnet_diameter = 6;
magnet_thickness = 2;
magnet_clearance = 0.15;
magnet_to_edge = (width - cutout_height - magnet_diameter) / 2;

upside_down = false;

include_cartouches = false;

function cartouche_pos(i) =
  cutout_start_pos + (i + 0.5) * cutout_step;

module magnet_hole() {
  dir_down(cutout_height / 2)
    down(magnet_thickness + magnet_clearance)
      cylinder(h = magnet_thickness + magnet_clearance + 0.01, r = magnet_diameter / 2 + magnet_clearance);
}

show_side_a = true;
show_side_b = true;
hinge_segments = 4;

module dir_down(d) {
  if (upside_down) {
    fwd(d)
      children();
  } else {
    back(d)
      children();
  }
}

if (show_side_a)
  color("gray") {
    diff() {
      difference() {
        inner_side();
        right(cartouche_pos(0))
          card_cutout("2");
        right(cartouche_pos(1))
          card_cutout("1");
        if (extra_ends)
          right(cartouche_pos(2))
            card_cutout("0", -last_cartouche_offset);
        if (include_magnets)
          right(length + thickness + clearance - thickness / 3 - magnet_diameter / 2 - magnet_to_edge)
            magnet_hole();
      }
    }
  }

if (show_side_b)
  color("green") {
    diff() {
      yrot(close_angle)
        difference() {
          outer_side();
          left(cartouche_pos(0))
            card_cutout("3");
          left(cartouche_pos(1))
            card_cutout("4");
          if (extra_ends)
            left(cartouche_pos(2))
              card_cutout("5", last_cartouche_offset);
          if (include_magnets)
            left(length + thickness + clearance - thickness / 3 - magnet_diameter / 2 - magnet_to_edge)
              magnet_hole();
        }
    }
  }

end_angle = 22.5;
end_skew_s = sin(end_angle);
end_move = thickness * end_skew_s;

module inner_side() {
  right(length / 2 + start_pos)
    down(clearance / 2)
      union() {
        skew(sxz = -end_skew_s)
          cuboid([length, width, thickness], anchor = TOP, rounding = cartouche_rounding + cartouche_to_edge / 2, edges = BACK + RIGHT);
        cuboid([length, width, thickness], anchor = TOP, rounding = cartouche_rounding + cartouche_to_edge / 2, edges = BACK + RIGHT) {
          position(LEFT + TOP)
            orient(anchor = FRONT)
              left(thickness / 2 + thickness / 3 - clearance)
                tag("remove")
                  cylinder(r = thickness + clearance / 2, h = width, center = true);
          position(LEFT + TOP)
            orient(anchor = LEFT)
              down(thickness / 3)
                knuckle_hinge(width, segs = hinge_segments, offset = thickness + clearance, inner = true, knuckle_clearance = clearance, clearance = clearance / 2, arm_angle = 90, knuckle_diam = 2 * thickness + clearance, clear_top = true, in_place = true);
        }
      }
}

module outer_side() {
  left(length / 2 + start_pos)
    down(clearance / 2)
      union() {
        skew(sxz = end_skew_s)
          cuboid([length, width, thickness], anchor = TOP, rounding = cartouche_rounding + cartouche_to_edge / 2, edges = BACK + LEFT);
        cuboid([length, width, thickness], anchor = TOP, rounding = cartouche_rounding + cartouche_to_edge, edges = BACK + LEFT) {
          position(RIGHT + TOP)
            orient(anchor = FRONT)
              right(thickness / 2 + thickness / 3 - clearance)
                tag("remove")
                  cylinder(r = thickness + clearance / 2, h = width, center = true);
          position(RIGHT + TOP)
            orient(anchor = RIGHT)
              down(thickness / 3)
                knuckle_hinge(width, segs = hinge_segments, offset = thickness + clearance, inner = false, knuckle_clearance = clearance, clearance = clearance / 2, arm_angle = 90, knuckle_diam = 2 * thickness + clearance, clear_top = true, in_place = true);
        }
      }
}

module card_cutout(number, off = 0) {
  if (use_cartouche) {
    dir_down(cutout_height / 2)
      right(off)
        down(cartouche_depth / 2 + cartouche_clearance)
          cartouche_frame(clr = cartouche_clearance);
  } else {
    dir_down(cutout_height / 2)
      down(1)
        right(off)
          linear_extrude(1)
            text(str(number), halign = "center", valign = "center");
  }

  dir_down(-(width / 2 + 50 - cutout_height))
    cuboid([85, 100, 3 * thickness], rounding = 5, edges = "Z");
}

module cartouche(number) {
  down(0.2)
    cartouche_frame(depth_cut = 0.4);
  left(cartouche_width / 4)
    color("black")
      linear_extrude(1)
        text(str(number), halign = "center", valign = "center", size = dice_size);
  right(cartouche_width / 4)
    color("black")
      dice_pips(number);
}

if (include_cartouches)
  fwd(50) {
    for(n = [1:6]) {
      right(50 * n)
        cartouche(n);
    }
  }

function pip_size_factor(n) =
  12 / (n + 6);

module dice_pips(n) {
  up(0.8)
    difference() {
      cuboid([dice_size, dice_size, 0.4], rounding = 4, edges = "Z");
      if (n > 1) {
        pip(-1, -1, n);
        pip(1, 1, n);
      }
      if (n == 6) {
        pip(0, -1, n);
        pip(0, 1, n);
      }
      if (n > 3) {
        pip(1, -1, n);
        pip(-1, 1, n);
      }
      if (n == 1 || n == 3 || n == 5) {
        pip(0, 0, n);
      }
    }
}

module pip(x, y, n) {
  translate([x * pip_scale, y * pip_scale, 0])
    cylinder(h = 20, r = pip_size / 2 * pip_size_factor(n), center = true);
}
