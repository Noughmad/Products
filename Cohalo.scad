include <BOSL2/std.scad>
include <BOSL2/hinges.scad>

$fn = 180;

Thickness = 3;
Clearance = 0.4;

Side_length = 20;

module hex() {
    linear_sweep(hexagon(side=Side_length), h=Thickness);
}

hex();