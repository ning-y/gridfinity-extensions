include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

// ===== CUSTOMS ===== //

gluestick_diameter = 20;
gluestick_height = 105;
gluestick_tolerance = .6;
finger_indent_diamter = 10;

module gluestick(diameter, height, tolerance) {
    translate([
            0, (height+2*gluestick_tolerance)/2, 
            (diameter+2*gluestick_tolerance)/2])
        rotate([90, 0])
    cylinder(
        h=height+2*gluestick_tolerance,
        d=diameter+2*gluestick_tolerance);
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
gridz = ceil(2*(gluestick_diameter)/7)+ 1;   
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

difference() {
    union() {
        gridfinityInit(
            gridx, gridy, height(gridz, gridz_define, enable_lip, enable_zsnap),
            height_internal, length) {}
        gridfinityBase(
            gridx, gridy, length, div_base_x, div_base_y, style_hole); }

    hull() {
        translate([0, 0,
                   h_base+height(gridz, gridz_define, enable_lip, enable_zsnap)-
                   2*gluestick_diameter])
            gluestick(gluestick_diameter, gluestick_height, gluestick_tolerance);
        translate([0, 0,
                   h_base+height(gridz, gridz_define, enable_lip, enable_zsnap)])
            gluestick(gluestick_diameter, gluestick_height, gluestick_tolerance);}

    translate([
            0, (gluestick_height+2*gluestick_tolerance)/2,
                h_base+height(gridz, gridz_define, enable_lip, enable_zsnap)])
        sphere(d=finger_indent_diamter);}
