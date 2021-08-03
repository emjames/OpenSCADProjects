module chasis(x, y, z) {
    // dimensions in mm (x, y, z) is (Width, Depth, Height)
    color("white") cube([x, y, z], true);
}


module base (width, depth, height) {
    // we want the heat sink to start at the top of the chasis
    color("Green") cube([width, depth, height], true);
}

module plate_fin (width, height, depth) {
    color("Lime") cube([width, height, depth], true);
}
    
// Single heat sink
// pos: position
module heatsink (pos, base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing) {
    
    translate (pos) {
        base(base_w, base_d, base_h);
    
        fin_x = (base_w/2) - (fin_w/2);
        fin_y = 0;
        fin_z = base_h*3;
        base_start = (base_w / 2) - (fin_w/2);
        // Total fins we can place inside the base
        total_fins = base_w / ((fin_w/2) + fin_spacing);
        
        echo(base_w);
        
        //translate([base_start, fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);  
        //translate([base_start + -fin_spacing, fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
       //translate([base_start + -fin_spacing*2, fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h); 
        //translate([base_start, fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);  
        
        // Start at the base and fill from there
        for (i = [0: total_fins]) {
            translate([base_start - ((fin_spacing * i) + (fin_w * i)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
            echo(i);
        }
      
        
       
        //translate([fin_x - (fin_x / 2 - fin_spacing), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 2 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 3 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 4 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
    }
}


// Heat sinks in the chasis
module heatsinks () {
    position = [0, 0, height_server / 2];
    fin_height = 10;
    
    // base (mm)
    base_w = 80; // 寬度
    base_h = 4.25;  // 
    base_d = 108; // 長度
    
    // Fin (mm)
    fin_w = 0.7; // 
    fin_h = 21; // 
    fin_d = base_d; // 
    fin_spacing = 2.66;
    
    // Bypass (mm)
    bp_w = 200;
    bp_h = 44.5;
    
    heatsink(position, base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing);
}

module fans () {
    height = height_server - 150;
    width = 73;
    depth = 73;
        
    x = (width_server / 2) - (width / 2);
    y = (depth_server / 2) - (depth / 2);
    z = (height_server/ 2) + (height / 2);
    
    
    for (i = [1: 1.2: 7]) {
    
        translate([x - (width * i), y, z]) cube([width, depth, height], true);
            
    }
}


width_server = 587; // mm
height_server = 225; // mm
depth_server = 998; // mm

chasis(width_server, depth_server, height_server);
fans();
heatsinks();
