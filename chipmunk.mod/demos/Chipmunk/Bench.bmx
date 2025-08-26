
SuperStrict

' Import required modules
Framework brl.d3d9max2d
'Framework brl.glmax2d
'Import brl.StandardIO
'Import brl.Max2D
'Import brl.random
'Import brl.math
'Import brl.Color

' Import Chipmunk library
Import hot.chipmunk

Import "ChipmunkDemo.bmx"

?Not ios
ENABLE_HASTY = 0
?

Function MakeHastySpace:CPSpace()
    space = New CPSpace.Create()
    space.SetThreads(0)
    Return space
End Function
   
Function BENCH_SPACE_NEW:CPSpace()
	If ENABLE_HASTY
		Return MakeHastySpace()
	Else
		Return New CPSpace.Create()
	EndIf
End Function

Function BENCH_SPACE_FREE(space:CPSpace)
	space.Free
End Function

Function BENCH_SPACE_STEP(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Const bevel:Double = 1.0

Global simple_terrain_verts:CPVect[] = [ ..
    Vec2(350.00, 425.07), Vec2(336.00, 436.55), Vec2(272.00, 435.39), Vec2(258.00, 427.63), Vec2(225.28, 420.00), Vec2(202.82, 396.00),  ..
    Vec2(191.81, 388.00), Vec2(189.00, 381.89), Vec2(173.00, 380.39), Vec2(162.59, 368.00), Vec2(150.47, 319.00), Vec2(128.00, 311.55),  ..
    Vec2(119.14, 286.00), Vec2(126.84, 263.00), Vec2(120.56, 227.00), Vec2(141.14, 178.00), Vec2(137.52, 162.00), Vec2(146.51, 142.00),  ..
    Vec2(156.23, 136.00), Vec2(158.00, 118.27), Vec2(170.00, 100.77), Vec2(208.43, 84.00), Vec2(224.00, 69.65), Vec2(249.30, 68.00),  ..
    Vec2(257.00, 54.77), Vec2(363.00, 45.94), Vec2(374.15, 54.00), Vec2(386.00, 69.60), Vec2(413.00, 70.73), Vec2(456.00, 84.89),  ..
    Vec2(468.09, 99.00), Vec2(467.09, 123.00), Vec2(464.92, 135.00), Vec2(469.00, 141.03), Vec2(497.00, 148.67), Vec2(513.85, 180.00),  ..
    Vec2(509.56, 223.00), Vec2(523.51, 247.00), Vec2(523.00, 277.00), Vec2(497.79, 311.00), Vec2(478.67, 348.00), Vec2(467.90, 360.00),  ..
    Vec2(456.76, 382.00), Vec2(432.95, 389.00), Vec2(417.00, 411.32), Vec2(373.00, 433.19), Vec2(361.00, 430.02), Vec2(350.00, 425.07) ..
]

Global simple_terrain_count:Int = simple_terrain_verts.Length

'	Local bodies:CPBody[1000]
'	Local circles:CPCircleShape[1000]

Function AddCircle(space:CPSpace, Index:Int, radius:Double)
    Local mass:Double = radius * radius / 25.0
    Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
'	Local body:CPBody = New CPBody.init(bodies[i], mass, MomentForCircle(mass, 0.0, radius, CPVZero))
	space.AddBody(body)
    body.SetPosition(frand_unit_circle().Mult(180.0))
    
    Local shape:CPShape = New CPCircleShape.Create(body, radius, CPVZero)
'	Local shape:CPShape = New CPCircleShape.init(circles[i], body, radius, CPVZero)
	space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.9)
End Function

Function AddBox(space:CPSpace, Index:Int, Size:Double)
    Local mass:Double = Size * Size / 100.0
    Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Size, Size))
'	Local body:CPBody = New CPBody.init(bodies[i], mass, MomentForBox(mass, Size, Size))
	space.AddBody(body)
    Body.SetPosition(frand_unit_circle().Mult(180.0))
    
    Local shape:CPPolyShape = New cpBoxShape.Create(body, Size - bevel * 2, Size - bevel * 2, 0.0)
	space.AddShape(shape)
    cpPolyShapeSetRadius(shape.cpObjectPtr, bevel)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.9)
End Function

Function AddHexagon(space:CPSpace, Index:Int, radius:Double)
    Local hexagon:CPVect[6]
    For Local i:Int = 0 Until 6
        Local angle:Double = -CP_PI * 2.0 * i / 6.0
        hexagon[i] = Vec2(Cos(angle), Sin(angle)).Mult(radius - bevel)
    Next
    
    Local mass:Double = radius * radius
    Local body:CPBody = New CPBody.Create(mass, MomentForPoly(mass, hexagon, CPVZero, 0.0))
	space.AddBody(body)
    Body.SetPosition(frand_unit_circle().Mult(180.0))
    
    Local shape:CPShape = New CPPolyShape.Create(body, hexagon, CPVZero, bevel)
	space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.9)
End Function


Function SetupSpace_simpleTerrain:cpSpace()
    space = BENCH_SPACE_NEW()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, -100))
    space.SetCollisionSlop(0.5)
    
    Local offset:CPVect = Vec2(-320, -240)
    For Local i:Int = 0 Until simple_terrain_count - 1
        Local a:cpVect = simple_terrain_verts[i]
        Local b:cpVect = simple_terrain_verts[i + 1]
        space.AddShape(New CPSegmentShape.Create(space.GetStaticBody(), a.Add(offset), b.Add(offset), 0.0))
    Next
    
    Return space
End Function

