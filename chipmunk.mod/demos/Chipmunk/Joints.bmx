
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

Function addBall:CPBody(space:CPSpace, Pos:CPVect, boxOffset:CPVect)
    Local radius:Double = 15.0
    Local mass:Double = 1.0
    Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
	space.AddBody(body)
    body.SetPosition(Pos.Add(boxOffset))
    
    Local shape:CPCircleShape = New CPCircleShape.Create(body, radius, CPVZero)
	space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.7)
    
    Return body
End Function

Function addLever:CPBody(space:CPSpace, Pos:CPVect, boxOffset:CPVect)
    Local mass:Double = 1.0
    Local a:CPVect = Vec2(0, -15)
    Local b:CPVect = Vec2(0, 15)
    
    Local body:CPBody = New CPBody.Create(mass, MomentForSegment(mass, a, b, 0.0))
	space.AddBody(body)
    Body.SetPosition(Pos.Add(boxOffset.Add(Vec2(0, 15))))
    
    Local shape:CPSegmentShape = New CPSegmentShape.Create(body, a, b, 5.0)
	space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
    
    Return body
End Function

Function addBar:CPBody(space:CPSpace, Pos:CPVect, boxOffset:CPVect)
    Local mass:Double = 2.0
    Local a:CPVect = Vec2(0, -30)
    Local b:CPVect = Vec2(0, 30)
    
    Local body:CPBody = New CPBody.Create(mass, MomentForSegment(mass, a, b, 0.0))
	space.AddBody(body)
    Body.SetPosition(Pos.Add(boxOffset))
    
    Local shape:CPSegmentShape = New CPSegmentShape.Create(body, a, b, 5.0)
	space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
    Shape.setFilter(CP_ALL_CATEGORIES)
	shape.SetGroup(1)
    
    Return body
End Function

Function addWheel:CPBody(space:CPSpace, Pos:CPVect, boxOffset:CPVect)
    Local radius:Double = 15.0
    Local mass:Double = 1.0
    Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
	space.AddBody(body)
    Body.SetPosition(Pos.Add(boxOffset))
    
    Local shape:CPCircleShape = New CPCircleShape.Create(body, radius, CPVZero)
	space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
    Shape.setFilter(CP_ALL_CATEGORIES)
	shape.SetGroup(1)
    
    Return body
End Function

Function addChassis:CPBody(space:CPSpace, Pos:CPVect, boxOffset:CPVect)
    Local mass:Double = 5.0
    Local Width:Double = 80
    Local Height:Double = 30
    
    Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Width, Height))
	space.AddBody(body)
    Body.SetPosition(Pos.Add(boxOffset))
    
    Local shape:CPPolyShape = New cpBoxShape.Create(body, Width, Height, 0.0)
	space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
    Shape.setFilter(CP_ALL_CATEGORIES)
	shape.SetGroup(1)
    
    Return body
End Function

Function initSpace:CPSpace()
    Local space:CPSpace = New CPSpace.Create()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, 100))
    space.SetSleepTimeThreshold(0.5)
    
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, -240), Vec2(320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, -120), Vec2(320, -120), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 0), Vec2(320, 0), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 120), Vec2(320, 120), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
	
    shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-160, 240), Vec2(-160, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(0, 240), Vec2(0, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(160, 240), Vec2(160, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
	Local boxOffset:CPVect
	Local body1:CPBody, body2:CPBody
	
	Local posA:CPVect = Vec2(50, -60)
	Local posB:CPVect = Vec2(110, -60)
	
    Local anchorA:CPVect
    Local anchorB:CPVect
		
'	/ / Pin Joints - Link shapes with a solid bar Or pin.
'	/ / Keeps the anchor points the same distance apart from when the joint was created.
	boxOffset = Vec2(-320, 240)
	body1 = addBall(space, posA, boxOffset)
	body2 = addBall(space, posB, boxOffset)
	space.AddConstraint(New CPPinJoint.Create(body1, body2, Vec2(15, 0), Vec2(-15, 0)))
	
'	// Slide Joints - Like pin joints but with a min/max distance.
'	// Can be used for a cheap approximation of a rope.
	boxOffset = Vec2(-160, 240)
	body1 = addBall(space, posA, boxOffset)
	body2 = addBall(space, posB, boxOffset)
	space.AddConstraint(New CPSlideJoint.Create(body1, body2, Vec2(15, 0), Vec2(-15, 0), 20.0, 40.0))
	
'	// Pivot Joints - Holds the two anchor points together. Like a swivel.
	boxOffset = Vec2(0, 240)
	body1 = addBall(space, posA, boxOffset)
	body2 = addBall(space, posB, boxOffset)
    anchorA = boxOffset.Add(Vec2(80, -60)).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(Vec2(80, -60)).Sub(body2.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, body2, anchorA, anchorB))
'	// cpPivotJoint.Create(bodyA,bodyB,pivot) takes it's anchor parameter in world coordinates. The anchors are calculated from that
'	// cpPivotJoint.Create(bodyA,bodyB,anchorA,anchorB) lets you specify the two anchor points explicitly
	
'	// Groove Joints - Like a pivot joint, but one of the anchors is a line segment that the pivot can slide in
	boxOffset = Vec2(160, 240)
	body1 = addBall(space, posA, boxOffset)
	body2 = addBall(space, posB, boxOffset)
	space.AddConstraint(New CPGrooveJoint.Create(body1, body2, Vec2(30, -30), Vec2(30, 30), Vec2(-30, 0)))
	
'	// Damped Springs
	boxOffset = Vec2(-320, 120)
	body1 = addBall(space, posA, boxOffset)
	body2 = addBall(space, posB, boxOffset)
	space.AddConstraint(New CPDampedSpring.Create(body1, body2, Vec2(15, 0), Vec2(-15, 0), 20.0, 5.0, 0.3))
	
'	// Damped Rotary Springs
	boxOffset = Vec2(-160, 120)
	body1 = addBar(space, posA, boxOffset)
	body2 = addBar(space, posB, boxOffset)
'	// Add some pin joints to hold the circles in place.
    anchorA = boxOffset.Add(posA).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(posA).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, staticBody, anchorA, anchorB))
    anchorA = boxOffset.Add(posB).Sub(body2.GetPosition())
    anchorB = boxOffset.Add(posB).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body2, staticBody, anchorA, anchorB))
	space.AddConstraint(New cpDampedRotarySpring.Create(body1, body2, 0.0, 3000.0, 60.0))
	
