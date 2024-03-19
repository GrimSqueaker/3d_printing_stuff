// Total Height
Height=20.0;

Rim_Height=2.0;
Rim_Extra_Diameter=2.0;
Rim_Extra_Height=2.0;

Outside_Diameter=27.0;//27.1;
Inside_Diameter=20.4;//20.8;

$fn=200;

union() {
  translate ([0,0,0]) difference() {
    cylinder(d1 = Outside_Diameter, d2 = Outside_Diameter, h = Height);
    translate ([0,0,-.05])
    cylinder(d1 = Inside_Diameter, d2 = Inside_Diameter, h = Height+.1);
  }
  translate ([0,0,Height-Rim_Extra_Height]) difference() {
    cylinder(d1 = Outside_Diameter, d2 = Outside_Diameter, h = Rim_Extra_Height);
    translate ([0,0,-.05])
      cylinder(d1 = Inside_Diameter-Rim_Extra_Diameter, d2 = Inside_Diameter-Rim_Extra_Diameter, h = Rim_Extra_Height+.1);
  }
  translate ([0,0,0]) difference() {
    cylinder(d1 = Outside_Diameter+Rim_Extra_Diameter, d2 = Outside_Diameter+Rim_Extra_Diameter, h = Rim_Extra_Height);
    translate ([0,0,-.05])
    cylinder(d1 = Inside_Diameter, d2 = Inside_Diameter, h = Rim_Extra_Height+.1);
  }
}
