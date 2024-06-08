$fn = 100;  // Number of fragments used to construct curves and circles



module sprinkler_holder()
{
    // anchor
    anchor_width = 20;
    anchor_thickness = 2;
    anchor_length = 180;
    tip_length = anchor_width;
    stopper_position = anchor_length/2-4*anchor_thickness;
    
    intersection() {
        difference() {
            union() {
                cube([anchor_width, anchor_thickness, anchor_length], center=true);
                rotate([0,0,90])
                cube([anchor_width, anchor_thickness, anchor_length], center=true);
                // stopper
                translate([0,0,-stopper_position])
                rotate([0,0,45])
                scale([1/1.4,1/1.4,1])
                cube([anchor_width, anchor_width, anchor_thickness], center=true);
            }
            
            translate([0,0,anchor_length/2-tip_length])
            difference() {
                scale(1.01)
                translate([-anchor_width/2,-anchor_width/2,0])
                cube(anchor_width);
                cylinder(d2=0, d1=anchor_width, h=tip_length);
            }
        }
        
        rotate([0,0,45])
        cube([anchor_width/1.4, anchor_width/1.4, anchor_length], center=true);
    }
}

sprinkler_holder();
