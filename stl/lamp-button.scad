difference() {
    union() {
        cylinder(d=19,$fn=100,h=1);
        cylinder(d=16,$fn=100,h=1+10);
    }
    translate([0,0,-1]) cylinder(d=12.3,$fn=100,h=15);
    translate([0,0,3]) cylinder(d=13.5,$fn=100,h=15);
    translate([-2.5,-10,3]) cube([5,20,10]);
    translate([-10,-2.5,3]) cube([20,5,10]);    
}

translate([20,0,0]) difference() {
    cylinder(d=16+0.8*2,$fn=100,h=5);
    translate([0,0,0.6]) cylinder(d=15.8,$fn=100,h=5);
    translate([0,0,-1]) cylinder(d=16-1.2-1.2,$fn=100,h=8);
    translate([-3.5,-6.75,-1]) cube([7,13.5,4]);
}