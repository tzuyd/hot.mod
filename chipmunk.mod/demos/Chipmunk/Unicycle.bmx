
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

Const DEG_TO_RAD:Double = Pi / 180.0

Global balance_body:cpBody
Global balance_sin:Double = 0.0
'Global last_v:Double = 0.0

Global wheel_body:CPBody
Global motor:CPSimpleMotor = New CPSimpleMotor

Rem
	TODO:
	- Clamp max angle dynamically based on output torque.
EndRem


Function bias_coef:Double(errorBias:Double, dt:Double) inline
    Return 1.0 - (errorBias ^ dt)
End Function

Function motor_preSolve(motorptr:Byte ptr, unused:Byte ptr)
'    Local motor:CPSimpleMotor = cpsimplemotor(cpfind(motorptr))
    Local dt:Double = Space.GetCurrentTimeStep()

    Local target_x:Double = ChipmunkDemoMouse.x
    bmx_drawsegment(Vec2(target_x, 1000.0), Vec2(target_x, -1000.0), New scolor8(255, 0, 0, 255))
    
    Local max_v:Double = 500.0
    Local target_v:Double = Clamp(bias_coef(0.5, dt / 1.2) * (target_x - balance_body.GetPosition().x) / dt, -max_v, max_v)
    Local error_v:Double = (target_v - balance_body.GetVelocity().x)
    Local target_sin:Double = 3.0E-3 * bias_coef(0.1, dt) * error_v / dt
    
    Local max_sin:Double = Sin(0.6 * DEG_TO_RAD) ' Convert to radians
    balance_sin = Clamp(balance_sin - 6.0E-5 * bias_coef(0.2, dt) * error_v / dt, -max_sin, max_sin)
    Local target_a:Double = ASin(Clamp(-target_sin + balance_sin, -max_sin, max_sin))
    Local angular_diff:Double = ASin(balance_body.GetRot().Cross(CPVect.ForAngle(target_a)))
    Local target_w:Double = bias_coef(0.1, dt / 0.4) * (angular_diff) / dt
    
    Local max_rate:Double = 50.0
    Local rate:Double = Clamp(wheel_body.GetAngularVelocity() + balance_body.GetAngularVelocity() - target_w, -max_rate, max_rate)
    motor.SetRate Clamp(rate, -max_rate, max_rate)
    motor.SetMaxForce(8.0e4)
End Function

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "This unicycle is completely driven and balanced by a single cpSimpleMotor.~nMove the mouse to make the unicycle follow it."
    ChipmunkDemoMessageString:+"~nThis demo is broken.  Fix it"
	
	space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 500))

    ' Create static shapes
    Local staticBody:CPBody = space.GetStaticBody()
    Local shape:CPCircleShape = Null
    
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(staticBody, Vec2(-3200, 240), Vec2(3200, 240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)

	segshap = New CPSegmentShape.Create(staticBody, Vec2(0, 200), Vec2(240, 240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)

	segshap = New CPSegmentShape.Create(staticBody, Vec2(-240, 240), Vec2(0, 200), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)

    ' Create the wheel body
    Local radius:Double = 20.0
    Local mass:Double = 1.0
	
    Local moment:Double = MomentForCircle(mass, 0.0, radius, CPVZero)
    wheel_body = New CPBody.Create(mass, moment)
    space.AddBody(wheel_body)
    wheel_body.SetPosition(Vec2(0.0, -(-160.0 + radius)))
	
    shape = New CPCircleShape.Create(wheel_body, radius, CPVZero)
    space.AddShape(shape)
    shape.SetFriction(0.7)
    shape.setFilter(CP_ALL_CATEGORIES)
    shape.SetGroup(1)
	
    ' Create the balance body
    Local cog_offset:Double = 30.0
	
    Local bb1:CPBB = New CPBB.Create(-5.0, -(0.0 - cog_offset), 5.0, -(cog_offset * 1.2 - cog_offset))
    Local bb2:CPBB = New CPBB.Create(-25.0, -(bb1.t), 25.0, -(bb1.t + 10.0))
	
    mass = 3.0
    moment = MomentForBox(mass, bb1) + MomentForBox(mass, bb2)
	
    balance_body = New CPBody.Create(mass, moment)
    space.AddBody(balance_body)
    balance_body.SetPosition(Vec2(0.0, wheel_body.GetPosition().y - cog_offset))
	
	Local polyshap:CPPolyShape = New cpBoxShape.Create(balance_body, bb1, 0.0)
    space.AddShape(polyshap)
    polyshap.SetFriction(1.0)
    polyshap.setFilter(CP_ALL_CATEGORIES)
    polyshap.SetGroup(1)
	
	polyshap = New CPBoxShape.Create(balance_body, bb2, 0.0)
	space.AddShape(polyshap)
    polyshap.SetFriction(1.0)
    polyshap.setFilter(CP_ALL_CATEGORIES)
	polyshap.SetGroup(1)
    
    Local anchorA:CPVect = balance_body.World2Local(wheel_body.GetPosition())
    Local groove_a:CPVect = anchorA.Add(Vec2(0.0, -30.0))
    Local groove_b:CPVect = anchorA.Add(Vec2(0.0, 10.0))
    space.AddConstraint(New CPGrooveJoint.Create(balance_body, wheel_body, groove_a, groove_b, CPVZero))
    space.AddConstraint(New CPDampedSpring.Create(balance_body, wheel_body, anchorA, CPVZero, 0.0, 6.0e2, 30.0))
    
    motor = New CPSimpleMotor.Create(wheel_body, balance_body, 0.0)
	space.AddConstraint(motor)
    motor.SetPreSolveFunc(motor_preSolve)
    
    ' Create a box shape
    Local Width:Double = 100.0
    Local Height:Double = 20.0
    mass = 3.0
	
    Local boxBody:CPBody = New CPBody.Create(mass, MomentForBox(mass, Width, Height))
	space.AddBody(boxBody)
    boxBody.SetPosition(Vec2(200, 100))
	
	polyshap = New CPBoxShape.Create(boxBody, Width, Height, 0.0)
    space.AddShape(polyshap)
    polyshap.SetFriction(0.7)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

Global Unicycle:ChipmunkDemo = New ChipmunkDemo( ..
    "Unicycle",  ..
    1.0 / 60.0,  ..
	..
    initSpace,  ..
    updateSpace,  ..
    ChipmunkDemoDefaultDrawImpl,  ..
    destroySpace ..
, 21)
