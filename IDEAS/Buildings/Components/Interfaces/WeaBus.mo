within IDEAS.Buildings.Components.Interfaces;
connector WeaBus "Data bus that stores weather data"
  extends Modelica.Icons.SignalBus;
  parameter Integer numSolBus;
  parameter Boolean outputAngles = true "Set to false when linearising only";
  IDEAS.Buildings.Components.Interfaces.SolBus[numSolBus] solBus(each outputAngles=outputAngles) annotation ();
  RealCon Te(start = 293.15) "Ambient sensible temperature" annotation ();
  RealCon Tdes(start=-8 + 273.15) "Design temperature?" annotation ();
  RealCon TGroundDes(start=283.15)
    "Design ground temperature" annotation ();
  RealCon hConExt(unit="W/(m2.K)", start = 18.3) "Exterior convective heat transfer coefficient" annotation ();
  RealCon X_wEnv(start=0.01) "Environment air water mass fraction"
                                annotation ();
  RealCon CEnv(start=1e-6) "Environment air trace substance mass fraction"
                                annotation ();
  RealCon dummy(start=1)
    "Dummy variable of value 1 to include constant term in linearization (see SlabOnGround)"
    annotation ();
  RealCon TskyPow4,TePow4, solGloHor, solDifHor, F1, F2, angZen, angHou, angDec, solDirPer;

  connector RealCon = Real;
  annotation (
    defaultComponentName="weaBus",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This component is an expandable connector that is used to implement a bus that contains the weather data.
</p>
</html>
", revisions="<html>
<ul>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeaBus;
