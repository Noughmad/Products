include<BOSL2 / std.scad>

    turn_radius = 40;
angle = 60;

module profile() {
    difference() {
        square(10, center = true);
        square(8, center = true);
    }
}

path = [
    each arc(180, r = turn_radius, angle = [ 0, 90 + angle ]),
    each back(2 * turn_radius * cos(angle),
              p = left(2 * turn_radius * sin(angle), p = arc(180, r = turn_radius, angle = [ -90 + angle, -90 ]))),
];

path_extrude2d(path, caps = false) {
    profile();
}
