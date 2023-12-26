include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

// ===== CUSTOMS ===== //

gridz_units = 10;

marker_negative_diameter = 12;
marker_negative_height = 7*(gridz_units-1);
module marker_negative() {
    translate([-42/2 + 12/2 + 3, 0, 7])
        cylinder(h=marker_negative_height, r=marker_negative_diameter/2);
}

tape_negative_width = 25;
tape_negative_height = 7*(gridz_units-1);
module tape_negative() {
    // 5.7 is eyeball'd
    translate([5.7, 0, 7])
        linear_extrude(tape_negative_height)
        // 1.6, the rounded diameter of the rectangle's bevel, is from
        // gridfinity specs https://gridfinity.xyz/specification/
        rounded_square(tape_negative_width, 3*42 - 5.75, 1.6); 
}

module rounded_square(w, h, d) {
    translate([-(w-d)/2, -(h-d)/2])
        hull() {
            circle(d=d);
            translate([w-d, 0]) circle(d=d);
            translate([0, h-d]) circle(d=d);
            translate([w-d, h-d]) circle(d=d);
        }
}

tape_stands_radius = 2.5;
tape_stands_distance = 75;
module tape_stands(side) {
    // side: -1 or +1
    translate([5.7, side*tape_stands_distance/2, 7])
    union() {
        linear_extrude(20)
            square([tape_negative_width, 2*tape_stands_radius], center=true);
        // This difference removes the bottom "semi-circle" cylinder.
        translate([0, 0, 20]) difference() {
            translate([-tape_negative_width/2, 0]) rotate([0, 90])
                linear_extrude(tape_negative_width)
                circle(r=tape_stands_radius);
            translate([0, 0, -tape_stands_radius])
                linear_extrude(tape_stands_radius)
                square(tape_negative_width, center=true);
        }
    }
}

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// number of bases along x-axis
gridx = 1;  
// number of bases along y-axis   
gridy = 3;  
// bin height. See bin height information and "gridz_define" below.  
gridz = gridz_units;
// base unit
length = 42;

/* [Compartments] */
// number of X Divisions
divx = 0;
// number of y Divisions
divy = 0;

/* [Toggles] */
// internal fillet for easy part removal
enable_scoop = true;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// enable upper lip for stacking other bins
enable_lip = true;

/* [Other] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments -
                  // Zack's method,1:gridz is the internal height in
                  // millimeters, 2:gridz is the overall external height of the
                  // bin in millimeters]
// the type of tabs
style_tab = 1; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]

// overrides internal block height of bin (for solid containers). Leave zero
//  for default height. Units: mm
height_internal = 0; 

/* [Base] */
style_hole = 3; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes -
                // no printable slit, 3: magnet and screw holes - printable slit]
// number of divisions per 1 unit of base along the X axis. (default 1, only use
//  integers. 0 means automatically guess the right division)
div_base_x = 0;
// number of divisions per 1 unit of base along the Y axis. (default 1, only use
// integers. 0 means automatically guess the right division)
div_base_y = 0; 

// ===== IMPLEMENTATION ===== //

module main() {
    union() {
        difference() {
            union() {
                gridfinityInit(
                    gridx, gridy,
                    height(gridz, gridz_define, enable_lip, enable_zsnap),
                    height_internal, length) {}
                gridfinityBase(
                    gridx, gridy, length, div_base_x, div_base_y, style_hole); }
            marker_negative();
            tape_negative();
        }
        tape_stands(1);
        tape_stands(-1);
    }
}

main();
