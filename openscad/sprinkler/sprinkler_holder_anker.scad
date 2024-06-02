$fn = 100;  // Number of fragments used to construct curves and circles



module sprinkler_holder()
{
    // anker
    anker_width = 10;
    anker_thickness = 1.5;
    anker_length = 150;
    tip_length = anker_width;
    stopper_position = anker_length/2-4*anker_thickness;
    
    intersection() {
        difference() {
            union() {
                cube([anker_width, anker_thickness, anker_length], center=true);
                rotate([0,0,90])
                cube([anker_width, anker_thickness, anker_length], center=true);
                // stopper
                translate([0,0,-stopper_position])
                rotate([0,0,45])
                scale([1/1.4,1/1.4,1])
                cube([anker_width, anker_width, anker_thickness], center=true);
            }
            
            translate([0,0,anker_length/2-tip_length])
            difference() {
                scale(1.01)
                translate([-anker_width/2,-anker_width/2,0])
                cube(anker_width);
                cylinder(d2=0, d1=anker_width, h=tip_length);
            }
        }
        
        rotate([0,0,45])
        cube([anker_width/1.4, anker_width/1.4, anker_length], center=true);
    }
}

sprinkler_holder();
