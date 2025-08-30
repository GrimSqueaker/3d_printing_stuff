// Pond Pump Filter Box
// The pump can be placed inside this box along with some
// filter sponges so that roots and algea to do not block
// the pump often.
// All dimensions in millimeters

// === FILTER SPONGE SPECIFICATIONS ===
sponge_thickness = 30;    // Thickness of filter sponges (3cm)
sponge_holder_height = 10; // How deep the sponge insertion slots are

// === PUMP DIMENSIONS ===
pump_width = 70;           // Internal width of the box
pump_depth = 100;          // Internal depth of the box  
pump_height = 80;          // Internal height of the box

// === MAIN DIMENSIONS (determined by the pump and filters) ===
box_width = pump_width + 2*sponge_thickness; // Internal width of the box
box_depth = pump_depth + sponge_thickness;   // Internal depth of the box  
box_height = 80;                             // Internal height of the box
wall_thickness = 2;                          // Thickness of walls and bottom

// === BAR SPECIFICATIONS ===
bar_width = 10;                  // Width of bars on sides
bar_spacing = 10;                // Spacing between bars
bar_depth = wall_thickness*1.01;      // Depth of bars (same as wall thickness)

// === CABLE AND PIPE OPENINGS ===
cable_diameter = 8;      // Diameter of power cable opening
pipe_diameter = 25;       // Diameter of water pipe opening
opening_height_from_bottom = 50; // Height of openings from bottom

// === CLIP LID SPECIFICATIONS ===
lid_thickness = 2;        // Thickness of the sliding lid
lid_clearance = 1;        // Clearance for lid fit in tracks
track_depth = 6;          // How deep the lid slides into tracks
track_height = lid_thickness + 2; // Height of the sliding tracks

// === CALCULATED DIMENSIONS ===
outer_width = box_width + 2 * wall_thickness;
outer_depth = box_depth + 2 * wall_thickness;
outer_height = box_height + wall_thickness; // No top wall, tracks will be added
lid_width = outer_width; // Lid fits in tracks
lid_depth = outer_depth; // Extra length for handle outside box

// === MAIN ASSEMBLY ===
module filter_box_complete() {
    union() {
        filter_box_body();
        
        // Position lid next to the box for printing/visualization
        translate([outer_width + 20, 0, 0])
            create_lid();
    }
}

// === FILTER BOX BODY ===
module filter_box_body() {
    difference() {
        // Outer shell
        cube([outer_width, outer_depth, outer_height]);
        
        // Hollow out interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([box_width, box_depth, box_height + 1]); // +1 for open top
        
        // Cable opening (back wall)
        translate([outer_width/2 - cable_diameter/2, -1, outer_height])
            rotate([-90, 0, 0])
            cylinder(d=cable_diameter, h=wall_thickness + 2);
        
        //// Pipe opening (back wall, offset from cable)
        //translate([outer_width/2 + 30, -1, opening_height_from_bottom + 30])
        //    rotate([-90, 0, 0])
        //    cylinder(d=pipe_diameter, h=wall_thickness + 2);
    
        // Add bars to the three sides
        create_filter_bars();
    }
        
    // Create sponge holders
    create_sponge_holders();
    
}

// === SPONGE INSERTION SLOTS ===
module create_sponge_holders() {
    // Front wall holder
    translate([sponge_thickness, pump_depth, 0])
        cube([pump_width + 2*wall_thickness, wall_thickness, sponge_holder_height]);
    
    // Left wall holder  
    translate([sponge_thickness, 0, 0])
        cube([wall_thickness, pump_depth, sponge_holder_height]);
    
    // Right wall holder
    translate([sponge_thickness + pump_width + wall_thickness, 0, 0])
        cube([wall_thickness, pump_depth, sponge_holder_height]);
}

// === FILTER BARS ===
module create_filter_bars() {
    // Front wall bars
    create_bars_on_wall("front");
    
    // Left wall bars
    create_bars_on_wall("left");
    
    // Right wall bars
    create_bars_on_wall("right");
}

module create_bars_on_wall(wall) {
    bar_height = box_height - 5; // Leave space at top
    
    if (wall == "front") {
        num_bars = floor((box_width - bar_width) / (bar_width + bar_spacing));
        start_offset = (box_width - (num_bars * bar_width + (num_bars - 1) * bar_spacing)) / 2;
        
        for (i = [0:num_bars-1]) {
            translate([wall_thickness + start_offset + i * (bar_width + bar_spacing),
                      outer_depth - wall_thickness - 0.001,
                      wall_thickness])
                cube([bar_width, bar_depth, bar_height]);
        }
    }    
    else if (wall == "left") {
        num_bars = floor((box_depth - bar_width) / (bar_width + bar_spacing));
        start_offset = (box_depth - (num_bars * bar_width + (num_bars - 1) * bar_spacing)) / 2;
        
        for (i = [0:num_bars-1]) {
            translate([-0.001,
                      wall_thickness + start_offset + i * (bar_width + bar_spacing),
                      wall_thickness])
                cube([bar_depth, bar_width, bar_height]);
        }
    }    
    else if (wall == "right") {
        num_bars = floor((box_depth - bar_width) / (bar_width + bar_spacing));
        start_offset = (box_depth - (num_bars * bar_width + (num_bars - 1) * bar_spacing)) / 2;
        
        for (i = [0:num_bars-1]) {
            translate([outer_width - bar_depth + 0.001,
                      wall_thickness + start_offset + i * (bar_width + bar_spacing),
                      wall_thickness])
                cube([bar_depth, bar_width, bar_height]);
        }
    }
}

// === SLIDING LID ===
module create_lid() {
    difference() {
        union() {
            // Main lid body
            cube([lid_width, lid_depth, lid_thickness]);

            create_lid_clips();
        }
    }
}

module create_lid_clips() {

}


// === RENDER THE COMPLETE FILTER BOX ===
filter_box_complete();

// === ALTERNATIVE: Render parts separately ===
// Uncomment the desired part to render individually:

// filter_box_body();      // Just the main box
// create_lid();          // Just the lid

//// === PRINT INFORMATION ===
//echo("=== POND FILTER BOX SPECIFICATIONS ===");
//echo(str("Box internal dimensions: ", box_width, "x", box_depth, "x", box_height, "mm"));
//echo(str("Box external dimensions: ", outer_width, "x", outer_depth, "x", outer_height, "mm"));
//echo(str("Lid dimensions: ", lid_width, "x", lid_depth, "x", lid_thickness, "mm"));
//echo(str("Sponge slot width: ", sponge_thickness + sponge_slot_clearance, "mm"));
//echo(str("Number of bars per side: varies by wall length"));
//echo("=== CABLE/PIPE OPENINGS ===");
//echo(str("Cable opening: ", cable_diameter, "mm diameter"));
//echo(str("Pipe opening: ", pipe_diameter, "mm diameter"));