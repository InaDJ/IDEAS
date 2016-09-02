within IDEAS.Buildings.Components.Interfaces;
connector SolBus
  "Bus containing solar radiation for various incidence angles"
  extends Modelica.Icons.SignalBus;
  parameter Boolean outputAngles = true "Set to false when linearising only";

  RealCon iSolDir(start=100) annotation ();
  RealCon iSolDif(start=100) annotation ();
  RealCon angInc if outputAngles;
  RealCon angZen if outputAngles annotation ();
  RealCon angAzi if outputAngles;
  RealCon Tenv(start=293.15) annotation ();

  connector RealCon = Real;

end SolBus;
