SuperStrict

Import hot.Chipmunk
 
Import BRL.GLMax2d
?win32
Import BRL.d3d7max2d
?
'Import BRL.PNGLoader
'Import BRL.Pixmap


Global staticBody:CPBody
Global space:CPSpace
Global ticks:Int = 0

'AutoMidHandle(True)
'Global crate:TImage = LoadImage("crate.png")
'Global ball:TImage = LoadImage("ball.png")

Function drawFPS()
	Global frame:Int = 0
	Global fps:Int = 0
	Global time:Int = MilliSecs() + 1000

	DrawText fps, -310, -230

	frame:+ 1
	If MilliSecs() >= time
		fps = frame
		frame = 0
		time :+ 1000
	End If
End Function

Function drawPolyShape(shape:CPPolyShape)

	Local body:CPBody = shape.GetBody()
	
	Local pos:CPVect = body.GetPosition()
'Rem
	Local verts:CPVect[] = shape.GetVerts()
	Local First:CPVect
	Local last:CPVect
	
	For Local i:Int = 0 Until verts.Length
		Local v:CPVect = pos.Add(verts[i].Rotate(body.GetRot()))
		
		If Not First Then
			First = v
		End If
		
		If last Then
			DrawLine Float(last.x), Float(last.y), Float(v.x), Float(v.y)
		End If
		
		last = v
	Next
	
	DrawLine Float(last.x), Float(last.y), Float(First.x), Float(First.y)
'End Rem
'DebugLog "drawpoly at " + pos.x + ", " + pos.y
'	SetRotation body.GetAngle()
'	DrawImage crate, pos.x, pos.y

End Function

Function drawCircleShape(shape:CPCircleShape)

	Local body:CPBody = shape.GetBody()
	
	Local pos:CPVect = body.GetPosition()
	Local center:CPVect = shape.GetTransformedCenter()

	'SetRotation body.GetAngle()
	'DrawImage ball, pos.x, pos.y
	Local radius:Float = shape.GetRadius()
'DebugLog "radius = " + radius + " cx = " + center.x + " : cy = " + center.y
	DrawOval Float(center.x - radius), Float(center.y - radius), radius * 2, radius * 2
	
	SetColor 0, 0, 0
	DrawLine Float(center.x), Float(center.y), Float(center.x + Cos(body.GetAngle()) * radius), Float(center.y + Sin(body.GetAngle()) * radius)
	SetColor 255, 255, 255
End Function

Function drawSegmentShape(shape:CPSegmentShape)

	SetRotation 0

	Local body:CPBody = shape.GetBody()
	
	Local pos:CPVect = body.GetPosition()

	Local a:CPVect = pos.Add(shape.GetEndPointA().Rotate(body.GetRot()))
	Local b:CPVect = pos.Add(shape.GetEndPointB().Rotate(body.GetRot()))
	
	DrawLine Float(a.x), Float(a.y), Float(b.x), Float(b.y)

End Function

Function drawObject(shape:Object, data:Object)

	If CPPolyShape(shape) Then
		drawPolyShape(CPPolyShape(shape))
	ElseIf CPSegmentShape(shape) Then
		drawSegmentShape(CPSegmentShape(shape))
	ElseIf CPCircleShape(shape) Then
		drawCircleShape(CPCircleShape(shape))
	End If
	
End Function


