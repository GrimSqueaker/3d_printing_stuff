// Träger/Halter für Glasregalboden in Badschrank

$fn=64;

pin_thickness = 3;

holder_wall_height = 20;
holder_wall_width = 10;
holder_wall_thickness = 2.25;

holder_L_thickness = 4;
holder_L_length = 10;

spring_cutout_width = holder_wall_width - 4;
spring_cutout_height = 10;
spring_cutout_pos_h_offset = 7; 

mink_radius = 2;

pin_diameter = 2.8;
pin_length = 7;

spring_width = 4;
spring_radius = 11;
spring_thickness = 1.25;
spring_height = 2.25;
spring_offset = 8;

delta = .1;

union() {
    // main body
    difference() {
        // base shape
        translate(mink_radius*[0,1,1])
        minkowski() {
            cube([holder_L_length-mink_radius,
                  holder_wall_width-2*mink_radius, 
                  holder_wall_height-2*mink_radius
                  ]);
            sphere(mink_radius);
        }
        
        // main cut-out
        translate([holder_wall_thickness, 0, holder_L_thickness])
            scale([holder_L_length, holder_wall_width, holder_wall_height])
            cube(1);
        
        // straight back
        translate([-mink_radius, 0, 0])
            scale([mink_radius, holder_wall_width, holder_wall_height])
            cube(1);
        
        // spring cutout
        translate([-delta, (holder_wall_width-spring_cutout_width)/2, spring_cutout_pos_h_offset])
            scale([holder_wall_thickness+2*delta, spring_cutout_width, spring_cutout_height])
            cube(1);
    };
    
    // pin
    translate([-pin_length/2, holder_wall_width/2, holder_L_thickness])
        rotate([0,90,0])
        cylinder(h=pin_length, d=pin_diameter, center=true);
    
    // spring
    intersection() {
        translate([holder_wall_thickness-spring_radius+spring_height,holder_wall_width/2,spring_cutout_height/2+spring_offset])
            scale([1,1,.8])
            rotate([90,0,0])
            difference() {
                cylinder(h=spring_width, r=spring_radius, center=true);
                cylinder(h=spring_width+2*delta, r=spring_radius-spring_thickness, center=true);
            }
        translate([holder_wall_thickness-delta, 0, spring_cutout_pos_h_offset])
        cube([holder_L_length,
              holder_wall_width, 
              holder_wall_height
              ]);  
    }
}
