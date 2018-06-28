//
//  WifiLamp
//  part of Let's make series
//
//  The Cave, 2018
//  https://thecave.cz
//
//  Licensed under MIT License (see LICENSE file for details)
//

$dia = 8;
$rimDia = 9.5;
$holeHeight=0.6;
$rimHeight = $holeHeight+4.4;
$buttonHeight = $rimHeight+4;

difference() {
    union() {
        cylinder(d=$rimDia,h=$rimHeight,$fn=100);
        intersection() {
            cylinder(d=$dia,h=$buttonHeight,$fn=100);
            translate([0,0,1]) sphere(d=15,$fn=100);
        }
    }
    translate([0,0,-1]) cylinder(d=4,h=1 + $holeHeight, $fn=100);
}

