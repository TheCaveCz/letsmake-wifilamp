//
//  WifiLamp
//  part of Let's make series
//
//  The Cave, 2018
//  https://thecave.cz
//
//  Licensed under MIT License (see LICENSE file for details)
//

$innerX = 38.9;
$innerY = 14.9;
$outerZ = 9.6;
$wall = 1.6;
$outerDia = 5;
$dentZ = 3.2;

$buttonDia = 9;

$powerWidth = 9.5;
$powerDia = 8.5;


difference() {
    // rounded corner box body
    translate([$outerDia/2,$outerDia/2,$outerDia/2]) minkowski() {
        sphere(d=$outerDia,$fn=50);
        cube([$innerX+$wall*2-$outerDia,$innerY+$wall*2-$outerDia,$outerZ+$outerDia*2]);
    }
    
    // inner box space
    translate([$wall,$wall,$wall]) cube([$innerX,$innerY,$outerZ*4]);
    
    // box cutoff
    translate([-1,-1,$outerZ]) cube([$innerX*2,$innerY*2,$outerZ*4]);
    
    // inner rim
    translate([$wall/2+($outerDia-$wall)/2,$wall/2+($outerDia-$wall)/2,$outerZ-$dentZ]) minkowski() {
        cube([$innerX+$wall-($outerDia-$wall),$innerY+$wall-($outerDia-$wall),$outerZ]);
        cylinder(d=$outerDia-$wall,h=$outerZ,$fn=50);
    }
    
    // button hole
    translate([$wall+$innerX/2,$wall+$innerY/2,-1]) cylinder(d=$buttonDia,h=$wall*2,$fn=100);
    
    // power plug hole
    translate([-1,$wall+($innerY-$powerWidth)/2,$wall]) cube([$wall+2, $powerWidth, 100]);
    
    // cable hole
    translate([$innerX+$wall-1,$wall+$innerY/2,$outerZ]) rotate([0,90,0]) cylinder(d=3,h=$wall+2,$fn=100);
}

difference() {
    translate([3.5, $wall, $wall]) cube([3, $innerY, 4]);
    translate([0, $wall+$innerY/2, $wall+$powerDia/2]) rotate([0, 90, 0]) cylinder(d=$powerDia, h=10, $fn=100);
}

