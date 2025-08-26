
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

Const COLLISION_TYPE_ONE_WAY:Int = 1

Function PreSolve:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoefficient:Float, Data:Object)
    Local drawOptions:bmx_drawoptions = New bmx_drawoptions
    drawOptions.collisionPointColor = New SColor8(255, 0, 0, 255)	' Collision point color
    bmx_drawcollisionpoints(shapeA.GetBody(), Data, drawOptions)
    
    Local shapeBVelocity:CPVect = shapeB.GetBody().VelocityAtWorldPoint(shapeB.GetBody().GetPosition())
    
    If shapeBVelocity.y < 0  ' -- Assuming downward velocity is positive
        Return False  ' -- Moving upward, prevent collision
    EndIf

    Return True  ' -- Default to allow collision
End Function

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "One way platforms are trivial in Chipmunk using a very simple collision callback."
    
	space = New CPSpace.Create()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, 100))

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
    
    ' Add our one way segment
	segshap = New CPSegmentShape.Create(staticBody, Vec2(-160, 100), Vec2(160, 100), 10.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.SetCollisionType(COLLISION_TYPE_ONE_WAY)
    segshap.setFilter(NOT_GRABBABLE_FILTER)
    
    ' Add a ball to test it out
    Local radius:Double = 15.0
	body = New CPBody.Create(10.0, MomentForCircle(10.0, 0.0, radius, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(0, 200))
    body.SetVelocity(Vec2(0, -170))
    
	shape = New CPCircleShape.Create(body, radius, CPVZero)
    space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.9)
    shape.SetCollisionType(2)
    
    space.AddWildcardFunc(COLLISION_TYPE_ONE_WAY, Null, New cpArbiter, PreSolve)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global OneWayPlatforms:ChipmunkDemo = New ChipmunkDemo( ..
    "One Way Platforms",  ..
    1.0 / 60.0,  ..
    initSpace,  ..
    updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
    destroySpace ..
, 11)
