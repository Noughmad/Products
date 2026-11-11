#include <BOSL2/std.scad>;

/* [Components] */

include_box = true;
include_coins = false;
include_gimmick = false;
include_wrapper = true;

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

$fn = 360;

if (include_coins)
    color("black") {
        difference() {
            cylinder(r = coin_diameter / 2, h = coin_thickness);
            translate([ 0, 0, -0.1 ]) cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness + .2);
            translate([ 0, 0, layer_height ])
                cylinder(r = coin_diameter / 2 + nozzle_diameter, h = coin_thickness - 2 * layer_height);
        }
    }

if (include_coins)
    color("yellow") {
        cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness);
        translate([ 0, 0, layer_height ]) cylinder(r = coin_diameter / 2, h = coin_thickness - 2 * layer_height);
    }

if (include_coins)
    color("black") {
        translate([ -0.5, 0, coin_thickness - layer_height ]) linear_extrude(layer_height)
            text(heads_symbol, halign = "center", valign = "center", size = 14, font = heads_font);
        mirror([ 0.5, 0, 0 ]) translate([ -1, 0, 0 ]) linear_extrude(layer_height)
            text(tails_symbol, halign = "center", valign = "center", size = 14, font = tails_font);
    }

if (include_gimmick)
    translate([ 30, 0, 0 ]) color("black") {
        difference() {
            cylinder(r = coin_diameter / 2, h = gimmick_thickness);
            translate([ 0, 0, layer_height ]) cylinder(r = coin_diameter / 2 - nozzle_diameter, h = coin_thickness);
        }
    }
if (include_gimmick)
    translate([ 30, 0, 0 ]) color("yellow") {
        translate([ 0, 0, layer_height ])
            cylinder(r = coin_diameter / 2 - nozzle_diameter, h = gimmick_thickness - layer_height);
    }
if (include_gimmick)
    translate([ 30, 0, 0 ]) color("black") {
        translate([ -0.5, 0, gimmick_thickness - layer_height ]) linear_extrude(layer_height)
            text(heads_symbol, halign = "center", valign = "center", size = 14, font = heads_font);
    }

// Box
if (include_box)
    translate([ 0, 30, 0 ]) color("green") {
        box_height = 4 * coin_thickness + gimmick_thickness + 2 * box_top_clearance + box_stop_thickness;
        box_radius = coin_diameter / 2 + box_side_clearance + box_thickness;
        difference() {
            cyl(h = box_height, r = box_radius, chamfer = box_thickness / 3, anchor = BOTTOM);
            cyl(h = box_height, r = coin_diameter / 2 + box_side_clearance, chamfer = -box_thickness / 3,
                anchor = BOTTOM);
        }

        up(gimmick_thickness + box_top_clearance) {
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