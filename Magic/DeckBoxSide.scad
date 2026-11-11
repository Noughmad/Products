include <BOSL2 / std.scad>
include <BOSL2 / hinges.scad>

$fn = 180;

Box_width = 94;
Box_depth = 56;
Box_height = 66;
Flap_length = 44;
Flap_rounding = 12;
Flap_magnet_depth = 2.15;
Box_magnet_depth = 2.15;

Magnet_diameter = 6.2;
Magnet_offset = 8;
Box_thickness = 2.5;
Box_front_thickness = 3;

Box_width_outer = Box_width + 2 * Box_thickness;
Box_depth_outer = Box_depth + Box_thickness + Box_front_thickness;
Box_height_outer = Box_height + 2 * Box_thickness;

Thickness = 3.25;
Handle_cut_length = 20;
Hinge_offset = Thickness / 2 + 0.2;

Box_cutout_width = Box_width / 2;
Box_cutout_depth = Box_height * 2 / 5;
Box_cutout_rounding = Box_cutout_depth / 2;
Hinge_segments = 9;

Sideboard_separator_offset = 1;
Close_angle = 0; // [0:90]

Back_side_length = Box_height_outer - Thickness / 2 - Hinge_offset;

Opening_handle_depth = 1.5;
Opening_handle_offset = sqrt(Thickness) - Opening_handle_depth;

Four_magnets = false;

First_hinge_in_place = true;
Hinge_pin_diam = 2;

Separator_thickness = 2;
Separator_1 = 42;
Separator_2 = 0;
Separator_3 = 0;
Separator_4 = 0;

Top_rounding_size = 8;
Top_rounding_radius = 40;

Separators = [Separator_1, Separator_2, Separator_3, Separator_4];

Include_plugs = false;

top_rounding_angle = asin(Top_rounding_size / Top_rounding_radius);
top_rounding_offset = Top_rounding_radius * (1 - cos(top_rounding_angle));

Box_magnets_inside = false;
Closing_hooks = true;
Hook_diameter = 5.85;
Hook_depth = 1.85;

Box_front_delta = (Box_front_thickness - Box_thickness) / 2;

module hinge(inner, in_place = true) {
  knuckle_hinge(length = Box_width_outer, segs = Hinge_segments, offset = Hinge_offset, arm_height = 0, arm_angle = 90, pin_diam = Hinge_pin_diam, knuckle_diam = Thickness, inner = inner, in_place = in_place);
}

module side(length = Box_depth, start_in_place = true) {
  translate([-length / 2 - Hinge_offset, 0, 0])
    cuboid([length, Box_width_outer, Thickness]) {
      position(RIGHT)
        orient(anchor = RIGHT)
          hinge(true, in_place = start_in_place);
      position(LEFT)
        orient(anchor = LEFT)
          hinge(false);
    }
}

module magnet_holes(length, depth, four) {
  magnet_holes_set(length, depth);

  if (four) {
    right(Flap_length / 2)
      magnet_holes_set(length, depth);
  }
}

module magnet_holes_set(length, depth) {
  translate([-length / 2 + Magnet_offset, Box_width / 2 - Magnet_offset, -depth]) {
    cylinder(h = depth + 0.01, r = Magnet_diameter / 2);
  }
  translate([-length / 2 + Magnet_offset, -Box_width / 2 + Magnet_offset, -depth]) {
    cylinder(h = depth + 0.01, r = Magnet_diameter / 2);
  }
}

module hooks_set(length) {
  translate([-length / 2 + Magnet_offset, Box_width / 2 - Magnet_offset, 0]) {
    hook();
  }
  translate([-length / 2 + Magnet_offset, -Box_width / 2 + Magnet_offset, 0]) {
    hook();
  }
}

module hook() {
  intersection() {
    cylinder(h = Hook_depth, r = Hook_diameter / 2);
    hull() {
      cylinder(h = Hook_depth, r1 = Hook_diameter / 2, r2 = Hook_diameter / 2 - Hook_depth);
      right(Hook_diameter)
        cylinder(h = Hook_depth, r1 = Hook_diameter / 2, r2 = Hook_diameter / 2 - Hook_depth);
    }
  }
}

