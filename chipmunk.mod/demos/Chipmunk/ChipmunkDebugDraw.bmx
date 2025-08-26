
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

' Import Chipmunk library
Import hot.chipmunk

Function LAColor:SColor8(l:Byte, a:Float)
    Local Color:SColor8 = New SColor8(l, l, l, Byte(a * 255))
    Return Color
End Function

Rem
bbdoc: // Call this at the beginning of the frame to clear out any bmx_Draw*() commands.
end rem
Function bmx_drawclearrenderer()
End Function

Rem
bbdoc: // Save the current contents of the renderer.
end rem
Function bmx_drawpushrenderer()
End Function
Rem
bbdoc: // Reset the renderer back to it's last pushed state.
end rem
Function bmx_drawpoprenderer()
	Flip
	Cls
End Function

Global bmx_drawvpmatrix:CPTransform
Global bmx_drawpointlinescale:Float = 1.0

Function bmx_drawinit()
	SetOrigin GraphicsWidth() / 2, GraphicsHeight() / 2
	SetBlend ALPHABLEND
End Function

Function PushVertexes(vcount:Int, index_src:Int[], icount:Int)
End Function

Function bmx_drawdot(Size:Double, Pos:CPVect, fillColor:SColor8, Data:Object = Null)
    Local r:Float = Size * 0.5 * bmx_drawpointlinescale
	SetColor fillColor.r, fillColor.g, fillColor.b
	SetAlpha fillColor.a / 255
    
    DrawOval Pos.x - r, Pos.y - r, r + r, r + r
End Function

Function bmx_drawcircle(Pos:CPVect, angle:Double, radius:Double, outlineColor:SColor8, fillColor:SColor8, Data:Object, drawseg:Int = True)
    Local r:Float = radius + bmx_drawpointlinescale

    SetColor outlineColor.r, outlineColor.g, outlineColor.b
	SetAlpha outlineColor.a / 255
    DrawOval Pos.x - r, Pos.y - r, r * 2, r * 2

    SetColor fillcolor.r, fillcolor.g, fillcolor.b
	SetAlpha fillColor.a / 255
    DrawOval Pos.x - r + 2, Pos.y - r + 2, r * 2 - 4, r * 2 - 4
    
	If drawseg
	    SetColor outlineColor.r, outlineColor.g, outlineColor.b
		SetAlpha outlineColor.a / 255
		bmx_drawfatsegment(Pos, Pos.Add(New CPVect.ForAngle((angle - 90) * (Pi / 180)).Mult(1 * radius)), 0, outlineColor, outlineColor, Data)
	EndIf
End Function

Function bmx_drawsegment(a:CPVect, b:CPVect, Color:SColor8, Data:Object = Null)
    bmx_drawfatsegment(a, b, -1, Color, Color, Data)
End Function

Function bmx_drawfatsegment(a:CPVect, b:CPVect, radius:Double, outlineColor:SColor8, fillColor:SColor8, Data:Object = Null)
    ' Calculate the adjusted radius
    Local r:Float = radius + bmx_drawpointlinescale
    
    ' Set outline color and alpha
    SetColor outlineColor.r, outlineColor.g, outlineColor.b
    SetAlpha outlineColor.a / 255
    
    ' Set line width for outline
    SetLineWidth r + r  ' Adjust line width as needed

    ' Draw the outline
    DrawLine a.x, a.y, b.x, b.y, 0

    ' Set fill color and alpha
    SetColor fillcolor.r, fillcolor.g, fillcolor.b
    SetAlpha fillColor.a / 255

	SetLineWidth r + r - 4
    
    ' Draw the filled shape
    DrawLine a.x, a.y, b.x, b.y, 0
End Function

Function bmx_drawpolygon(Count:Int, verts:CPVect[], radius:Double, outlineColor:SColor8, fillColor:SColor8, Data:Object = Null)
	    Local polyFillVerts:Float[] = New Float[verts.Length * 2]
	    
	    For Local i:Int = 0 Until Count
	        Local v:CPVect = verts[i]
	        polyFillVerts[i * 2] = v.x
	        polyFillVerts[i * 2 + 1] = v.y
	    Next
	    
	    ' Draw the filled shape
        SetColor fillColor.r, fillColor.g, fillColor.b
        SetAlpha fillColor.a / 255
	    DrawPoly polyFillVerts
    For Local i:Int = 0 Until Count
        Local v0:CPVect = verts[i]
        Local v_next:CPVect = verts[(i + (Count + 1)) Mod Count]
        
        ' Draw the outline
		bmx_drawfatsegment(v_next, v0, 0, outlineColor, outlineColor, Data)
    Next
