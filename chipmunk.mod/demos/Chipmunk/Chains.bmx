
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

Const CHAIN_COUNT:Int = 8
Const LINK_COUNT:Int = 10

Function BreakablejointPostStepRemove(spaceptr:Byte ptr, joint:Object, unused:Object)
    CPConstraint(joint).Free()
End Function

Function BreakableJointPostSolve(joint:Byte ptr, spaceptr:Byte ptr)
    Local dt:Double = cpSpaceGetCurrentTimeStep(spaceptr)
    
    ' Convert the impulse to a force by dividing it by the timestep.
    Local force:Double = cpconstraintGetImpulse(joint) / dt
    Local maxForce:Double = cpconstraintGetMaxForce(joint)

    ' If the force is almost as big as the joint's max force, break it.
    If force > 0.9 * maxForce Then
		Local jointobj:CPConstraint = New CPConstraint
		jointobj.cpobjectptr = joint
		jointobj.parent = space
        bmx_cpspace_addpoststepcallback(spaceptr, BreakablejointPostStepRemove, jointobj, Null)
    End If
End Function

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function InitSpace:CPSpace()
	space = New CPSpace.Create()
	space.SetIterations(30)
    space.SetGravity(Vec2(0, 100))
    space.SetSleepTimeThreshold(0.5)
    
    Local body:CPBody, staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPCircleShape
    
    ' Create segments around the edge of the screen.
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

	segshap = New CPSegmentShape.Create(staticBody, Vec2(-320, -240), Vec2(320, -240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)

    Local mass:Double = 1
    Local Width:Double = 20
    Local Height:Double = 30
    
    Local spacing:Double = Width * 0.3
    
    ' Add lots of boxes.
    For Local i:Int = 0 To CHAIN_COUNT - 1
        Local prev:CPBody = Null
        
        For Local j:Int = 0 To LINK_COUNT - 1
            Local Pos:CPVect = Vec2(40 * (i - (CHAIN_COUNT - 1) / 2.0), -(240 - (j + 0.5) * Height - (j + 1) * spacing))
            
			body = New CPBody.Create(mass, MomentForBox(mass, Width, Height))
            space.AddBody(body)
            body.SetPosition(Pos)
            
			segshap = New CPSegmentShape.Create(body, Vec2(0, -((Height - Width) / 2.0)), Vec2(0, -((Width - Height) / 2.0)), Width / 2.0)
            space.AddShape(segshap)
            segshap.SetFriction(0.8)
            
            Local breakingForce:Double = 80000
            
            Local constraint:CPSlideJoint = Null
            If prev = Null
				constraint = New CPSlideJoint.Create(body, staticBody, Vec2(0, -(Height / 2)), Vec2(Pos.x, -240), 0, spacing)
                space.AddConstraint(constraint)
            Else
				constraint = New CPSlideJoint.Create(body, prev, Vec2(0, -(Height / 2)), Vec2(0, -(-Height / 2)), 0, spacing)
                space.AddConstraint(constraint)
            End If

            constraint.SetMaxForce(breakingForce)
            constraint.SetPostSolveFunc(BreakableJointPostSolve)
            constraint.SetCollideBodies(False)
            
            prev = body
        Next
    Next
    
    Local radius:Double = 15.0
	body = New CPBody.Create(10.0, MomentForCircle(10.0, 0.0, radius, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(0, -(-240 + radius + 5)))
    body.SetVelocity(Vec2(0, -300))

	shape = New CPCircleShape.Create(body, radius, CPVZero)
    space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.9)
    
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Chains:ChipmunkDemo = New ChipmunkDemo( ..
	"Breakable Chains",  ..
	1.0 / 180.0,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 14)