module flap(length = Flap_length) {
  translate([-length / 2 - Hinge_offset, 0, 0])
    difference() {
      union() {
        cuboid([length, Box_width_outer, Thickness], rounding = Flap_rounding, edges = [FRONT + LEFT, BACK + LEFT]) {
          position(RIGHT)
            orient(anchor = RIGHT)
              hinge(true);
        }

        // Hooks
        if (Closing_hooks) {
          up(Thickness / 2)
            right(Flap_length / 2)
              hooks_set(length);
        }
      }
      // Magnet holes
      up(Thickness / 2)
        magnet_holes(length, Flap_magnet_depth, Four_magnets);
      // Opening handle
      translate([-length / 2, 0, Thickness / 2])
        rotate([90, 45, 0])
          handle_cut();
    }
}

module handle_cut() {
  cuboid([Thickness, Thickness, Handle_cut_length]) {
    position(TOP)
      orient(anchor = TOP)
        prismoid(h = Thickness, size1 = [Thickness, Thickness], size2 = [0, 0]);
    position(BOTTOM)
      orient(anchor = BOTTOM)
        prismoid(h = Thickness, size1 = [Thickness, Thickness], size2 = [0, 0]);
  }
}

module old_whole_box() {

  left(-Back_side_length / 2 - Box_depth_outer / 2 - 2 * Hinge_offset)
    up(Box_height_outer / 2 - Thickness / 2)
      box();

  rotate([0, 90, 0])
    translate([-Back_side_length / 2 - Hinge_offset, 0, Back_side_length / 2 + Hinge_offset])
      side(Back_side_length, start_in_place = First_hinge_in_place);

  up(Back_side_length + 2 * Hinge_offset)
    rotate([0, 180, 0])
      left(Back_side_length / 2 + Box_depth_outer / 2 + 2 * Hinge_offset)
        side(Box_depth_outer);


  rotate([0, 270, 0])
    left(Back_side_length / 2 + Box_depth_outer + Flap_length / 2 + 4 * Hinge_offset)
      flap();
}

module whole_box() {
  box();
  next_segment(Box_depth_outer - Hinge_offset) {
    side(Back_side_length, start_in_place = First_hinge_in_place);
    next_segment(Back_side_length) {
      side(Box_depth_outer);
      next_segment(Box_depth_outer) {
        flap();
      }
    }
  }
}

module next_segment(prev_length) {
  left(prev_length + 2 * Hinge_offset)
    rotate([0, Close_angle, 0])
      children();
}

module grab_cutout() {
  up(Box_height_outer / 2 - Box_cutout_depth / 2)
    cuboid([Box_depth_outer + 2, Box_cutout_width, Box_cutout_depth], rounding = Box_cutout_rounding, edges = "X");
  up(Box_height_outer / 2 - Box_cutout_depth / 4)
    cuboid([Box_depth_outer + 2, Box_cutout_width, Box_cutout_depth / 2], rounding = -Box_cutout_rounding, edges = [TOP + FRONT, TOP + BACK]);
}

module box_base() {
  difference() {
    cuboid([Box_depth_outer, Box_width_outer, Box_height_outer])
      position(LEFT + BOTTOM)
        orient(anchor = LEFT)
          back(Thickness / 2)
            hinge(false, in_place = First_hinge_in_place);
    // Hole to put the cards in
    up(Box_thickness / 2)
      left(Box_front_thickness / 2 - Box_thickness / 2)
        cuboid([Box_depth, Box_width, Box_height + Box_thickness + 0.01]);
    // Rounding at the top
    up(Box_height_outer / 2 - Top_rounding_size / 2) {
      left(Box_depth / 2 + Box_front_delta)
        top_rounding(Box_width);
      zrot(180)
        left(Box_depth / 2 - Box_front_delta)
          top_rounding(Box_width);
      zrot(90)
        left(Box_width / 2)
          back(Box_front_delta)
            top_rounding(Box_depth);
      zrot(270)
        left(Box_width / 2)
          fwd(Box_front_delta)
            top_rounding(Box_depth);
    }

    up(Box_height_outer / 2 - Top_rounding_size / 2) {
      left(Box_depth / 2 + Box_front_delta)
        back(Box_width / 2)
          zrot(-90)
            top_rounding_corner();
      left(Box_depth / 2 + Box_front_delta)
        fwd(Box_width / 2)
          zrot(0)
            top_rounding_corner();
      right(Box_depth / 2 - Box_front_delta)
        fwd(Box_width / 2)
          zrot(90)
            top_rounding_corner();
      right(Box_depth / 2 - Box_front_delta)
        back(Box_width / 2)
          zrot(180)
            top_rounding_corner();
    }
  }

