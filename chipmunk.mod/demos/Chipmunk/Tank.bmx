
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
Framework brl.StandardIO
Import brl.Max2D
Import brl.d3d9max2d
Import brl.random
Import brl.math
Import brl.Color

' Import Chipmunk library
Import hot.chipmunk

Import "ChipmunkDemoTextSupport.bmx"

Include "ChipmunkDemo.bmx"
Include "ChipmunkDebugDraw.bmx"

Global tankBody:CPBody = Null
Global tankControlBody:CPBody = Null

Function UpdateSpace(space:CPSpace, dt:Double)
    ' Turn the control body based on the angle relative to the actual body
    Local mouseDelta:CPVect = ChipmunkDemoMouse.Sub(tankBody.GetPosition())
    Local turn:Double = tankBody.GetRot().UnRotate(mouseDelta).ToAngle()
    tankControlBody.SetAngle(tankBody.GetAngle() - turn)
    
    ' Drive the tank towards the mouse
    If ChipmunkDemoMouse.near(tankBody.GetPosition(), 30.0)
	Local isnear:Int = ChipmunkDemoMouse.near(tankBody.GetPosition(), 30.0)
	DebugStop
        tankControlBody.SetVelocity(CPVZero) ' Stop
    Else
        Local Direction:Double
		If(mouseDelta.Dot(tankBody.GetRot()) > 0.0) Then Direction = 1.0 Else Direction = -1.0
        tankControlBody.SetVelocity(tankBody.GetRot().Rotate(Vec2(30.0 * Direction, 0.0)))
    End If
    
	space.DoStep(dt)
End Function

Function AddBox:CPBody(space:CPSpace, Size:Double, mass:Double)
    Local radius:Double = Vec2(Size, Size).Length()
    Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Size, Size))
	space.AddBody(body)
    Body.SetPosition(Vec2(Rnd() * (640.0 - 2.0 * radius) - (320.0 - radius), -(Rnd() * (480.0 - 2.0 * radius) - (240.0 - radius))))
    
	Local shape:CPPolyShape = New CPPolyShape.BoxShapeCreate(body, Size, Size, 0.0)
    space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
    
    Return body
End Function

Function InitSpace:CPSpace()
    ChipmunkDemoMessageString = "Use the mouse to drive the tank, it will follow the cursor."
    
	init()
    space.SetIterations(10)
    space.SetSleepTimeThreshold(0.5)
    
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
    ' Create segments around the edge of the screen.
	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320.0, 240.0), Vec2(-320.0, -240.0), 0.0)
    space.AddShape(Shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(320.0, 240.0), Vec2(320.0, -240.0), 0.0)
    space.AddShape(Shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320.0, 240.0), Vec2(320.0, 240.0), 0.0)
    space.AddShape(Shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320.0, -240.0), Vec2(320.0, -240.0), 0.0)
    space.AddShape(Shape)
    Shape.SetElasticity(1.0)
    Shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

    For Local i:Int = 0 Until 50
        Local body:CPBody = AddBox(space, 20.0, 1.0)
        
		Local pivot:CPPivotJoint = New CPPivotJoint.Create(staticBody, body, CPVZero, CPVZero)
        space.AddConstraint(pivot)
        pivot.SetMaxBias(0) ' Disable joint correction
        pivot.SetMaxForce(1000.0) ' Emulate linear friction
        
		Local gear:cpgearjoint = New CPGearJoint.Create(staticBody, body, 0.0, 1.0)
        space.AddConstraint(gear)
        gear.SetMaxBias(0) ' Disable joint correction
        gear.SetMaxForce(5000.0) ' Emulate angular friction
    Next
    
    ' We joint the tank to the control body and control the tank indirectly by modifying the control body.
	tankControlBody = New CPBody.CreateKinematic()
    space.AddBody(tankControlBody)
    tankBody = AddBox(space, 30.0, 10.0)
    
	Local pivot:CPPivotJoint = New CPPivotJoint.Create(tankControlBody, tankBody, CPVZero, CPVZero)
    space.AddConstraint(pivot)
    pivot.SetMaxBias(0) ' Disable joint correction
    pivot.SetMaxForce(10000.0) ' Emulate linear friction
    
	Local gear:CPGearJoint = New CPGearJoint.Create(tankControlBody, tankBody, 0.0, 1.0)
    space.AddConstraint(gear)
    gear.SetErrorBias(0) ' Attempt to fully correct the joint each step
    gear.SetMaxBias(1.2)  ' But limit its angular correction rate
    gear.SetMaxForce(50000.0) ' Emulate angular friction
    
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

Global Tank:ChipmunkDemo = New ChipmunkDemo( ..
	"Tank",  ..
	1.0 / 60.0,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 13)

    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
