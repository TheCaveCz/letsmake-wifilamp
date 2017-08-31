baseThickness = 1;
baseInnerDia = 132.6;
baseRimWidth = 0.9;
baseRimHeight = 2;

difference() {
    cylinder(h=baseThickness+baseRimHeight,d=baseInnerDia+baseRimWidth*2,$fn=300);
    translate([0,0,baseThickness]) cylinder(h=100,d=baseInnerDia,$fn=300);
}


translate([0,0,baseThickness]) {
    translate([-6.5/2,-baseInnerDia/2,0]) cube([6.5,5,baseRimHeight]);
    
    cylinder(d=3,h=7,$fn=10);
    cylinder(d=6,h=4,$fn=10);
    
    translate([38.1,0,0]) {
        translate([0,9.525,0]) {
            cylinder(d=3,h=7,$fn=10);
            cylinder(d=6,h=4,$fn=10);
        }
        translate([0,-12.7,0]) {
            cylinder(d=3,h=7,$fn=10);
            cylinder(d=6,h=4,$fn=10);
        }
    }
}