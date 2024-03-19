// housing to hold and stabilize two 2.0mm JST-PH connectors that are soldered
// together in a 90 degree angle for an LED strip connection


// Parameters
pipe_width = 10; // Width of the pipe
pipe_height = 5; // Height of the pipe
wall_thickness = 1; // Thickness of the pipe wall
arm_right_length = 12;
arm_up_length = 11
;

// Calculate total width and height including walls
total_width = pipe_width + 2 * wall_thickness;
total_height = pipe_height + 2 * wall_thickness;

// Pipe with rectangular cross-section
difference() {
    union() {
        cube([arm_right_length, total_width, total_height]);
        cube([total_height, total_width, arm_up_length]);
    }

    translate([wall_thickness, wall_thickness, wall_thickness]) {
        cube([arm_right_length+1, pipe_width, pipe_height]);
        cube([pipe_height, pipe_width, arm_up_length+1]);
    }
    
    translate([-.05, -.05, -.05]) {
        cube([arm_right_length+.1, wall_thickness+.1, arm_up_length+.1]);
    }
}
