$fn = 200;  // Number of fragments used to construct curves and circles

module drawRing()
{    
    // panel holder
    holder_thickness = 1.5;
    holder_thickness_bottom = 1.0;
    panel_thickness = 4;
    panel_thickness_bottom = 4.2;
    panel_holder_width = 40;
    panel_holder_height = 10;
    panel_holder_thickness = panel_thickness + 2*holder_thickness;
    
    metal_floor_thickness = 7;
    floor_extra_length = 10;
    
    // holding tray with wedge for easy insertion of panel
    rotate([90, 0, 90])
    linear_extrude(panel_holder_width)
    polygon(points=[
        // outer wood side of S
        [0, 0],
        [panel_holder_thickness, 0],
        [panel_holder_thickness, panel_holder_height],
        // metal side of S
        [panel_holder_thickness+metal_floor_thickness, panel_holder_height],
        [panel_holder_thickness+metal_floor_thickness, 0],
        [panel_holder_thickness+metal_floor_thickness+holder_thickness, 0],
        [panel_holder_thickness+metal_floor_thickness+holder_thickness, panel_holder_height+holder_thickness],
        [panel_holder_thickness-holder_thickness, panel_holder_height+holder_thickness],
        // inner side of S
        [panel_holder_thickness-holder_thickness, panel_holder_height-2*holder_thickness],
        [panel_holder_thickness/2+panel_thickness_bottom/2, holder_thickness_bottom],
        [panel_holder_thickness/2-panel_thickness_bottom/2, holder_thickness_bottom],
        [holder_thickness, panel_holder_height/1.5-1.5*holder_thickness],
        [0, panel_holder_height/1.5],
        [0, holder_thickness_bottom],
        [-floor_extra_length, holder_thickness_bottom],
        [-floor_extra_length, 0],
    ]);
}


drawRing();
