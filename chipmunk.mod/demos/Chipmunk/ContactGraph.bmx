
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

' Import required modules
Framework brl.d3d9max2d
'Import brl.StandardIO
'Import brl.Max2D
'Import brl.random
'Import brl.math
'Import brl.Color

' Import Chipmunk library
Import hot.chipmunk

Import "ChipmunkDemo.bmx"

Global scaleStaticBody:cpBody
Global ballBody:cpBody

Function ScaleIterator(body:Object, arb:Object, sum:Object)
    impulseSum = CPVect(sum).Add(cpArbiter(arb).TotalImpulse())
End Function

Function BallIterator(body:Object, arb:Object, unused:Object)
'	/ / body is the body we are iterating the arbiters For.
'	// CPArbiter_Get*() in an arbiter iterator always returns the body/shape for the iterated body first.
    Local ball:CPShape = New CPShape, other:CPShape = New CPShape
    cpArbiter(arb).GetShapes(ball, other)
    bmx_drawbb(other.GetBB(), New scolor8(255, 0, 0, 255))
    Count = Count + 1
End Function

Type CrushingContext
	Field magnitudeSum:Double = 0
	Field vectorSum:CPVect = CPVZero
End Type

Function EstimateCrushing(body:Object, arb:Object, context:Object)
    Local j:CPVect = cpArbiter(Arb).TotalImpulse()
    CrushingContext(context).magnitudeSum:+j.Length()
    CrushingContext(context).vectorSum = CrushingContext(context).vectorSum.Add(j)
	crush = CrushingContext(context)
End Function

Function UpdateSpace(space:cpSpace, dt:Double)
	space.DoStep(dt)
    Local fmt:String = "Place objects on the scale to weigh them. The ball marks the shapes it's sitting on.~n"

'	/ / sum the total impulse applied To the Scale from all collision pairs in the contact graph.
		impulseSum = CPVZero
        scaleStaticBody.EachArbiter(ScaleIterator, impulseSum)
    
    ' Force is the impulse divided by the timestep
    Local force:Double = impulseSum.Length() / dt
    
    ' Weight can be found similarly from the gravity vector
    Local g:CPVect = space.GetGravity()
    Local weight:Double = g.Dot(impulseSum) / (g.LengthSq() * dt)
    
    fmt:+"Total force: " + String(force) + ", Total weight: " + String(weight) + "~n"
    
	
    ' Highlight and count the number of shapes the ball is touching
		Count = 0
        ballBody.EachArbiter(BallIterator, Null)
    
    fmt:+"The ball is touching " + String(Count) + " shapes.~n"
    
		crush = New CrushingContext
        ballBody.EachArbiter(EstimateCrushing, crush)
		
        Local crushForce:Double = (crush.magnitudeSum - crush.vectorSum.Length()) * dt
    

    If crushForce > 10.0
        fmt:+"The ball is being crushed. (f: " + String(crushForce) + ")"
    Else
        fmt:+"The ball is not being crushed. (f: " + String(crushForce) + ")"
    End If
    ChipmunkDemoTextDrawString(Vec2(-300, -220), fmt)
End Function

    Global impulseSum:CPVect
    Global Count:Int
        Global crush:CrushingContext

Function InitSpace:CPSpace()
    init()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 300))
    space.SetCollisionSlop(0.5)
    space.SetSleepTimeThreshold(1.0)

	Local body:CPBody, staticBody:CPBody = Space.GetStaticBody()
	Local shape:CPCircleShape
	
'	// Create segments around the edge of the screen.
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
	space.AddShape(segshap)
	segshap.SetElasticity(1.0)
	segshap.SetFriction(1.0)
	segshap.setFilter(NOT_GRABBABLE_FILTER)

	segshap = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
	space.AddShape(segshap)
	segshap.SetElasticity(1.0)
	segshap.SetFriction(1.0)
	segshap.setFilter(NOT_GRABBABLE_FILTER)

	segshap = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
	space.AddShape(segshap)
	segshap.SetElasticity(1.0)
	segshap.SetFriction(1.0)
	segshap.setFilter(NOT_GRABBABLE_FILTER)

	scaleStaticBody = New CPBody.Create(INFINITY, INFINITY)
	space.AddBody(scaleStaticBody)
	segshap = New CPSegmentShape.Create(scaleStaticBody, Vec2(240, 180), Vec2(-140, 180), 4.0)
	space.AddShape(segshap)
	segshap.SetElasticity(1.0)
	segshap.SetFriction(1.0)
	segshap.setFilter(NOT_GRABBABLE_FILTER)

	' Add some boxes to stack on the scale
	For Local i:Int = 0 To 4
	    Local body:CPBody = New CPBody.Create(1.0, MomentForBox(1.0, 30.0, 30.0))
		space.AddBody(body)
	    body.SetPosition(Vec2(0, -(i * 32 - 220)))
	    
	    Local shape:CPPolyShape = New cpBoxShape.Create(body, 30.0, 30.0, 0.0)
		space.AddShape(shape)
	    shape.SetElasticity(0.0)
	    shape.SetFriction(0.8)
	Next
	
'	// Add a ball that we'll track which objects are beneath it.
	Local radius:Double = 15.0
	ballBody = New CPBody.Create(10.0, MomentForCircle(10.0, 0.0, radius, CPVZero))
	space.AddBody(ballBody)
	ballBody.SetPosition(Vec2(120, -(-240 + radius + 5)))

	shape = New CPCircleShape.Create(ballBody, radius, CPVZero)
	space.AddShape(shape)
	shape.SetElasticity(0.0)
	shape.SetFriction(0.9)
	
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

Local ContactGraph:ChipmunkDemo = New chipmunkdemo( ..
	"Contact Graph",  ..
	1.0 / 60.0,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 16)
