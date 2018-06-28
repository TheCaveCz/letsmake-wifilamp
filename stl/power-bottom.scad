//
//  WifiLamp
//  part of Let's make series
//
//  The Cave, 2018
//  https://thecave.cz
//
//  Licensed under MIT License (see LICENSE file for details)
//

$innerX = 39;
$innerY = 15;
$outerZ = 12.1;
$wall = 1.6;
$outerDia = 5;
$dentZ = 3;

$powerWidth = 9.5;


module bottomBase() {
    difference() {
        translate([$outerDia/2,$outerDia/2,$outerDia/2]) minkowski() {
            sphere(d=$outerDia,$fn=50);
            cube([$innerX+$wall*2-$outerDia,$innerY+$wall*2-$outerDia,$outerZ+$outerDia*2]);
        }
        translate([$wall,$wall,$wall]) cube([$innerX,$innerY,$outerZ*2]);
        translate([-1,-1,$outerZ-$dentZ]) cube([$innerX*2,$innerY*2,$outerZ*2]);
    }
}

module bottomDent() {
    translate([$outerDia/2,$outerDia/2,$outerZ-$dentZ]) difference() {
        minkowski() {
            cube([$innerX+$wall-($outerDia-$wall),$innerY+$wall-($outerDia-$wall),$dentZ/2]);
            cylinder(d=$outerDia-$wall-0.3,h=$dentZ/2,$fn=50);
        }
        translate([-$outerDia/2+$wall,-$outerDia/2+$wall,-1]) cube([$innerX,$innerY,$dentZ+2]);
    }
}

module bottomSupports() {
    translate([$wall,$wall,$wall]) cube([3, $innerY, 3]);
    translate([$wall+27,$wall,$wall]) cube([4,$innerY,3]);
    translate([$wall+30.5,$wall,$wall]) cube([2,$innerY,4]);
}

module bottom() {
    difference() {
        union() {
            bottomBase();
            bottomDent();
        }
        translate([$innerX+$wall-1,$wall+$innerY/2,$outerZ-$dentZ]) {
            translate([0,-1.5,0]) cube([$wall+2, 3, 100]);
            rotate([0,90,0]) cylinder(d=3,h=$wall+2,$fn=100);
        }
        translate([-1,$wall+($innerY-$powerWidth)/2,$wall+4]) cube([$wall+2,$powerWidth, 100]);
    }
    bottomSupports();
}

bottom();


