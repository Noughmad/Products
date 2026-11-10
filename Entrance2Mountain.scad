#include <BOSL2/std.scad>

bez1 = [
    [0, 0, 0],
    [10, 19, 0],
    [26, 16, 0],
    [53, 11, 0],
    [80, 6, 0],
    [125, 0, 0],
    [180, 62, 0]
];

bez2 = [
    [0, 15, 40],
    [10, 19, 40],
    [26, 16, 40],
    [53, 11, 40],
    [80, 6, 40],
    [115, 0, 40],
    [170, 72, 40]
];

bez3 = [
    [-5, 40, 80],
    [10, 35, 80],
    [26, 30, 80],
    [53, 21, 80],
    [80, 31, 80],
    [115, 40, 80],
    [160, 82, 80]
];

bez4 = [
    [-15, 40, 120],
    [13, 38, 120],
    [26, 42, 120],
    [53, 51, 120],
    [80, 60, 120],
    [100, 66, 120],
    [140, 102, 120]
];

stroke(bezpath_curve(bez1, N=2) ,dots=true,dots_color="red");
stroke(bezpath_curve(bez2, N=2) ,dots=true,dots_color="red");
stroke(bezpath_curve(bez3, N=2) ,dots=true,dots_color="red");
stroke(bezpath_curve(bez4, N=2) ,dots=true,dots_color="red");

bez = [bez1, bez2, bez3, bez4];

vnf_polyhedron(bezier_sheet(bez, 1, splinesteps=128));

// debug_bezier(bez1, N=2);
