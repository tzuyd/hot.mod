
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
End Rem

Rem
	Previous WalkBot demo was fairly disappointing, so I implemented
	the mechanism that Theo Jansen uses in his kinetic sculptures. Brilliant.
	Read more here: http://en.wikipedia.org/wiki/Theo_Jansen
End Rem

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

Global motor:CPsimplemotor

Function updateSpace(space:CPSpace, dt:Double)
    Local coef:Double = (2.0 - ChipmunkDemoKeyboard.y) / 3.0
    Local rate:Double = -ChipmunkDemoKeyboard.x * 10.0 * coef
    motor.SetRate(rate)
	If rate Then
	    motor.SetMaxForce(100000.0)
	Else
	    motor.SetMaxForce(0.0)
	EndIf
	space.DoStep(dt)
End Function

Global seg_radius:Double = 3.0

Function make_leg(space:CPSpace, side:Double, offset:Double, chassis:CPBody, crank:CPBody, anchor:CPVect)
    Local a:CPVect, b:CPVect
    Local shape:CPCircleShape
    
    Local leg_mass:Double = 1.0

'	// make leg
    a = CPVZero
	b = Vec2(0.0, -side)
    Local upper_leg:CPBody = New CPBody.Create(leg_mass, MomentForSegment(leg_mass, a, b, 0.0))
	space.AddBody(upper_leg)
    upper_leg.SetPosition(Vec2(offset, 0.0))
    
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(upper_leg, a, b, seg_radius)
    space.AddShape(segshap)
    segshap.setFilter(CP_ALL_CATEGORIES)
    segshap.SetGroup(1)
	
    space.AddConstraint(New CPPivotJoint.Create(chassis, upper_leg, Vec2(offset, 0.0), CPVZero))
    
'	// lower leg
    a = CPVZero
	b = Vec2(0.0, 1.0 * side)
    Local lower_leg:CPBody = New CPBody.Create(leg_mass, MomentForSegment(leg_mass, a, b, 0.0))
	space.AddBody(lower_leg)
    lower_leg.SetPosition(Vec2(offset, side))
    
	segshap = New CPSegmentShape.Create(lower_leg, a, b, seg_radius)
    space.AddShape(segshap)
    segshap.setFilter(CP_ALL_CATEGORIES)
	segshap.SetGroup(1)
    
    shape = New CPCircleShape.Create(lower_leg, seg_radius * 2.0, Vec2(0, -(-side - seg_radius)))
    space.AddShape(shape)
    Shape.setFilter(CP_ALL_CATEGORIES)
	Shape.SetGroup(1)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(1.0)
    
    space.AddConstraint(New CPPinJoint.Create(chassis, lower_leg, Vec2(offset, 0), CPVZero))
    
    space.AddConstraint(New CPGearJoint.Create(upper_leg, lower_leg, 0.0, 1.0))
    
    Local constraint:CPPinJoint
    Local diag:Double = Sqr(side * side + offset * offset)
    
    constraint = New CPPinJoint.Create(crank, upper_leg, anchor, Vec2(0, -side))
    space.AddConstraint(constraint)
    constraint.SetDist(diag)
    
    constraint = New CPPinJoint.Create(crank, lower_leg, anchor, CPVZero)
    space.AddConstraint(constraint)
    constraint.SetDist(diag)
End Function

Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "Use the arrow keys to control the machine."
    
    space = New CPSpace.Create()
    space.SetIterations(20)
    space.SetGravity(Vec2(0, 500))

    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    Local a:CPVect, b:CPVect
    
'	// Create segments around the edge of the screen.
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

    Local offset:Double = 30.0

'	// make chassis
    Local chassis_mass:Double = 2.0
    a = Vec2(-offset, 0.0)
	b = Vec2(offset, 0.0)
    Local chassis:CPBody = New CPBody.Create(chassis_mass, MomentForSegment(chassis_mass, a, b, 0.0))
	space.AddBody(chassis)
    
    shape = New CPSegmentShape.Create(chassis, a, b, seg_radius)
    space.AddShape(shape)
    shape.setFilter(CP_ALL_CATEGORIES)
	shape.SetGroup(1)
    
'	// make crank
    Local crank_mass:Double = 1.0
    Local crank_radius:Double = 13
    Local crank:CPBody = New CPBody.Create(crank_mass, MomentForCircle(crank_mass, crank_radius, 0.0, CPVZero))
	space.AddBody(crank)
    
	Local circshap:CPCircleShape = New CPCircleShape.Create(crank, crank_radius, CPVZero)
    space.AddShape(circshap)
    circshap.setFilter(CP_ALL_CATEGORIES)
	circshap.SetGroup(1)
    
    space.AddConstraint(New CPPivotJoint.Create(chassis, crank, CPVZero, CPVZero))
    
    Local side:Double = 30.0
    
    Local num_legs:Int = 2
    For Local i:Int = 0 Until num_legs
        make_leg(space, side, offset, chassis, crank, New CPVect.ForAngle((2 * i + 0.0) / num_legs * Pi).Mult(crank_radius))
        make_leg(space, side, -offset, chassis, crank, New CPVect.ForAngle((2 * i + 1.0) / num_legs * Pi).Mult(crank_radius))
    Next
    
    motor = New CPSimpleMotor.Create(chassis, crank, 6.0)
    space.AddConstraint(motor)
    
    Return space
End Function

Function destroySpace(space:CPSpace Ptr)
    ChipmunkDemoFreeSpaceChildren(space)
    cpSpaceFree(space)
End Function

Global TheoJansen:ChipmunkDemo = New ChipmunkDemo( ..
	"Theo Jansen Machine",  ..
	1.0 / 180.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroyspace ..
, 9)
	