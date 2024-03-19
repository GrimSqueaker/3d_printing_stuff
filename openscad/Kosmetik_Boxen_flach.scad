// container for cosmetics in a mirror cabinet
// holds boxes with magnetic lids in place


$fn= $preview ? 32 : 128;

// Parameters for thin lipstick
numRows = 5;          // Number of rows of holes
numCols = 2;          // Number of columns of holes
boxHeight = 45;       // Height of the box
holeWidth = 76;       // Width of each box hole
holeHeight = 25;      // Height of each box hole
outerWall = 2;        // outer wall thickness
innerWall = 1;        // inner wall thickness
roundedEdgeWidth = 4; // rounding at corners

// precomputed often used values
width = numCols * holeWidth + (numCols - 1) * innerWall + 2*outerWall;
depth = numRows * holeHeight + (numRows - 1) * innerWall + 2*outerWall;
widthStraightPart = width - 2*roundedEdgeWidth; 
depthStraightPart = depth - 2*roundedEdgeWidth; 

module roundedEdge() {
    difference() {
        cylinder(h = boxHeight, r = roundedEdgeWidth, center = false);
        translate([0, 0, -1]) {
            cylinder(h = boxHeight + 2, r = roundedEdgeWidth-outerWall, center = false);
            translate([-roundedEdgeWidth - 1, -roundedEdgeWidth - 1, 0]) {
                cube([roundedEdgeWidth + 1, 2*roundedEdgeWidth + 2, boxHeight + 2], center = false);
                cube([2*roundedEdgeWidth + 2, roundedEdgeWidth + 1, boxHeight + 2], center = false);
            }       
        }
    }
}

module roundedEdgeCutoff() {
    difference() {
        translate([0, 0, -1])
            cube([roundedEdgeWidth, roundedEdgeWidth, boxHeight+2], center = false);
        translate([roundedEdgeWidth, roundedEdgeWidth, -2])
            cylinder(h = boxHeight + 4, r = roundedEdgeWidth, center = false);       
    }
}

union() {
    // outer walls
    translate([roundedEdgeWidth, 0, 0])
        cube([widthStraightPart, outerWall, boxHeight], false);
    translate([roundedEdgeWidth, depth-outerWall, 0])
        cube([widthStraightPart, outerWall, boxHeight], false);
    translate([0, roundedEdgeWidth, 0])
        cube([outerWall, depthStraightPart, boxHeight], false);
    translate([width-outerWall, roundedEdgeWidth, 0])
        cube([outerWall, depthStraightPart, boxHeight], false);
    
    // inner walls
    for (c = [1:numCols - 1]) {
        translate([outerWall + holeWidth*c + innerWall*(c-1), 0, 0])
            cube([innerWall, depth, boxHeight]);
    }
    for (r = [1:numRows - 1]) {
        translate([0, outerWall + holeHeight*r + innerWall*(r-1), 0])
            cube([width, innerWall, boxHeight]);
    }

    // rounded edges
    translate([roundedEdgeWidth, roundedEdgeWidth, 0]) rotate([0, 0, 180]) roundedEdge();
    translate([width-roundedEdgeWidth, depth-roundedEdgeWidth, 0]) rotate([0, 0, 0]) roundedEdge();
    translate([roundedEdgeWidth, depth-roundedEdgeWidth, 0]) rotate([0, 0, 90]) roundedEdge();
    translate([width-roundedEdgeWidth, roundedEdgeWidth, 0]) rotate([0, 0, 270]) roundedEdge();

    // bottom
    difference() {
        cube([width, depth, outerWall]);
        translate([-0.01, -0.01, 0]) roundedEdgeCutoff();
        translate([width+0.01, -0.01, 0])      rotate([0, 0, 90])  roundedEdgeCutoff();
        translate([width+0.01, depth+0.01, 0]) rotate([0, 0, 180]) roundedEdgeCutoff();
        translate([-0.01, depth+0.01, 0])      rotate([0, 0, 270]) roundedEdgeCutoff();
    }
}
