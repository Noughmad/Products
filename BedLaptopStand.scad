include <BOSL2/std.scad>
include <BOSL2/transforms.scad>

thickness = 10;
height = 10;

radius = 30;

hex_width = 2 * radius * cos(30);
hex_height = hex_width * cos(30);

y_step = [0, hex_width, 0];
x_step = [hex_width * cos(30), hex_width / 2, 0];

module hex() {
  linear_extrude(height) {
    difference() {
      hexagon(or = radius + thickness / 2);
      hexagon(or = radius - thickness / 2);
    }
  }
}

// hex();

module rows(n, m = 4) {
  for(i = [0:n - 1]) {
    right(i * x_step[0]) {
      count = ((i % 2) == 0) ? m - 1 : m;
      line_copies(y_step, n = count) {
        hex();
      }
    }
  }
}

rows(4);

right(5) {
  yrot(-90) {
    intersection() {
      left(-5)
        rows(1);
    }
  }
}

right(5 + hex_height) {
  yrot(-90) {
    left(hex_height - 5)
      intersection() {
        rows(4);
      }
  }
}

color("blue") {
  translate([90, hex_width / 2 - 5, -5])
    yrot(-45) {
      cube([20, 10, 80]);
    }
  translate([90, -hex_width / 2 - 5, -5])
    yrot(-45) {
      cube([20, 10, 80]);
    }
}
