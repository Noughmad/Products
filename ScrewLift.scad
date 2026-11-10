include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = 64;

// 1. Define your custom thin blade profile
// Coordinates are [X, Y] where:
// X = distance from the core/shaft axis (radius)
// Y = position along the length of the screw
blade_thickness = 2; 
blade_depth = 12;     // How far out the blade extends from the core

custom_profile = [
    [-1/2, 0],  // Top inner
    [-1/20, blade_depth/20],  // Top inner
    [1/20, blade_depth/20],  // Top inner
    [1/20, 0],  // Top inner
    [1/2, 0]  // Top inner
];

// 2. Generate the screw
generic_threaded_rod(
    d = 10,                  // Shaft/core diameter
    l = 240,                 // Length of the screw
    pitch = 20,              // Large pitch for wide pockets
    profile = custom_profile,
    bevel1=0
);

