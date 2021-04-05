$fn=20;

/*[Global]*/
    //Axis=[r]
    AxisRadius = [4];
    //Slider Hole [radius]
    SliderHoleRadius = [4];
    //M3 Screw Thread Clearance Radius
    M3ScrewHole = [1.5];
    //Z Axis Guide to Z Screw 
    ZA2ZSSeparation = [25];

/*[Z Screw Holder Block]*/
    //Z Screw Holder Block = [OuterRadius, InnerRadius, Height]
    ZSH = [10, 5, 10];
    ZSHM3Separation = [10];

/*[Z Axis Holder Block]*/
    //Z Axis Holder = [w or external diameter,displacement of center of hole]
    ZAH = [15,ZSH[1]];
    //Z Axis Cutout to Slider Hole = [w]
    ZAHCutout = [10];
    numberOfTeeth = 20;
    toothWidth = .7;
    toothDepth = 2;


/*[X Axis Holder Block]*/
    //X Axis Holder = [w,d,h]
    XAH = [ZA2ZSSeparation[0] + ZAH[0]/2 + ZSH[0]/2, 20, 60];
    //X Axis Hole depth and position from the bottom of the Holder block
    XAxisHoleDepth = [25];
    XAxisHoleSeparation = [40];
    XAxisHole1Height = XAH[2]/2+XAxisHoleSeparation[0]/2;
    XAxisHole2Height = XAH[2]/2-XAxisHoleSeparation[0]/2;

/*[X Pulley Hole]*/
    pulleyAxleHoleDepth = 20;
    pulleyAxleClearanceRadius = 2;
    pulleyFullHoleDepth = XAH[0]-3;
    pulleyFullHoleWidth = 17;
    pulleyFullHoleHeight = 17;


module XAxisHole() {
           rotate([0, -90, 0])
                cylinder(r=AxisRadius[0], h=XAxisHoleDepth[0]);

}

module XPulleyHole(){
    union() {
        //pulley Axle Hole
        translate([-pulleyAxleHoleDepth+XAH[0]/2, 0, pulleyFullHoleHeight/2-pulleyAxleClearanceRadius/2])
            cube([pulleyAxleHoleDepth, XAH[1], pulleyAxleClearanceRadius]);
        //rest of the pulley hole
        translate([-pulleyFullHoleDepth+XAH[0]/2, (XAH[1]-pulleyFullHoleWidth)/2, 0])
            cube([pulleyFullHoleDepth, pulleyFullHoleWidth, pulleyFullHoleHeight]);
    }
}

module XPulleyTightenerHole() {
    rotate([0, 90, 0])
        cylinder(r=M3ScrewHole, h=5);
}

module XAxisHolder() {
    //X Axis Holder Block
    difference() {
        //X Axis Holder Raw Block
#        translate(-[XAH[0]/2, XAH[1]/2, 0])  cube([XAH[0], XAH[1], XAH[2]]);

        //X Axis Support Hole 1
        translate([XAH[0]/2, 0, XAxisHole1Height]) XAxisHole();
 
        //X Axis Support Hole 2
        translate([XAH[0]/2, 0, XAxisHole2Height]) XAxisHole();

        //X Pulley Hole
        translate([0, -XAH[1]/2 ,(XAH[2]-pulleyFullHoleHeight)/2]) XPulleyHole();

        //X Pulley Tightener Hole
        translate([-XAH[0]/2, 0, XAH[2]/2]) XPulleyTightenerHole();

    }
}


module tooth() {
    translate([-toothDepth/2,-toothWidth/2,0]) 
        cube([toothDepth,toothWidth,XAH[2]]);
    
}

module ZAxisHolder() {
    difference() {
        union() {
            //support part
            cube([ZAH[0],ZSH[0],XAH[2]]);
            translate([ZAH[0]/2,ZSH[0],0])
                cylinder(r=ZAH[0]/2,h=XAH[2]);
        }

            translate([ZAH[0]/2,ZSH[0],0])
        union(){
            cylinder(r=SliderHoleRadius[0], h=XAH[2]);

            for(i=[0:numberOfTeeth]) //n is number of teeth
                rotate([0,0,i*360/numberOfTeeth])
                    translate([SliderHoleRadius[0],0,0]) // r is radius of circle
                        tooth(); // tooth is the module that describes the shape of the tooth.
        }
    }
}

module ZScrewHolder() {
    //Z Screw Holder Main Block
    difference() {
        union() {
            translate([-ZSH[0],0,0]) cube([ZSH[0]*2,ZSH[0],ZSH[2]]);
            translate([0,ZSH[0],0]) cylinder(r=ZSH[0], h=ZSH[2]);
        }
        //Z Screw Holder centre hole
        translate([0,ZSH[0],0]) cylinder(r=ZSH[1], h=ZSH[2]);
        //Z Screw Holder M3 Throughholes
        translate([-ZSHM3Separation[0]/2, ZSH[0]+ZSHM3Separation[0]/2,0]) cylinder(r=M3ScrewHole[0], h=ZSH[2]);
        translate([-ZSHM3Separation[0]/2, ZSH[0]-ZSHM3Separation[0]/2,0]) cylinder(r=M3ScrewHole[0], h=ZSH[2]);
        translate([ZSHM3Separation[0]/2, ZSH[0]+ZSHM3Separation[0]/2,0]) cylinder(r=M3ScrewHole[0], h=ZSH[2]);
        translate([ZSHM3Separation[0]/2, ZSH[0]-ZSHM3Separation[0]/2,0]) cylinder(r=M3ScrewHole[0], h=ZSH[2]);

    }
    
}

//Z Axis Holder Left Construction
module main() {
    translate([-XAH[0]/2, XAH[1]/2, 0]) 
        ZAxisHolder();
    translate([XAH[0]/2-ZSH[0],  XAH[1]/2,  XAH[2]-ZSH[2]]) 
        ZScrewHolder();
    XAxisHolder();
}

main();
//XPulleyHole();
//        translate([0, -XAH[1]/2 ,(XAH[2]-pulleyFullHoleHeight)/2]) XPulleyHole();

/* unused */

   /*    #linear_extrude(XAH[2])
            polygon([
                [-XAH[0]/2,-XAH[1]/2],
                [XAH[0]/2,-XAH[1]/2],
                [XAH[0]/2,XAH[1]/2],
                [-XAH[0]/2,XAH[1]/2]]
            );*/
 
module ZAxisHolder1() {
    difference() {
        //Z Axis Holder Raw Block
        translate([-ZAH[0]/2,0,0])
            cube([ZAH[0], ZAH[1], XAH[2]]);
        //Z Axis Slider holder
        translate([0, SliderHoleRadius[0], 0])
            cylinder(r=SliderHoleRadius[0], h=XAH[2]);
        // Z Axis Holder cutout to Slider holder
        translate([-ZAHCutout[0]/2,SliderHoleRadius[0],0])
            cube([ZAHCutout[0],ZAH[1]-SliderHoleRadius[0], XAH[2]]);
    }
}

