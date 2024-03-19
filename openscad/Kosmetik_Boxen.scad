// container for lipstick in a mirror cabinet
// holds lipsticks with magnetic lids in place


$fn= $preview ? 32 : 128;

/*
// Parameters for thick lipstick
numRows = 4;          // Number of rows of lipstick holes
numCols = 2;          // Number of columns of lipstick holes
boxHeight = 30;       // Height of the box
holeDiameter = 28;    // Diameter of each lipstick hole
outerWall = 1.5;      // outer wall thickness
innerWall = 1.0;      // inner wall thickness
*/
//*
// Parameters for thin lipstick
numRows = 5;          // Number of rows of lipstick holes
numCols = 2;          // Number of columns of lipstick holes
boxHeight = 40;       // Height of the box
holeDiameter = 23;    // Diameter of each lipstick hole
outerWall = 2;        // outer wall thickness
innerWall = 1;        // inner wall thickness
//*/


// precomputed often used values
width = numCols * holeDiameter + (numCols - 1) * innerWall + 2*outerWall;
depth = numRows * holeDiameter + (numRows - 1) * innerWall + 2*outerWall;
widthStraightPart = width - holeDiameter - 2*outerWall; 
depthStraightPart = depth - holeDiameter - 2*outerWall; 

roundedEdgeWidth = holeDiameter/2 + outerWall;

module roundedEdge() {
    difference() {
        cylinder(h = boxHeight, r = roundedEdgeWidth, center = false);
        translate([0, 0, -1]) {
            cylinder(h = boxHeight + 2, r = holeDiameter/2, center = false);
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
            cylinder(h = boxHeight + 4, r = holeDiameter/2 + outerWall, center = false);       
    }
}

union() {
    // outer walls
    translate([outerWall + holeDiameter/2, 0, 0])
        cube([widthStraightPart, outerWall, boxHeight], false);
    translate([outerWall + holeDiameter/2, depth-outerWall, 0])
        cube([widthStraightPart, outerWall, boxHeight], false);
    translate([0, outerWall + holeDiameter/2, 0])
        cube([outerWall, depthStraightPart, boxHeight], false);
    translate([width-outerWall, outerWall + holeDiameter/2, 0])
        cube([outerWall, depthStraightPart, boxHeight], false);
    
    // inner walls
    for (c = [1:numCols - 1]) {
        translate([outerWall + holeDiameter*c + innerWall*(c-1), 0, 0])
            cube([innerWall, depth, boxHeight]);
    }
    for (r = [1:numRows - 1]) {
        translate([0, outerWall + holeDiameter*r + innerWall*(r-1), 0])
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
