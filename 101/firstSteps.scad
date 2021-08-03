translation_d = [25, 5, 0];
translate(translation_d) {
    
    difference() {
        
        cube(30, center=true);
        sphere(20);
    }
    cylinder(h=40, r=10);
}


