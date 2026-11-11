include<BOSL2 / std.scad>;
use<MTG / mana.ttf>;

count = 5;

card_width = 63.5;
card_height = 88.9;

divider_width = 60;
divider_height = 80;
thickness = 0.6;

flap_height = 14;
flap_width = 14;

$fn = 30;

SYMBOLS = [ "\ue600", "\ue601", "\ue602", "\ue603", "\ue604", "\ue904" ];

module symbol(number, size) {
    translate([ 0, -2 * thickness, 0 ]) xrot(90) {
        scale(1) {
            linear_extrude(0.1) text(SYMBOLS[number], font = "Mana", valign = "center", halign = "center", size = size);
        }
    }
}

module divider(number, count) {
    flap_start = flap_width / 2;
    flap_stride = (divider_width - flap_width) / (count - 1);

    x = flap_start + number * flap_stride;
    echo(x);

    cuboid([ divider_width, thickness, divider_height ], rounding = 3,
           edges = [ TOP + LEFT, TOP + RIGHT, BOTTOM + LEFT, BOTTOM + RIGHT ]);

    symbol = SYMBOLS[number];

    color("black") {
        symbol(number, 30);
        zrot(180) symbol(number, 30);
    }

    translate([ x - divider_width / 2, 0, divider_height / 2 ]) {
        cuboid([ flap_width, thickness, flap_height + 7 ], rounding = flap_width / 2,
               edges = [ TOP + LEFT, TOP + RIGHT, BOTTOM + LEFT, BOTTOM + RIGHT ]);

        up(5) color("black") {
            symbol(number, 6);
            zrot(180) symbol(number, 6);
        }
    }
}

xdistribute(100) {
    divider(0, 6);
    divider(1, 6);
    divider(2, 6);
    divider(3, 6);
    divider(4, 6);
    divider(5, 6);
}