'/ / SimpleTerrain constant sized Objects
Function init_SimpleTerrainCircles_1000:CPSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 1000
        AddCircle(space, i, 5.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainCircles_500:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 500
        AddCircle(space, i, 5.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainCircles_100:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 100
        AddCircle(space, i, 5.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainBoxes_1000:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 1000
        AddBox(space, i, 10.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainBoxes_500:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 500
        AddBox(space, i, 10.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainBoxes_100:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 100
        AddBox(space, i, 10.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainHexagons_1000:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 1000
        AddHexagon(space, i, 5.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainHexagons_500:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 500
        AddHexagon(space, i, 5.0)
    Next
    
    Return space
End Function

Function init_SimpleTerrainHexagons_100:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 100
        AddHexagon(space, i, 5.0)
    Next
    
    Return space
End Function


'/ / SimpleTerrain variable sized Objects
Function rand_size:Double()
    Return 1.5 ^ Lerp(-1.5, 3.5, frand())
End Function

Function init_SimpleTerrainVCircles_200:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 200
        AddCircle(space, i, 5.0 * rand_size())
    Next
    
    Return space
End Function

Function init_SimpleTerrainVBoxes_200:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 200
        AddBox(space, i, 8.0 * rand_size())
    Next
    
    Return space
End Function

Function init_SimpleTerrainVHexagons_200:cpSpace()
    space = SetupSpace_simpleTerrain()
    For Local i:Int = 0 Until 200
        AddHexagon(space, i, 5.0 * rand_size())
    Next
    
    Return space
End Function


' ComplexTerrain
Global complex_terrain_verts:CPVect[] = [ ..
    Vec2(46.78, 479.00), Vec2(35.00, 475.63), Vec2(27.52, 469.00), Vec2(23.52, 455.00), Vec2(23.78, 441.00), Vec2(28.41, 428.00), Vec2(49.61, 394.00), Vec2(59.00, 381.56), Vec2(80.00, 366.03), Vec2(81.46, 358.00), Vec2(86.31, 350.00), Vec2(77.74, 320.00),  ..
    Vec2(70.26, 278.00), Vec2(67.51, 270.00), Vec2(58.86, 260.00), Vec2(57.19, 247.00), Vec2(38.00, 235.60), Vec2(25.76, 221.00), Vec2(24.58, 209.00), Vec2(27.63, 202.00), Vec2(31.28, 198.00), Vec2(40.00, 193.72), Vec2(48.00, 193.73), Vec2(55.00, 196.70),  ..
    Vec2(62.10, 204.00), Vec2(71.00, 209.04), Vec2(79.00, 206.55), Vec2(88.00, 206.81), Vec2(95.88, 211.00), Vec2(103.00, 220.49), Vec2(131.00, 220.51), Vec2(137.00, 222.66), Vec2(143.08, 228.00), Vec2(146.22, 234.00), Vec2(147.08, 241.00), Vec2(145.45, 248.00),  ..
    Vec2(142.31, 253.00), Vec2(132.00, 259.30), Vec2(115.00, 259.70), Vec2(109.28, 270.00), Vec2(112.91, 296.00), Vec2(119.69, 324.00), Vec2(129.00, 336.26), Vec2(141.00, 337.59), Vec2(153.00, 331.57), Vec2(175.00, 325.74), Vec2(188.00, 325.19), Vec2(235.00, 317.46),  ..
    Vec2(250.00, 317.19), Vec2(255.00, 309.12), Vec2(262.62, 302.00), Vec2(262.21, 295.00), Vec2(248.00, 273.59), Vec2(229.00, 257.93), Vec2(221.00, 255.48), Vec2(215.00, 251.59), Vec2(210.79, 246.00), Vec2(207.47, 234.00), Vec2(203.25, 227.00), Vec2(179.00, 205.90),  ..
    Vec2(148.00, 189.54), Vec2(136.00, 181.45), Vec2(120.00, 180.31), Vec2(110.00, 181.65), Vec2(95.00, 179.31), Vec2(63.00, 166.96), Vec2(50.00, 164.23), Vec2(31.00, 154.49), Vec2(19.76, 145.00), Vec2(15.96, 136.00), Vec2(16.65, 127.00), Vec2(20.57, 120.00),  ..
    Vec2(28.00, 114.63), Vec2(40.00, 113.67), Vec2(65.00, 127.22), Vec2(73.00, 128.69), Vec2(81.96, 120.00), Vec2(77.58, 103.00), Vec2(78.18, 92.00), Vec2(59.11, 77.00), Vec2(52.00, 67.29), Vec2(31.29, 55.00), Vec2(25.67, 47.00), Vec2(24.65, 37.00),  ..
    Vec2(27.82, 29.00), Vec2(35.00, 22.55), Vec2(44.00, 20.35), Vec2(49.00, 20.81), Vec2(61.00, 25.69), Vec2(79.00, 37.81), Vec2(88.00, 49.64), Vec2(97.00, 56.65), Vec2(109.00, 49.61), Vec2(143.00, 38.96), Vec2(197.00, 37.27), Vec2(215.00, 35.30),  ..
    Vec2(222.00, 36.65), Vec2(228.42, 41.00), Vec2(233.30, 49.00), Vec2(234.14, 57.00), Vec2(231.00, 65.80), Vec2(224.00, 72.38), Vec2(218.00, 74.50), Vec2(197.00, 76.62), Vec2(145.00, 78.81), Vec2(123.00, 87.41), Vec2(117.59, 98.00), Vec2(117.79, 104.00),  ..
    Vec2(119.00, 106.23), Vec2(138.73, 120.00), Vec2(148.00, 129.50), Vec2(158.50, 149.00), Vec2(203.93, 175.00), Vec2(229.00, 196.60), Vec2(238.16, 208.00), Vec2(245.20, 221.00), Vec2(275.45, 245.00), Vec2(289.00, 263.24), Vec2(303.60, 287.00), Vec2(312.00, 291.57),  ..
    Vec2(339.25, 266.00), Vec2(366.33, 226.00), Vec2(363.43, 216.00), Vec2(364.13, 206.00), Vec2(353.00, 196.72), Vec2(324.00, 181.05), Vec2(307.00, 169.63), Vec2(274.93, 156.00), Vec2(256.00, 152.48), Vec2(228.00, 145.13), Vec2(221.09, 142.00), Vec2(214.87, 135.00),  ..
    Vec2(212.67, 127.00), Vec2(213.81, 119.00), Vec2(219.32, 111.00), Vec2(228.00, 106.52), Vec2(236.00, 106.39), Vec2(290.00, 119.40), Vec2(299.33, 114.00), Vec2(300.52, 109.00), Vec2(300.30, 53.00), Vec2(301.46, 47.00), Vec2(305.00, 41.12), Vec2(311.00, 36.37),  ..
    Vec2(317.00, 34.43), Vec2(325.00, 34.81), Vec2(334.90, 41.00), Vec2(339.45, 50.00), Vec2(339.82, 132.00), Vec2(346.09, 139.00), Vec2(350.00, 150.26), Vec2(380.00, 167.38), Vec2(393.00, 166.48), Vec2(407.00, 155.54), Vec2(430.00, 147.30), Vec2(437.78, 135.00),  ..
    Vec2(433.13, 122.00), Vec2(410.23, 78.00), Vec2(401.59, 69.00), Vec2(393.48, 56.00), Vec2(392.80, 44.00), Vec2(395.50, 38.00), Vec2(401.00, 32.49), Vec2(409.00, 29.41), Vec2(420.00, 30.84), Vec2(426.92, 36.00), Vec2(432.32, 44.00), Vec2(439.49, 51.00),  ..
    Vec2(470.13, 108.00), Vec2(475.71, 124.00), Vec2(483.00, 130.11), Vec2(488.00, 139.43), Vec2(529.00, 139.40), Vec2(536.00, 132.52), Vec2(543.73, 129.00), Vec2(540.47, 115.00), Vec2(541.11, 100.00), Vec2(552.18, 68.00), Vec2(553.78, 47.00), Vec2(559.00, 39.76),  ..
    Vec2(567.00, 35.52), Vec2(577.00, 35.45), Vec2(585.00, 39.58), Vec2(591.38, 50.00), Vec2(591.67, 66.00), Vec2(590.31, 79.00), Vec2(579.76, 109.00), Vec2(582.25, 119.00), Vec2(583.66, 136.00), Vec2(586.45, 143.00), Vec2(586.44, 151.00), Vec2(580.42, 168.00),  ..
    Vec2(577.15, 173.00), Vec2(572.00, 177.13), Vec2(564.00, 179.49), Vec2(478.00, 178.81), Vec2(443.00, 184.76), Vec2(427.10, 190.00), Vec2(424.00, 192.11), Vec2(415.94, 209.00), Vec2(408.82, 228.00), Vec2(405.82, 241.00), Vec2(411.00, 250.82), Vec2(415.00, 251.50),  ..
    Vec2(428.00, 248.89), Vec2(469.00, 246.29), Vec2(505.00, 246.49), Vec2(533.00, 243.60), Vec2(541.87, 248.00), Vec2(547.55, 256.00), Vec2(548.48, 267.00), Vec2(544.00, 276.00), Vec2(534.00, 282.24), Vec2(513.00, 285.46), Vec2(468.00, 285.76), Vec2(402.00, 291.70),  ..
    Vec2(392.00, 290.29), Vec2(377.00, 294.46), Vec2(367.00, 294.43), Vec2(356.44, 304.00), Vec2(354.22, 311.00), Vec2(362.00, 321.36), Vec2(390.00, 322.44), Vec2(433.00, 330.16), Vec2(467.00, 332.76), Vec2(508.00, 347.64), Vec2(522.00, 357.67), Vec2(528.00, 354.46),  ..
    Vec2(536.00, 352.96), Vec2(546.06, 336.00), Vec2(553.47, 306.00), Vec2(564.19, 282.00), Vec2(567.84, 268.00), Vec2(578.72, 246.00), Vec2(585.00, 240.97), Vec2(592.00, 238.91), Vec2(600.00, 239.72), Vec2(606.00, 242.82), Vec2(612.36, 251.00), Vec2(613.35, 263.00),  ..
    Vec2(588.75, 324.00), Vec2(583.25, 350.00), Vec2(572.12, 370.00), Vec2(575.45, 378.00), Vec2(575.20, 388.00), Vec2(589.00, 393.81), Vec2(599.20, 404.00), Vec2(607.14, 416.00), Vec2(609.96, 430.00), Vec2(615.45, 441.00), Vec2(613.44, 462.00), Vec2(610.48, 469.00),  ..
    Vec2(603.00, 475.63), Vec2(590.96, 479.00) ..
]

Global complex_terrain_count:Int = complex_terrain_verts.Length

Function init_ComplexTerrainCircles_1000:CPSpace()
    space = BENCH_SPACE_NEW()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, -100))
    space.SetCollisionSlop(0.5)
    
    Local offset:CPVect = Vec2(-320, -240)
    For Local i:Int = 0 Until (complex_terrain_count - 1)
        Local a:CpVect = complex_terrain_verts[i], b:CpVect = complex_terrain_verts[i + 1]
        space.AddShape(New CPSegmentShape.Create(space.GetStaticBody(), a.Add(offset), b.Add(offset), 0.0))
    Next
    
    For Local i:Int = 0 Until 1000
        Local radius:Double = 5.0
        Local mass:Double = radius * radius
        Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
        body.SetPosition(frand_unit_circle().Mult(180.0).Add(Vec2(0.0, 300.0)))
        
        Local shape:CPShape = New CPCircleShape.Create(body, radius, CPVZero)
		space.AddShape(shape)
        shape.SetElasticity(0.0)
		shape.SetFriction(0.0)
    Next
    
    Return space
End Function

Function init_ComplexTerrainHexagons_1000:CPSpace()
    space = BENCH_SPACE_NEW()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, -100))
    space.SetCollisionSlop(0.5)
    
    Local offset:CPVect = Vec2(-320, -240)
    For Local i:Int = 0 Until (complex_terrain_count - 1)
        Local a:CpVect = complex_terrain_verts[i], b:CpVect = complex_terrain_verts[i + 1]
        space.AddShape(New CPSegmentShape.Create(space.GetStaticBody(), a.Add(offset), b.Add(offset), 0.0))
    Next
    
    Local radius:Double = 5.0
    Local hexagon:CPVect[6]
    For Local i:Int = 0 Until 6
        Local angle:Double = -CP_PI * 2.0 * i / 6.0
        hexagon[i] = Vec2(Cos(angle), Sin(angle)).Mult(radius - bevel)
    Next
    
    For Local i:Int = 0 Until 1000
        Local mass:Double = radius * radius
        Local body:CPBody = New CPBody.Create(mass, MomentForPoly(mass, hexagon, CPVZero, 0.0))
		space.AddBody(body)
        body.SetPosition(frand_unit_circle().Mult(180.0).Add(Vec2(0.0, 300.0)))
        
        Local shape:CPShape = New CPPolyShape.Create(body, hexagon, CPVZero, bevel)
		space.AddShape(shape)
        shape.SetElasticity(0.0)
		shape.SetFriction(0.0)
    Next
    
    Return space
End Function


' BouncyTerrain
Global bouncy_terrain_verts:CPVect[] = [ ..
	Vec2(537.18, 23.00), Vec2(520.50, 36.00), Vec2(501.53, 63.00), Vec2(496.14, 76.00), Vec2(498.86, 86.00), Vec2(504.00, 90.51), Vec2(508.00, 91.36), Vec2(508.77, 84.00), Vec2(513.00, 77.73), Vec2(519.00, 74.48), Vec2(530.00, 74.67), Vec2(545.00, 54.65),..
	Vec2(554.00, 48.77), Vec2(562.00, 46.39), Vec2(568.00, 45.94), Vec2(568.61, 47.00), Vec2(567.94, 55.00), Vec2(571.27, 64.00), Vec2(572.92, 80.00), Vec2(572.00, 81.39), Vec2(563.00, 79.93), Vec2(556.00, 82.69), Vec2(551.49, 88.00), Vec2(549.00, 95.76),..
	Vec2(538.00, 93.40), Vec2(530.00, 102.38), Vec2(523.00, 104.00), Vec2(517.00, 103.02), Vec2(516.22, 109.00), Vec2(518.96, 116.00), Vec2(526.00, 121.15), Vec2(534.00, 116.48), Vec2(543.00, 116.77), Vec2(549.28, 121.00), Vec2(554.00, 130.17), Vec2(564.00, 125.67),..
	Vec2(575.60, 129.00), Vec2(573.31, 121.00), Vec2(567.77, 111.00), Vec2(575.00, 106.47), Vec2(578.51, 102.00), Vec2(580.25, 95.00), Vec2(577.98, 87.00), Vec2(582.00, 85.71), Vec2(597.00, 89.46), Vec2(604.80, 95.00), Vec2(609.28, 104.00), Vec2(610.55, 116.00),..
	Vec2(609.30, 125.00), Vec2(600.80, 142.00), Vec2(597.31, 155.00), Vec2(584.00, 167.23), Vec2(577.86, 175.00), Vec2(583.52, 184.00), Vec2(582.64, 195.00), Vec2(591.00, 196.56), Vec2(597.81, 201.00), Vec2(607.45, 219.00), Vec2(607.51, 246.00), Vec2(600.00, 275.46),..
	Vec2(588.00, 267.81), Vec2(579.00, 264.91), Vec2(557.00, 264.41), Vec2(552.98, 259.00), Vec2(548.00, 246.18), Vec2(558.00, 247.12), Vec2(565.98, 244.00), Vec2(571.10, 237.00), Vec2(571.61, 229.00), Vec2(568.25, 222.00), Vec2(562.00, 217.67), Vec2(544.00, 213.93),..
	Vec2(536.73, 214.00), Vec2(535.60, 204.00), Vec2(539.69, 181.00), Vec2(542.84, 171.00), Vec2(550.43, 161.00), Vec2(540.00, 156.27), Vec2(536.62, 152.00), Vec2(534.70, 146.00), Vec2(527.00, 141.88), Vec2(518.59, 152.00), Vec2(514.51, 160.00), Vec2(510.33, 175.00),..
	Vec2(519.38, 183.00), Vec2(520.52, 194.00), Vec2(516.00, 201.27), Vec2(505.25, 206.00), Vec2(507.57, 223.00), Vec2(519.90, 260.00), Vec2(529.00, 260.48), Vec2(534.00, 262.94), Vec2(538.38, 268.00), Vec2(540.00, 275.00), Vec2(537.06, 284.00), Vec2(530.00, 289.23),..
	Vec2(520.00, 289.23), Vec2(513.00, 284.18), Vec2(509.71, 286.00), Vec2(501.69, 298.00), Vec2(501.56, 305.00), Vec2(504.30, 311.00), Vec2(512.00, 316.43), Vec2(521.00, 316.42), Vec2(525.67, 314.00), Vec2(535.00, 304.98), Vec2(562.00, 294.80), Vec2(573.00, 294.81),..
	Vec2(587.52, 304.00), Vec2(600.89, 310.00), Vec2(596.96, 322.00), Vec2(603.28, 327.00), Vec2(606.52, 333.00), Vec2(605.38, 344.00), Vec2(597.65, 352.00), Vec2(606.36, 375.00), Vec2(607.16, 384.00), Vec2(603.40, 393.00), Vec2(597.00, 398.14), Vec2(577.00, 386.15),..
	Vec2(564.35, 373.00), Vec2(565.21, 364.00), Vec2(562.81, 350.00), Vec2(553.00, 346.06), Vec2(547.48, 338.00), Vec2(547.48, 330.00), Vec2(550.00, 323.30), Vec2(544.00, 321.53), Vec2(537.00, 322.70), Vec2(532.00, 326.23), Vec2(528.89, 331.00), Vec2(527.83, 338.00),..
	Vec2(533.02, 356.00), Vec2(542.00, 360.73), Vec2(546.68, 369.00), Vec2(545.38, 379.00), Vec2(537.58, 386.00), Vec2(537.63, 388.00), Vec2(555.00, 407.47), Vec2(563.00, 413.52), Vec2(572.57, 418.00), Vec2(582.72, 426.00), Vec2(578.00, 431.12), Vec2(563.21, 440.00),..
	Vec2(558.00, 449.27), Vec2(549.00, 452.94), Vec2(541.00, 451.38), Vec2(536.73, 448.00), Vec2(533.00, 441.87), Vec2(520.00, 437.96), Vec2(514.00, 429.69), Vec2(490.00, 415.15), Vec2(472.89, 399.00), Vec2(472.03, 398.00), Vec2(474.00, 396.71), Vec2(486.00, 393.61),..
	Vec2(492.00, 385.85), Vec2(492.00, 376.15), Vec2(489.04, 371.00), Vec2(485.00, 368.11), Vec2(480.00, 376.27), Vec2(472.00, 379.82), Vec2(463.00, 378.38), Vec2(455.08, 372.00), Vec2(446.00, 377.69), Vec2(439.00, 385.24), Vec2(436.61, 391.00), Vec2(437.52, 404.00),..
	Vec2(440.00, 409.53), Vec2(463.53, 433.00), Vec2(473.80, 441.00), Vec2(455.00, 440.30), Vec2(443.00, 436.18), Vec2(436.00, 431.98), Vec2(412.00, 440.92), Vec2(397.00, 442.46), Vec2(393.59, 431.00), Vec2(393.71, 412.00), Vec2(400.00, 395.10), Vec2(407.32, 387.00),..
	Vec2(408.54, 380.00), Vec2(407.42, 375.00), Vec2(403.97, 370.00), Vec2(399.00, 366.74), Vec2(393.00, 365.68), Vec2(391.23, 374.00), Vec2(387.00, 380.27), Vec2(381.00, 383.52), Vec2(371.56, 384.00), Vec2(364.98, 401.00), Vec2(362.96, 412.00), Vec2(363.63, 435.00),..
	Vec2(345.00, 433.55), Vec2(344.52, 442.00), Vec2(342.06, 447.00), Vec2(337.00, 451.38), Vec2(330.00, 453.00), Vec2(325.00, 452.23), Vec2(318.00, 448.17), Vec2(298.00, 453.70), Vec2(284.00, 451.49), Vec2(278.62, 449.00), Vec2(291.47, 408.00), Vec2(291.77, 398.00),..
	Vec2(301.00, 393.83), Vec2(305.00, 393.84), Vec2(305.60, 403.00), Vec2(310.00, 409.47), Vec2(318.00, 413.07), Vec2(325.00, 412.40), Vec2(332.31, 407.00), Vec2(335.07, 400.00), Vec2(334.40, 393.00), Vec2(329.00, 385.69), Vec2(319.00, 382.79), Vec2(301.00, 389.23),..
	Vec2(289.00, 389.97), Vec2(265.00, 389.82), Vec2(251.00, 385.85), Vec2(245.00, 389.23), Vec2(239.00, 389.94), Vec2(233.00, 388.38), Vec2(226.00, 382.04), Vec2(206.00, 374.75), Vec2(206.00, 394.00), Vec2(204.27, 402.00), Vec2(197.00, 401.79), Vec2(191.00, 403.49),..
	Vec2(186.53, 407.00), Vec2(183.60, 412.00), Vec2(183.60, 422.00), Vec2(189.00, 429.31), Vec2(196.00, 432.07), Vec2(203.00, 431.40), Vec2(209.47, 427.00), Vec2(213.00, 419.72), Vec2(220.00, 420.21), Vec2(227.00, 418.32), Vec2(242.00, 408.41), Vec2(258.98, 409.00),..
	Vec2(250.00, 435.43), Vec2(239.00, 438.78), Vec2(223.00, 448.19), Vec2(209.00, 449.70), Vec2(205.28, 456.00), Vec2(199.00, 460.23), Vec2(190.00, 460.52), Vec2(182.73, 456.00), Vec2(178.00, 446.27), Vec2(160.00, 441.42), Vec2(148.35, 435.00), Vec2(149.79, 418.00),..
	Vec2(157.72, 401.00), Vec2(161.00, 396.53), Vec2(177.00, 385.00), Vec2(180.14, 380.00), Vec2(181.11, 374.00), Vec2(180.00, 370.52), Vec2(170.00, 371.68), Vec2(162.72, 368.00), Vec2(158.48, 361.00), Vec2(159.56, 349.00), Vec2(154.00, 342.53), Vec2(146.00, 339.85),..
	Vec2(136.09, 343.00), Vec2(130.64, 351.00), Vec2(131.74, 362.00), Vec2(140.61, 374.00), Vec2(130.68, 387.00), Vec2(120.75, 409.00), Vec2(118.09, 421.00), Vec2(117.92, 434.00), Vec2(100.00, 432.40), Vec2(87.00, 427.48), Vec2(81.59, 423.00), Vec2(73.64, 409.00),..
	Vec2(72.57, 398.00), Vec2(74.62, 386.00), Vec2(78.80, 378.00), Vec2(88.00, 373.43), Vec2(92.49, 367.00), Vec2(93.32, 360.00), Vec2(91.30, 353.00), Vec2(103.00, 342.67), Vec2(109.00, 343.10), Vec2(116.00, 340.44), Vec2(127.33, 330.00), Vec2(143.00, 327.24),..
	Vec2(154.30, 322.00), Vec2(145.00, 318.06), Vec2(139.77, 311.00), Vec2(139.48, 302.00), Vec2(144.95, 293.00), Vec2(143.00, 291.56), Vec2(134.00, 298.21), Vec2(118.00, 300.75), Vec2(109.40, 305.00), Vec2(94.67, 319.00), Vec2(88.00, 318.93), Vec2(81.00, 321.69),..
	Vec2(67.24, 333.00), Vec2(56.68, 345.00), Vec2(53.00, 351.40), Vec2(47.34, 333.00), Vec2(50.71, 314.00), Vec2(56.57, 302.00), Vec2(68.00, 287.96), Vec2(91.00, 287.24), Vec2(110.00, 282.36), Vec2(133.80, 271.00), Vec2(147.34, 256.00), Vec2(156.47, 251.00),..
	Vec2(157.26, 250.00), Vec2(154.18, 242.00), Vec2(154.48, 236.00), Vec2(158.72, 229.00), Vec2(166.71, 224.00), Vec2(170.15, 206.00), Vec2(170.19, 196.00), Vec2(167.24, 188.00), Vec2(160.00, 182.67), Vec2(150.00, 182.66), Vec2(143.60, 187.00), Vec2(139.96, 195.00),..
	Vec2(139.50, 207.00), Vec2(136.45, 221.00), Vec2(136.52, 232.00), Vec2(133.28, 238.00), Vec2(129.00, 241.38), Vec2(119.00, 243.07), Vec2(115.00, 246.55), Vec2(101.00, 253.16), Vec2(86.00, 257.32), Vec2(63.00, 259.24), Vec2(57.00, 257.31), Vec2(50.54, 252.00),..
	Vec2(47.59, 247.00), Vec2(46.30, 240.00), Vec2(47.58, 226.00), Vec2(50.00, 220.57), Vec2(58.00, 226.41), Vec2(69.00, 229.17), Vec2(79.00, 229.08), Vec2(94.50, 225.00), Vec2(100.21, 231.00), Vec2(107.00, 233.47), Vec2(107.48, 224.00), Vec2(109.94, 219.00),..
	Vec2(115.00, 214.62), Vec2(122.57, 212.00), Vec2(116.00, 201.49), Vec2(104.00, 194.57), Vec2(90.00, 194.04), Vec2(79.00, 198.21), Vec2(73.00, 198.87), Vec2(62.68, 191.00), Vec2(62.58, 184.00), Vec2(64.42, 179.00), Vec2(75.00, 167.70), Vec2(80.39, 157.00),..
	Vec2(68.79, 140.00), Vec2(61.67, 126.00), Vec2(61.47, 117.00), Vec2(64.43, 109.00), Vec2(63.10, 96.00), Vec2(56.48, 82.00), Vec2(48.00, 73.88), Vec2(43.81, 66.00), Vec2(43.81, 56.00), Vec2(50.11, 46.00), Vec2(59.00, 41.55), Vec2(71.00, 42.64),..
	Vec2(78.00, 36.77), Vec2(83.00, 34.75), Vec2(99.00, 34.32), Vec2(117.00, 38.92), Vec2(133.00, 55.15), Vec2(142.00, 50.70), Vec2(149.74, 51.00), Vec2(143.55, 68.00), Vec2(153.28, 74.00), Vec2(156.23, 79.00), Vec2(157.00, 84.00), Vec2(156.23, 89.00),..
	Vec2(153.28, 94.00), Vec2(144.58, 99.00), Vec2(151.52, 112.00), Vec2(151.51, 124.00), Vec2(150.00, 126.36), Vec2(133.00, 130.25), Vec2(126.71, 125.00), Vec2(122.00, 117.25), Vec2(114.00, 116.23), Vec2(107.73, 112.00), Vec2(104.48, 106.00), Vec2(104.32, 99.00),..
	Vec2(106.94, 93.00), Vec2(111.24, 89.00), Vec2(111.60, 85.00), Vec2(107.24, 73.00), Vec2(102.00, 67.57), Vec2(99.79, 67.00), Vec2(99.23, 76.00), Vec2(95.00, 82.27), Vec2(89.00, 85.52), Vec2(79.84, 86.00), Vec2(86.73, 114.00), Vec2(98.00, 136.73),..
	Vec2(99.00, 137.61), Vec2(109.00, 135.06), Vec2(117.00, 137.94), Vec2(122.52, 146.00), Vec2(122.94, 151.00), Vec2(121.00, 158.58), Vec2(134.00, 160.97), Vec2(153.00, 157.45), Vec2(171.30, 150.00), Vec2(169.06, 142.00), Vec2(169.77, 136.00), Vec2(174.00, 129.73),..
	Vec2(181.46, 126.00), Vec2(182.22, 120.00), Vec2(182.20, 111.00), Vec2(180.06, 101.00), Vec2(171.28, 85.00), Vec2(171.75, 80.00), Vec2(182.30, 53.00), Vec2(189.47, 50.00), Vec2(190.62, 38.00), Vec2(194.00, 33.73), Vec2(199.00, 30.77), Vec2(208.00, 30.48),..
	Vec2(216.00, 34.94), Vec2(224.00, 31.47), Vec2(240.00, 30.37), Vec2(247.00, 32.51), Vec2(249.77, 35.00), Vec2(234.75, 53.00), Vec2(213.81, 93.00), Vec2(212.08, 99.00), Vec2(213.00, 101.77), Vec2(220.00, 96.77), Vec2(229.00, 96.48), Vec2(236.28, 101.00),..
	Vec2(240.00, 107.96), Vec2(245.08, 101.00), Vec2(263.00, 65.32), Vec2(277.47, 48.00), Vec2(284.00, 47.03), Vec2(286.94, 41.00), Vec2(292.00, 36.62), Vec2(298.00, 35.06), Vec2(304.00, 35.77), Vec2(314.00, 43.81), Vec2(342.00, 32.56), Vec2(359.00, 31.32),..
	Vec2(365.00, 32.57), Vec2(371.00, 36.38), Vec2(379.53, 48.00), Vec2(379.70, 51.00), Vec2(356.00, 52.19), Vec2(347.00, 54.74), Vec2(344.38, 66.00), Vec2(341.00, 70.27), Vec2(335.00, 73.52), Vec2(324.00, 72.38), Vec2(317.00, 65.75), Vec2(313.00, 67.79),..
	Vec2(307.57, 76.00), Vec2(315.00, 78.62), Vec2(319.28, 82.00), Vec2(322.23, 87.00), Vec2(323.00, 94.41), Vec2(334.00, 92.49), Vec2(347.00, 87.47), Vec2(349.62, 80.00), Vec2(353.00, 75.73), Vec2(359.00, 72.48), Vec2(366.00, 72.32), Vec2(372.00, 74.94),..
	Vec2(377.00, 81.34), Vec2(382.00, 83.41), Vec2(392.00, 83.40), Vec2(399.00, 79.15), Vec2(404.00, 85.74), Vec2(411.00, 85.06), Vec2(417.00, 86.62), Vec2(423.38, 93.00), Vec2(425.05, 104.00), Vec2(438.00, 110.35), Vec2(450.00, 112.17), Vec2(452.62, 103.00),..
	Vec2(456.00, 98.73), Vec2(462.00, 95.48), Vec2(472.00, 95.79), Vec2(471.28, 92.00), Vec2(464.00, 84.62), Vec2(445.00, 80.39), Vec2(436.00, 75.33), Vec2(428.00, 68.46), Vec2(419.00, 68.52), Vec2(413.00, 65.27), Vec2(408.48, 58.00), Vec2(409.87, 46.00),..
	Vec2(404.42, 39.00), Vec2(408.00, 33.88), Vec2(415.00, 29.31), Vec2(429.00, 26.45), Vec2(455.00, 28.77), Vec2(470.00, 33.81), Vec2(482.00, 42.16), Vec2(494.00, 46.85), Vec2(499.65, 36.00), Vec2(513.00, 25.95), Vec2(529.00, 22.42), Vec2(537.18, 23.00) ..
]

Global bouncy_terrain_count:Int = bouncy_terrain_verts.Length

Function init_BouncyTerrainCircles_500:CPSpace()
	space = BENCH_SPACE_NEW()
	space.SetIterations(10)
	
	Local offset:CPVect = Vec2(-320, -240)
	For Local i:Int = 0 Until (bouncy_terrain_count - 1)
		Local a:CPVect = bouncy_terrain_verts[i]
		Local b:CPVect = bouncy_terrain_verts[i+1]
		Local shape:CPShape = New CPSegmentShape.Create(space.GetStaticBody(), a.Add(offset), b.Add(offset), 0.0)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
	Next
	
	For Local i:Int = 1 Until 501
		Local radius:Double = 5.0
		Local mass:Double = radius * radius
		Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
		body.SetPosition(frand_unit_circle().Mult(130.0).Add(CPVZero))
		body.SetVelocity(frand_unit_circle().Mult(50.0))
		
		Local shape:CPShape = New CPCircleShape.Create(body, radius, CPVZero)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
	Next
	
	Return space
End Function

Function init_BouncyTerrainHexagons_500:CPSpace()
	space = BENCH_SPACE_NEW()
	space.SetIterations(10)
	
	Local offset:CPVect = Vec2(-320, -240)
	For Local i:Int = 0 Until (bouncy_terrain_count - 1)
		Local a:CPVect = bouncy_terrain_verts[i]
		Local b:CPVect = bouncy_terrain_verts[i+1]
		Local shape:CPShape = New CPSegmentShape.Create(space.GetStaticBody(), a.Add(offset), b.Add(offset), 0.0)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
	Next
	
	Local radius:Double = 5.0
	Local hexagon:CPVect[6]
	For Local i:Int = 0 Until 6
		Local angle:Double = -CP_PI * 2.0 * i / 6.0
		hexagon[i] = Vec2(Cos(angle), Sin(angle)).Mult(radius - bevel)
	Next
	
	For Local i:Int = 1 Until 501
		Local mass:Double = radius * radius
		Local body:CPBody = New CPBody.Create(mass, MomentForPoly(mass, hexagon, CPVZero, 0.0))
		space.AddBody(body)
		body.SetPosition(frand_unit_circle().Mult(130.0).Add(CPVZero))
		body.SetVelocity(frand_unit_circle().Mult(50.0))
		
		Local shape:CPShape = New CPPolyShape.Create(body, hexagon, CPVZero, bevel)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
	Next
	
	Return space
End Function


'// No collisions

Function NoCollide_begin:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object)
	Assert("")
	
	Return True
End Function


Function init_NoCollide:CPSpace()
	space = BENCH_SPACE_NEW()
	space.SetIterations(10)
	
	space.AddCollisionPairFunc(2, 2, NoCollide_begin)
	
	
	Local radius:Double = 4.5
	
	Local shape:CPShape = New CPSegmentShape.Create(space.GetStaticBody(), Vec2(-330 - radius, -250 - radius), Vec2(330 + radius, -250 - radius), 0.0)
	space.AddShape(shape)
	shape.SetElasticity(1.0)
	shape = New CPSegmentShape.Create(space.GetStaticBody(), Vec2(330 + radius, 250 + radius), Vec2(330 + radius, -250 - radius), 0.0)
	space.AddShape(shape)
	shape.SetElasticity(1.0)
	shape = New CPSegmentShape.Create(space.GetStaticBody(), Vec2(330 + radius, 250 + radius), Vec2(-330 - radius, 250 + radius), 0.0)
	space.AddShape(shape)
	shape.SetElasticity(1.0)
	shape = New CPSegmentShape.Create(space.GetStaticBody(), Vec2(-330 - radius, -250 - radius), Vec2(-330 - radius, 250 + radius), 0.0)
	space.AddShape(shape)
	shape.SetElasticity(1.0)
	
	For Local x:Int = -320 Until 321 Step 20
		For Local y:Int = -240 Until 241 Step 20
			space.AddShape(New CPCircleShape.Create(space.GetStaticBody(), radius, Vec2(x, y)))
		Next
	Next
	
	For Local y:Int = 10-240 Until 241 Step 40
		Local mass:Double = 7.0
		Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
		body.SetPosition(Vec2(-320.0, y))
		body.SetVelocity(Vec2(100.0, 0.0))
		
		Local shape:CPShape = New CPCircleShape.Create(body, radius, CPVZero)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
		shape.SetCollisionType(2)
	Next
	
	For Local x:Int = 30-320 Until 321 Step 40
		Local mass:Double = 7.0
		Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
		body.SetPosition(Vec2(x, -240.0))
		body.SetVelocity(Vec2(0.0, 100.0))
		
		Local shape:CPShape = New CPCircleShape.Create(body, radius, CPVZero)
		space.AddShape(shape)
		shape.SetElasticity(1.0)
		shape.SetCollisionType(2)
	Next
	
	Return space
End Function


'// TODO ideas:
'// addition/removal
'// Memory usage? (too small to matter?)
'// http://forums.tigsource.com/index.php?topic=18077.msg518578#msg518578


'// Build benchmark list
Function UpdateSpace(space:CPSpace, dt:Double)
	BENCH_SPACE_STEP(space, dt)
End Function

Function destroySpace(space:CPSpace)
	ChipmunkDemoFreeSpaceChildren(space)
	BENCH_SPACE_FREE(space)
End Function

Global bench_list:CPSpace()[] = [ ..
	init_SimpleTerrainCircles_1000,  ..
	init_SimpleTerrainCircles_500,  ..
	init_SimpleTerrainCircles_100,  ..
	init_SimpleTerrainBoxes_1000,  ..
	init_SimpleTerrainBoxes_500,  ..
	init_SimpleTerrainBoxes_100,  ..
	init_SimpleTerrainHexagons_1000,  ..
	init_SimpleTerrainHexagons_500,  ..
	init_SimpleTerrainHexagons_100,  ..
	init_SimpleTerrainVCircles_200,  ..
	init_SimpleTerrainVBoxes_200,  ..
	init_SimpleTerrainVHexagons_200,  ..
	init_ComplexTerrainCircles_1000,  ..
	init_ComplexTerrainHexagons_1000,  ..
	init_BouncyTerrainCircles_500,  ..
	init_BouncyTerrainHexagons_500,  ..
	init_NoCollide ..
]

Global bench_count:Int = bench_list.Length

'// Make a second demo declaration for this demo to use in the regular demo set.
Global BouncyHexagons:ChipmunkDemo = New ChipmunkDemo( ..
	"Bouncy Hexagons",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 27)

Function BENCH:ChipmunkDemo(n:Int)
	Return New ChipmunkDemo("benchmark - " + String(n), 1.0 / 60.0, bench_list[n], UpdateSpace, ChipmunkDemoDefaultDrawImpl, destroySpace, n)
End Function

Function initSpace:CPSpace()
	For Local i:Int = 0 Until bench_count
		BENCH(i)
	Next
	End
End Function
