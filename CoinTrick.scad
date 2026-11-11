include<BOSL2 / std.scad> include<BOSL2 / threading.scad>

    /* [Components] */

    include_box = true;
include_coins = false;
include_gimmick = false;
include_wrapper = true;
include_container = true;

/* [Parameters] */

coin_diameter = 23.25;
coin_thickness = 2.33;

nozzle_diameter = 0.5;
layer_height = 0.2;

clearance = 0.25;

gimmick_thickness = 2.33;

heads_symbol = "1";
tails_symbol = "€";

heads_font = "Sans:style=Bold Italic";
tails_font = "Sans:style=Bold Italic";

box_top_clearance = 1.5;
box_side_clearance = 0.6;
box_thickness = 1;
box_stop_thickness = 1;
box_stop_width = 3;
box_bottom_clearance = 0;

container_clearance = 1;
container_thickness = 1;

$fn = 360;

if (include_coins)
    translate([ -30, 0, 0 ]) color("yellow") {
        // Yellow coin
        cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness);
        translate([ 0, 0, layer_height ]) cylinder(r = coin_diameter / 2, h = coin_thickness - 2 * layer_height);
    }

if (include_coins)
    translate([ -30, 0, 0 ]) color("black") {
        // Black edge
        difference() {
            cylinder(r = coin_diameter / 2, h = coin_thickness);
            translate([ 0, 0, -0.1 ]) cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness + .2);
            translate([ 0, 0, layer_height ])
                cylinder(r = coin_diameter / 2 + nozzle_diameter, h = coin_thickness - 2 * layer_height);
        }

        // Black text
        translate([ -0.5, 0, coin_thickness - layer_height ]) linear_extrude(layer_height)
            text(heads_symbol, halign = "center", valign = "center", size = 14, font = heads_font);
        mirror([ 0.5, 0, 0 ]) translate([ -1, 0, 0 ]) linear_extrude(layer_height)
            text(tails_symbol, halign = "center", valign = "center", size = 14, font = tails_font);
    }

if (include_gimmick)
    translate([ 30, 0, 0 ]) color("yellow") {
        translate([ 0, 0, layer_height ])
            cylinder(r = coin_diameter / 2 - nozzle_diameter, h = gimmick_thickness - layer_height);
    }

if (include_gimmick)
    translate([ 30, 0, 0 ]) color("black") {
        difference() {
            cylinder(r = coin_diameter / 2, h = gimmick_thickness);
            translate([ 0, 0, layer_height ]) cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness);
        }
        translate([ -0.5, 0, gimmick_thickness - layer_height ]) linear_extrude(layer_height)
            text(heads_symbol, halign = "center", valign = "center", size = 14, font = heads_font);
    }

// Box
if (include_box)
    translate([ 0, 30, 0 ]) color("green") {
        box_height =
            4 * coin_thickness + gimmick_thickness + 2 * box_top_clearance + box_stop_thickness + box_bottom_clearance;
        box_radius = coin_diameter / 2 + box_side_clearance + box_thickness;
        difference() {
            cyl(h = box_height, r = box_radius, chamfer = box_thickness / 3, anchor = BOTTOM);
            cyl(h = box_height, r = coin_diameter / 2 + box_side_clearance, chamfer = -box_thickness / 3,
                anchor = BOTTOM);
        }

        up(gimmick_thickness + box_top_clearance + box_bottom_clearance) {
            difference() {
                cyl(h = box_stop_thickness, r = box_radius, chamfer = box_thickness / 3, anchor = BOTTOM);
                cyl(h = box_stop_thickness, r = coin_diameter / 2 + box_side_clearance - box_stop_width,
                    chamfer = -box_thickness / 3, anchor = BOTTOM);
            }
        }
    }

if (include_wrapper) {
    translate([ 30, 30, 0 ]) {
        color("black") {
            cyl(h = coin_thickness, r = coin_diameter / 2 + 0.2);
        }
    }
}

if (include_container) {
    box_height =
        4 * coin_thickness + gimmick_thickness + 2 * box_top_clearance + box_stop_thickness + box_bottom_clearance;
    container_height = box_height + 2 * container_clearance + container_thickness;
    container_inner_radius = coin_diameter / 2 + box_side_clearance + box_thickness + container_clearance;
    container_radius =
        coin_diameter / 2 + box_side_clearance + box_thickness + container_clearance + container_thickness;
    thread_height = 4.5;
    difference() {
        union() {
            cyl(h = container_height, r = container_radius, anchor = BOTTOM);
            up(container_height - thread_height / 2) {
                threaded_rod(d = 2 * container_radius + 1.5, height = thread_height, pitch = 1.25, teardrop = false);
            }
        }
        up(container_thickness) {
            cyl(h = 2 * container_height, r = container_radius - container_thickness, anchor = BOTTOM);
        }
    }
}

if (include_container)
    translate([ 70, 0, 0 ]) {
        box_height =
            4 * coin_thickness + gimmick_thickness + 2 * box_top_clearance + box_stop_thickness + box_bottom_clearance;
        container_height = box_height + 2 * container_clearance + container_thickness;
        container_inner_radius = coin_diameter / 2 + box_side_clearance + box_thickness + container_clearance;
        container_radius =
            coin_diameter / 2 + box_side_clearance + box_thickness + container_clearance + container_thickness;

        thread_height = 4.5;
        cap_height = thread_height + container_thickness + 2;
        cap_radius = container_radius + 0.75 + container_thickness;
        difference() {
            cyl(h = cap_height, r = cap_radius);
            up(container_thickness) threaded_rod(d = 2 * container_radius + 1.5, height = thread_height + 2,
                                                 pitch = 1.25, teardrop = false, internal = true, $slop = 0.075);
        }
    }