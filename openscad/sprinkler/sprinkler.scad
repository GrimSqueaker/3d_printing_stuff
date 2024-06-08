// Parameters
wall_thickness = 1.5;

body_diameter = 30;
body_height = 6;

cone_height = 10;
cone_wall_thickness = 2.2;

inlet_outer_diameter = 8.8; // mm
inlet_length = 10; // mm
inlet_wall_thickness = 1.0;

outlet_diameter = 2.7; // mm
outlet_count = 6;
outlet_angle_span = 110; // degrees

eps = 0.01;

$fn=100;

module sprinkler() {
    difference() {
        // outer shell
        union() {
            // Main body
            cylinder(h = body_height, d = body_diameter);

            // cone
            translate([0, 0, body_height])
                cylinder(h = cone_height, d2 = inlet_outer_diameter, d1 = body_diameter);
            
            // inlet
            translate([0, 0, body_height + cone_height])
                cylinder(h = inlet_length, d = inlet_outer_diameter);
        }
        
        // hollow inner parts
        union() {
            // Main body
            translate([0,0,wall_thickness])
                cylinder(h = body_height-wall_thickness+eps, d = body_diameter-2*wall_thickness);

            // cone
            translate([0, 0, body_height])
                cylinder(h = cone_height, d2 = inlet_outer_diameter-cone_wall_thickness, d1 = body_diameter-cone_wall_thickness);
            
            // inlet
            translate([0, 0, body_height + cone_height-eps])
                cylinder(h = inlet_length+2*eps, d = inlet_outer_diameter-2*inlet_wall_thickness);
        }

        // Create the outlets
        for (i = [0:outlet_count-1]) {
            rotate([0, 0, i * (outlet_angle_span / (outlet_count - 1))])
                translate([0, 0, 0.8*wall_thickness + outlet_diameter/2])
                    rotate([0, 90, 0])
                        cylinder(h = body_diameter/2, d = outlet_diameter);
        }
    }
}

sprinkler();
