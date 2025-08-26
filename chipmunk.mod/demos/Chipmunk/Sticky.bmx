
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

Const COLLISION_TYPE_STICKY:Int = 1

Global STICKY_SENSOR_THICKNESS:Float = 2.5

Function PostStepAddJoint(unused:Byte Ptr, Key:Object, Data:Object)
'	DebugLog("Adding joint for " + String(Data))

    Local joint:CPConstraint = CPConstraint(Key)
    space.AddConstraint(joint)
End Function

Function StickyPreSolve:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoefficient:Float, Data:Object)
'	/ / We want To fudge the collisions a bit To allow shapes To overlap more.
'	// This simulates their squishy sticky surface, and more importantly
'	// keeps them from separating and destroying the joint.
	
'	// Track the deepest collision point and use that to determine if a rigid collision should occur.
    Local deepest:Double = INFINITY
    
'	/ / Grab the contact Set And iterate over them.
    For Local i:Int = 0 Until contacts.Length
'		/ / Sink the contact points into the surface of each shape.
        contacts[i].setr1(contacts[i].GetR1().Sub(contacts[i].GetNormal().Mult(STICKY_SENSOR_THICKNESS)))
        contacts[i].SetR2(contacts[i].GetR2().Sub(contacts[i].GetNormal().Mult(STICKY_SENSOR_THICKNESS)))
        deepest = Min(deepest, contacts[i].GetDistance())
    Next

'	/ / Set the New contact Point Data.
	cpArbiter(Data).SetContactPointSet(contacts)
    
'	/ / If the shapes are overlapping enough, Then Create a
'	// joint that sticks them together at the first contact point.
    If Not cpArbiter(Data).GetUserData() And deepest >= 0.0
        Local bodyA:CPBody = Shapea.GetBody()
        Local bodyB:CPBody = Shapeb.GetBody()
        
'		/ / Create a joint at the contact Point To hold the body in place.
        Local anchorA:CPVect = Bodya.World2Local(contacts[0].GetR1())
        Local anchorB:CPVect = Bodyb.World2Local(contacts[0].GetR2())
        Local joint:CPPivotJoint = New CPPivotJoint.Create(bodyA, bodyB, anchorA, anchorB)
 
' 		/ / Give it a finite force For the stickyness.
        joint.SetMaxForce(3e3)

'		/ / Schedule a Post - Step() callback To Add the joint.
        space.AddPostStepCallback(PostStepAddJoint, joint, Null)
		
'		/ / Store the joint on the arbiter so we can Remove it later.
        cpArbiter(Data).SetUserData(joint)
    End If
    
'	/ / Position correction And velocity are handled separately so changing
'	// the overlap distance alone won't prevent the collision from occuring.
'	// Explicitly the collision for this frame if the shapes don't overlap using the new distance.
    Return deepest >= 0.0
	
'	// Lots more that you could improve upon here as well:
'	// * Modify the joint over time to make it plastic.
'	// * Modify the joint in the post-step to make it conditionally plastic (like clay).
'	// * Track a joint for the deepest contact point instead of the first.
'	/ / * Track a joint For each contact Point.(more complicated since you only Get one Data pointer).
End Function

Function PostStepRemoveJoint(unused:Byte Ptr, Key:Object, Data:Object)
'	DebugLog("Removing joint for " + String(Data))

    Local joint:CPConstraint = CPConstraint(Key)
    joint.Free()
End Function

Function StickySeparate(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoefficient:Float, Data:Object)
    Local joint:CPConstraint = CPConstraint(cpArbiter(Data).GetUserData())
    If joint
'		/ / The joint won't be removed until the step is done.
'		// Need to disable it so that it won't apply itself.
'		// Setting the force to 0 will do just that
        joint.SetMaxForce(0.0)

'		/ / perform the removal in a Post - Step() callback.
        space.AddPostStepCallback(PostStepRemoveJoint, joint, Null)

'		/ / Null out the reference To the joint.
'		// Not required, but it's a good practice.
        cpArbiter(Data).SetUserData(Null)
    End If
End Function

Function StickyInit:CPSpace()
    ChipmunkDemoMessageString = "Sticky collisions using the cpArbiter data pointer."

    init()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, 1000))
    space.SetCollisionSlop(2.0)
    
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
'	/ / Create segments around the edge of the screen.
    shape = New CPSegmentShape.Create(staticBody, Vec2(-340, 260), Vec2(-340, -260), 20.0)
    space.AddShape(shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(340, 260), Vec2(340, -260), 20.0)
    space.AddShape(shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-340, 260), Vec2(340, 260), 20.0)
    space.AddShape(shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-340, -260), Vec2(340, -260), 20.0)
    space.AddShape(shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    For Local i:Int = 0 Until 200
        Local mass:Double = 0.15
        Local radius:Double = 10.0
        
        Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
        Body.SetPosition(Vec2(Lerp(-150.0, 150.0, Rnd()), Lerp(-150.0, 150.0, Rnd())))
        
        Local shape:CPCircleShape = New CPCircleShape.Create(body, radius + STICKY_SENSOR_THICKNESS, CPVZero)
		space.AddShape(shape)
        Shape.SetFriction(0.9)
        Shape.SetCollisionType(COLLISION_TYPE_STICKY)
    Next i
    
    space.AddWildcardFunc(COLLISION_TYPE_STICKY, Null, New cpArbiter, StickyPreSolve, Null, StickySeparate)
    
    Return space
End Function

Function StickyUpdate(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function StickyDestroy(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp()
End Function

Global StickyDemo:ChipmunkDemo = New ChipmunkDemo( ..
	"Sticky Surfaces",  ..
	1.0 / 60.0,  ..
	..
	StickyInit,  ..
	StickyUpdate,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	StickyDestroy ..
, 22)
