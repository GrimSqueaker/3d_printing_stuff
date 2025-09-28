// Pond Pump Filter Box
// The pump can be placed inside this box along with some
// filter sponges so that roots and algea to do not block
// the pump often.
// All dimensions in millimeters

$fn = 100;  // Number of fragments used to construct curves and circles

// === FILTER SPONGE SPECIFICATIONS ===
sponge_thickness = 20;    // Thickness of filter sponges (3cm)
sponge_holder_height = 10; // How deep the sponge insertion slots are

// === PUMP DIMENSIONS ===
pump_width = 70-5;           // Width of the pump minus margin, because it is rounded
pump_depth = 100-5;          // Depth of the pump minus margin, because it is rounded
pump_height = 80;            // Internal height of the box

// === MAIN DIMENSIONS (determined by the pump and filters) ===
box_width = pump_width + 2*sponge_thickness; // Internal width of the box
box_depth = pump_depth + sponge_thickness;   // Internal depth of the box  
box_height = 80;                             // Internal height of the box
wall_thickness = 2;                          // Thickness of walls and bottom

// === BAR SPECIFICATIONS ===
bar_width = 10;                  // Width of bars on sides
bar_spacing = 10;                // Spacing between bars
bar_top_spacing = 10;                // Spacing between bars
clip_opening_height = 5;                      // Height of clip spacing opening
bar_depth = wall_thickness*1.01;      // Depth of bars (same as wall thickness)

front_num_bars = floor((box_width - bar_width) / (bar_width + bar_spacing));
front_bar_start_offset = (box_width - (front_num_bars * bar_width + (front_num_bars - 1) * bar_spacing)) / 2;
side_num_bars = floor((box_depth - bar_width) / (bar_width + bar_spacing));
side_bar_start_offset = (box_depth - (side_num_bars * bar_width + (side_num_bars - 1) * bar_spacing)) / 2;

// === CABLE AND HOSE OPENINGS ===
cable_diameter = 5;      // Diameter of power cable opening
hose_diameter = 11.5;      // Diameter of the water hose
hose_opening_from_back = 70;
hose_opening_from_left = 65;

// === SNAP-ON LID SPECIFICATIONS ===
lid_thickness = 2;        // Thickness of the lid
lid_lip_height = 5;       // Height of the lip that goes over the box edges
lid_lip_thickness = 2;    // Thickness of the lid lip
clip_clearance = 0.2;    // Clearance for easier insertion
clip_width = 8;          // Width of each clip (slightly less than bar_width)
clip_height = bar_top_spacing+clip_clearance;        // How far clips extend down
clip_thickness = 2.0;    // Thickness of clip arms

// === CALCULATED DIMENSIONS ===
outer_width = box_width + 2 * wall_thickness;
outer_depth = box_depth + 2 * wall_thickness;
outer_height = box_height + wall_thickness; // No top wall
lid_clearance = 0.1;
lid_width = outer_width + 2 * (lid_lip_thickness+lid_clearance); // Lid overlaps the box
lid_depth = outer_depth + 2 * (lid_lip_thickness+lid_clearance);

// === MAIN ASSEMBLY ===
module filter_box_complete() {
    union() {
        filter_box_body();
        
        // Position lid next to the box for printing/visualization
        translate([2*outer_width + 20, -lid_lip_thickness-lid_clearance, outer_height+lid_thickness])
            rotate([0,180,0])
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
        translate([outer_width/2 - cable_diameter/2, -1, outer_height-lid_lip_height-0.5*cable_diameter])
            rotate([-90, 0, 0])
            cylinder(d=cable_diameter, h=wall_thickness + 2);
        translate([outer_width/2 - cable_diameter/2, wall_thickness/2, outer_height-.5*lid_lip_height-0.25*cable_diameter + 0.01])
            cube([cable_diameter, wall_thickness + 2, lid_lip_height+0.5*cable_diameter], center=true);
    
        // Add bars to the three sides
        create_filter_bar_openings();
    }
        
    // Create sponge holders
    translate([0,0,wall_thickness])
        create_sponge_holders();
}

// === SPONGE INSERTION SLOTS ===
module create_sponge_holders() {
    // Front wall holder
    translate([sponge_thickness, wall_thickness + pump_depth, 0])
        cube([pump_width + 2*wall_thickness, wall_thickness, sponge_holder_height]);
    
