#include <BOSL2/std.scad>;

/* [Common Parameters] */

card_height = 90;
card_width = 65;

/* [Q5 Card Index] */

flap_thickness = 0.5;
q5_card_thickness = 0.31;  // 16 / 52;

flap_height = card_height + 3;
flap_width = card_width + 2;
flap_corner_radius = 2;
flap_hold_height = 7.5;

flap_base_height = 4;
flap_base_thickness = flap_thickness + 2 * q5_card_thickness;

hole_radius = 1;
hole_count = 8;

q5_include_holes = false;
q5_print_together = false;

q5_total_thickness = 26 * q5_card_thickness + 14 * flap_thickness;
echo(q5_total_thickness);

module q5_flap_base(include_base_spacer = true) {
    difference() {
        union() {
            cuboid([ flap_width, flap_thickness, flap_base_height + flap_height ], rounding = flap_corner_radius,
                   edges = "Y", anchor = BOTTOM);
            if (include_base_spacer) {
                back(flap_base_thickness / 2) {
                    cuboid([ flap_width, flap_base_thickness - flap_thickness, flap_base_height / 2 ],
                           rounding = flap_corner_radius, edges = [ BOTTOM + RIGHT, BOTTOM + LEFT ], anchor = BOTTOM);
                    up(flap_base_height) right(flap_width / 2)
                        cuboid([ flap_thickness, flap_base_thickness - flap_thickness, 4 * flap_thickness ],
                               anchor = BOTTOM + RIGHT);
                    up(flap_base_height) left(flap_width / 2)
                        cuboid([ flap_thickness, flap_base_thickness - flap_thickness, 4 * flap_thickness ],
                               anchor = BOTTOM + LEFT);
                }
            }
        }

        if (q5_include_holes)
            up(flap_base_height / 2) for (i = [1:hole_count]) {
                left((i)*flap_width / (hole_count + 1) - flap_width / 2) ycyl(h = 10, r = hole_radius);
            }
    }
}

module q5_flap_left(height) {
    union() {
        q5_flap_base();
        if (height > 0)
            up(flap_height) {
                left(flap_width / 3) cuboid([ flap_width / 3, flap_thickness, flap_base_height + height ],
                                            rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
            }
    }
}

module q5_flap_right(height) {
    union() {
        q5_flap_base();
        if (height > 0)
            up(flap_height) {
                right(flap_width / 3) cuboid([ flap_width / 3, flap_thickness, flap_base_height + height ],
                                             rounding = flap_corner_radius, edges = "Y", anchor = BOTTOM);
            }
    }
}

module q5_flap_center(height) {
    union() {
        q5_flap_base();
        if (height > 0)
            up(flap_height) {
                cuboid([ flap_width, flap_thickness, flap_base_height + height ], rounding = flap_corner_radius,
                       edges = "Y", anchor = BOTTOM);
            }
    }
}

module q5(print_together = q5_print_together) {
    ydistribute(print_together ? flap_base_thickness : 2 * flap_base_thickness) {
        q5_flap_left(0.25 * flap_hold_height);
        q5_flap_left(1.25 * flap_hold_height);
        q5_flap_left(2.25 * flap_hold_height);
        q5_flap_left(3.25 * flap_hold_height);
        q5_flap_left(4.25 * flap_hold_height);
        q5_flap_right(1.5 * flap_hold_height);
        q5_flap_right(2.5 * flap_hold_height);
        q5_flap_right(3.5 * flap_hold_height);
        q5_flap_right(4.5 * flap_hold_height);
        q5_flap_center(1.5 * flap_hold_height);
        q5_flap_center(2.5 * flap_hold_height);
        q5_flap_center(3.5 * flap_hold_height);
        q5_flap_center(4.5 * flap_hold_height);
        q5_flap_base(include_base_spacer = false);
    }
}

zrot(90) yrot(90) q5(true);

/*
left(4*card_width)
q5(false);
*/