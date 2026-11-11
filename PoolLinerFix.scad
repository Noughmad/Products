
include<BOSL2 / std.scad> include<BOSL2 / screws.scad>;

cap_radius = 50;
nut_radius = 12;

finger_holes = false;

$fn = 60;

sphere_radius = 2 * cap_radius;

sphere_height = sqrt(sphere_radius * sphere_radius - cap_radius * cap_radius);

depth = sphere_radius - sphere_height;

thickness = 2;
edge = 2;

screw_spec = "M16x2,12";
hole_spec = "M16x2,20";

module cap(top) {
    factor = top ? -1 : 1;
    translate([ 0, 0, factor * sphere_height ]) difference() {
        sphere(r = sphere_radius);
        sphere(r = sphere_radius - thickness);
        translate([ 0, 0, factor * (sphere_radius - sphere_height) ])
            cube([ 2 * sphere_radius + 1, 2 * sphere_radius + 1, 2 * sphere_radius ], center = true);
    }
}

module bottom() {
    difference() {
        union() {
            difference() {
                cylinder(h = edge, r = cap_radius);
                if (edge > thickness)
                    translate([ 0, 0, thickness ]) cylinder(h = edge, r = cap_radius - thickness);
            }
            if (finger_holes)
                for (i = [0:2]) {
                    rotate([ 0, 0, i * 120 ]) {
                        translate([ cap_radius * 0.6, 0, -5 ]) {
                            sphere(10);
                        }
                    }
                }
        }

        if (finger_holes)
            for (i = [0:2]) {
                rotate([ 0, 0, i * 120 ]) {
                    translate([ cap_radius * 0.6, 0, -5 ]) {
                        sphere(10 - thickness);
                    }
                }
            }

        translate([ 0, 0, -50 ]) cylinder(h = 50, r = cap_radius);
    }

    translate([ 0, 0, 6 ]) screw(screw_spec);
}

module round_cap() {

    translate([ 150, 0, 0 ]) {

        union() {
            cap(false);
            translate([ 0, 0, 0 ]) {
                mirror([ 0, 0, 1 ]) nut("M10");
            }
        }

        translate([ 0, 0, 20 ]) union() {
            cap(true);
            translate([ 0, 0, depth - 8 ]) {
                mirror([ 0, 0, 1 ]) screw("M10,16");
            }
        }
    }
}

module washer() {
    difference() {
        cylinder(h = thickness / 2, r = cap_radius);
        translate([ 0, 0, -0.1 ]) cylinder(h = thickness / 2 + 0.2, r = cap_radius / 2);
    }

    for (i = [0:5]) {
        rotate([ 0, 0, i * 60 ]) {
            translate([ cap_radius, 0, 0 ]) {
                cylinder(r = 10, h = thickness / 2);
            }
        }
    }
}

module top() {
    intersection() {
        difference() {
            union() {
                cap(true);
                for (i = [0:2]) {
                    rotate([ 0, 0, i * 120 ]) {
                        translate([ cap_radius * 0.5, 0, 14 ]) {
                            sphere(12);
                        }
                    }
                }
            }
            for (i = [0:2]) {
                rotate([ 0, 0, i * 120 ]) {
                    translate([ cap_radius * 0.5, 0, 14 ]) {
                        sphere(12 - thickness);
                    }
                }
            }
        }
        translate([ 0, 0, -sphere_height ]) sphere(r = sphere_radius);
    }
    difference() {
        intersection() {
            translate([ 0, 0, 2 ]) cylinder(r = 14, h = depth);
            translate([ 0, 0, -sphere_height ]) sphere(r = sphere_radius);
        }

        up(6) rotate([ 0, 180, 0 ]) screw_hole(hole_spec, thread = true, head = "flat");
    }
}

bottom();

translate([ 0, 0, 50 ]) washer();

translate([ 0, 0, 100 ]) top();
