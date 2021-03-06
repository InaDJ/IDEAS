within IDEAS.Buildings.Validation.BaseClasses.Structure.BaseClasses;
model Bui "Base model"

  extends IDEAS.Templates.Interfaces.BaseClasses.Structure(
    final nZones=1, final nEmb=0,
    ATrans=1,
    VZones={gF.V});

  IDEAS.Buildings.Components.Zone gF(
    airModel(mSenFac=0.822),
    V=129.6,
    n50=0.822*0.5*20,
    T_start=293.15,
    redeclare package Medium = Medium,
    nSurf=6,
    hZone=2.7)  annotation (Placement(transformation(extent={{40,0},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
    redeclare parameter Data.Constructions.LightWall constructionType,
    A={21.6,16.2,9.6,16.2},
    final azi={IDEAS.Types.Azimuth.N,IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,
        IDEAS.Types.Azimuth.W},
    final inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,
        IDEAS.Types.Tilt.Wall}) annotation (Placement(transformation(
        extent={{-5.5,-9.49999},{5.5,9.49999}},
        rotation=90,
        origin={-49.5,-14.5})));

  IDEAS.Buildings.Components.BoundaryWall floor(
    redeclare parameter Data.Constructions.LightFloor constructionType,
    final A=48,
    inc=IDEAS.Types.Tilt.Floor,
    final azi=IDEAS.Types.Azimuth.S) annotation (Placement(transformation(
        extent={{-5.5,-9.5},{5.5,9.5}},
        rotation=90,
        origin={-19.5,-14.5})));
  IDEAS.Buildings.Components.OuterWall roof(
    redeclare final parameter Data.Constructions.LightRoof constructionType,
    final A=48,
    final inc=IDEAS.Types.Tilt.Ceiling,
    final azi=IDEAS.Types.Azimuth.S) annotation (Placement(transformation(
        extent={{-5.5,-9.5},{5.5,9.5}},
        rotation=90,
        origin={-79.5,-14.5})));

equation
  connect(temperatureSensor.T, TSensor[1]) annotation (Line(
      points={{140,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF.gainCon, temperatureSensor.port) annotation (Line(
      points={{80,14},{100,14},{100,-60},{120,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{80,14},{120,14},{120,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{80,8},{120,8},{120,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(roof.propsBus_a, gF.propsBus[1]) annotation (Line(
      points={{-81.4,-9.91667},{-81.4,31.3333},{40,31.3333}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.propsBus_a, gF.propsBus[2:5]) annotation (Line(
      points={{-51.4,-9.91667},{-51.4,26},{40,26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_a, gF.propsBus[6]) annotation (Line(
      points={{-21.4,-9.91667},{-21.4,24.6667},{40,24.6667}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(port_b[1], gF.port_b) annotation (Line(
      points={{-20,100},{-20,60},{56,60},{56,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(port_a[1], gF.port_a) annotation (Line(
      points={{20,100},{20,62},{64,62},{64,40}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,-100},
            {150,100}}),       graphics), Documentation(info="<html>
<p>
Basic, most generic structure of the BesTest model.
To be extended in other models.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end Bui;