    // Left wall holder  
    translate([sponge_thickness, wall_thickness, 0])
        cube([wall_thickness, pump_depth, sponge_holder_height]);
    
    // Right wall holder
    translate([sponge_thickness + pump_width + wall_thickness, wall_thickness, 0])
        cube([wall_thickness, pump_depth, sponge_holder_height]);
}

// === FILTER BARS ===
module create_filter_bar_openings() {
    // Front wall clip openings
    create_clip_openings("front");
    
    // Left wall clip openings
    create_clip_openings("left");
    
    // Right wall clip openings
    create_clip_openings("right");
    
    // Front wall water openings
    create_water_openings("front");
    
    // Left wall water openings
    create_water_openings("left");
    
    // Right wall water openings
    create_water_openings("right");
}

module create_clip_openings(wall) {    
    if (wall == "front") {
        for (i = [0,front_num_bars-1]) {
            translate([wall_thickness + front_bar_start_offset + i * (bar_width + bar_spacing),
                      outer_depth - wall_thickness - 0.01,
                      wall_thickness + box_height - bar_top_spacing - clip_opening_height])
                cube([bar_width, bar_depth, clip_opening_height]);
        }
    }    
    else if (wall == "left") {
        for (i = [0,side_num_bars-1]) {
            translate([-0.01,
                      wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing),
                      wall_thickness + box_height - bar_top_spacing - clip_opening_height])
                cube([bar_depth, bar_width, clip_opening_height]);
        }
    }    
    else if (wall == "right") {
        for (i = [0,side_num_bars-1]) {
            translate([outer_width - bar_depth + 0.01,
                      wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing),
                      wall_thickness + box_height - bar_top_spacing - clip_opening_height])
                cube([bar_depth, bar_width, clip_opening_height]);
        }
    }
}

module create_water_openings(wall) {
    // hexagonal openings on the given wall
    linear_extrude(height = 5)
    circle(r=5, $fn=6);
/*    bar_height = box_height - bar_top_spacing; // Leave space at top
    
    if (wall == "front") {
        for (i = [0,front_num_bars-1]) {
            translate([wall_thickness + front_bar_start_offset + i * (bar_width + bar_spacing),
                      outer_depth - wall_thickness - 0.01,
                      wall_thickness])
                cube([bar_width, bar_depth, bar_height]);
        }
    }    
    else if (wall == "left") {
        for (i = [0,side_num_bars-1]) {
            translate([-0.01,
                      wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing),
                      wall_thickness])
                cube([bar_depth, bar_width, bar_height]);
        }
    }    
    else if (wall == "right") {
        for (i = [0,side_num_bars-1]) {
            translate([outer_width - bar_depth + 0.01,
                      wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing),
                      wall_thickness])
                cube([bar_depth, bar_width, bar_height]);
        }
    }
*/
}

// === SNAP-ON LID ===
module create_lid() {
    difference() {
        union() {
            // Main lid body with lid lip
            difference() {
                cube([lid_width, lid_depth, lid_thickness + lid_lip_height]);
            
                translate([lid_lip_thickness, lid_lip_thickness, lid_thickness])
                    cube([outer_width + 2*lid_clearance, outer_depth + 2*lid_clearance, lid_lip_height + 2]);

                // Hose opening
                translate([hose_opening_from_left, hose_opening_from_back, lid_thickness/2])
                    rotate([0, 0, 90])
                    cylinder(d=hose_diameter, h=lid_thickness + 2, center=true);        
                }
            
            // Add clips
            create_lid_clips();

            // Add sponge holders
            translate([lid_lip_thickness+lid_clearance,wall_thickness+.5,wall_thickness])
                scale([1,1,2])
                create_sponge_holders();
        }
    }
}

module create_lid_clips() {
    // Calculate clip positions to align with bar openings
    
    // Place clips in the spaces between outer bars
    for (i = [0,front_num_bars-1]) { // Every other space
        x_pos = lid_lip_thickness + lid_clearance + wall_thickness + front_bar_start_offset + i * (bar_width + bar_spacing) + bar_spacing/2;
        translate([x_pos, lid_depth - lid_lip_thickness, lid_thickness])
            create_single_clip("front");
    }
    
