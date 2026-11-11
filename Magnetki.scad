text = "J A N I T I N A";
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

difference() {
    union() {
        difference() {
            linear_extrude(8) {
                offset(delta = 1.5) text(text, 33, font = font_spec, $fn = 100);
            }
            linear_extrude(7) {
                offset(delta = 0.5) text(text, 33, font = font_spec, $fn = 100);
            }
        }
        for (hole = hole_locations) {
            translate([ hole[0], hole[1], 0 ]) {
                linear_extrude(8) {
                    circle(4, $fn = 100);
                }
            }
        }
    }
    for (hole = hole_locations) {
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
