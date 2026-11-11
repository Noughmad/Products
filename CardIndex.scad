include <BOSL2/std.scad>
;

/* [Common Parameters] */

card_height = 90;
card_width = 65;
card_thickness = 0.4; // 16 / 52;
card_corner_radius = 2;

/* [Spread Index] */

card_angle = 12;
card_angles = [-1.5, -0.5, 0.5, 1.5];

value_step = 4;
value_count = 13;

frame_thickness = .8;
frame_skew = value_step / (card_thickness * 4);
frame_height = 30;

pivot_height = 0.33; // [0:0.01:1]

chamfer_height = 3 * frame_skew;

/* [Q5 Card Index] */

flap_thickness = 0.42;
q5_card_thickness = 0.45; // 16 / 52;

flap_height = card_height + 5;
flap_width = card_width + 2;
flap_corner_radius = 2;
flap_hold_height = 5;

flap_base_height = 6;
flap_base_thickness = flap_thickness + 2 * q5_card_thickness;

hole_radius = 1;
hole_count = 8;

q5_include_holes = false;
q5_print_together = false;

q5_total_thickness = 26 * q5_card_thickness + 14 * flap_thickness;
echo(q5_total_thickness);

module single_card() {
  cuboid([card_width, card_thickness, card_height], rounding = card_corner_radius, edges = "Y", anchor = BOTTOM);
}

module four_cards() {
  for(a = card_angles) {
    up(card_height * pivot_height)

      yrot(a * card_angle)
        back(a * card_thickness)
          down(card_height * pivot_height)
            single_card();
  }
}

// four_cards();

module frame(n = 4) {
  thickness = card_thickness * n + frame_thickness * 2;
  down(14) {
    up(thickness * frame_skew / 2) {
      intersection() {
        skew(szy = frame_skew)
          cuboid([card_width * 1.33, thickness, frame_height], anchor = BOTTOM, chamfer = 0.5);

        down(thickness * frame_skew / 2 - chamfer_height / 2)
          cuboid([card_width * 1.33, thickness, frame_height + thickness * frame_skew - chamfer_height], anchor = BOTTOM, chamfer = 0.5);
      }
      down(thickness * frame_skew / 2 - chamfer_height / 2)
        fwd(thickness / 2 - 4)
          cuboid([card_width * 1.33, 8, 18], anchor = BOTTOM, chamfer = 0.5);
    }
  }
}

module cards_frame(value_count = value_count, include_cards = false) {
  n = value_count * 4;
  difference() {
    frame(n);
    for(v = [0:value_count - 1]) {
      back(v * 4 * card_thickness - (value_count - 1) * 2 * card_thickness) {
        up(v * value_step)
          four_cards();
      }
    }
  }

  if (include_cards) {
    color("red") {
      for(v = [0:value_count - 1]) {
        back(v * 4 * card_thickness - (value_count - 1) * 2 * card_thickness) {
          up(v * value_step)
            four_cards();
        }
      }
    }
  }
}

module four_cards_frame() {
  difference() {
    frame(4);
    four_cards();
  }
}

// four_cards_frame();

module eight_cards_frame() {
  difference() {
    frame(8);
    back(2 * card_thickness) {
      four_cards();
    }
    fwd(2 * card_thickness) {
      four_cards();
    }
  }
}

cards_frame();

module q5_flap_base(include_base_spacer = true) {
  difference() {
    union() {
      cuboid([flap_width, flap_thickness, flap_base_height + flap_height], rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
      if (include_base_spacer)
        back(flap_base_thickness / 2)
          cuboid([flap_width, flap_base_thickness - flap_thickness, flap_base_height], rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
    }

    if (q5_include_holes)
      up(flap_base_height / 2)
        for(i = [1:hole_count]) {
          left((i) * flap_width / (hole_count + 1) - flap_width / 2)
            ycyl(h = 10, r = hole_radius);
        }
  }
}

module q5_flap_left(height) {
  union() {
    q5_flap_base();
    if (height > 0)
      up(flap_height) {
        left(flap_width / 3)
          cuboid([flap_width / 3, flap_thickness, flap_base_height + height], rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
      }
  }
}

module q5_flap_right(height) {
  union() {
    q5_flap_base();
    if (height > 0)
      up(flap_height) {
        right(flap_width / 3)
          cuboid([flap_width / 3, flap_thickness, flap_base_height + height], rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
      }
  }
}

module q5_flap_center(height) {
  union() {
    q5_flap_base();
    if (height > 0)
      up(flap_height) {
        cuboid([flap_width, flap_thickness, flap_base_height + height], rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
      }
  }
}

module q5(print_together = q5_print_together) {
  ydistribute(print_together ? flap_base_thickness : 2 * flap_base_thickness) {
    q5_flap_left(0 * flap_hold_height);
    q5_flap_left(1 * flap_hold_height);
    q5_flap_left(2 * flap_hold_height);
    q5_flap_left(3 * flap_hold_height);
    q5_flap_left(4 * flap_hold_height);
    q5_flap_right(1 * flap_hold_height);
    q5_flap_right(2 * flap_hold_height);
    q5_flap_right(3 * flap_hold_height);
    q5_flap_right(4 * flap_hold_height);
    q5_flap_center(1 * flap_hold_height);
    q5_flap_center(2 * flap_hold_height);
    q5_flap_center(3 * flap_hold_height);
    q5_flap_center(4 * flap_hold_height);
    q5_flap_base(include_base_spacer = false);
  }
}

left(2 * card_width)
  q5(true);

/*
left(4*card_width)
q5(false);
*/
