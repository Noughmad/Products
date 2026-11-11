include <BOSL2 / std.scad>
;
include <BOSL2 / hinges.scad>
;

$fn = 180;

Thickness = 3;
Clearance = 0.4;

Side_length = 12;
Hinge_segments = 3;
Hinge_offset = Thickness / 2;

Hex_height = Side_length * sqrt(3);
Hex_width = Side_length * 2;

Hex_x_step = Side_length * 1.5 + sqrt(3) * Hinge_offset;
Hex_y_step = Side_length * sqrt(3) + 2 * Hinge_offset;

module hinge(inner, in_place = true) {
  knuckle_hinge(length = Side_length, segs = Hinge_segments, offset = Hinge_offset, arm_height = 0, arm_angle = 90, knuckle_diam = Thickness, inner = inner, in_place = in_place);
}

module hex() {
  hex_base();

  up(Side_length / 2)
    regular_prism(n = 6, h = Side_length, r1 = Side_length * 0.8, // bottom base radius
    r2 = 0.01 // top apex (0 radius)
    );
}

module hex_base() {
  linear_sweep(hexagon(side = Side_length), h = Thickness);
  up(Thickness / 2)
    for(i = [0:5])
      zrot(i * 60)
        back(Hex_height / 2)
          xrot(-90)
            hinge(i < 3);
}

Hex_distance = Side_length * sqrt(3) + Thickness / 2 + Hinge_offset;

function hex_radius(i, j) =
  (i == 1) ? Hex_distance : i * Hex_distance;

module hex_position(i, j) {
  translate([i * (Hex_x_step), j * Hex_y_step + ((i % 2 == 1) ? Hex_y_step / 2 : 0)])
    children();
}

module hex_pattern(m, n) {
  for(i = [1:m - 1]) {
    for(j = [(i % 2 == 0 ? 1 : 0):n]) {
      hex_position(i, j)
        hex();
    }
  }

  intersection() {
    union() {
      hex_position(m / 2 + 1, -1)
        hex_base();
      hex_position(m / 2 - 1, -1)
        hex_base();
      hex_position(m / 2 + 1, n + 1)
        hex_base();
      hex_position(m / 2 - 1, n + 1)
        hex_base();
      hex_position(m / 2, -0.33)
        cuboid([Side_length * 4, Side_length, Thickness], anchor = BOTTOM);
      hex_position(m / 2, n + 1.33)
        cuboid([Side_length * 4, Side_length, Thickness], anchor = BOTTOM);
    }
    union() {
      hex_position(m / 2, 0)
        cuboid([Side_length * 4.5, Side_length * sqrt(3), Thickness + 0.1], anchor = BOTTOM, rounding = Side_length / 2, edges = "Z");
      hex_position(m / 2, n + 1)
        cuboid([Side_length * 4.5, Side_length * sqrt(3), Thickness + 0.1], anchor = BOTTOM, rounding = Side_length / 2, edges = "Z");
    }
  }
}

hex_pattern(4, 3);
