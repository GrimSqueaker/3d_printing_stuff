$fn = 100;  // Number of fragments used to construct curves and circles



module sprinkler_holder()
{
    // Dimensions of ring
    inner_diameter = 10.5;
    inner_radius = inner_diameter/2;
    thickness = 1.5;
    outer_radius = inner_radius + thickness;
    height = 10;

    // Ring opening
    opening_percent = 0.9;
    ring_middle = inner_radius+thickness/2;
    opening_cutter_y = opening_percent * inner_radius;
    opening_cutter_x = sqrt( ring_middle^2 - opening_cutter_y^2);
    opening_cutter_rotation = asin(opening_cutter_y/ring_middle);
    
    // holder
    holder_width = 12;
    holder_length = 150;
    holder_thickness = 2;
    
    // stabilizer
    stabilizer_height = 6;
    
    // anker
    anker_width = 10;
    anker_thickness = 1.5;
    
    // other values
    tolerance = 0.02;
    tolerance1 = 1+tolerance;

    // whole object
    union() {
        // tube grabber
        translate([0,0,height/2]) {
            difference() {
                cylinder(h = height, r = outer_radius, center=true);
                
                cylinder(h = height + 2*tolerance, r = outer_radius - thickness, center=true);

                // arc cutout
                scale(2)
                translate([0, 0, -height/2]) 
                linear_extrude(height)
                polygon(points=[
                    [0,0],
                    [opening_cutter_y, opening_cutter_x],
                    [opening_cutter_y, tolerance1*outer_radius],
                    [-opening_cutter_y, tolerance1*outer_radius],
                    [-opening_cutter_y, opening_cutter_x]
                ]);
            }
            
            // roundings at tube grabber
            translate([opening_cutter_y, opening_cutter_x,0])
            cylinder(h=height, d=thickness, center=true);
            translate([-opening_cutter_y, opening_cutter_x,0])
            cylinder(h=height, d=thickness, center=true);
        }
              
        // holder plate
        difference() {
            translate([-holder_width/2, -holder_length, 0])
            cube([holder_width, holder_length, holder_thickness]);
            cylinder(h = height + 2*tolerance, r = outer_radius - thickness, center=true);
            
            // anker connection cut-out
            translate([0,-holder_length+anker_width,0])
            rotate([0,0,45])
            translate([0,0,(holder_thickness-tolerance)/2])
            scale([1,1,tolerance1])
            union() {
                cube([anker_width, anker_thickness, holder_thickness], center=true);
                rotate([0,0,90])
                cube([anker_width, anker_thickness, holder_thickness], center=true);
            }
        }
        
        // stabilizer   
        rotate([0,0,180])
        translate([-holder_thickness/2, (inner_radius+thickness/2), 0])
        cube([holder_thickness, holder_length-(inner_radius+thickness)-2*anker_width, stabilizer_height]);
    }
}

sprinkler_holder();
