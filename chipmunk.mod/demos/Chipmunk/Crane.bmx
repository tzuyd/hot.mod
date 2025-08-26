
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

Global HOOK_SENSOR:size_t = 1
Global CRATE:size_t = 2

Global dollyBody:CPBody = Null
'// Constraint used as a servo motor to move the dolly back and forth.
Global dollyServo:CPPivotJoint = Null

'// Constraint used as a winch motor to lift the load.
Global winchServo:CPSlideJoint = Null

'// Temporary joint used to hold the hook to the load.
Global hookJoint:CPPivotJoint = Null


Function updateSpace(space:CPSpace, dt:Double)
'	// Set the first anchor point (the one attached to the static body) of the dolly servo to the mouse's x position.
    dollyServo.SetAnchorA(Vec2(ChipmunkDemoMouse.x, -100))
    
'	// Set the max length of the winch servo to match the mouse's height.
    winchServo.SetMax(Max(100 + ChipmunkDemoMouse.y, 50))
    
    If hookJoint <> Null And ChipmunkDemoRightClick
        hookJoint.Free()
        hookJoint = Null
		ChipmunkDemoRightClick = 0
    End If
    
	space.DoStep(dt)
End Function

Function AttachHook(spaceptr:Byte ptr, Hook:Object, crate:Object)
    Local anchorA:CPVect = CPBody(Hook).GetPosition().Sub(CPBody(Hook).GetPosition())
    Local anchorB:CPVect = CPBody(Hook).GetPosition().Sub(CPBody(crate).GetPosition())
	hookJoint = New CPPivotJoint.Create(CPBody(Hook), CPBody(crate), anchorA, anchorB)
    space.AddConstraint(hookJoint)
End Function

Function HookCrate:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoefficient:Float, Data:Object)
    If hookJoint = Null
'		// Get pointers to the two bodies in the collision pair and define local variables for them.
'		// Their order matches the order of the collision types passed
'		// to the collision handler this function was defined for
        Local Hook:CPBody = Shapea.GetBody()
        Local crate:CPBody = Shapeb.GetBody()
        
'		// additions and removals can't be done in a normal callback.
'		// Schedule a post step callback to do it.
'		// Use the hook as the key and pass along the arbiter.
        space.AddPostStepCallback(AttachHook, Hook, crate)
    End If
    
    Return True ' return value is ignored for sensor callbacks anyway
End Function


Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "Control the crane by moving the mouse. Right click to release."
    
	space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 100))
    space.SetDamping(0.8)
    
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPCircleShape
    
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)
    
'	// Add a body for the dolly.
	dollyBody = New CPBody.Create(10, INFINITY)
    space.AddBody(dollyBody)
    dollyBody.SetPosition(Vec2(0, -100))
    
'	// Add a block so you can see it.
    space.AddShape(New CPBoxShape.Create(dollyBody, 30, 30, 0.0))
    
'	// Add a groove joint for it to move back and forth on.
    space.AddConstraint(New CPGrooveJoint.Create(staticBody, dollyBody, Vec2(-250, -100), Vec2(250, -100), CPVZero))
    
'	// Add a pivot joint to act as a servo motor controlling it's position
'	// By updating the anchor points of the pivot joint, you can move the dolly.
    Local anchorA:CPVect = dollyBody.GetPosition().Sub(staticBody.GetPosition())
    Local anchorB:CPVect = dollyBody.GetPosition().Sub(dollyBody.GetPosition())
	dollyServo = New CPPivotJoint.Create(staticBody, dollyBody, anchorA, anchorB)
	space.AddConstraint(dollyServo)
'	// Max force the dolly servo can generate.
    dollyServo.SetMaxForce(10000)
'	// Max speed of the dolly servo
    dollyServo.SetMaxBias(100)
'	// You can also change the error bias to control how it slows down.
'	dollyServo.SetErrorBias(0.2)
 
   
'	// Add the crane hook.
	Local hookBody:CPBody = New CPBody.Create(1, INFINITY)
    space.AddBody(hookbody)
    hookBody.SetPosition(Vec2(0, -50))
    
'	// Add a sensor shape for it. This will be used to figure out when the hook touches a box.
	Shape = New CPCircleShape.Create(hookBody, 10, CPVZero)
    space.AddShape(shape)
    Shape.SetSensor(True)
    Shape.SetCollisionType(HOOK_SENSOR)
    
'	// Add a slide joint to act as a winch motor
'	// By updating the max length of the joint you can make it pull up the load.
	winchServo = New CPSlideJoint.Create(dollyBody, hookBody, CPVZero, CPVZero, 0, INFINITY)
    space.AddConstraint(winchServo)
'	// Max force the dolly servo can generate.
    winchServo.SetMaxForce(30000)
'	// Max speed of the dolly servo
    winchServo.SetMaxBias(60)
    
'	// TODO: cleanup
'	// Finally a box to play with
    Local boxBody:CPBody = New CPBody.Create(30, MomentForBox(30, 50, 50))
	space.AddBody(boxbody)
    boxBody.SetPosition(Vec2(200, 200))
    
'	// Add a block so you can see it.
	Local polyshap:CPPolyShape = New cpBoxShape.Create(boxBody, 50, 50, 0.0)
    space.AddShape(polyshap)
    polyshap.SetFriction(0.7)
    polyshap.SetCollisionType(CRATE)
    
    space.AddCollisionPairFunc(HOOK_SENSOR, CRATE, HookCrate)
    
	
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Crane:ChipmunkDemo = New chipmunkdemo( ..
	"Crane",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 15)
