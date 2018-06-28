//
//  WifiLamp
//  part of Let's make series
//
//  The Cave, 2018
//  https://thecave.cz
//
//  Licensed under MIT License (see LICENSE file for details)
//

$ledHolderOuterDia = 27.1;
$ledHolderInnerDia = 25;
$ledHolderRimThickness = 1.5;
$ledHolderHeight = 15;

$baseThickness = 2;

$nutInsertDia = 11;
$nutDia = 8.1;
$nutThickness = 3;
$nutSides = 6;


module base() {
    difference() {
        cylinder(h=$baseThickness+$ledHolderHeight,d=$ledHolderOuterDia,$fn=100);
        translate([0,0,-1]) cylinder(h=$baseThickness+$ledHolderHeight+2,d=$ledHolderInnerDia,$fn=100);
    }
    cylinder(h=$baseThickness,d=$ledHolderOuterDia+$ledHolderRimThickness*2,$fn=100);
}

module nutInsert() {
    difference() {
        cylinder(d=$nutInsertDia,h=$nutThickness,$fn=100);
        translate([0,0,-1]) cylinder(d=$nutDia,h=$nutThickness+2,$fn=$nutSides);
    }
}

difference() {
    union() {
        base();
        translate([0,0,$baseThickness]) nutInsert();
    }
    translate([0,0,-1]) cylinder(d=4.2,h=$baseThickness+2,$fn=100);
}





