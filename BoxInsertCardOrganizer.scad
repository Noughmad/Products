include <BOSL2 / std.scad>

BoxLength = 345;
BoxWidth = 235;
BoxHeight = 80;

CardWidth = 63;
CompartmentWidth = CardWidth + 4;

BedSizeX = 240;
BedSizeY = 240;

DividerThickness = 1;
WidthStep = CompartmentWidth + DividerThickness;

DividerHeight = 42;

MaxCompartmentLength = 240;
ActualMaxCompartmentLength = min(MaxCompartmentLength, BedSizeX - DividerThickness);

NumCompartmentsY = ceil((BoxWidth + DividerThickness) / WidthStep);

NumCompartmentsX = ceil((BoxLength + DividerThickness) / (ActualMaxCompartmentLength));
LengthStep = (BoxLength - DividerThickness) / NumCompartmentsX;
CompartmentLength = LengthStep - DividerThickness;

CornerSupportSize = 20;
DividerSupportSize = 7;

SupportOffset = DividerSupportSize / 2 - DividerThickness / 2;

Hexes = false;

WallAtEnds = true;
WallAtSides = false;
WallAtSide1 = false;
WallAtSide2 = false;

HexDiameter = 10;
HexSpacing = 12;
HexMinDistance = 1;

HexRadiusRatio = sqrt(3) / 2;
HexHeight = HexRadiusRatio * HexSpacing;

HexRows = floor((DividerHeight - 2 * HexMinDistance) / HexHeight);

ConnectorClearance = 0.15;

function makeSegments(fullSize, bedSize, step) =
  fullSize > bedSize ? makeMultipleSegments(fullSize, bedSize, step) : [
    [0, 0, fullSize]
  ];

function makeMultipleSegments(fullSize, bedSize, step) =
  let (segmentSize = floor(bedSize / step) * step, numSegments = ceil((fullSize - DividerThickness) / segmentSize))
    [
      for (i = [0:numSegments - 1])
        (i == numSegments - 1) ? [i, i * segmentSize, fullSize] : [i, i * segmentSize, i * segmentSize + segmentSize],
    ];

SegmentsX = makeSegments(BoxLength, BedSizeX, LengthStep);
SegmentsY = makeSegments(BoxWidth, BedSizeY, WidthStep);

assert(WidthStep <= BedSizeY, "Compartment width does not fit onto the print bed");
assert(LengthStep <= BedSizeX, "Compartment length does not fit onto the print bed");

function hexRowZ(r) =
  DividerHeight / 2 - (HexRows + 1) / 2 * HexHeight + r * HexHeight;

function numHexes(length) =
  floor((length - 2 * HexMinDistance) / HexSpacing);

function hexPositionsX(length, row = 1) =
  let (n = numHexes(length), o = (length - 2 * HexMinDistance - n * HexSpacing) / 2, start = (row % 2 == 1) ? o : o + HexSpacing / 2, count = (row % 2 == 1) ? n - 1 : n - 2)
    [
      for (i = [0:count])
        HexMinDistance + start + HexSpacing / 2 + i * HexSpacing
    ];

function hexPositions(length) =
  [
    for (row = [1:HexRows])
      for (x = hexPositionsX(length, row))
        [-hexRowZ(row), x, -2 * DividerThickness]
  ];

function connectorPositions(thickness) =
  [
    for (row = [-1, 1])
      [-DividerHeight / 2 + row * HexHeight, 0, -(thickness + DividerThickness) / 2]
  ];

module IntersectWithBox() {
  intersection() {
    Box();
    children();
  }
}

module Box() {
  cube([BoxLength, BoxWidth, BoxHeight]);
}

module Wall(length, hasWall = true) {
  WallBase(length, hasWall);
}

module CornerSupport() {
  rotate([0, 0, 45]) {
    translate([-CornerSupportSize / 2, -CornerSupportSize / 2, 0])
      cube([CornerSupportSize, CornerSupportSize, DividerThickness]);
  }
}