End Function

Function bmx_drawbb(bb:CPBB, Color:SColor8)
	bb._Update
    Local verts:CPVect[] = [Vec2(bb.r, bb.b), Vec2(bb.r, bb.t), Vec2(bb.l, bb.t), Vec2(bb.l, bb.b)]
    bmx_drawpolygon(4, verts, 0.0, Color, New SColor8(0, 0, 0, 255))
End Function

Rem
bbdoc: // Call this at the end of the frame to draw the ChipmunkDebugDraw*() commands to the screen.
end rem
Function bmx_drawflushrenderer()
End Function

Function bmx_drawshape(shape:Object, options:Object)
	If CPObject(shape).cpobjectptr
	    Local body:CPBody = CPShape(shape).GetBody()
	    Local Data:Object = bmx_drawoptions(options).Data
	   
	    Local outline_color:SColor8 = bmx_drawoptions(options).shapeOutlineColor
	    Local fill_color:SColor8 = bmx_drawoptions(options).colorForShape(CPShape(shape), Data)
	
	    Local tc:CPVect = body.GetPosition()
	    Local a:Double = body.GetAngle()

		If CPCircleShape(shape)
		    ' Adjust the circle's position by the offset
		    Local offset:CPVect = CPCircleShape(shape).GetOffset()
    
			' Convert degrees to radians
			Local angleInRadians:Double = a * (Pi / 180)
						
			' Adjust the circle's position by the offset
			Local rotatedOffset:CPVect = offset.Rotate(CPVect.ForAngle(angleInRadians))
			
			' Add the rotated offset to the circle's position
			tc = tc.Add(rotatedOffset)
		    
		    ' Draw the circle
            bmx_drawcircle(tc, a, CPCircleShape(shape).GetRadius(), outline_color, fill_color, Data)
		ElseIf CPSegmentShape(shape)
            Local ta:CPVect = CPSegmentShape(shape).GetEndPointA()
            Local tb:CPVect = CPSegmentShape(shape).GetEndPointB()
			
			' Adjust endpoints by body's position and rotation
			ta = ta.Rotate(body.GetRot())
			ta = ta.Add(body.GetPosition())
			
			tb = tb.Rotate(body.GetRot())
			tb = tb.Add(body.GetPosition())
    
			bmx_drawcircle(ta, a, CPSegmentShape(shape).GetRadius(), outline_color, fill_color, Data, 0)
			bmx_drawcircle(tb, a, CPSegmentShape(shape).GetRadius(), outline_color, fill_color, Data, 0)
            bmx_drawfatsegment(ta, tb, CPSegmentShape(shape).GetRadius(), outline_color, fill_color, Data)
		ElseIf CPPolyShape(shape)
            Local Count:Int = bmx_cppolyshape_numverts(CPPolyShape(shape).cpObjectPtr)
            Local verts:CPVect[] = New CPVect[Count]
            bmx_cppolyshape_getverts(CPPolyShape(shape).cpObjectPtr, verts)
		    Local adjustedVertices:CPVect[] = adjustVertices(verts, tc, a)  ' Adjust vertices by body's position and rotation
            bmx_drawpolygon(Count, adjustedVertices, CPPolyShape(shape).GetRadius(), outline_color, fill_color, Data)
		Else
			DebugStop
		End If
	Else
		DebugStop
	EndIf
End Function

Function adjustVertices:CPVect[] (verts:CPVect[], Position:CPVect, angle:Double)
    Local adjustedVerts:CPVect[] = New CPVect[verts.Length]
    For Local i:Int = 0 Until verts.Length
        ' Rotate the vertex around the body's position
        Local rotatedX:Double = verts[i].x * Cos(angle) - Verts[i].y * Sin(angle)
        Local rotatedY:Double = verts[i].x * Sin(angle) + Verts[i].y * Cos(angle)
        ' Translate the rotated vertex to the body's position
        adjustedVerts[i] = Vec2(rotatedX + Position.x, (rotatedY + Position.y))
    Next
    Return adjustedVerts
