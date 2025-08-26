
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

Const DENSITY: Float = 1.0 / 10000.0
Const MAX_VERTEXES_PER_VORONOI:Int = 16

Type WorleyContex
    Field seed: UInt
    Field cellSize:Double
    Field Width:Int
    Field height: Int
    Field bb: cpBB
    Field focus: cpVect
End Type

Function HashVect:CPVect(x:UInt, y:UInt, Seed:UInt)
'	Local border:Double = 0.21
    Local border:Double = 0.05
    
    Local h:UInt = (x * 1640531513 ~ y * 2654435789) + Seed
    
    Return Vec2( ..
        Lerp(border, 1.0 - border, Double(h & $FFFF) / Double($ffff)),  ..
        Lerp(border, 1.0 - border, Double((h Shr 16) & $FFFF) / Double($ffff)) ..
    )
End Function

Function WorleyPoint:CPVect(i:Int, j:Int, context:WorleyContex)
    Local Size:Double = context.cellSize
    Local Width:Int = context.Width
    Local height: Int = context.height
    Local bb: cpBB = context.bb
    bb._Update
	
'	Local fv:CPVect = Vec2(0.5, 0.5)
    Local fv:CPVect = HashVect(uint(i), uint(j), context.Seed)
    
    Return Vec2( ..
        Lerp(bb.l, bb.r, 0.5) + Size * (i + fv.x - Width * 0.5),  ..
        Lerp(bb.b, bb.t, 0.5) + Size * (j + fv.y - Height * 0.5) ..
    )
End Function

Function ClipCell:CPVect[] (shape:CPShape, center:CPVect, i:Int, j:Int, context:WorleyContex, verts:CPVect[], Count:Int)
    Local other:CPVect = WorleyPoint(i, j, context)
	Local clipped:CPVect[] = New CPVect[MAX_VERTEXES_PER_VORONOI]
'	DebugLog("  other " + String(i) + "x" + String(j) + ": (" + String(other.x) + ", " + String(other.y) + ") ")
    If shape.PointQuery(other, Null) > 0.0
'		DebugLog("excluded~n")
        Return verts
	Else
'		DebugLog("clipped~n")
    End If
    
    Local n:CPVect = other.Sub(center)
    Local Dist:Double = n.Dot(center.Lerp(other, 0.5))
    
    Local clipped_count:Int = 0
	i = Count - 1
    For Local j:Int = 0 Until Count
        Local a:CPVect = verts[i]
        Local a_dist:Double = a.Dot(n) - Dist
        
        If a_dist <= 0.0 Then
            clipped[clipped_count] = a
            clipped_count :+ 1
        End If
        
        Local b:CPVect = verts[(j)]
        Local b_dist:Double = b.Dot(n) - Dist
        
        If a_dist * b_dist < 0.0 Then
            Local t:Double = Abs(a_dist) / (Abs(a_dist) + Abs(b_dist))
			
            clipped[clipped_count] = a.Lerp(b, t)
            clipped_count:+1
        End If
		i = j
    Next

	Local pong:CPVect[clipped_count]
	For i = 0 Until clipped_count
		pong[i] = clipped[i]
	Next
    Return pong
End Function

Function ShatterCell(space:CPSpace, shape:CPPolyShape, cell:CPVect, cell_i:Int, cell_j:Int, context:WorleyContex)
'	DebugLog("cell " + String(cell_i) + "x" + String(cell_j) + ": (" + String(cell.x) + ", " + String(cell.y) + ")~n")

    Local body:CPBody = Shape.GetBody()
    
	Local ping:CPVect[] = shape.GetVerts()

    For Local k:Int = 0 Until ping.Length
        ping[k] = body.Local2World(ping[k])
    Next
    
    For Local i: Int = 0 Until context.width
        For Local j: Int = 0 Until context.height
            If Not (i = cell_i And j = cell_j) And ..
			Shape.PointQuery(cell, Null) < 0.0
                ping = ClipCell(shape, cell, i, j, context, ping, ping.Length)
            End If
        Next
    Next
    
    Local centroid:CPVect = CentroidForPoly(ping)
    Local mass:Double = AreaForPoly(ping, 0.0) * DENSITY
    Local moment:Double = MomentForPoly(mass, ping, centroid.Negate(), 0.0)
    
    Local new_body:CPBody = New CPBody.Create(mass, moment)
	space.AddBody(new_body)
    new_Body.SetPosition(centroid.Negate())
    new_Body.SetVelocity(Body.VelocityAtWorldPoint(centroid))
    new_Body.SetAngularVelocity(Body.GetAngularVelocity())
    
	Local offset:CPVect = centroid.Negate()
	Local new_shape:CPPolyShape = New CPPolyShape.Create(new_body, ping, offset, 0.0)
	space.AddShape(new_shape)
'	/ / Copy whatever properties you have Set on the original shape that are important
    new_Shape.SetFriction(Shape.GetFriction())
End Function

Function ShatterShape(space:CPSpace, shape:CPPolyShape, cellSize:Double, focus:CPVect)
    Local bb:CPBB = Shape.GetBB()
	bb._Update
    Local width: Int = Int((bb.r - bb.l) / cellSize) + 1
    Local height: Int = Int((bb.t - bb.b) / cellSize) + 1
'	DebugLog("Splitting as " + String(Width) + "x" + String(Height) + "~n")
    Local context:WorleyContex = New WorleyContex
    context.Seed = Rnd()
    context.cellSize = cellSize
    context.width = width
    context.height = height
    context.bb = bb
    context.focus = focus
    
    For Local i: Int = 0 Until context.width
        For Local j: Int = 0 Until context.height
            Local cell: cpVect = WorleyPoint(i, j, context)
            If Shape.PointQuery(cell, Null) < 0.0
                ShatterCell(space, shape, cell, i, j, context)
            End If
        Next
    Next
    
    Shape.GetBody().Free()
    Shape.Free()
End Function

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
    
    If ChipmunkDemoRightDown
        Local info:CPPointQueryInfo
		Local tmpshp:CPShape = space.PointQueryNearest(ChipmunkDemoMouse, 0, GRAB_FILTER, info)
        If CPPolyShape(tmpshp)
            Local bb:CPBB = CPPolyShape(tmpshp).GetBB()
            Local cell_size:Double = Max(bb.r - bb.l, bb.t - bb.b) / 5.0
            If cell_size > 5.0
                ShatterShape(space, CPPolyShape(tmpshp), cell_size, ChipmunkDemoMouse)
			Else
				DebugLog("Too small to splinter " + String(cell_size) + "~n")
            End If
        End If
    End If
End Function

Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "Right click something to shatter it."
    
	space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 500))
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    Local body:CPBody
    Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPSegmentShape
    
'	/ / Create segments around the edge of the screen.
    shape = New CPSegmentShape.Create(staticBody, Vec2(-1000, 240), Vec2(1000, 240), 0.0)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    Local Width:Double = 200.0
    Local Height:Double = 200.0
    Local mass:Double = Width * Height * DENSITY
    Local moment:Double = MomentForBox(mass, Width, Height)
    
    body = New CPBody.Create(mass, moment)
	space.AddBody(body)
    
    Local polyshap:CPPolyShape = New cpBoxShape.Create(body, Width, Height, 0.0)
	space.AddShape(polyshap)
    shape.SetFriction(0.6)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Shatter:ChipmunkDemo = New ChipmunkDemo( ..
	"Shatter.",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 23)
