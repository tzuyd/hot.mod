
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

Global QUERY_START:CPVect = Vec2(0, 0)

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
    
    If ChipmunkDemoRightClick Then
		QUERY_START = ChipmunkDemoMouse
		ChipmunkDemoRightClick = False
	EndIf
    
    Local start:cpVect = QUERY_START
    Local EndPoint:CPVect = ChipmunkDemoMouse
    Local radius:Double = 10.0
    bmx_drawsegment(Start, EndPoint, New scolor8(0, 255, 0, 255))
    
	Local fmt:String = "Query: Dist(" + String(Start.dist(EndPoint)) + ") Point(" + String(EndPoint.x) + ", " + String(EndPoint.y) + "), ~n"
    
    Local segInfo:cpSegmentQueryInfo = New cpSegmentQueryInfo
	Local First:CPShape = space.SegmentQueryFirst(Start, EndPoint, radius, CP_SHAPE_FILTER_ALL, segInfo)
    If First
        Local Point:CPVect = First.GetBody().GetPosition()
        Local n:CPVect = CPVZero
'        Local Point:CPVect = New CPVect.Create(segInfo.pointx, segInfo.Pointy)
'        Local n:CPVect = New CPVect.Create(segInfo.Normalx, segInfo.Normaly)
        
        ' Draw blue over the occluded part of the query
        bmx_drawsegment(Start.Lerp(EndPoint, segInfo.Alpha), EndPoint, New SColor8(0, 0, 255, 255))
        
        ' Draw a little red surface normal
        bmx_drawsegment(Point, Point.Add(n.Mult(16)), New SColor8(255, 0, 0, 255))
        
        ' Draw a little red dot on the hit point.
        bmx_drawdot(3, Point, New SColor8(255, 0, 0, 255))

        
		fmt:+"Segment Query: Dist(" + segInfo.Alpha * Start.dist(EndPoint) + ") Normal(" + n.x + ", " + n.y + ")" ..
		+ "~nQueryInfo functionality is currently disabled"
    Else
		fmt:+"Segment Query (None)"
    End If
    ChipmunkDemoTextDrawString(Vec2(-300, -220), fmt)
    
    ' Draw a fat green line over the unoccluded part of the query
    bmx_drawfatsegment(Start, EndPoint, radius, New SColor8(0, 255, 0, 255), LAColor(0, 0),, 1)
'    bmx_drawfatsegment(Start, Start.Lerp(EndPoint, segInfo.Alpha), radius, New SColor8(0, 255, 0, 255), LAColor(0, 0),, 1)
    
    Local nearestInfo:CPPointQueryInfo = New CPPointQueryInfo
	Local nearest:CPShape = space.PointQueryNearest(ChipmunkDemoMouse, 100.0, CP_SHAPE_FILTER_ALL, nearestInfo)
    If nearest
        ' Draw a grey line to the closest shape.
        bmx_drawdot(3, ChipmunkDemoMouse, New SColor8(128, 128, 128, 255))
        bmx_drawsegment(ChipmunkDemoMouse, nearest.GetBody().GetPosition(), New SColor8(128, 128, 128, 255))
'        bmx_drawsegment(ChipmunkDemoMouse, New CPVect.Create(nearestInfo.Pointx, nearestInfo.pointY), New SColor8(128, 128, 128, 255))
' Temporary functionality until QueryInfo is working
        ' Draw a red bounding box around the shape under the mouse.
        If nearestInfo.distance = 0 Then bmx_drawbb(nearest.GetBB(), New SColor8(255, 0, 0, 255))
'        If nearestInfo.distance < 0 Then bmx_drawbb(nearest.GetBB(), New SColor8(255, 0, 0, 255))
    End If
End Function

Function InitSpace:CPSpace()
    QUERY_START = CPVZero
    
	space = New CPSpace.Create()
    space.SetIterations(5)
    
    ' add a fat segment
    Local mass:Double = 1.0
    Local length:Double = 100.0
    Local a:CPVect = Vec2(-Length / 2.0, 0.0), b:CPVect = Vec2(Length / 2.0, 0.0)
    
	Local body:CPBody = New CPBody.Create(mass, MomentForSegment(mass, a, b, 0.0))
    space.AddBody(body)
    body.SetPosition(Vec2(0.0, -100.0))
    
    space.AddShape(New CPSegmentShape.Create(body, a, b, 20.0))
    
    ' add a static segment
    space.AddShape(New CPSegmentShape.Create(space.GetStaticBody(), Vec2(0, -300), Vec2(300, 0), 0.0))
    
    ' add a pentagon
    mass = 1.0
    
    Local verts:cpVect[5]
    For Local i:Int = 0 Until 5
        Local angle:Double = -2.0 * CP_PI * i / 5.0
        verts[i] = Vec2(30 * Cos(angle), -(30 * Sin(angle)))
    Next
    
	body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero, 0.0))
    space.AddBody(body)
    body.SetPosition(Vec2(50.0, -30.0))
    
	Local shape:CPPolyShape = New CPPolyShape.Create(body, verts, CPVZero, 10.0)
    space.AddShape(shape)
    
    ' add a circle
    mass = 1.0
    Local r:Double = 20.0
    
	body = New CPBody.Create(mass, MomentForCircle(mass, 0.0, r, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(100.0, -100.0))
    
    space.AddShape(New CPCircleShape.Create(body, r, CPVZero))
    
    Return space
End Function

Function DestroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global QueryDemo:ChipmunkDemo = New ChipmunkDemo( ..
    "Segment Query",  ..
    1.0 / 60.0,  ..
	..
    InitSpace,  ..
    UpdateSpace,  ..
    ChipmunkDemoDefaultDrawImpl,  ..
    DestroySpace ..
, 10)
