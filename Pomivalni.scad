Length = 80;
Layer_height = 0.2;
Chamfer = 8;
Straight = 8;
Height = 30;
Edge = 1;

color("beige") linear_extrude(Length) {
    polygon([
        [ 0, 0 ],
        [ Height - Edge, 0 ],
        [ Height - Edge, Edge ],
        [ Height - Chamfer, Chamfer ],
        [ Height - Chamfer, Straight + Chamfer ],
        [ -Chamfer - Edge, Straight + Chamfer ],
        [ -Chamfer - Edge, Straight + Chamfer - Edge ],
        [ 0, Straight ],
    ]);
}

color("gray") {
    rotate([ 90, 90, 0 ]) translate([ -Length / 2, Height * 0.55, -Layer_height ]) linear_extrude(Layer_height) {
        text("Čisto", halign = "center", valign = "center", size = 12, font = "Liberation Sans");
    }
}

color("lightblue") {
    rotate([ 90, 90, 0 ]) translate([ -Length / 2, Height / 2, -Layer_height ]) linear_extrude(Layer_height) {
        text("\x47            \x47", halign = "center", valign = "center", size = 10, font = "Zapf Dingbats");
    }
}

color("gray") {
    rotate([ 90, 90, 180 ]) translate([ -Length / 2, Chamfer - Height * 0.45, Straight + Chamfer - Layer_height ])
        linear_extrude(Layer_height) {
        text("Umazano", halign = "center", valign = "center", size = 12);
    }
}