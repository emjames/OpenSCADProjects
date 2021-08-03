module chasis(x, y, z) {
    // dimensions in mm (x, y, z) is (Width, Depth, Height)
    color("white") cube([x, y, z], true);
}


module base (width, depth, height, col) {
    // we want the heat sink to start at the top of the chasis
    color(col) cube([width, depth, height], true);
}

module plate_fin (width, height, depth) {
    color("Lime") cube([width, height, depth], true);
}


module strip_fin(width, height, depth, staggered, i) {
/*
 * If it is staggered, we want the even indices to be translated differently
 *
 * */

    difference() {
        color("Yellow") cube([width, height, depth], true);
        slab_height = 10;

        if (staggered && (i % 2 == 0)) {
            translate([0, -50, 0]) cube([width, slab_height, depth], true);
            translate([0, -24, 0]) cube([width, slab_height, depth], true);
            translate([0, 0, 0]) cube([width, slab_height, depth], true);
            translate([0, 26, 0]) cube([width, slab_height, depth], true);
            translate([0, 50, 0]) cube([width, slab_height, depth], true);
        } else {
            translate([0, -12, 0]) cube([width, slab_height, depth], true);
            translate([0, -38, 0]) cube([width, slab_height, depth], true);
            translate([0,  12, 0]) cube([width, slab_height, depth], true);
            translate([0,  38, 0]) cube([width, slab_height, depth], true);
        }
    }
}

module square_fin(width, height, depth, staggered, i) {
/*
 * If it is staggered, we want the even indices to be translated differently
 *
 * */
    color("Cyan") cube([width, height, depth], true);

    for (k = [10:10:50]){
        if (staggered && (i % 2 == 0) && (k % 2 ==0)) {
            // staggered factor
            sf = 0.9;
            translate([0,  k*sf, 0]) color("Cyan") cube([width, height, depth], true);
            translate([0, -k*sf, 0]) color("Cyan") cube([width, height, depth], true);
        }
        else {
            translate([0,  k, 0]) color("Cyan") cube([width, height, depth], true);
            translate([0, -k, 0]) color("Cyan") cube([width, height, depth], true);
        }
    }
}

module circular_fin(radius, height, staggered, i) {
/*
 * If it is staggered, we want the even indices to be translated differently
 *
 * */
    color("Green") {
        
        translate([0, 0, 0]) cylinder(r=radius, h=height, true);
        for (k = [10:10:50]){
            if (staggered && (i % 2 == 0) && (k % 2 ==0)) {
                // staggered factor
                sf = 0.9;
                translate([0,  k*sf, 0]) cylinder(r=radius, h=height, true);
                translate([0, -k*sf, 0]) cylinder(r=radius, h=height, true);
            }
            else {
                translate([0,  k, 0]) cylinder(r=radius, h=height, true);
                translate([0, -k, 0]) cylinder(r=radius, h=height, true);
            }
        }
    }

    difference() {

        /* if (staggered && (i % 2 == 0)) { */
        /*     translate([0, -50, 0]) cylinder([radius, height]); */
        /*     translate([0, -24, 0]) cylinder([radius, height]); */
        /*     translate([0, 0, 0])   cylinder([radius, height]); */
        /*     translate([0, 26, 0])  cylinder([radius, height]); */
        /*     translate([0, 50, 0])  cylinder([radius, height]); */
        /* } else { */
        /*     translate([0, -12, 0]) cylinder([radius, height]); */
        /*     translate([0, -38, 0]) cylinder([radius, height]); */
        /*     translate([0,  12, 0]) cylinder([radius, height]); */
        /*     translate([0,  38, 0]) cylinder([radius, height]); */
        /* } */
    }
}

    
// Single heat sink
// col: color
// pos: position
//
module heatsink (col, pos, base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing, type) {
    
    translate (pos) {
        base(base_w, base_d, base_h, col);
    
        fin_x = (base_w/2) - (fin_w/2);
        fin_y = 0;
        fin_z = base_h*3;
        base_start = (base_w / 2) - (fin_w/2);
        // Total fins we can place inside the base
        total_fins = base_w / ((fin_w) + fin_spacing);
        
             
        // Start at the base and fill from there
        for (i = [1: total_fins]) {
            translate([base_start - ((fin_spacing * i) + (fin_w * i)), fin_y, fin_z]) {
                if (type == "plate fin") {
                    plate_fin(fin_w, fin_d, fin_h);
                } else if (type == "strip fin") {
                    strip_fin(fin_w, fin_d, fin_h, false, i);
                } else if (type == "staggered strip fin") {
                    strip_fin(fin_w, fin_d, fin_h, true, i);
                } else if (type == "circular pin fin") {
                    circular_fin(fin_w, fin_h, false, i);
                } else if (type == "staggered circular pin fin"){
                    circular_fin(fin_w, fin_h, true, i);
                } else if (type == "square pin fin"){
                    square_fin(fin_w, fin_d, fin_h, false, i);
                } else if (type == "staggered square pin fin") {
                    square_fin(fin_w, fin_d, fin_h, true, i);
                }
            }
        }
      
        
       
        //translate([fin_x - (fin_x / 2 - fin_spacing), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 2 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 3 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
        //translate([fin_x - ((fin_x / 2) * 4 - (fin_spacing)), fin_y, fin_z]) plate_fin(fin_w, fin_d, fin_h);
    }
}


// Heat sinks in the chasis
module heatsinks_demo () {
    position = [-500, 0, height_server / 2];
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
    
    // Basic plate fin
    heatsink("Green", position, base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing, "plate fin");

    // Strip fin
    heatsink("Gold", position + [base_w *2, 0, 0], base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing, "strip fin");

    // Staggered strip fin
    heatsink("Gold", position + [base_w *4, 0, 0], base_w, base_d, base_h, fin_w, fin_h, fin_d, fin_spacing, "staggered strip fin");

    // Circular pin fin
    // radius (mm)
    fin_r = 2;
    circular_spacing = 7;
    // height
    heatsink("DarkGreen", position + [base_w *6, 0, 0], base_w, base_d, base_h, fin_r, fin_h, fin_d, circular_spacing, "circular pin fin");

    heatsink("DarkGreen", position + [base_w *8, 0, 0], base_w, base_d, base_h, fin_r, fin_h, fin_d, circular_spacing, "staggered circular pin fin");

    // Square pin fin
    square_fin_w = 4;
    square_fin_h = 25;
    square_fin_d = 4;
    square_fin_spacing = 7.5;

    heatsink("Navy", position + [base_w *10, 0, 0], base_w, base_d, base_h, square_fin_w, square_fin_h, square_fin_d, square_fin_spacing, "square pin fin");

    // Staggered strip fin
    //
    heatsink("Navy", position + [base_w *12, 0, 0], base_w, base_d, base_h, square_fin_w, square_fin_h, square_fin_d, square_fin_spacing, "staggered square pin fin");

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
heatsinks_demo();
