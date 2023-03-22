include <Round-Anything/polyround.scad>

// Enclosure width
width = 50;
// Enclosure height
height = 50;
// Enclosure depth
depth = 37;
// Enclosure wall hhickness
wallThickness = 3;
// Enclosure corner fillet radius
cornerRadius = 6;
// OD of internal mounting posts for module
postOD = 5;
// ID of internal mounting posts for module
postID = 1.3;
// Height of internal mounting posts
postHeight = 18;
// Square pattern spacing of internal mounting posts
postSpacing = 34;
// Size of the hole the lens pokes through
apertureDiameter = 20;
// OD of the protrusion ("snoot") on front of the housing
snootOD = 30;
// ID of snoot protrusion
snootID = 25;
// Length of the snoot
snootLength = 5;
// Diameter of the tripod mounting stud hole
studHoleDiameter = 5.8;

hps = postSpacing / 2;
posts = [[hps, hps], [hps, -hps], [-hps, -hps], [-hps, hps]];

dimX = width/2;
dimY = height/2;
dimZ = depth;

intDimX = dimX - wallThickness;
intDimY = dimY - wallThickness;
intCornerRadius = cornerRadius - wallThickness;
$fn = 100;
difference() {
    union() {
        difference() {
            // Extrude the housing
            linear_extrude(dimZ) {
                polygon(polyRound([
                  [dimX, dimY, cornerRadius],
                  [dimX, -dimY, cornerRadius],
                  [-dimX, -dimY, cornerRadius],
                  [-dimX, dimY, cornerRadius]
                ],10));
            };
            
            // Cut the interal volume
            translate([0, 0, wallThickness]) {
                linear_extrude(dimZ-wallThickness+1) {
                    polygon(polyRound([
                      [intDimX, intDimY, intCornerRadius],
                      [intDimX, -intDimY, intCornerRadius],
                      [-intDimX, -intDimY, intCornerRadius],
                      [-intDimX, intDimY, intCornerRadius]
                    ],10));
                };
            }; 
        };

        for(post = posts) {
            echo(post);
            translate([post[0], post[1], wallThickness]) {
                difference() {
                    union() {
                        cylinder(postHeight, d = postOD);
                        cylinder(postHeight/3, d1 = postOD * 1.5, d2 = postOD);
                    };
                    cylinder(postHeight+1, d=postID);
                };
            };
        };

        // Cover screw mounting ears
        translate([-intDimX, 0, dimZ-5]) { 
                cylinder(5, d=wallThickness*1.99);
        };
        translate([intDimX, 0, dimZ-5]) { 
            cylinder(5, d=wallThickness*1.99);
        };
        // Snoot
        difference() {
            translate([0, 0, -snootLength])
                cylinder(snootLength, d=snootOD);
            translate([0, 0, -snootLength-1])
            cylinder(snootLength, d=snootID);
        };
        // Tripod Mount
        translate([0, -dimY, dimZ/2]) {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(h=6, d1=20, d2=14);
                    cylinder(h=15, d=studHoleDiameter);
                }
            }
        }
    };
    // Cover screw holes
    translate([-intDimX, 0, dimZ-5]) { 
        cylinder(6, d=2.8);
    };
    translate([intDimX, 0, dimZ-5]) { 
        cylinder(6, d=2.8);
    };    
    // Cut the aperture hole
    translate([0, 0, -wallThickness]) {
        cylinder(wallThickness*2.1, d=apertureDiameter);
    };       
};

// Cover
translate([0, 0, dimZ + 10]) {
    difference() {
        union() {    
            difference() {
                linear_extrude(3) {
                    polygon(polyRound([
                      [dimX, dimY, cornerRadius],
                      [dimX, -dimY, cornerRadius],
                      [-dimX, -dimY, cornerRadius],
                      [-dimX, dimY, cornerRadius]
                    ],10));
                };
                
                // cover screw holes
                translate([-intDimX, 0, 0]) {
                    cylinder(5, d=3.5);   
                };
                translate([intDimX, 0, 0]) {
                    cylinder(5, d=3.5);   
                };
                translate([intDimX, 0, 2]) {
                    cylinder(5, d=5.5);   
                };
                translate([-intDimX, 0, 2]) {
                    cylinder(5, d=5.5);   
                };           
            };
            translate([0,0,-2]) {
                difference() {
                     linear_extrude(2) {
                        polygon(polyRound([
                          [intDimX-0.25, intDimY-0.25, intCornerRadius],
                          [intDimX-0.25, -intDimY+0.25, intCornerRadius],
                          [-intDimX+0.25, -intDimY+0.25, intCornerRadius],
                          [-intDimX+0.25, intDimY-0.25, intCornerRadius]
                        ],10));
                    };
                    translate([-intDimX, 0, -3]) { 
                        cylinder(5, d=wallThickness*3);
                    };
                    translate([intDimX, 0, -3]) { 
                        cylinder(5, d=wallThickness*3);
                    };            
                };
            };
        };
        translate([0, -intDimY+wallThickness, -3]) {
            union() {
                cylinder(15, d=5);
                translate([0, -5, 0]) {
                    cube([5, 10, 15], center=true);
                };
            };
        };
    };
};

