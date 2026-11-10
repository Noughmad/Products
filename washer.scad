include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

length = 100;
height = 40;
depth = 21;
rounding_outside = 10;
rounding_inside = 5;

thickness_side = 2;
thickness_top = 6;

hole_depth = depth - 2 * thickness_side;
hole_height = height - 2 * thickness_top;

text_a = "Čisto";
text_b = "Umazano";

text_a2 = "\x47          \x47";
text_b2 = "";

text_size = 12;
text_font = "Liberation Sans";
text_font2 = "Zapf Dingbats";
text_depth = 0.4;

clearance = 0.15;

dovetail_width = thickness_top/2;
dovetail_length = 10;
dovetail_depth = 1.5;

joiner_count = 2;

module joiner_locations() {
    num_positions = joiner_count + 2;
    step = length / num_positions;
    xs = [-length/2+step:length/2:step];
    ys = [height/2-thickness_top/2, -height/2+thickness_top/2];
    
    for (x = xs) {
        for (y = ys) {
            translate([x - dovetail_length/2, y, depth/2]) children();
        }
    }
}

module half_base() {
up(depth/2)
    rotate([-90, 0, 0]) {
        intersection() {
            difference() {
                cuboid([length, depth, height], rounding=rounding_outside);
                cuboid([length+0.01, hole_depth, hole_height], rounding=rounding_inside, edges="X");
            }
            cuboid([length+0.01, depth/2+0.01, height+0.01], anchor=FRONT);
        }
    }
}

module half_text(face_text, face_font) {
up(text_depth)
    rotate([180, 0, 0])
    color("black") {
        linear_extrude(text_depth)
        text(face_text, valign="center", halign="center", size=text_size, font=face_font);
    }
}

module joint_a() {
    rotate([0, 0, 90])
    dovetail("male", slide=dovetail_length, height=dovetail_depth, width=dovetail_width, angle=22.5);
}

module joint_b() {
    rotate([0, 0, -90]) {
        dovetail("female", slide=dovetail_length+clearance, height=dovetail_depth+clearance, width=dovetail_width+clearance, angle=22.5);
        translate([0, dovetail_length, 0])
            dovetail("female", slide=dovetail_length+clearance, height=dovetail_depth+clearance, width=dovetail_width+clearance, angle=0);
    }
}

union() {
    half_base();
    joiner_locations() joint_a();
}

half_text(text_a, text_font);
if (text_a2 != "") {
    half_text(text_a2, text_font2);
}

right(length + 50) {
    difference() {
        half_base();
        joiner_locations() joint_b();
    }
}
right(length + 50) half_text(text_b, text_font);
if (text_b2 != "") {
    right(length + 50) half_text(text_b2, text_font2);
}