// Spacer for placing hexagonal acoustic panels evenly on a wall

length = 70;
width = 12;
thickness = 5;

union() {
    translate([0, -width/2, 0])
        cube([length, width, thickness]);
    rotate([0, 0, 120])
        translate([0, -width/2, 0])
            cube([length, width, thickness]);
    rotate([0, 0, 240])
        translate([0, -width/2, 0])
            cube([length, width, thickness]);
}
