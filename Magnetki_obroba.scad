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

color("black") {
    translate([ 0, 0, 7 ]) {
        difference() {
            linear_extrude(1) {
                offset(delta = 1.2) text(text, 33, font = font_spec, $fn = 100);
            }
            linear_extrude(2) {
                offset(delta = 0.2) text(text, 33, font = font_spec, $fn = 100);
            }
        }
    }
}
