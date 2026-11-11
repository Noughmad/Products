include<BOSL2 / std.scad>

    $fn = 90;

layer = 0.2;     // in mm
num_layers = 8;  // in layers

thickness = layer * num_layers;

cube_size = 100;     // [100, 150] in mm
cube_clearance = 1;  // in mm
diffusor_thickness = 0.8;

width = cube_size + 2 * thickness + 2 * cube_clearance;  // [100, 150] in mm

size1 = [ width, width ];

nw = width - 2 * thickness;
size2 = [ nw, nw ];

edge_radius = 6;
er = edge_radius;

side_length = width - 2 * thickness - 2 * edge_radius;
sl = side_length;

join_radius = 1;
clearance = 0.15;
join_depth = 3;

join_distance = 7 / 8 * sl;

unit = width / 16;

show_base = false;
show_top = false;
show_light = false;
show_dark = false;
show_medium = false;
show_diffusor = true;
show_small_diffusors = false;

show_all = true;

module joiner(r, h, chamfer = 0) {
    union() {
        cyl(r = r, h = h, anchor = BOTTOM, chamfer2 = chamfer);
        zrot(135) {
            cuboid([ r, r, h ], anchor = BOTTOM + LEFT + FRONT, chamfer = chamfer, edges = TOP);
        }
    }
}

module side(l = sl, cover = true) {
    translate([ sr - er / 2 - clearance, -sl / 2, 0 ]) {

        if (cover) {

            difference() {
                cube([ er, l, er ]);
                translate([ 0, l, er ]) rotate([ 90, 0, 0 ]) {
                    cylinder(r = er, h = l);
                }

                translate([ 0, sl / 2 - join_distance / 2, join_radius + clearance ]) {
                    yrot(90) joiner(r = join_radius + clearance, h = er);
                }
                translate([ 0, sl / 2, join_radius + clearance ]) {
                    yrot(90) joiner(r = join_radius + clearance, h = er);
                }
                translate([ 0, sl / 2 + join_distance / 2, join_radius + clearance ]) {
                    yrot(90) joiner(r = join_radius + clearance, h = er);
                }
            }
        } else {
            difference() {
                union() {
                    translate([ er - join_radius, sl / 2 - join_distance / 2, 0 ]) {
                        joiner(r = join_radius, h = join_depth, chamfer = 0.5);
                    }
                    translate([ er - join_radius, sl / 2, 0 ]) {
                        joiner(r = join_radius, h = join_depth, chamfer = 0.5);
                    }
                    translate([ er - join_radius, sl / 2 + join_distance / 2, 0 ]) {
                        joiner(r = join_radius, h = join_depth, chamfer = 0.5);
                    }
                }
                translate([ 0, l, er ]) rotate([ 90, 0, 0 ]) {
                    cylinder(r = er, h = l);
                }
            }
        }
    }
}

sr = nw / 2 - er / 2;

module corner() {
    difference() {
        cube([ er, er, er ]);
        translate([ er, er, er ]) {
            sphere(er);
        }
    }
}

module base() {
    difference() {
        color("gray") prismoid(size1, size2, h = thickness, anchor = CENTER + BOTTOM) {
            attach(TOP) {
                children();
            }
        }
        holes();
    }
}

module pixel(x, y, w = 1, h = 1, c = 0) {
    translate([ x + c, y + c, 0 ]) cube([ w - 2 * c, h - 2 * c, 1 ]);
}

module pixels(t) {
    zrot(-90) scale([ unit, unit, t ]) {
        translate([ -8, -8, 0 ]) {
            union() {
                children();
            }
        }
    }
}

module holes(c = 0) {
    pixels(thickness) {
        pixel(5, 2, 2, 1, c = c);
        pixel(11, 2, 2, 1, c = c);
        pixel(2, 3, 6, 1, c = c);
        pixel(3, 4, 2, 1, c = c);
        pixel(11, 5, c = c);
        pixel(5, 6, 4, c = c);
        pixel(6, 7, 2, c = c);
        pixel(13, 7, 2, c = c);
        pixel(4, 9, 2, 2, c = c);
        pixel(8, 9, 5, c = c);
        pixel(9, 10, 2, c = c);
        pixel(7, 12, 2, c = c);
        pixel(2, 13, 2, c = c);
        pixel(11, 13, c = c);
    }
}

module light_cover(c = 0) {
    pixels(layer) {
        difference() {
            scale([ 1, 1, 0.5 ]) pixel(1, 1, 14, 14, c = -0.1);
            down(0.25) pixel(1, 1, 14, 14);
        }
        pixel(12, 2, 1, 1, c = c);
        pixel(6, 3, 1, 1, c = c);
        pixel(4, 4, 1, 1, c = c);
        // pixel(11, 5, c=c);
        // pixel(5, 6, 4, c=c);
        pixel(7, 7, 1, c = c);
        pixel(14, 7, 1, c = c);
        pixel(5, 10, 1, 1, c = c);
        pixel(12, 9, 1, c = c);
        pixel(10, 10, 1, c = c);
        pixel(8, 12, 1, c = c);
        pixel(3, 13, 1, c = c);
    }
}

