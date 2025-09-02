
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

Const numBalls:Int = 5
Global balls:CPBody[numBalls]

Global motor:CPSimpleMotor

Function UpdateSpace(space:CPSpace, dt:Double)
    Local coef:Double = (2.0 + ChipmunkDemoKeyboard.y) / 3.0
    Local rate:Double = -ChipmunkDemoKeyboard.x * 30.0 * coef
    
    motor.SetRate(rate)
	If rate
	    motor.SetMaxForce(1000000.0)
	Else
	    motor.SetMaxForce(0.0)
	End If

	space.DoStep(dt)

    For Local i:Int = 0 Until numBalls
        Local ball:CPBody = balls[i]
        Local Pos:CPVect = ball.GetPosition()
        
        If pos.x > 320.0
            ball.SetVelocity(CPVZero)
            ball.SetPosition(Vec2(-224.0, -200.0))
        EndIf
    Next
End Function

Function AddBall:CPBody(space:CPSpace, pos:CPVect)
    Local body:CPBody = New CPBody.Create(1.0, MomentForCircle(1.0, 30, 0, CPVZero))
	Space.AddBody(body)
    body.SetPosition(Pos)
    
    Local shape:CPCircleShape = New CPCircleShape.Create(body, 30, CPVZero)
	Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    
    Return body
End Function

Function InitSpace:CPSpace()
    ChipmunkDemoMessageString = "Use the arrow keys to control the machine."
    
    space = New CPSpace.Create()
    Space.SetGravity(Vec2(0, 600))
    
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
    ' Beveling all of the line segments slightly helps prevent things from getting stuck on cracks
    shape = New CPSegmentShape.Create(staticBody, Vec2(-256, -16), Vec2(-256, -300), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-256, -16), Vec2(-192, 0), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-192, 0), Vec2(-192, 64), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-128, 64), Vec2(-128, -144), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-192, -80), Vec2(-192, -176), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-192, -176), Vec2(-128, -240), 2.0)
    Space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
    shape = New CPSegmentShape.Create(staticBody, Vec2(-128, -144), Vec2(192, -64), 2.0)
    space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.5)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
    
	Local verts:CPVect[] = [ ..
		Vec2(-30, 80),  ..
		Vec2(-30, -80),  ..
		Vec2(30, -64),  ..
		Vec2(30, 80) ..
	]

	Local plunger:CPBody = New CPBody.Create(1.0, INFINITY)
	plunger.SetPosition(Vec2(-160, 80))
	Space.AddBody(plunger)
	plunger.SetAngle(0.0)      ' force transform rebuild
	
	Local polyshap:CPPolyShape = New CPPolyShape.Create(plunger, verts, CPVZero, 0.0)
	Space.AddShape(polyshap)
	polyShap.SetElasticity(1.0)
	polyShap.SetFriction(0.5)
	polyShap.setFilter(1)
	
    ' Add balls to hopper
    For Local i:Int = 0 Until numBalls
        balls[i] = AddBall(space, Vec2(-224 + i, -(80 + 64 * i)))
    Next
    
'	/ / Add small gear
	Local smallGear:CPBody = New CPBody.Create(10.0, MomentForCircle(10.0, 80, 0, CPVZero))
	Space.AddBody(smallgear)
	smallgear.SetPosition(Vec2(-160, 160))
	smallGear.SetAngle(CP_PI / 2.0)

	Local circshap:CPCircleShape = New CPCircleShape.Create(smallGear, 80.0, CPVZero)
	Space.AddShape(circshap)
	circshap.setFilter(CP_SHAPE_FILTER_NONE)
	
	Space.AddConstraint(New CPPivotJoint.Create(staticBody, smallGear, Vec2(-160, 160), CPVZero))

'	// add big gear
	Local bigGear:CPBody = New CPBody.Create(40.0, MomentForCircle(40.0, 160, 0, CPVZero))
	Space.AddBody(biggear)
	biggear.SetPosition(Vec2(80, 160))
	bigGear.SetAngle(Pi / 2.0)
	
	circshap = New CPCircleShape.Create(bigGear, 160.0, CPVZero)
	Space.AddShape(circshap)
	circshap.setFilter(CP_SHAPE_FILTER_NONE)
	
	Space.AddConstraint(New CPPivotJoint.Create(staticBody, bigGear, Vec2(80, 160), CPVZero))

'	// connect the plunger to the small gear.
	Local tmppin:CPPinJoint = New CPPinJoint.Create(smallGear, plunger, Vec2(80, 0), Vec2(0, 0))
	space.AddConstraint(tmppin)
'	// connect the gears.
	space.AddConstraint(New CPGearJoint.Create(smallGear, bigGear, -Pi / 2.0, -2.0))
	
	
'	// feeder mechanism
	Local bottom:Double = -300.0
	Local Top:Double = 32.0
	Local feeder:CPBody = New CPBody.Create(1.0, MomentForSegment(1.0, Vec2(-224.0, -bottom), Vec2(-224.0, -Top), 0.0))
	feeder.SetPosition(Vec2(-224, -((bottom + Top) / 2.0)))
	Space.AddBody(feeder)
	feeder.SetAngle(0.0)      ' force transform rebuild
	
	Local Leng:Double = Top - bottom
	shape = New CPSegmentShape.Create(feeder, Vec2(0.0, -(Leng / 2.0)), Vec2(0.0, -(-Leng / 2.0)), 20.0)
	Space.AddShape(shape)
	Shape.setFilter(GRAB_FILTER)
	
	space.AddConstraint(New CPPivotJoint.Create(staticBody, feeder, Vec2(-224.0, -bottom), Vec2(0.0, -(-Leng / 2.0))))
	Local anchr:CPVect = feeder.World2Local(Vec2(-224, 160.0))
	space.AddConstraint(New CPPinJoint.Create(feeder, smallGear, anchr, Vec2(0.0, -80.0)))

    ' Motorize the second gear
    motor = New CPSimpleMotor.Create(staticBody, bigGear, 3.0)
	Space.AddConstraint(motor)
    
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Local Pump:ChipmunkDemo = New chipmunkdemo( ..
	"Pump",  ..
	1.0 / 120.0,  ..
	..
	initSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 8)
