#include <BOSL2/std.scad>;

/* [Common Parameters] */

card_height = 90;
card_width = 65;
card_thickness = 0.4;  // 16 / 52;
card_corner_radius = 2;

/* [Spread Index] */

card_angle = 12;
card_angles = [ -1.5, -0.5, 0.5, 1.5 ];

value_step = 4;
value_count = 13;

frame_thickness = .8;
frame_skew = value_step / (card_thickness * 4);
frame_height = 35;

pivot_height = 0.33;  // [0:0.01:1]

chamfer_height = 3 * frame_skew;

module single_card() {
    cuboid([ card_width, card_thickness, card_height ], rounding = card_corner_radius, edges = "Y", anchor = BOTTOM);
}

module four_cards() {
    for (a = card_angles) {
        up(card_height * pivot_height)

            yrot(a * card_angle) back(a * card_thickness) down(card_height * pivot_height) single_card();
    }
}

// four_cards();

module frame(n = 4) {
    thickness = card_thickness * n + frame_thickness * 2;
    down(14) {
        up(thickness * frame_skew / 2) {
            intersection() {
                skew(szy = frame_skew)
                    cuboid([ card_width * 1.33, thickness, frame_height ], anchor = BOTTOM, chamfer = 0.5);

                down(thickness * frame_skew / 2 - chamfer_height / 2)
                    cuboid([ card_width * 1.33, thickness, frame_height + thickness * frame_skew - chamfer_height ],
                           anchor = BOTTOM, chamfer = 0.5);
            }
            down(thickness * frame_skew / 2 - chamfer_height / 2) fwd(thickness / 2 - 4)
                cuboid([ card_width * 1.33, 8, 18 ], anchor = BOTTOM, chamfer = 0.5);
        }
    }
}

module cards_frame(value_count = value_count, include_cards = false) {
    n = value_count * 4;
    difference() {
        frame(n);
        for (v = [0:value_count - 1]) {
            back(v * 4 * card_thickness - (value_count - 1) * 2 * card_thickness) {
                up(v * value_step) four_cards();
            }
        }
    }

    if (include_cards) {
        color("red") {
            for (v = [0:value_count - 1]) {
                back(v * 4 * card_thickness - (value_count - 1) * 2 * card_thickness) {
                    up(v * value_step) four_cards();
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