module light() {
    pixels(layer) {
        pixel(0, 0, 2);
        pixel(8, 0);
        pixel(5, 1, 2);
        pixel(9, 1, 3);
        pixel(7, 2);
        pixel(14, 2, 2);
        pixel(9, 3, 2);
        pixel(1, 4, 2);
        pixel(7, 4, 4);
        pixel(5, 5, 2);
        pixel(1, 6, 3);
        pixel(13, 6);
        pixel(1, 7);
        pixel(11, 7);
        pixel(15, 7);
        pixel(0, 8, 3);
        pixel(8, 8, 3);
        pixel(7, 9);
        pixel(0, 10);
        pixel(14, 10);
        pixel(3, 11);
        pixel(7, 11);
        pixel(2, 12);
        pixel(5, 12);
        pixel(11, 12);
        pixel(13, 12, 3);
        pixel(7, 14, 4);
        pixel(0, 15, 3);
        pixel(12, 15);
        pixel(15, 15);
    }
}

module dark() {
    pixels(layer) {
        pixel(7, 0);
        pixel(11, 3, 2);
        pixel(6, 4);
        pixel(3, 5, 2);
        pixel(8, 5, 2);
        pixel(15, 5);
        pixel(11, 6);
        pixel(0, 7);
        pixel(8, 7);
        pixel(5, 8, 3);
        pixel(13, 8, 2);
        pixel(2, 10);
        pixel(11, 10);
        pixel(9, 11, 2);
        pixel(7, 13, 2);
        pixel(12, 13, 2);
        pixel(2, 14, 3);
        pixel(11, 14);
        pixel(6, 15);
    }
}

module medium() {
    pixels(layer) {
        pixel(9, 0);
        pixel(1, 1, 3);
        pixel(13, 1, 2);
        pixel(3, 2);
        pixel(0, 3);
        pixel(8, 3);
        pixel(13, 3, 2);
        pixel(5, 4);
        pixel(0, 5, 2);
        pixel(7, 5);
        pixel(10, 5);
        pixel(13, 5);
        pixel(9, 6, 1, 2);
        pixel(0, 7);
        pixel(4, 7);
        pixel(3, 8, 2);
        pixel(15, 8, 1, 2);
        pixel(1, 10);
        pixel(3, 10);
        pixel(6, 10);
        pixel(2, 11);
        pixel(5, 11);
        pixel(8, 11);
        pixel(11, 11, 2);
        pixel(15, 11);
        pixel(0, 12, 2);
        pixel(5, 13, 2);
        pixel(10, 13);
        pixel(14, 13);
        pixel(0, 14);
        pixel(13, 14);
        pixel(5, 15, 2);
        pixel(8, 15);
        pixel(10, 15, 2);
    }
}

if (show_base || show_all) {
    // Side
    base() {
        zrot(0) back(clearance) side(l = sl - clearance, cover = true);
        translate([ sr + er / 2 - clearance, sr + er / 2 - clearance, 0 ]) {
            zrot(180) corner();
        }
        zrot(90) side(l = sl + er + thickness, cover = true);
        zrot(270) side(l = sl, cover = false);

        down(thickness) {
            prismoid(size1, size2, h = thickness, shift = [ -thickness, 0 ]);
        }
    }
}

// Light layer
if (show_light || show_all)
    up(20) {
        color("#bbbbbb") {
            light();
        }
    }

// Dark layer
if (show_dark || show_all)
    up(40) {
        color("#555555") {
            dark();
        }
    }

// Medium layer
if (show_medium || show_all)
    up(60) {
        color("#777777") {
            medium();
        }
    }

if (show_small_diffusors || show_all)
    up(80) {
        diffusors();
    }

// Top
if (show_top || show_all)
    right(width + 20) base() {
        for (c = [ 0, 90, 180, 270 ]) {
            zrot(c) side(l = sl, cover = false);
        }
    }

// Light layer
if (show_light || show_all)
    up(20) right(width + 20) {
        color("#bbbbbb") {
            light();
        }
    }

// Dark layer
if (show_dark || show_all)
    up(40) right(width + 20) {
        color("#555555") {
            dark();
        }
    }

// Medium layer
if (show_medium || show_all)
    up(60) right(width + 20) {
        color("#777777") {
            medium();
        }
    }

if (show_small_diffusors || show_all)
    up(80) right(width + 20) {
        diffusors();
    }

module diffusors(plate = 0, clearance = 0, thickness = layer) {
    difference() {
        cube([ width - 2 * unit + 2 * clearance, width - 2 * unit + 2 * clearance, plate + thickness ],
             anchor = CENTER + BOT);
        up(plate) minkowski() {
            difference() {
                cube([ width - 2 * unit + 8 * clearance, width - 2 * unit + 8 * clearance, thickness ],
                     anchor = CENTER + BOT);
                holes(c = 0);
            }
            cube([ clearance, clearance, thickness ], anchor = CENTER + BOT);
        }
    }
}

if (show_diffusor || show_all)
    left(width + 20) {
        mirror([ 0, 1, 0 ]) diffusors(plate = diffusor_thickness, clearance = clearance, thickness = thickness);
    }

if (show_diffusor || show_all)
    left(width + 20) up(20) {
        mirror([ 0, 1, 0 ]) light_cover();
    }

if (show_small_diffusors || show_all)
    left(2 * (width + 20)) {
        diffusors(clearance = clearance);
    }