End Function

Global spring_verts:CPVect[] = [ ..
	Vec2(0.00, 0.0),  ..
	Vec2(0.20, 0.0),  ..
	Vec2(0.25, -3.0),  ..
	Vec2(0.30, 6.0),  ..
	Vec2(0.35, -6.0),  ..
	Vec2(0.40, 6.0),  ..
	Vec2(0.45, -6.0),  ..
	Vec2(0.50, 6.0),  ..
	Vec2(0.55, -6.0),  ..
	Vec2(0.60, 6.0),  ..
	Vec2(0.65, -6.0),  ..
	Vec2(0.70, 3.0),  ..
	Vec2(0.75, -6.0),  ..
	Vec2(0.80, 0.0),  ..
	Vec2(1.00, 0.0) ..
]
Global spring_count:Int = spring_verts.Length

Function bmx_drawconstraint(constraint:Object, options:Object)
	If CPObject(constraint).cpObjectPtr
	    Local Data:Object = bmx_drawoptions(options).Data
	    Local Color:SColor8 = bmx_drawoptions(options).constraintColor
	
		    ' Get the bodies involved in the constraint
	    Local body_a:CPBody = CPConstraint(constraint).GetBodyA()
	    Local body_b:CPBody = CPConstraint(constraint).GetBodyB()
		body_a._Update
		body_b._Update
	    
	    If CPPinJoint(constraint)
		    Local joint:CPPinJoint = CPPinJoint(constraint)
		    
		    ' Get the anchor points in local coordinates
		    Local anchor1:CPVect = joint.GetAnchor1()
		    Local anchor2:CPVect = joint.GetAnchor2()
		    
		    ' Transform anchor points to global coordinates
		    Local a:CPVect = body_a.Local2World(anchor1)
		    Local b:CPVect = body_b.Local2World(anchor2)
		    
		    ' Draw the anchor points and the connecting line
		    bmx_drawdot(5, a, Color, Data)
		    bmx_drawdot(5, b, Color, Data)
			bmx_drawsegment(a, b, Color, Data)
	    ElseIf CPSlideJoint(constraint)
	        Local joint:CPSlideJoint = CPSlideJoint(constraint)
	    
		    ' Get the anchor points in local coordinates
		    Local anchor1:CPVect = joint.GetAnchor1()
		    Local anchor2:CPVect = joint.GetAnchor2()
		    
		    ' Transform anchor points to global coordinates
		    Local a:CPVect = body_a.Local2World(anchor1)
		    Local b:CPVect = body_b.Local2World(anchor2)
		    
		    ' Draw the anchor points and the connecting line
			bmx_drawdot 5, a, Color, Data
			bmx_drawdot 5, b, Color, Data
			bmx_drawsegment(a, b, Color, Data)
	    ElseIf CPPivotJoint(constraint)
		    Local joint:CPPivotJoint = CPPivotJoint(constraint)
		    
		    ' Get the anchor points in local coordinates
		    Local anchor1:CPVect = joint.GetAnchor1()
		    Local anchor2:CPVect = joint.GetAnchor2()
		    
		    ' Transform anchor points to global coordinates
		    Local a:CPVect = body_a.Local2World(anchor1)
		    Local b:CPVect = body_b.Local2World(anchor2)

		    ' Draw the anchor points
		    bmx_drawdot(10, a, Color, Data)
		    bmx_drawdot(10, b, Color, Data)
		ElseIf CPGrooveJoint(constraint)
		    Local joint:CPGrooveJoint = CPGrooveJoint(constraint)
		    
		    ' Get the groove points in local coordinates
		    Local grooveA:CPVect = joint.GetGrooveA()
		    Local grooveB:CPVect = joint.GetGrooveB()
		    
		    ' Transform groove points to global coordinates
		    Local globalGrooveA:CPVect = body_a.Local2World(grooveA)
		    Local globalGrooveB:CPVect = body_a.Local2World(grooveB)
		    
		    ' Get the anchor point in local coordinates
		    Local anchor:CPVect = joint.GetAnchor()
		    
		    ' Transform anchor point to global coordinates
		    Local globalAnchor:CPVect = body_b.Local2World(anchor)
		    
		    ' Draw the anchor point
		    bmx_drawdot(5, globalAnchor, Color, Data)
		    
		    ' Draw the groove
		    bmx_drawfatsegment(globalGrooveA, globalGrooveB, -1, Color, Color, Data)
		ElseIf CPDampedSpring(constraint)
		    Local spring:CPDampedSpring = CPDampedSpring(constraint)
		    
		    ' Get the anchor points in local coordinates
		    Local anchorA:CPVect = spring.GetAnchorA()
		    Local anchorB:CPVect = spring.GetAnchorB()
		    
		    ' Transform anchor points to global coordinates
		    Local globalAnchorA:CPVect = body_a.Local2World(anchorA)
		    Local globalAnchorB:CPVect = body_b.Local2World(anchorB)
		    
		    ' Draw the anchor points
		    bmx_drawdot(5, globalAnchorA, Color, Data)
		    bmx_drawdot(5, globalAnchorB, Color, Data)
		
		    ' Draw the spring itself
	        Local delta:CPVect = globalAnchorB.Sub(globalAnchorA)
	        Local s:Float = 1.0 / delta.Length()
	        Local Cos:Float = delta.x
	        Local Sin:Float = delta.y
	        
	        Local r1:CPVect = Vec2(Cos, -Sin * s)
	        Local r2:CPVect = Vec2(Sin, Cos * s)
	        
	        Local verts:CPVect[] = New CPVect[spring_count]
	        For Local i:Int = 0 Until spring_count
	            Local v:CPVect = spring_verts[i]
	            verts[i] = Vec2(v.Dot(r1) + globalAnchorA.x, v.Dot(r2) + globalAnchorA.y)
	        Next
	        
	        For Local i:Int = 0 Until spring_count - 1
				bmx_drawfatsegment(verts[i], verts[i + 1], -1, Color, Color, Data)
	        Next
	    End If
	EndIf