    // Place 2 clips on left side
    for (i = [0, side_num_bars-1]) {
        y_pos = lid_lip_thickness + lid_clearance + wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing) + bar_spacing/2;
        translate([lid_lip_thickness, y_pos, lid_thickness])
            rotate([0, 0, 90])
            create_single_clip("side");
    }
    
    // 2 Right side clips
    for (i = [0, side_num_bars-1]) {
        y_pos = lid_lip_thickness + lid_clearance + wall_thickness + side_bar_start_offset + i * (bar_width + bar_spacing) + bar_spacing/2;
        translate([lid_width - lid_lip_thickness, y_pos, lid_thickness])
            rotate([0, 0, 270])
            create_single_clip("side");
    }
}

module create_single_clip(orientation) {
    clip_width_factor = 2;
    // Create a flexible clip that snaps into the bar openings
    translate([-clip_width/2,0,0])
    difference() {
        union() {
            // Vertical part of clip
            cube([clip_width, clip_thickness, clip_height]);
            
            // Clip at bottom
            translate([0, -(clip_width_factor-1)*clip_thickness, clip_height])
                cube([clip_width, clip_width_factor*clip_thickness, clip_width_factor*clip_thickness]);
        }
        
        // Chamfer for easier insertion
        translate([.5*clip_width, -(clip_width_factor-1)*clip_thickness, clip_height+clip_width_factor*clip_thickness])
            scale([1,sqrt(2)*(clip_width_factor-1)*clip_thickness,sqrt(2)*(clip_width_factor-1)*clip_thickness])
            rotate([45, 0, 0])
            cube([clip_width*1.1, 1, 1],center=true);

        // Chamfer for easier printing/opening
        translate([.5*clip_width, -(clip_width_factor-1)*clip_thickness, clip_height])
            scale([1,sqrt(2)*(clip_width_factor-1)*clip_thickness,0.8*(clip_width_factor-1)*clip_thickness])
            rotate([45, 0, 0])
            cube([clip_width*1.1, 1, 1],center=true);
    }
}

// === RENDER THE COMPLETE FILTER BOX ===
filter_box_complete();

// === ALTERNATIVE: Render parts separately ===
// Uncomment the desired part to render individually:

// filter_box_body();      // Just the main box
// create_lid();          // Just the lid

module create_hexagonal_prisms(cols, rows, height, radius, distance) {
    // For hexagons with flat sides touching:
    // - Horizontal spacing (between columns): radius * sqrt(3)
    // - Vertical spacing (between rows): radius * 3/2
    // - Every other column is offset by radius * 3/4
    
    hex_width = radius * sqrt(3);
    hex_height = radius * 2;
    
    // When flat sides touch, the actual spacing is:
    y_spacing = 2*radius*sqrt(1 - 1/4) + distance;
    x_spacing = y_spacing*sqrt(1 - 1/4);
    
    for (col = [0:cols-1]) {
        for (row = [0:rows-1]) {
            // Calculate position
            x_pos = col * x_spacing;
            // Offset every other column for hex packing
            y_pos = row * y_spacing + (col % 2) * (y_spacing / 2);
            
            // Create hexagonal prism at position
            translate([x_pos, y_pos, 0]) {
                rotate([0, 0, 0]) {  // Rotate 30 degrees so flat sides are vertical
                    linear_extrude(height = height)
                        circle(r = radius, $fn = 6);
                }
            }
        }
    }
}

// For perfect tessellation (no gaps), use distance = 0
translate([-50, -50, 0])
    create_hexagonal_prisms(6, 6, 3, 5, 2);  // Larger hexagons, no gaps



// === PRINT INFORMATION ===
echo("=== POND FILTER BOX SPECIFICATIONS ===");
echo(str("Box internal dimensions: ", box_width, "x", box_depth, "x", box_height, "mm"));
echo(str("Box external dimensions: ", outer_width, "x", outer_depth, "x", outer_height, "mm"));
echo(str("Lid dimensions: ", lid_width, "x", lid_depth, "x", lid_thickness, "mm"));
echo(str("Sponge thickness: ", sponge_thickness, "mm"));
echo(str("Number of clips: 2-3 per side"));
echo("=== CABLE OPENING ===");
echo(str("Cable opening: ", cable_diameter, "mm diameter"));
echo(str("side_bar_start_offset", side_bar_start_offset, "mm"));