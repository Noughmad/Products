text = "A";
size = 30;
font = "Sans";

hole_locations = [
    [ 7.5, 10.75 ],
    [ 42.3, 10.75 ],
    [ 87.8, 16 ],
    [ 126, 16 ],
    [ 159.5, 16 ],
    [ 192.7, 16 ],
    [ 231.5, 16 ],
    [ 276.5, 10.75 ],
];

font_spec = str(font, ":style=Bold");
echo(font_spec);

module letter(text, hole) {
    difference() {
        union() {
            difference() {
                linear_extrude(8) {
                    offset(delta = 1.5)
                        text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
                }
                translate([ 0, 0, -1 ]) linear_extrude(8) {
                    offset(delta = 0.5)
                        text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
                }
            }
            translate([ hole[0], hole[1], 0 ]) {
                linear_extrude(8) {
                    circle(4.6, $fn = 100);
                }
            }
        }
        translate([ hole[0], hole[1], -1 ]) {
            linear_extrude(3.4) {
                circle(3.1, $fn = 100);
            }
        }
    }
}

module border(text) {
    color("black") {
        translate([ 0, 0, 8 - 0.2 ]) difference() {
            linear_extrude(0.2) {
                offset(delta = 1) text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
            }
            translate([ 0, 0, -0.5 ]) linear_extrude(2) {
                text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
            }
        }
    }
}

values = [
    [ "1", 2.7, 0 ], [ "2", 7.5, 6 ], [ "3", 2, 1 ], [ "4", 5.4, 0 ], [ "5", -6, 3 ], [ "6", -7.2, -0.3 ],
    [ "7", 3, 0 ], [ "8", 0, 1.2 ], [ "9", 7.7, 1 ], [ "0", 8, 4 ],
    /*
        ["A", 0, -5.4],
        ["B", 0, 1],
        ["C", -8, 0],
        ["D", -9, 0],
    */
];

for (i = [0:len(values) - 1]) {
    value = values[i];
    translate([ (i % 5) * 36, floor(i / 5) * 50, 0 ]) {
        // letter(value[0], [value[1], value[2]]);
        border(value[0]);
    }
}