End Function

' Define the structure for the drawing options
Type bmx_drawoptions
    Field flags:Int
    Field shapeOutlineColor:SColor8
    Field colorForShape:SColor8(shape:CPShape, Data:Object)
    Field constraintColor:SColor8
    Field collisionPointColor:SColor8
    Field Data:Object
End Type

' Define the debug draw flags
Const bmx_DRAW_SHAPES:Int = 1
Const bmx_DRAW_CONSTRAINTS:Int = 2
Const bmx_DRAW_COLLISION_POINTS:Int = 4

Function bmx_draw(space:CPSpace, options:bmx_drawoptions)
    Local Flags:Int = options.Flags
    
    If flags & bmx_DRAW_SHAPES
		space.EachShape(bmx_drawshape, options)
    End If
    
    If flags & bmx_DRAW_CONSTRAINTS
		space.EachConstraint(bmx_drawconstraint, options)
    End If
    
    If flags & bmx_DRAW_COLLISION_POINTS
		space.EachBody(bmx_drawfunc, options)
    End If
End Function

Function bmx_drawfunc(body:Object, Data:Object)
	CPBody(body).EachArbiter(bmx_drawcollisionpoints, Data)
End Function

Function bmx_drawcollisionpoints(body:Object, arbiter:Object, Data:Object)
    ' Cast the arbiter to cpArbiter type
    Local arb:cpArbiter = cpArbiter(arbiter)
    
    ' Iterate over the contact points and draw segments
    For Local j:Int = 0 Until arb.GetCount()
        ' Get the contact points in world space
        Local p1:CPVect = arb.GetPointA(j)
        Local p2:CPVect = arb.GetPointB(j)
        
        ' Calculate the midpoint between p1 and p2
        Local midpoint:CPVect = p1.Add(p2).Mult(0.5)
        
        ' Draw a dot at the midpoint
        bmx_drawdot(4, midpoint, bmx_drawoptions(Data).collisionPointColor, Data)
    Next
End Function
