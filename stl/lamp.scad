$ledHolderDia = 27.1;
$ledHolderOuterWall = 1.5;
$ledHolderOuterDia = $ledHolderDia+$ledHolderOuterWall*2;
$ledHolderHeight = 15;
$ledHolderRimHeight = 3;
$ledHolderInnerDia = 25;
$dcDia = 8;
$baseDia = 120;
$baseCutSize = 50;
$baseThickness = 1;
$nutDia = 6.4;
$nutThickness = 2.4;
$nutSides = 6;
$springDia = 8;
$springOuterDia = 10;
$springHeight = 5;
$cableDia = 3.5;


module baseLedHolder() {
    intersection() {
        difference() {
            union() {
                cylinder(h=$baseThickness,d=$baseDia,$fn=100);
                cylinder(h=$baseThickness+$ledHolderHeight,d=$ledHolderDia,$fn=100);
                cylinder(h=$baseThickness+$ledHolderRimHeight,d=$ledHolderOuterDia,$fn=100);
            }
            translate([0,0,-1]) cylinder(h=$baseThickness+$ledHolderHeight+2,d=$ledHolderInnerDia,$fn=100);
        }
        translate([-$baseCutSize/2,-$baseDia/2,0]) cube([$baseCutSize,$baseDia,100]);
    }
}

module springInsert() {
    difference() {
        cylinder(d=$springOuterDia,h=$springHeight+$nutThickness,$fn=100);
        translate([0,0,$nutThickness]) cylinder(d=$springDia,h=$springHeight+2,$fn=100);
        translate([0,0,-1]) cylinder(d=$nutDia,h=$nutThickness+2,$fn=$nutSides);
    }
}

module touchHolder() {
    translate([5,10,0]) cylinder(d=1.5,h=2,$fn=50);
    translate([5,-10,0]) cylinder(d=1.5,h=2,$fn=50);
    translate([-15,10,0]) cylinder(d=1.5,h=2,$fn=50);
    translate([-15,-10,0]) cylinder(d=1.5,h=2,$fn=50);
    %cylinder(h=1,d=11.5,$fn=100);
}

module cableClamp() {
    translate([-3,-2-$cableDia/2,0]) {
        cube([6,2,$cableDia]);
        translate([0,2+$cableDia,0]) cube([6,2,$cableDia]);
        %translate([1.5,-$cableDia-2,0]) cube([3,2,1]);
        %translate([1.5,$cableDia*2+4,0]) cube([3,2,1]);
    }
}

module boardHolder() {
    
    module boardStand() {
        cylinder(d=6,h=3,$fn=100);
        cylinder(d=3,h=6,$fn=100);
    }

    translate([17.145,-7.62]) boardStand();
    translate([17.145,7.62]) boardStand();
    translate([-17.145,0]) boardStand();
}

module everything() {
    $touchYoffset = -($baseDia-$springOuterDia*2-$ledHolderOuterDia)/4-$ledHolderOuterDia/2;
    $clampXoffset = ($baseCutSize-$ledHolderOuterDia)/3+$ledHolderOuterDia/2;
    difference() {
        union() {
            baseLedHolder();
            translate([0,($baseDia-$springOuterDia)/2,$baseThickness]) springInsert();
            translate([0,-($baseDia-$springOuterDia)/2,$baseThickness]) springInsert();
            translate([0,$touchYoffset,$baseThickness]) touchHolder();
            translate([$clampXoffset,0,$baseThickness]) cableClamp();
            translate([0,-$touchYoffset,$baseThickness]) boardHolder();
            
        }
        translate([0,($baseDia-$springOuterDia)/2,-1]) cylinder(d=3.5,h=$baseThickness+2,$fn=100);
        translate([0,-($baseDia-$springOuterDia)/2,-1]) cylinder(d=3.5,h=$baseThickness+2,$fn=100);
        
        translate([-14.5,$touchYoffset-4,-1]) cube([2,8,5]);
        translate([0,$touchYoffset,-1]) cylinder(h=1.4,d=11.5,$fn=100);
        translate([$clampXoffset-1.5,-$cableDia*1.5-4,-1]) cube([3,2,$baseThickness+2]);
        translate([$clampXoffset-1.5,+$cableDia*1.5+2,-1]) cube([3,2,$baseThickness+2]);
    }
}

everything();







