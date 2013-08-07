within IDEAS.Buildings.Components;
model SlabOnGround "opaque floor on ground slab"

  extends IDEAS.Buildings.Components.Interfaces.StateWall;

  replaceable parameter Data.Interfaces.Construction constructionType(
      insulationType=insulationType, insulationTickness=insulationThickness)
    "Type of building construction" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-38,72},{-34,76}})),
    Dialog(group="Construction details"));
  replaceable parameter Data.Interfaces.Insulation insulationType(d=
        insulationThickness) "Type of thermal insulation" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-38,84},{-34,88}})),
    Dialog(group="Construction details"));
  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));
  parameter Modelica.SIunits.Area AWall "Total wall area";
  parameter Modelica.SIunits.Area PWall "Total wall perimeter";
  parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90� denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0� denotes South";

  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/25)
    "Wall U-value";
  final parameter Modelica.SIunits.Power QNom=U_value*AWall*(273.15 + 21 - sim.city.TdesGround)
    "Design heat losses at reference outdoor temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  final parameter IDEAS.Buildings.Data.Materials.Ground ground1(d=0.50);
  final parameter IDEAS.Buildings.Data.Materials.Ground ground2(d=0.33);
  final parameter IDEAS.Buildings.Data.Materials.Ground ground3(d=0.17);

  Modelica.SIunits.HeatFlowRate Qm=U*AWall*(22 - 9) - Lpi*4*cos(2*3.1415/12*(m
       - 1 + alfa)) + Lpe*9*cos(2*3.1415/12*(m - 1 - beta));

  Modelica.SIunits.Length B=AWall/(0.5*PWall)
    "Characteristic dimension of the slab on ground";
  Modelica.SIunits.Length dt=sum(constructionType.mats.d) + ground1.k*layMul.R
    "Equivalent thickness";
  Real U=ground1.k/(0.457*B + dt);
  Real alfa=1.5 - 12/(2*3.14)*atan(dt/(dt + delta));
  Real beta=1.5 - 0.42*log(delta/(dt + 1));
  Real delta=sqrt(3.15*10^7*ground1.k/3.14/ground1.rho/ground1.c);
  Real Lpi=AWall*ground1.k/dt*sqrt(1/((1 + delta/dt)^2 + 1));
  Real Lpe=0.37*PWall*ground1.k*log(delta/dt + 1);
  Real m=12*time/31536000;

  //protected
public
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats,
    locGain=constructionType.locGain)
    "Declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon(A=AWall, inc=
       inc)
    "Convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layGro(
    A=AWall,
    inc=inc,
    nLay=3,
    mats={ground1,ground2,ground3},
    locGain=1)
    "Declaration of array of resistances and capacitances for ground simulation"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  //    nMat(T(start={{273.15},{273.15},{273.15}} + {{11.5},{12.2},{12.7}})))

