include <BOSL2/std.scad>
include <BOSL2/hinges.scad>

$fn=180;
thickness=6;
clearance=0.3;
length = 255;
width = 36;

close_angle = 170;

cartouche_width = 36;
cartouche_height = 18;
cartouche_depth = 2;
cartouche_clearance = 0.15;

use_cartouche = true;
cartouche_rounding = 5;

cutout_height = 10;

start_pos = -thickness/3+thickness+clearance;
end_pos = length;
cutout_step = length / 2.5;

cartouche_to_edge = (width - cutout_height - cartouche_height) / 2;
last_cartouche_offset = cartouche_width/2+cartouche_to_edge;

dice_size = cartouche_height - 4;
pip_size = 3;
pip_scale = 3;

module cartouche_frame(clr=0, depth_cut=0) {
    cuboid([cartouche_width + 2*clr, cartouche_height+2*clr, cartouche_depth+2*clr-depth_cut], rounding=cartouche_rounding, edges="Z");
}

function cartouche_pos(i) = start_pos + (i + 0.5) * cutout_step;

color("gray") {
    diff() {
        difference() {
            inner_side();
            right(cartouche_pos(0)) card_cutout("2");
            right(cartouche_pos(1)) card_cutout("1");
            right(cartouche_pos(2)) card_cutout("0", -last_cartouche_offset);
        }
    }
}

color("green") {
    diff() {
        yrot(close_angle)
        difference() {
            outer_side();
            left(cartouche_pos(0)) card_cutout("3");
            left(cartouche_pos(1)) card_cutout("4");
            left(cartouche_pos(2)) card_cutout("5", last_cartouche_offset);
        }
    }
}

module inner_side() {
    right(length/2+start_pos)
    cuboid([length,width,thickness],anchor=TOP, rounding=cartouche_rounding+cartouche_to_edge/2, edges=FRONT+RIGHT) {
        right(thickness/3)
        position(LEFT+TOP) orient(anchor=LEFT)
          knuckle_hinge(width, segs=5, offset=thickness+clearance,
                        inner=true, knuckle_clearance=clearance,
                        clearance=clearance/2, arm_angle=90,
                        knuckle_diam=2*thickness+clearance,
                        clear_top=true, in_place=true, pin_diam = thickness+clearance);
                       }}

module outer_side() {
    left(length/2+start_pos)
    cuboid([length,width,thickness],anchor=TOP, rounding=cartouche_rounding+cartouche_to_edge, edges=FRONT+LEFT) {
        left(thickness/3)
        position(RIGHT+TOP) orient(anchor=RIGHT)
          knuckle_hinge(width, segs=5, offset=thickness+clearance,
                        inner=false, knuckle_clearance=clearance,
                        clearance=clearance/2, arm_angle=90,
                        knuckle_diam=2*thickness+clearance,
                        clear_top=true, in_place=true, pin_diam = thickness+clearance);
                  }   
}

module card_cutout(number, off=0) {
    if (use_cartouche) {
        fwd(cutout_height/2) right(off) down(cartouche_depth/2+cartouche_clearance) cartouche_frame(clr=cartouche_clearance);
    } else {
        fwd(cutout_height/2) down(1) right(off) linear_extrude(1) text(str(number), halign = "center", valign = "center");
    }
    
    back(width/2 + 50 - cutout_height) cuboid([85, 100, 3*thickness], rounding=5, edges="Z");
}

module cartouche(number) {
    down(0.2) cartouche_frame(depth_cut=0.4);
    left(cartouche_width/4) color("black") linear_extrude(1) text(str(number), halign = "center", valign = "center", size = dice_size);
    right(cartouche_width/4) color("black") dice_pips(number);
}

fwd(50) {
    for (n = [1:6]) {
        right(50 * n)
        cartouche(n);
    }
}

module dice_pips(n) {
    up(0.8)
    difference() {
        cuboid([dice_size, dice_size, 0.4], rounding=4, edges="Z");
        if (n > 1) {
            pip(-1, -1);
            pip(1, 1);
        }
        if (n == 6) {
            pip(0, -1);
            pip(0, 1);
        }
        if (n > 3) {
            pip(1, -1);
            pip(-1, 1);
        }
        if (n == 1 || n == 3 || n == 5) {
            pip(0, 0);
        }
    }
}

module pip(x, y) {
    translate([x*pip_scale, y*pip_scale, 0]) cylinder(h=20, r=pip_size/2, center=true);
}

