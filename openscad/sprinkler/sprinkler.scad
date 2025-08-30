// Parameters
wall_thickness = 1.5;

body_diameter = 30;
body_height = 6;

cone_height = 10;
cone_wall_thickness = 2.2;

inlet_outer_diameter = 8.8; // mm
inlet_length = 10; // mm
inlet_wall_thickness = 1.0;

outlet_diameter = 3.9; // mm
outlet_count = 5;
outlet_angle_span = 100; // degrees

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

module holder_base(length=150, anchor_width=20, front_width=10, thickness=5) {
    roundness = 2;
    back_width = anchor_width*1.2;
    
    union() {
        // base
        linear_extrude(height=thickness)
        minkowski() {
            hull()
            translate([front_width/2,0]) {
                square(front_width-2*roundness, center=true);
                translate([length-(front_width+back_width)/2,0])
                square(back_width-2*roundness, center=true);
            }        
            circle(roundness);
        }
        // stabilizer
        linear_extrude(height=2*thickness)
        hull() {
            translate([thickness/2,0])
            circle(d=thickness);
            translate([length-(back_width),0])
            circle(d=thickness);
        }        
    }
}

module tube_grabber(inner_radius=12, grabber_thickness=1, thickness=5, opening_percent=0.9) {
        
    // Ring opening
    radius = inner_radius+grabber_thickness/2;
    opening_cutter_y = opening_percent * radius;
    opening_cutter_x = sqrt( radius^2 - opening_cutter_y^2);
    
    translate([-inner_radius,0,0])
    rotate([0,0,90])
    linear_extrude(thickness) {
        union() {
            difference() {
                circle(r = inner_radius+grabber_thickness);
                
                circle(r = inner_radius);

                // arc cutout
                scale(2)
                polygon(points=[
                    [0,0],
                    [opening_cutter_y, opening_cutter_x],
                    [opening_cutter_y, inner_radius],
                    [-opening_cutter_y, inner_radius],
                    [-opening_cutter_y, opening_cutter_x]
                ]);
            }
            translate([opening_cutter_y, opening_cutter_x,0])
            circle(d=grabber_thickness);
            translate([-opening_cutter_y, opening_cutter_x,0])
            circle(d=grabber_thickness);
        }
    }
}
   

module sprinkler_holder()
{
    // Dimensions of ring
    inner_diameter = 10.5;
    grabber_thickness = 1.5;
    grabber_height = 14;
    opening_percent = 0.9;

    // holder
    holder_width = 12;
    holder_length = 130;
    holder_thickness = 4;

    // anchor
    anchor_width = 20;
    anchor_thickness = 2;

    // other values
    tolerance = 0.02;
    tolerance1 = 1+tolerance;
    
    difference() {
        union() {
            holder_base(
                length=holder_length, 
                anchor_width=anchor_width, 
                front_width=holder_width, 
                thickness=holder_thickness
            );
            /*tube_grabber(
                inner_radius=inner_diameter/2,
                grabber_thickness=grabber_thickness,
                thickness=grabber_height,
                opening_percent=opening_percent
            );*/
        }
        // anchor connection cut-out
        translate([holder_length-anchor_width/1.41,0,0])
        rotate([0,0,45])
        translate([0,0,(holder_thickness-tolerance)/2])
        scale([1,1,tolerance1])
        union() {
            cube([anchor_width, anchor_thickness, holder_thickness], center=true);
            rotate([0,0,90])
            cube([anchor_width, anchor_thickness, holder_thickness], center=true);
        }
    }
}

union() {
    translate([-10, 0, 0])
        rotate([0, 0, 90])
        sprinkler();
    sprinkler_holder();
}
