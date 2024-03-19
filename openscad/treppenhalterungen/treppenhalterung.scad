// Connector to hold a thin plywood panel in place at a stairway that
// has round legs as connections between each pair of stairs.
// The connector can be snapped onto the legs.


$fn = 200;  // Number of fragments used to construct curves and circles

module drawRing()
{
    // Dimensions of ring
    inner_diameter = 49.0;
    inner_radius = inner_diameter/2;
    thickness = 3.5;
    outer_radius = inner_radius + thickness;
    height = 2.0*thickness;

    // Ring opening
    ring_middle = inner_radius+thickness/2;
    opening_cutter_y = inner_radius-10;
    opening_cutter_x = sqrt( ring_middle^2 - opening_cutter_y^2);
    opening_cutter_rotation = asin(opening_cutter_y/ring_middle);
    
    // panel holder
    holder_thickness = 1.5;
    holder_thickness_bottom = 1.0;
    panel_thickness = 4;
    panel_thickness_bottom = 4.2;
    panel_holder_width = 40;
    panel_holder_height = 10;
    panel_holder_thickness = panel_thickness + 2*holder_thickness;
    
    // other values
    tolerance = 0.1;
    tolerance1 = 1+tolerance;

    // whole object
    union() {
        // holding ring
        difference() {
            union() {
                cylinder(h = height, r = outer_radius, center=true);
            }
            cylinder(h = height + 2*tolerance, r = outer_radius - thickness, center=true);
            // snap cutout
            translate([opening_cutter_y, opening_cutter_x, 0]) {
                rotate([0, 0, -opening_cutter_rotation]) {
                    difference() {
                        dim = tolerance1*thickness;
                        cube([dim, dim, tolerance1*height], center = true);
                        translate([thickness/2, 0, 0]) {
                            cylinder(h=tolerance1*height, r=thickness/2, center=true);
                        }
                    }
                }
            }
            translate([-opening_cutter_y, opening_cutter_x, 0]) {
                rotate([0, 0, opening_cutter_rotation]) {
                    difference() {
                        dim = tolerance1*thickness;
                        cube([dim, dim, tolerance1*height], center = true);
                        translate([-thickness/2, 0, 0]) {
                            cylinder(h=tolerance1*height, r=thickness/2, center=true);
                        }
                    }
                }
            }
            // arc cutout
            scale(tolerance1)
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
        
        // holding tray with wedge for easy insertion of panel
        translate([-panel_holder_width/2, -(outer_radius+panel_holder_thickness-holder_thickness+(panel_thickness_bottom-panel_thickness)/2), -height/2])
        rotate([90, 0, 90])
        linear_extrude(panel_holder_width)
        polygon(points=[
            [0, 0],
            [panel_holder_thickness, 0],
            [panel_holder_thickness, panel_holder_height],
            [panel_holder_thickness-holder_thickness, panel_holder_height-2*holder_thickness],
            [panel_holder_thickness/2+panel_thickness_bottom/2, holder_thickness_bottom],
            [panel_holder_thickness/2-panel_thickness_bottom/2, holder_thickness_bottom],
            [holder_thickness, panel_holder_height-2*holder_thickness],
            [0, panel_holder_height]
        ]);
    }
}


drawRing();