module CutHexes(length) {
  rotate([0, 0, -90])
    rotate([0, 90, 0]) {
      for(p = hexPositions(length)) {
        translate(p)
          linear_extrude(3 * DividerThickness)
            hexagon(r = HexDiameter / 2);
      }
    }
}

module WallBase(length, hasWall = true) {
  if (hasWall) {
    difference() {
      cube([length, DividerThickness, DividerHeight]);
      if (Hexes)
        CutHexes(length);
    }
  } else {
    difference() {
      cube([length, DividerThickness, DividerHeight]);
      translate([SupportOffset, -DividerThickness, SupportOffset])
        cube([length - 2 * SupportOffset, 3 * DividerThickness, DividerHeight]);
    }

    rotate([90, 0, 0])
      translate([0, 0, -DividerThickness])
        CornerSupport();
  }
  translate([0, -SupportOffset, 0])
    cube([length, DividerSupportSize, DividerThickness]);
  CornerSupport();
}

function hasWallAtSide(j) =
  WallAtSides || (j != 0 && j != NumCompartmentsY) || (j == 0 && WallAtSide1) || (j == NumCompartmentsY && WallAtSide2);
function hasWallAtEnd(i) =
  WallAtEnds || (i != 0 && i != NumCompartmentsX);
function placeCorner(i, j) =
  hasWallAtEnd(i) || hasWallAtSide(j);

module Insert() {

  for(i = [0:NumCompartmentsX], j = [0:NumCompartmentsY]) {
    y = (j == NumCompartmentsY) ? BoxWidth - DividerThickness : j * WidthStep;
    width = (j == NumCompartmentsY - 1) ? BoxWidth - DividerThickness - (NumCompartmentsY - 1) * WidthStep : WidthStep;
    x = i * LengthStep;

    translate([x, y, 0]) {
      if (j != NumCompartmentsY)
        translate([DividerThickness, DividerThickness])
          rotate([0, 0, 90])
            Wall(width, hasWallAtEnd(i));
      if (i != NumCompartmentsX)
        translate([0, 0, 0])
          Wall(LengthStep + DividerThickness, hasWallAtSide(j));
    }
  }
}

module Connector(clearance) {
  rotate([0, 0, -90])
    rotate([0, 90, 0]) {
      for(p = connectorPositions(DividerThickness - clearance)) {
        translate(p)
          linear_extrude(DividerThickness - clearance)
            hexagon(r = HexDiameter / 2 - clearance);
      }
    }
}

module Connectors(clearance = 0, positive = true) {
  for(j = [0:NumCompartmentsY]) {
    y = (j == NumCompartmentsY) ? BoxWidth - DividerThickness : j * WidthStep;

    translate([0, y, 0]) {
      Connector(clearance);
      if (!positive && !hasWallAtSide(j)) {
        translate([HexDiameter / 3, 0, HexDiameter / 3 * tan(30)])
          Connector(clearance);
      }
    }
  }
}

function cutsX() =
  [0:LengthStep:10];

module DivideIntoSegments() {
  for(sx = SegmentsX, sy = SegmentsY) {
    translate([sx[0] * 10, sy[0] * 10, 0]) {
      difference() {
        intersection() {
          translate([sx[1], sy[1], 0]) {
            cube([sx[2] - sx[1], sy[2] - sy[1], BoxHeight]);
          }
          children();
        }
        if (sx[0] != 0) {
          translate([sx[1], sy[1], 0])
            color("black")
              Connectors(positive = false);
        }
      }
      if (sx[2] < BoxLength) {
        translate([sx[2] - sx[1], 0, 0])
          Connectors(clearance = ConnectorClearance, positive = true);
      // add small connetors at the end
      }
    }
  }
}

DivideIntoSegments() {
  Insert();
}

// CutHexes(200);
