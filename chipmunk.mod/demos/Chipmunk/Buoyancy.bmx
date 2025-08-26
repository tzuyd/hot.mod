
Rem Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
EndRem

SuperStrict

Framework brl.d3d9max2d
'Import brl.StandardIO
'Import brl.Max2D
'Import brl.random
'Import brl.math
'Import brl.Color

Import hot.chipmunk

Import "ChipmunkDemo.bmx"

Const FLUID_DENSITY:Float = 0.00014
Const FLUID_DRAG:Float = 2.0

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

'// Modified from chipmunk_private.h
Function k_scalar_body:Double(body:CPBody, Point:CPVect, n:CPVect) inline
    Local rcn:Double = Point.Sub(Body.GetPosition()).Cross(n)
    Return 1.0 / body.GetMass() + rcn * rcn / body.GetMoment()
End Function

Function waterPreSolve:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoefficient:Float, Data:Object)
    Local water: CPShape = shapeA
    Local poly:CPPolyShape = New CPPolyShape
	poly.cpObjectPtr = shapeB.cpObjectPtr
    
    Local body:CPBody = poly.GetBody()
    
    ' Get the top of the water sensor bounding box to use as the water level
    Local level:Double = water.GetBB().b
    
    Local verts: CPVect[] = poly.GetVerts()
    Local Count:Int = verts.Length
    
    ' Clip the polygon against the water level
    Local clippedCount: Int = 0
    Local clipped: cpVect[10]
    
        Local j:Int = Count - 1
    For Local i:Int = 0 Until Count
        Local a:CPVect = Body.Local2World(verts[j])
        Local b:CPVect = Body.Local2World(verts[i])
        a.y = -a.y
        b.y = -b.y
        
        If a.y < level Then
			clipped[clippedCount] = a
			clippedCount:+1
		EndIf
		
        Local a_level:Double = a.y - level
        Local b_level:Double = b.y - level

        If a_level * b_level < 0.0 Then
            Local t:Double = Abs(a_level) / (Abs(a_level) + Abs(b_level))
            clipped[clippedCount] = a.Lerp(b, t)
            clippedCount:+1
        EndIf
		j = i
    Next
    For Local i:Int = 0 Until clippedCount
		clipped[i].y = -clipped[i].y
	Next
		
    ' Calculate buoyancy from the clipped polygon area
    Local clippedArea:Double = AreaForPoly(clipped, 0.0, clippedCount)
    Local displacedMass:Double = clippedArea * FLUID_DENSITY
    Local centroid:CPVect = CentroidForPoly(clipped, clippedCount)

	bmx_drawpolygon(clippedCount, clipped, 5.0, New scolor8(0, 0, 255, 255), New SColor8(0, 0, 255, Int(255 * 0.1)))
	bmx_drawdot(5, centroid, New SColor8(0, 0, 255, 255))
	
    Local dt:Double = Space.GetCurrentTimeStep()
    Local g:CPVect = Space.GetGravity()

    ' Apply the buoyancy force as an impulse
    body.ApplyImpulseAtWorldPoint(g.Mult(-displacedMass * dt), centroid)
    
    ' Apply linear damping for the fluid drag
    Local v_centroid:CPVect = Body.VelocityAtWorldPoint(centroid)
    Local k:Double = k_scalar_body(body, centroid, v_centroid.Normalize())
    Local damping:Double = clippedArea * FLUID_DRAG * FLUID_DENSITY
    Local v_coef:Double = Exp(-damping * dt * k)	' // linear drag
'	Local v_coef:Double = 1.0 / (1.0 + damping * dt * v_centroid.Length() * k)	' // quadratic drag
    body.ApplyImpulseAtWorldPoint(v_centroid.Mult(v_coef).Sub(v_centroid).Mult(1.0 / k), centroid)
    
    ' Apply angular damping for the fluid drag
    Local cog:CPVect = Body.Local2World(Body.GetCenterOfGravity())
    Local w_damping:Double = MomentForPoly(FLUID_DRAG * FLUID_DENSITY * clippedArea, clipped, cog.Negate(), 0.0, clippedCount)
    body.SetAngularVelocity(body.GetAngularVelocity() * Exp(-w_damping * dt / body.GetMoment()))

    Return True
End Function

Function initSpace:CPSpace()
	init()
    space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 500))
'	space.SetDamping(0.5)
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    Local body:CPBody
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
    ' Create segments around the edge of the screen
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, -240), Vec2(320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
	    ' Add the edges of the bucket
	    Local bb:CPBB = New CPBB.Create(-300, 200, 100, 0)
	    Local radius:Double = 5.0
	    
	    shape = New CPSegmentShape.Create(staticBody, Vec2(bb.l, bb.b), Vec2(bb.l, bb.t), radius)
		space.AddShape(shape)
	    shape.SetElasticity(1.0)
	    shape.SetFriction(1.0)
	    shape.setFilter(NOT_GRABBABLE_FILTER)
	    
	    shape = New CPSegmentShape.Create(staticBody, Vec2(bb.r, bb.b), Vec2(bb.r, bb.t), radius)
		space.AddShape(shape)
	    shape.SetElasticity(1.0)
	    shape.SetFriction(1.0)
	    shape.setFilter(NOT_GRABBABLE_FILTER)
	    
	    shape = New CPSegmentShape.Create(staticBody, Vec2(bb.l, bb.b), Vec2(bb.r, bb.b), radius)
		space.AddShape(shape)
	    shape.SetElasticity(1.0)
	    shape.SetFriction(1.0)
	    shape.setFilter(NOT_GRABBABLE_FILTER)
	    
	    ' Add the sensor for the water
	    Local polyshap:CPPolyShape = New CPBoxShape.Create(staticBody, bb, 0.0)
		space.AddShape(polyshap)
	    polyShap.SetSensor(True)
	    polyShap.SetCollisionType(1)
    
		
	    Local Width:Double = 200.0
	    Local Height:Double = 50.0
	    Local mass:Double = 0.3 * FLUID_DENSITY * Width * Height
	    Local moment:Double = MomentForBox(mass, Width, Height)
	    
	    body = New CPBody.Create(mass, moment)
		space.AddBody(body)
	    body.SetPosition(Vec2(-50, 100))
	    body.SetVelocity(Vec2(0, 100))
	    body.SetAngularVelocity(1)
	    
	    polyshap = New CPBoxShape.Create(body, Width, Height, 0.0)
		space.AddShape(polyshap)
	    polyshap.SetFriction(0.8)
    
	    width = 40.0
	    height = width * 2
	    mass = 0.3 * FLUID_DENSITY * width * height
	    moment = MomentForBox(mass, Width, Height)
	    
	    body = New CPBody.Create(mass, moment)
		space.AddBody(body)
	    body.SetPosition(Vec2(-200, 50))
	    body.SetVelocity(Vec2(0, 100))
	    body.SetAngularVelocity(1)
	    
	    polyshap = New CPBoxShape.Create(body, Width, Height, 0.0)
		space.AddShape(polyshap)
	    polyshap.SetFriction(0.8)
    
    space.AddCollisionPairFunc(1, 0, Null, Null, waterPreSolve)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Buoyancy:ChipmunkDemo = New ChipmunkDemo( ..
	"Simple Sensor based fluids.",  ..
	1.0 / 180.0,  ..
	..
	InitSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 17)
