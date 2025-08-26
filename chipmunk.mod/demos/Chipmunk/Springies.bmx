
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

Function springForce:Double(springptr:Byte ptr, Dist:Double)
	Local Clmp:Double = 20.0
	Local spring:CPDampedSpring = CPDampedSpring(cpfind(springptr))
	Return Clamp(spring.GetRestLength() - Dist, -Clmp, Clmp) * spring.GetStiffness()
End Function

Function new_spring:CPDampedSpring(a:CPBody, b:CPBody, anchorA:CPVect, anchorB:CPVect, restLength:Double, stiff:Double, damp:Double)
	Local spring:CPDampedSpring = New CPDampedSpring.Create(a, b, anchorA, anchorB, restLength, stiff, damp)
	spring.SetSpringForceFunc(springForce)
	
	Return spring
End Function

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function AddBar:cpBody(space:cpSpace, a:cpVect, b:cpVect, group:Int)
	Local center:CPVect = a.Add(b).Mult(1.0 / 2.0)
	Local Length:Double = b.Sub(a).Length()
	Local mass:Double = Length / 160.0
	 
	Local body:CPBody = New CPBody.Create(mass, mass * Length * Length / 12.0)
	space.AddBody(body)
	body.SetPosition(center)
	
	Local shape:CPSegmentShape = New CPSegmentShape.Create(body, a.Sub(center), b.Sub(center), 10.0)
	space.AddShape(shape)
	shape.setFilter(CP_ALL_CATEGORIES)
	shape.SetGroup(group)
	
	Return body
End Function

Function InitSpace:CPSpace()
	space = New CPSpace.Create()
	Local staticBody:CPBody = Space.GetStaticBody()
	
	Local body1:CPBody = AddBar(space, Vec2(-240, -160), Vec2(-160, -80), 1)
	Local body2:CPBody = AddBar(space, Vec2(-160, -80), Vec2(-80, -160), 1)
	Local body3:CPBody = AddBar(space, Vec2(0, -160), Vec2(80, 0), 0)
	Local body4:CPBody = AddBar(space, Vec2(160, -160), Vec2(240, -160), 0)
	Local body5:CPBody = AddBar(space, Vec2(-240, 0), Vec2(-160, 80), 2)
	Local body6:CPBody = AddBar(space, Vec2(-160, 80), Vec2(-80, 0), 2)
	Local body7:CPBody = AddBar(space, Vec2(-80, 0), Vec2(0, 0), 2)
	Local body8:CPBody = AddBar(space, Vec2(0, 80), Vec2(80, 80), 0)
	Local body9:CPBody = AddBar(space, Vec2(240, -80), Vec2(160, 0), 3)
	Local body10:CPBody = AddBar(space, Vec2(160, 0), Vec2(240, 80), 3)
	Local body11:CPBody = AddBar(space, Vec2(-240, 80), Vec2(-160, 160), 4)
	Local body12:CPBody = AddBar(space, Vec2(-160, 160), Vec2(-80, 160), 4)
	Local body13:CPBody = AddBar(space, Vec2(0, 160), Vec2(80, 160), 0)
	Local body14:CPBody = AddBar(space, Vec2(160, 160), Vec2(240, 160), 0)
	
	space.AddConstraint(New CPPivotJoint.Create(body1, body2, Vec2(40, 40), Vec2(-40, 40)))
	space.AddConstraint(New CPPivotJoint.Create(body5, body6, Vec2(40, 40), Vec2(-40, 40)))
	space.AddConstraint(New CPPivotJoint.Create(body6, body7, Vec2(40, -40), Vec2(-40, 0)))
	space.AddConstraint(New CPPivotJoint.Create(body9, body10, Vec2(-40, 40), Vec2(-40, -40)))
	space.AddConstraint(New CPPivotJoint.Create(body11, body12, Vec2(40, 40), Vec2(-40, 0)))
	
	Local stiff:Double = 100.0
	Local damp:Double = 0.5
	space.AddConstraint(new_spring(staticBody, body1, Vec2(-320, -240), Vec2(-40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body1, Vec2(-320, -80), Vec2(-40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body1, Vec2(-160, -240), Vec2(-40, -40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body2, Vec2(-160, -240), Vec2(40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body2, Vec2(0, -240), Vec2(40, -40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body3, Vec2(80, -240), Vec2(-40, -80), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body4, Vec2(80, -240), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body4, Vec2(320, -240), Vec2(40, 0), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body5, Vec2(-320, -80), Vec2(-40, -40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body9, Vec2(320, -80), Vec2(40, -40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body10, Vec2(320, 0), Vec2(40, 40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body10, Vec2(320, 160), Vec2(40, 40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body11, Vec2(-320, 160), Vec2(-40, -40), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body12, Vec2(-240, 240), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body12, Vec2(0, 240), Vec2(40, 0), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body13, Vec2(0, 240), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body13, Vec2(80, 240), Vec2(40, 0), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(staticBody, body14, Vec2(80, 240), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body14, Vec2(240, 240), Vec2(40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(staticBody, body14, Vec2(320, 160), Vec2(40, 0), 0.0, stiff, damp))
	
	space.AddConstraint(new_spring(body1, body5, Vec2(40, 40), Vec2(-40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body1, body6, Vec2(40, 40), Vec2(40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body2, body3, Vec2(40, -40), Vec2(-40, -80), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body4, Vec2(-40, -80), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body4, Vec2(40, 80), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body7, Vec2(40, 80), Vec2(40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body7, Vec2(-40, -80), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body8, Vec2(40, 80), Vec2(40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body3, body9, Vec2(40, 80), Vec2(-40, 40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body4, body9, Vec2(40, 0), Vec2(40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body5, body11, Vec2(-40, -40), Vec2(-40, -40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body5, body11, Vec2(40, 40), Vec2(40, 40), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body7, body8, Vec2(40, 0), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body8, body12, Vec2(-40, 0), Vec2(40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body8, body13, Vec2(-40, 0), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body8, body13, Vec2(40, 0), Vec2(40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body8, body14, Vec2(40, 0), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body10, body14, Vec2(40, 40), Vec2(-40, 0), 0.0, stiff, damp))
	space.AddConstraint(new_spring(body10, body14, Vec2(40, 40), Vec2(-40, 0), 0.0, stiff, damp))
	
	Return space
End Function

Function DestroySpace(space:CPSpace)
	ChipmunkDemoFreeSpaceChildren(space)
	space.Free()
End Function

Global SpringiesDemo:ChipmunkDemo = New ChipmunkDemo( ..
	"Springies",  ..
	1.0 / 60.0,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 7)
