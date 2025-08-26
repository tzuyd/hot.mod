
' Copyright (c) 2007 Scott Lembcke
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.

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

Const DENSITY:Double = 1.0 / 10000.0

Type SliceContext
    Field a:CPVect
    Field b:CPVect
    Field space:CPSpace
End Type

Function ClipPoly(space:CPSpace, shape:CPPolyShape, n:CPVect, Dist:Double)
    Local body:CPBody = CPPolyShape(shape).GetBody()
	Local verts:CPVect[] = CPPolyShape(Shape).GetVerts()
    Local Count:Int = verts.Length
    Local clippedCount:Int = 0
    Local clipped:CPVect[] = New CPVect[count + 1]
    
    For Local i:Int = 0 Until count
        Local j:Int
		If i = 0 Then j = Count - 1 Else j = i - 1

        Local a:CPVect = body.Local2World(verts[j])
        Local a_dist:Double = a.Dot(n) - Dist
        
        If a_dist < 0.0 Then
            clipped[clippedCount] = a
            clippedCount :+ 1
        End If
        
        Local b:CPVect = body.Local2World(verts[i])
        Local b_dist:Double = b.Dot(n) - Dist
        
        If a_dist * b_dist < 0.0
            Local t:Double = Abs(a_dist) / (Abs(a_dist) + Abs(b_dist))
            clipped[clippedCount] = a.Lerp(b, t)
            clippedCount:+1
        End If
    Next
    
    Local centroid:CPVect = CentroidForPoly(clipped, clippedcount)
    Local mass:Double = AreaForPoly(clipped, 0.0, clippedcount) * DENSITY
    Local moment:Double = MomentForPoly(mass, clipped, centroid.Negate(), 0.0, clippedcount)
    
    Local new_body:CPBody = New CPBody.Create(mass, moment)
	space.AddBody(new_body)
    new_body.SetPosition(centroid)
    new_body.SetVelocity(body.VelocityAtWorldPoint(centroid))
    new_body.SetAngularVelocity(body.GetAngularVelocity())
    
    Local offset:CPVect = centroid.Negate()
    Local new_shape:CPPolyShape = New CPPolyShape.Create(new_body, clipped, offset, 0.0, clippedcount)
	space.AddShape(new_shape)

    ' Copy whatever properties you have set on the original shape that are important
    new_shape.SetFriction(CPPolyShape(shape).GetFriction())
End Function

Function SliceShapePostStep(space:Byte ptr, shape:Object, context:Object)
    Local a:CPVect = SliceContext(context).a
    Local b:CPVect = SliceContext(context).b
    
    ' Clipping plane normal and distance.
    Local n:CPVect = b.Sub(a).Perp().Normalize()
    Local dist:Double = a.Dot(n)
    
    ClipPoly(SliceContext(context).space, CPPolyShape(shape), n, Dist)
    ClipPoly(SliceContext(context).space, CPPolyShape(shape), n.Negate(), -Dist)
    
    Local body:CPBody = CPShape(shape).GetBody()
    CPShape(shape).Free()
	body.Free()
End Function

Function SliceQuery(shape:Object, Point:Object, Normal:Object, Alpha:Double, context:Object)
    Local a:CPVect = SliceContext(context).a
    Local b:CPVect = SliceContext(context).b
    
    ' Check that the slice was complete by checking that the endpoints aren't in the sliced shape.
    If CPShape(shape).PointQuery(a, Null) > 0.0 And CPShape(shape).PointQuery(b, Null) > 0.0
        ' Can't modify the space during a query.
        ' Must make a post-step callback to do the actual slicing.
        SliceContext(context).space.AddPostStepCallback(SliceShapePostStep, shape, context)
    End If
End Function

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
    
    Global lastDownState:Int = False
    Global sliceStart:CPVect = Vec2(0.0, 0.0)
    
    ' Annoying state tracking code that you wouldn't need
    ' in a real event driven system.
    If ChipmunkDemoRightDown <> lastDownState
        If ChipmunkDemoRightDown
            ' MouseDown
            sliceStart = ChipmunkDemoMouse
        Else
            ' MouseUp
            Local context:SliceContext = New SliceContext
            context.a = sliceStart
            context.b = ChipmunkDemoMouse
            context.space = space
            space.SegmentQuery(sliceStart, ChipmunkDemoMouse, 0.0, GRAB_FILTER, SliceQuery, context)
        End If
        
        lastDownState = ChipmunkDemoRightDown
    End If
    
    If ChipmunkDemoRightDown
        bmx_drawsegment(sliceStart, ChipmunkDemoMouse, New scolor8(255, 0, 0, 255))
    End If
End Function

Function InitSpace:CPSpace()
    ChipmunkDemoMessageString = "Right click and drag to slice up the block."
    
	space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 500))
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    Local body:CPBody, staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPPolyShape
    
    ' Create segments around the edge of the screen.
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(staticBody, Vec2(-1000, 240), Vec2(1000, 240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)
    
    Local Width:Double = 200.0
    Local height:Double = 300.0
    Local mass:Double = width * height * DENSITY
    Local moment:Double = MomentForBox(mass, Width, Height)
    
	body = New CPBody.Create(mass, moment)
    space.AddBody(body)
    
	shape = New CPBoxShape.Create(body, Width, Height, 0.0)
    space.AddShape(shape)
    shape.SetFriction(0.6)
    
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Local Slice:ChipmunkDemo = New ChipmunkDemo( ..
	"Slice.",  ..
	1.0 / 60.0,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroySpace ..
, 19)
