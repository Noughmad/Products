/* [Lamp parameters] */
inside = 154;
thickness = 1;

outside = inside + 2 * thickness;

difference() {
  cube([outside, outside, outside], center = true);
  translate([0, 0, -thickness])
    cube([inside, inside, inside + thickness], center = true);
  translate([inside * 2.5 / 8, outside * 0.5 - thickness / 2, -outside * 0.5 / 8]) {
    cube([inside * 3 / 8, 2 * thickness, outside * 1 / 8], center = true);
  }
  translate([-inside * 2.5 / 8, outside * 0.5 - thickness / 2, -outside * 0.5 / 8]) {
    cube([inside * 3 / 8, 2 * thickness, outside * 1 / 8], center = true);
  }
}
