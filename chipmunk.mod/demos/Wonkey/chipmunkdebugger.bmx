
SuperStrict

Import brl.StandardIO
Import brl.Max2D
Import brl.map
Import brl.random

Import hot.chipmunk

	Function DebugDraw(shape:Object, Data:Object)
	
		If CPPolyShape(shape) Then
			drawPolyShape(CPPolyShape(shape))
		ElseIf CPSegmentShape(shape) Then
			drawSegmentShape(CPSegmentShape(shape))
		ElseIf CPCircleShape(shape) Then
			drawCircleShape(CPCircleShape(shape))
		End If
	End Function
	
	Function drawCircleShape(shape:CPCircleShape)
	
		Local body:CPBody = shape.GetBody()
		
		Local pos:CPVect = body.GetPosition()
		Local center:CPVect = shape.GetTransformedCenter()
	
		'SetRotation body.GetAngle()
		'DrawImage ball, pos.x, pos.y
		Local radius:Float = shape.GetRadius()
	'DebugLog "radius = " + radius + " cx = " + center.x + " : cy = " + center.y
	
		SetColor 0, 0, 0

		DrawOval Float(center.x - radius), Float(center.y - radius), (radius * 2), (radius * 2)

		Local Color:bmx_cpspace_debugcolor = ColorForShape(shape, Null)
		SetColor Int(Color.r * 255), Int(Color.g * 255), Int(Color.b * 255)
		
		DrawOval Float(center.x - radius + 1.5), Float(center.y - radius + 1.5), radius * 2 - 3, radius * 2 - 3
		
		SetColor 0, 0, 0
		
		SetLineWidth 1
		DrawLine Float(center.x), Float(center.y), Float(center.x + Cos(body.GetAngle()) * (radius - 1.5)), Float(center.y + Sin(body.GetAngle()) * (radius - 1.5))
	End Function
	
	Function drawSegmentShape(shape:CPSegmentShape)

		SetRotation 0
	
		Local body:CPBody = shape.GetBody()
		
		Local pos:CPVect = body.GetPosition()
	
		Local a:CPVect = pos.Add(shape.GetEndPointA().Rotate(body.GetRot()))
		Local b:CPVect = pos.Add(shape.GetEndPointB().Rotate(body.GetRot()))
		
		Local Color:bmx_cpspace_debugcolor = ColorForShape(shape, Null)
		SetColor Int(Color.r * 255), Int(Color.g * 255), Int(Color.b * 255)

		DrawLine Float(a.x), Float(a.y), Float(b.x), Float(b.y)
	End Function
	
	Function DrawPolyShape(shape:CPPolyShape)
	    Local body:CPBody = shape.GetBody()
	    Local pos:CPVect = body.GetPosition()
	    Local verts:CPVect[] = shape.GetVerts()
	    
	    Local polyOutlineVerts:Float[] = New Float[verts.Length * 2]
	    Local polyFillVerts:Float[] = New Float[verts.Length * 2]
	    
	    For Local i:Int = 0 Until verts.Length
	        Local v:CPVect = pos.Add(verts[i].Rotate(body.GetRot()))
	        polyOutlineVerts[i * 2] = v.x
	        polyOutlineVerts[i * 2 + 1] = v.y
	        
	        ' Make the filled shape slightly smaller than the outline
	        Local offset:Float = 3 ' Adjust this value as needed
	        Local prevIndex:Int = (i - 1 + verts.Length) Mod verts.Length
	        Local nextIndex:Int = (i + 1) Mod verts.Length
	        Local prevVert:CPVect = pos.Add(verts[prevIndex].Rotate(body.GetRot()))
	        Local nextVert:CPVect = pos.Add(verts[nextIndex].Rotate(body.GetRot()))
	        Local offsetVect:CPVect = nextVert.Sub(prevVert).Normalize().Perp().Mult(offset)
	        Local vFill:CPVect = Pos.Add(verts[i].Rotate(body.GetRot()).Add(offsetVect))
	        polyFillVerts[i * 2] = vFill.x
	        polyFillVerts[i * 2 + 1] = vFill.y
	    Next
	    
	    ' Draw the outline
		SetColor 0, 0, 0
		SetAlpha 1
	    DrawPoly polyOutlineVerts
	    
	    ' Draw the filled shape
		Local Color:bmx_cpspace_debugcolor = ColorForShape(shape, Null)
		SetColor Int(Color.r * 255), Int(Color.g * 255), Int(Color.b * 255)
		SetAlpha 1
	    DrawPoly polyFillVerts
'	'DebugLog "drawpoly at " + pos.x + ", " + pos.y
'	'	SetRotation body.GetAngle()
'	'	DrawImage crate, pos.x, pos.y
	End Function

	Function ColorForShape:bmx_cpspace_debugcolor(shape:Object, Data:Object)
	
		Local Color:bmx_cpspace_debugcolor = bmx_cpspace_debugcolor(_colors[shape])
		If Color Return Color
		
		Color = New bmx_cpspace_debugcolor
		Color.r = Rnd(1)
		Color.g = Rnd(1 - Color.r)
		Color.b = Rnd(1 - Color.r - Color.g)
		Color.a = 1
		
		_colors[shape] = Color
		Return Color
	End Function
	
	Private
	
	Global _colors:TMap = New TMap

Type bmx_cpspace_debugcolor
	Field r:Float, g:Float, b:Float, a:Float
End Type