'	// Rotary Limit Joint
	boxOffset = Vec2(0, 120)
	body1 = addLever(space, posA, boxOffset)
	body2 = addLever(space, posB, boxOffset)
'	// Add some pin joints to hold the circles in place.
    anchorA = boxOffset.Add(posA).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(posA).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, staticBody, anchorA, anchorB))
    anchorA = boxOffset.Add(posB).Sub(body2.GetPosition())
    anchorB = boxOffset.Add(posB).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body2, staticBody, anchorA, anchorB))
'	// Hold their rotation within 90 degrees of each other.
	space.AddConstraint(New CPRotaryLimitJoint.Create(body1, body2, -Pi / 2.0, Pi / 2.0))
	
'	// Ratchet Joint - A rotary ratchet, like a socket wrench
	boxOffset = Vec2(160, 120)
	body1 = addLever(space, posA, boxOffset)
	body2 = addLever(space, posB, boxOffset)
'	// Add some pin joints to hold the circles in place.
    anchorA = boxOffset.Add(posA).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(posA).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, staticBody, anchorA, anchorB))
    anchorA = boxOffset.Add(posB).Sub(body2.GetPosition())
    anchorB = boxOffset.Add(posB).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body2, staticBody, anchorA, anchorB))
'	// Ratchet every 90 degrees
	space.AddConstraint(New CPRatchetJoint.Create(body1, body2, 0.0, Pi / 2.0))
	
'	// Gear Joint - Maintain a specific angular velocity ratio
	boxOffset = Vec2(-320, 0)
	body1 = addBar(space, posA, boxOffset)
	body2 = addBar(space, posB, boxOffset)
'	// Add some pin joints to hold the circles in place.
    anchorA = boxOffset.Add(posA).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(posA).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, staticBody, anchorA, anchorB))
    anchorA = boxOffset.Add(posB).Sub(body2.GetPosition())
    anchorB = boxOffset.Add(posB).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body2, staticBody, anchorA, anchorB))
'	// Force one to sping 2x as fast as the other
	space.AddConstraint(New CPGearJoint.Create(body1, body2, 0.0, 2.0))
	
'	// Simple Motor - Maintain a specific angular relative velocity
	boxOffset = Vec2(-160, 0)
	body1 = addBar(space, posA, boxOffset)
	body2 = addBar(space, posB, boxOffset)
'	// Add some pin joints to hold the circles in place.
    anchorA = boxOffset.Add(posA).Sub(body1.GetPosition())
    anchorB = boxOffset.Add(posA).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body1, staticBody, anchorA, anchorB))
    anchorA = boxOffset.Add(posB).Sub(body2.GetPosition())
    anchorB = boxOffset.Add(posB).Sub(staticBody.GetPosition())
	space.AddConstraint(New CPPivotJoint.Create(body2, staticBody, anchorA, anchorB))
'	// Make them spin at 1/2 revolution per second in relation to each other.
	space.AddConstraint(New CPSimpleMotor.Create(body1, body2, Pi))
	
'	// Make a car with some nice soft suspension
	boxOffset = Vec2(0, 0)
	Local wheel1:CPBody = addWheel(space, posA, boxOffset)
	Local wheel2:CPBody = addWheel(space, posB, boxOffset)
	Local chassis:CPBody = addChassis(space, Vec2(80, -100), boxOffset)
	
	space.AddConstraint(New CPGrooveJoint.Create(chassis, wheel1, Vec2(-30, 10), Vec2(-30, 40), CPVZero))
	space.AddConstraint(New CPGrooveJoint.Create(chassis, wheel2, Vec2(30, 10), Vec2(30, 40), CPVZero))
	
	space.AddConstraint(New CPDampedSpring.Create(chassis, wheel1, Vec2(-30, 0), CPVZero, 50.0, 20.0, 10.0))
	space.AddConstraint(New CPDampedSpring.Create(chassis, wheel2, Vec2(30, 0), CPVZero, 50.0, 20.0, 10.0))
	
    Return space
End Function

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Joints:ChipmunkDemo = New ChipmunkDemo( ..
	"Joints and Constraints",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 12)