public
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow periodicFlow(T_ref=
        284.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-8})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=0,
      T_ref=284.15)
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
equation
  periodicFlow.Q_flow = Qm;

  connect(layMul.port_b, intCon.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layGro.port_b, layMul.port_a) annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{16,-26},{16,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.port_gain, port_emb) annotation (Line(
      points={{0,-40},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, periodicFlow.port) annotation (Line(
      points={{-10,-30},{-14,-30},{-14,-8},{-20,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, layGro.port_a) annotation (Line(
      points={{-50,-30},{-40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
        graphics={
        Rectangle(
          extent={{-50,-90},{50,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{-30,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{-50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-70},{50,-70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>SlabOnGround.mo</code> model describes the transient behaviour of a builiding envelope constructions separating a thermal zone with ground massive. The description of the thermal response of a wall is structured as in the 3 different occurring processes, i.e. the heat balance of the outer surface, heat conduction between both surfaces and the heat balance of the interior surface.</p>
<p><h5>Description</h5></p>
<p>For the purpose of dynamic building simulation, the partial differential equation of the continuous time and space model of heat transport through a solid is most often simplified into ordinary differential equations with a finite number of parameters representing only one-dimensional heat transport through a construction layer. Within this context, the wall is modeled with lumped elements, i.e. a model where temperatures and heat fluxes are determined from a system composed of a sequence of discrete resistances and capacitances R_{n+1}, C_{n}. The number of capacitive elements $n$ used in modeling the transient thermal response of the wall denotes the order of the lumped capacitance model.</p>
<p>The heat balance of the outer surface in contact to the ground is approximated based on <a href=\"IDEAS.Buildings.UsersGuide.References\">[ISO 13370]</a> based on a steady-state and periodic coupling coefficient. </p>
<p>The heat balance of the interior surface is determined as Q_{net} = Q_{c} + Sum(Q_{SW,i}) + Sum(Q_{LW,i}) where Q_{net} denotes the heat flow into the wall, Q_{c} denotes heat transfer by convection, Q_{SW,i} denotes short-wave absorption of direct and diffuse solar light netering the interior zone through windows and Q_{LW,i} denotes long-wave heat exchange with the surounding interior surfaces. </p>
<p>The surface heat resistances <img src=\"modelica://IDEAS/Images/equations/equation-mp9YB9Y0.png\"/> for the exterior and interior surface respectively are determined as 1/R_{s} = A.h_{c} where A is the surface area and where h_ {c} is the exterior and interior convective heat transfer coefficient. The interior natural convective heat transfer coefficient h_{c,i} <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as h_{c,i} = n1.D^{n2}.(T_{a}-T_{s})^{n3} where D is the characteristic length of the surface, T_{a} is the indoor air temperature and n are correlation coefficients. These parameters {n1, n2, n3} are identical to {1.823,-0.121,0.293} for vertical surfaces <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. </p>
<p>Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[Buchberg 1955, Oppenheim 1956]</a>. The resulting heat exchange by longwave radiation between two surface s_{i} and s_{j} can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sj}^{4})/((1-e_{si})/e_{si} + 1/F_{si,sj} + A_{si}/sum(A_{si}) ) as derived from the Stefan-Boltzmann law wherefore e_{si} and e_{sj} are the emissivity of surfaces s_{i} and s_{j} respectively, F_{si,sj} is radiant-interchange configuration factor <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a> between surfaces s_{i} and s_{j} , A_{i} and A_{j} are the areas of surfaces s_{i} and s_{j} respectively, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and R_{i} and T_{j} are the surface temperature of surfaces s_{i} and s_{j} respectively. The above description of longwave radiation for a room or thermal zone results in the necessity of a very detailed input, i.e. the configuration between all surfaces needs to be described by their shape, position and orientation in order to define F_{si,sj}, and difficulties to introduce windows and internal gains in the zone of interest. Simplification is achieved by means of a delta-star transformation <a href=\"IDEAS.Buildings.UsersGuide.References\">[Kenelly 1899]</a> and by definition of a (fictive) radiant star node in the zone model. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. The heat exchange by longwave radiation between surface <img src=\"modelica://IDEAS/Images/equations/equation-Mjd7rCtc.png\"/> and the radiant star node in the zone model can be described as Q_{si,sj} = sigma.A_{si}.(T_{si}^{4}-T_{sr}^{4})/((1-e_{si})/e_{si} + A_{si}/sum(A_{si}) ) = sigma where e_{si} is the emissivity of surface s_{i}, A_{si} is the area of surface s_{i}, sum(A_{si}) is the sum of areas for all surfaces s_{i} of the thermal zone, sigma is the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a> and T_{si} and T_{sr} are the temperatures of surfaces <img src=\"modelica://IDEAS/Images/equations/equation-olgnuMEg.png\"/> and the radiant star node respectively. Absorption of shortwave solar radiation on the interior surface is handled equally as for the outside surface. Determination of the receiving solar radiation on the interior surface after passing through windows is dealt with in the zone model.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>"));
end SlabOnGround;
