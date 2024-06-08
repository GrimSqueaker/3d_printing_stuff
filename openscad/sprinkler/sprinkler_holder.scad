$fn = 100;  // Number of fragments used to construct curves and circles

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


module sprinkler_holder()
{
    difference() {
        union() {
            holder_base(
                length=holder_length, 
                anchor_width=anchor_width, 
                front_width=holder_width, 
                thickness=holder_thickness
            );
            tube_grabber(
                inner_radius=inner_diameter/2,
                grabber_thickness=grabber_thickness,
                thickness=grabber_height,
                opening_percent=opening_percent
            );
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

sprinkler_holder();