  for(sep = Separators) {
    if (sep > 0 && sep < Box_depth) {
      left(-Box_depth / 2 + sep) {
        separator();
      }
    }
  }
}

module separator() {
  difference() {
    cuboid([Separator_thickness, Box_width_outer, Box_height_outer]);

    up(Box_height_outer / 2 - Top_rounding_size / 2) {
      right(Separator_thickness / 2)
        top_rounding(Box_width);
      left(Separator_thickness / 2)
        zrot(180)
          top_rounding(Box_width);
    }

    up(Box_height_outer / 2 - Top_rounding_size / 2) {
      right(Separator_thickness / 2)
        back(Box_width / 2)
          zrot(-90)
            top_rounding_corner();
      right(Separator_thickness / 2)
        fwd(Box_width / 2)
          zrot(0)
            top_rounding_corner();
      left(Separator_thickness / 2)
        fwd(Box_width / 2)
          zrot(90)
            top_rounding_corner();
      left(Separator_thickness / 2)
        back(Box_width / 2)
          zrot(180)
            top_rounding_corner();
    }
  }
}

module box() {
  translate([-Box_depth_outer / 2, 0, Box_height_outer / 2 - Thickness / 2]) {
    difference() {
      box_base();

      // Hole in the side to grab the cards
      grab_cutout();
      // Opening handle
      translate([Box_depth_outer / 2, 0, Box_height_outer / 2 - Flap_length])
        right(Opening_handle_offset)
          hull() {
            rotate([90, 45, 0])
              handle_cut();
            down(12)
              rotate([90, 45, 0])
                handle_cut();
          }

      // Holes for magnets
      Magnet_holes_offset = Box_magnets_inside ? 0 : Box_front_thickness - Box_magnet_depth;

      right(Box_depth / 2 - Box_front_delta + Magnet_holes_offset)
        rotate([0, 90, 0])
          right(-Box_height_outer / 2 + Flap_length)
            rotate([0, 180, 0])
              magnet_holes(0, Box_magnet_depth, Four_magnets || Closing_hooks);
    }
  }
}

module sideboard_separator() {
  difference() {
    cuboid([Thickness, Box_width - 2 * Sideboard_separator_offset, Box_height - 2 * Sideboard_separator_offset], chamfer = 1);
    down(Box_height_outer / 2 - Box_height / 2 + Sideboard_separator_offset)
      grab_cutout();
  }
}

/*

right(200)
rotate([0, 90, 0])
sideboard_separator();

*/

whole_box();

module hinge_cap() {
  cylinder(h = 4, r = (Hinge_pin_diam - 0.15) / 2);
}

if (Include_plugs) {
  right(20)
    ydistribute() {
      hinge_cap();
      hinge_cap();
    }
}

module top_rounding(length) {
  difference() {
    cuboid([Top_rounding_size, length, Top_rounding_size]);
    translate([-Top_rounding_radius, 0, -Top_rounding_size / 2])
      xrot(90)
        cylinder(h = length + 0.01, r = Top_rounding_radius, center = true);
  }
}

module top_rounding_corner() {
  // translate([top_rounding_offset/2, top_rounding_offset/2, 0])
  difference() {
    translate([-top_rounding_offset / 2, -top_rounding_offset / 2, 0])
      cuboid([top_rounding_offset, top_rounding_offset, Top_rounding_size]);

    union() {
      difference() {
        cuboid([Top_rounding_size, Top_rounding_size, Top_rounding_size]);
        top_rounding(Top_rounding_size);
      }
      difference() {
        cuboid([Top_rounding_size, Top_rounding_size, Top_rounding_size]);
        zrot(90)
          top_rounding(Top_rounding_size);
      }
    }
  }
}
