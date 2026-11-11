text = "A";
size = 33;
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
                linear_extrude(7) {
                    offset(delta = 0.5)
                        text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
                }
            }
            translate([ hole[0], hole[1], 0 ]) {
                linear_extrude(8) {
                    circle(4, $fn = 100);
                }
            }
        }
        translate([ hole[0], hole[1], 0 ]) {
            linear_extrude(2.2) {
                circle(3.15, $fn = 100);
            }
            linear_extrude(7) {
                circle(2, $fn = 100);
            }
        }
    }
}

module border(text) {
    color("black") {
        difference() {
            linear_extrude(1) {
                offset(delta = 1.2) text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
            }
            linear_extrude(2) {
                offset(delta = 0.2) text(text, 33, font = font_spec, halign = "center", valign = "center", $fn = 100);
            }
        }
    }
}

values = [
    [ "1", 2, 0 ], [ "2", 4, 0 ], [ "3", 2, 1 ], [ "4", 5, -5.4 ], [ "5", 0, 2 ], [ "6", -7, 0 ], [ "7", 3, 0 ],
    [ "8", 0, 1 ], [ "9", 7, 0 ], [ "0", 0, 14 ],
    /*
        ["A", 0, -5.4],
        ["B", 0, 1],
        ["C", -8, 0],
        ["D", -9, 0],
    */
];

for (i = [0:len(values) - 1]) {
    value = values[i];
    translate([ i * 36, 0, 0 ]) letter(value[0], [ value[1], value[2] ]);

    translate([ i * 36, 50, 0 ]) {
        border(value[0]);
    }
}

translate([ 0, 50, 0 ]) {}