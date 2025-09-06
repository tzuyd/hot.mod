
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
end rem
 
Rem
	IMPORTANT - READ ME!
	
	This file sets up a simple interface that the individual demos can use to get
	a Chipmunk space running and draw what's in it. In order to keep the Chipmunk
	examples clean and simple, they contain no graphics code. All drawing is done
	by accessing the Chipmunk structures at a very low level. It is NOT
	recommended to write a game or application this way as it does not scale
	beyond simple shape drawing and is very dependent on implementation details
	about Chipmunk which may change with little to no warning.
end rem

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
 end rem

SuperStrict

Import hot.chipmunk

Import "ChipmunkDebugDraw.bmx"
Import "ChipmunkDemoTextSupport.bmx"

Type ChipmunkDemo
    Field Name:String
    Field timestep:Double
    
    Field initFunc:CPSpace()
    Field updateFunc(space:CPSpace, dt:Double)
    Field drawFunc(space:CPSpace)
    Field destroyFunc(space:CPSpace)
	
	Method New(Name:String, timestep:Double, initFunc:CPSpace(), updateFunc(space:CPSpace, dt:Double), drawFunc(space:CPSpace), destroyFunc(space:CPSpace), Index:Int = 0)
		Self.Name = Name
		Self.timestep = timestep
		Self.initFunc = initFunc
		Self.updateFunc = updateFunc
		Self.drawFunc = drawFunc
		Self.destroyFunc = destroyFunc
		demo_index = Index
		If Index < 0 Then Index = 0
		demos[0] = Self	' Index] = Self
		demo_count:+1
		Main()
	End Method
End Type

Function frand:Double() inline
    Return Double(Rnd())
End Function

Function frand_unit_circle:CPVect() inline
	Local v:CPVect = Vec2(frand() * 2.0 - 1.0, frand() * 2.0 - 1.0)
	If v.LengthSq() < 1.0 Then
		Return v
	Else
		Return frand_unit_circle()
	EndIf
End Function

Global ChipmunkDemoMessageString:String = ""


Global GRAB_FILTER:UInt = GRABBABLE_MASK_BIT
Global NOT_GRABBABLE_FILTER:UInt = ~GRABBABLE_MASK_BIT


Function ChipmunkDemoDefaultDrawImpl(space:CPSpace)
    Local drawOptions:bmx_drawoptions = New bmx_drawoptions
    drawOptions.flags = bmx_DRAW_SHAPES | bmx_DRAW_CONSTRAINTS | bmx_DRAW_COLLISION_POINTS
	
    drawOptions.shapeOutlineColor = New SColor8(255 - $EE, 255 - $E8, 255 - $D5, 255)	' Outline color
    drawOptions.ColorForShape = ColorForShape
    drawOptions.constraintColor = New SColor8(000, 191, 000, 255)	' Constraint color
    drawOptions.collisionPointColor = New SColor8(255, 0, 0, 255)	' Collision point color
    
    bmx_draw(space, drawOptions)
End Function

Function ChipmunkDemoFreeSpaceChildren(space:CPSpace)
    space.EachShape(PostShapeFree, space)
    space.EachConstraint(PostConstraintFree, space)
	
    space.EachBody(PostBodyFree, space)
End Function

' Global variables
Global demos:ChipmunkDemo[32]
Global demo_count:Int
Global demo_index:Int

Global paused:Int = False
Global StepFlag:Int = False ' Renamed Step to StepFlag

Global space:CPSpace

Global Accumulator:Double
Global LastTime:Double
Global ChipmunkDemoTicks:Int
Global ChipmunkDemoTime:Double

Global ChipmunkDemoMouse:CPVect = Vec2(0, 0)
Global ChipmunkDemoRightClick:Int
Global ChipmunkDemoRightDown:Int
Global ChipmunkDemoKeyboard:CPVect = Vec2(0, 0)

Global mouse_body:CPBody = New CPBody
Global mouse_joint:CPConstraint = New CPConstraint

Global view_translate:CPVect = Vec2(0, 0)
Global view_scale:Double = 1.0

Global dt:Double = 0

' Constants
Const GRABBABLE_MASK_BIT:Int = 2147483648

' Function definitions

Function ShapeFreeWrap(space:Byte Ptr, shape:Object, unused:Object)
    CPShape(shape).Free()
End Function

Function PostShapeFree(shape:Object, space:Object)
    CPSpace(space).AddPostStepCallback(ShapeFreeWrap, shape, Null)
End Function

Function ConstraintFreeWrap(space:Byte Ptr, constraint:Object, unused:Object)
    CPConstraint(Constraint).Free()
End Function

Function PostConstraintFree(constraint:Object, space:Object)
    CPSpace(space).AddPostStepCallback(ConstraintFreeWrap, constraint, Null)
End Function

Function BodyFreeWrap(space:Byte Ptr, body:Object, unused:Object)
    CPBody(Body).Free()
End Function

Function PostBodyFree(body:Object, space:Object)
    CPSpace(space).AddPostStepCallback(BodyFreeWrap, body, Null)
End Function

Function DrawCircle(p:CPVect, a:Double, r:Double, outline:SColor8, Fill:SColor8, Data:Object)
    bmx_drawcircle(p, a, r, outline, Fill, Data)
End Function

Function DrawSegment(a:CPVect, b:CPVect, Color:SColor8, Data:Object)
    bmx_drawsegment(a, b, Color, Data)
End Function

Function DrawFatSegment(a:CPVect, b:CPVect, r:Double, outline:SColor8, Fill:SColor8, Data:Object)
    bmx_drawfatsegment(a, b, r, outline, Fill, Data)
End Function

Function DrawPolygon(Count:Int, verts:CPVect[], r:Double, outline:SColor8, Fill:SColor8, Data:Object)
    bmx_drawpolygon(Count, verts, r, outline, Fill, Data)
End Function

Function DrawDot(Size:Double, Pos:CPVect, Color:SColor8, Data:Object)
    bmx_drawdot(Size, Pos, Color, Data)
End Function

Global Colors:SColor8[] = [ ..
    New SColor8($b5, $89, $00, 255),  ..
    New SColor8($cb, $4b, $16, 255),  ..
    New SColor8($dc, $32, $2f, 255),  ..
    New SColor8($d3, $36, $82, 255),  ..
    New SColor8($6c, $71, $c4, 255),  ..
    New SColor8($26, $8b, $d2, 255),  ..
    New SColor8($2a, $a1, $98, 255),  ..
    New SColor8($85, $99, $00, 255) ..
]

Function ColorForShape:SColor8(shape:CPShape, Data:Object)
    If shape.GetSensor() Then
        Return LAColor(255, 0.1)
    Else
        Local body:CPBody = Shape.GetBody()
        
		body._Update
        If body.IsSleeping() Then
            Return New SColor8($58, $6e, $75, 255)
        ElseIf body.sleeping.idleTime > cpSpaceGetSleepTimeThreshold(cpShapeGetSpace(shape.cpObjectPtr))
            Return New SColor8($93, $a1, $a1, 255)
        Else
			shape._Update
            Local val:Size_T = shape.hashid
            
             ' Scramble the bits up using Robert Jenkins' 32-bit integer hash function
            val = (val + $7ed55d16) + (val Shl 12)
            val = (val ~ $c761c23c) ~ (val Shr 19)
            val = (val + $165667b1) + (val Shl 5)
            val = (val + $d3a2646c) ~ (val Shl 9)
            val = (val + $fd7046c5) + (val Shl 3)
            val = (val ~ $b55a4f09) ~ (val Shr 16)

            Return Colors[val & $7]
        End If
    End If
End Function

Function init()
    ' Initialize ChipmunkDebugDraw and ChipmunkDemoText
    bmx_DrawInit()
    ChipmunkDemoTextInit()

	SetClsColor($07, $36, $42, 1)

    ' Create a kinematic body for mouse interaction
	mouse_body.CreateKinematic()
End Function

Function DrawInstructions()
    Local title:String = "Demo(" + Chr(65 + demo_index) + "): " + demos[0].Name	' demo_index].Name
    ChipmunkDemoTextDrawString(Vec2(-300, 220), title)
    
    Local controlInfo:String = "Controls:~n" + ..
        "                    (space restarts)~n" + ..
        "Use the mouse to grab objects.~n"
    
    ChipmunkDemoTextDrawString(Vec2(-300, 200), controlInfo)
End Function

Global max_arbiters:Int = 0
Global max_points:Int = 0
Global max_constraints:Int = 0

Rem
bbdoc: Too low level, left empty
end rem
Function DrawInfo()
Rem
    Local arbiters:Int = space.arbiters.num
	space.EachBody(bmx_DrawInfofunc, Null)
    Local points:Int = 0
    
    For Local i:Int = 0 Until arbiters
		points:+cpArbiter(space.arbiters.arr[i]).Count
    Next
    
    Local constraints:Int = (space.constraints.num + points) * space.iterations
    
    max_arbiters = Max(arbiters, max_arbiters)
    max_points = Max(points, max_points)
    max_constraints = Max(constraints, max_constraints)
    
    Local Format:String = ..
        "Arbiters: %d (%d) - " + ..
        "Contact Points: %d (%d)~n" + ..
        "Other Constraints: %d, Iterations: %d~n" + ..
        "Constraints x Iterations: %d (%d)~n" + ..
        "Time:% 5.2fs, KE:% 5.2e"
    
    Local ke:Double = 0.0
    
    For Local i:Int = 0 Until - 1'space.dynamicBodies.num
        Local body:CPBody = CPBody(space.dynamicBodies.arr[i])
        If body.m <> INFINITY And body.i <> INFINITY Then
            ke:+body.m * body.v.Dot(body.v) + body.i * body.w * body.w
        End If
    Next
    
	Local buffer:String = "Arbiters: " + arbiters + " (" + max_arbiters + ") - " + ..
	                     "Contact Points: " + points + " (" + max_points + ")" + Chr(10) + ..
	                     "Other Constraints: " + space.constraints.num + ", Iterations: " + space.iterations + Chr(10) + ..
	                     "Constraints x Iterations: " + constraints + " (" + max_constraints + ")" + Chr(10) + ..
						 "Time:" + ChipmunkDemoTime + ", ke:"
	Select ke < 1E-10
	    Case True
	        buffer:+0.0
	    Case False
	        buffer:+ke
	End Select
    
    ChipmunkDemoTextDrawString(Vec2(0, 220), buffer)
end rem
End Function

Function Tick(dt:Double)
    If Not paused Or StepFlag Then
        
        ' Completely reset the renderer only at the beginning of a tick.
        ' That way it can always display at least the last tick's debug drawing.
        bmx_drawclearrenderer()
        ChipmunkDemoTextClearRenderer()
        
        Local new_point:CPVect = mouse_body.GetPosition().Lerp(ChipmunkDemoMouse, 0.25)
        mouse_body.SetVelocity new_point.Sub(mouse_body.GetPosition()).Mult(60.0)
        mouse_body.SetPosition new_point

        demos[0].updateFunc(space, dt)	' demo_index].updateFunc(space, dt)
        
        ChipmunkDemoTicks :+ 1
        ChipmunkDemoTime :+ dt
        
        StepFlag = False
    EndIf
End Function

Function Update()
    Local time:Double = MilliSecs() / 1000.0
    dt = time - LastTime
    If dt > 0.2 Then dt = 0.2
    
    Local fixed_dt:Double = demos[0].timestep	' demo_index].timestep
    
    Accumulator :+ dt
    While Accumulator > fixed_dt
        Tick(fixed_dt)
        Accumulator :- fixed_dt
    Wend

	event()
    LastTime = time
End Function

Function Display()
    Local screen_size:CPVect = Vec2(GraphicsWidth(), GraphicsHeight())
	Local view_matrix:CPTransform = New CPTransform.Mult(New CPTransform.Scale(view_scale, view_scale), New CPTransform.Translate(view_translate))

    Local screen_scale:Float = Min(screen_size.x / screen_size.x, screen_size.y / screen_size.y)
    Local hw:Float = screen_size.x * (0.5 / screen_scale)
    Local hh:Float = screen_size.y * (0.5 / screen_scale)
    Local projection_matrix:CPTransform = New CPTransform.Ortho(New CPBB.Create(-hw, -hh, hw, hh))

    bmx_drawpointlinescale = 1.0 / view_scale
	bmx_drawvpmatrix = New CPTransform.Mult(projection_matrix, view_matrix)

    ' Save the drawing commands from the most recent tick.
    bmx_drawpushrenderer()
    ChipmunkDemoTextPushRenderer()
    demos[0].drawFunc(space)	' demo_index].drawFunc(space)
    
'   Highlight the shape under the mouse because it looks neat.
    Local nearest:CPShape = Space.PointQueryNearest(ChipmunkDemoMouse, 0.0, CP_ALL_CATEGORIES, Null)
    If(nearest)
	    Local drawOptions:bmx_drawoptions = New bmx_drawoptions
	    drawOptions.shapeOutlineColor = New SColor8(255, 000, 000, 255)
	    drawOptions.ColorForShape = ColorForShape
	    bmx_drawshape(nearest, drawOptions)
    EndIf
    
    ' Draw the renderer contents and reset it back to the last tick's state.
    bmx_drawflushrenderer()

    Update()
    
    
    ' Now render all the UI text.
    DrawInstructions()
    DrawInfo()
        ChipmunkDemoTextDrawString(Vec2(-300, -200), ChipmunkDemoMessageString)
    
    ChipmunkDemoTextMatrix = projection_matrix
    ChipmunkDemoTextFlushRenderer()
    
    bmx_drawpoprenderer()
    ChipmunkDemoTextPopRenderer()
End Function

Function RunDemo(Index:Int = Null)
    SeedRnd(45073)
    
    ChipmunkDemoTicks = 0
    ChipmunkDemoTime = 0.0
	'                 \___/
    Accumulator = 0.0
    LastTime = MilliSecs() / 1000

    mouse_joint = Null
    ChipmunkDemoMessageString = ""
    max_arbiters = 0
    max_points = 0
    max_constraints = 0
    space = demos[0].initFunc()	' demo_index].initFunc()
	init()
End Function

Function Keyboard()
    Local translate_increment:Float = 50.0 / Float(view_scale)
    Local scale_increment:Float = 1.2

    If KeyHit(KEY_SPACE)
        demos[0].destroyFunc(space)	' demo_index].destroyFunc(space)
		CleanUp
        RunDemo(0)	' demo_index)
    ElseIf KeyHit(KEY_TILDE)
        paused = Not paused
    ElseIf KeyHit(KEY_1)
        StepFlag = 1.0
    ElseIf KeyDown(KEY_NUM4)
        view_translate.x :+ translate_increment
    ElseIf KeyDown(KEY_NUM6)
        view_translate.x :- translate_increment
    ElseIf KeyDown(KEY_NUM2)
        view_translate.y :+ translate_increment
    ElseIf KeyDown(KEY_NUM8)
        view_translate.y :- translate_increment
    ElseIf KeyDown(KEY_NUM7)
        view_scale = view_scale / scale_increment
    ElseIf KeyDown(KEY_NUM9)
        view_scale = view_scale * scale_increment
    ElseIf KeyDown(KEY_NUM5)
        view_translate.x = 0.0
        view_translate.y = 0.0
        view_scale = 1.0
    End If
    
        ChipmunkDemoKeyboard = Vec2(0, 0)
    If KeyDown(KEY_UP)
        ChipmunkDemoKeyboard.y = -1.0
    ElseIf KeyDown(KEY_DOWN)
        ChipmunkDemoKeyboard.y = 1.0
	EndIf
    If KeyDown(KEY_LEFT)
        ChipmunkDemoKeyboard.x = -1.0
    ElseIf KeyDown(KEY_RIGHT)
        ChipmunkDemoKeyboard.x = 1.0
    End If
End Function

Function MouseToSpace:CPVect(event:Object = Null)
    ' Calculate clip coord for mouse.
    Local screen_size:CPVect = Vec2(GraphicsWidth(), GraphicsHeight())
    Local clip_coord:CPVect = Vec2(2 * MouseX() / screen_size.x - 1, 1 - 2 * MouseY() / screen_size.y)
	clip_coord.y = -clip_coord.y

    ' Use the VP matrix to transform to world space.
	Local vp_inverse:CPTransform = New CPTransform.Inverse(bmx_DrawVPMatrix)
    Return New CPTransform.Point(vp_inverse, clip_coord)
End Function

Function Click()
    Local mouse_pos:CPVect = MouseToSpace()

    If MouseDown(1) Then
		If mouse_joint = Null
			' // give the mouse Click a little radius To make it easier To Click small shapes.
	        Local radius:Double = 5.0
	        
	        Local info:CPPointQueryInfo = New CPPointQueryInfo
	        Local shape:CPShape = Space.PointQueryNearest(mouse_pos, radius, GRAB_FILTER, info)
	        
	        If shape <> Null And shape.GetBody().GetMass() < INFINITY Then
				' // Use the closest Point on the surface If the Click is outside of the shape.
	            Local nearest:CPVect
	            If info.distance > 0.0 Then
	                nearest = Vec2(info.Pointx, info.Pointy)
	            Else
	                nearest = mouse_pos
	            EndIf
	            
	            Local body:CPBody = Shape.GetBody()
				mouse_joint = New CPPivotJoint.Create(mouse_body, body, CPVZero, body.World2Local(nearest))
	            mouse_joint.SetMaxForce 50000.0
	            mouse_joint.SetErrorBias (1.0 - 0.15) ^ 60.0
	            space.AddConstraint(mouse_joint)
	        EndIf
		EndIf
    Else
        If mouse_joint <> Null Then
            mouse_joint.Free()
            mouse_joint = Null
        EndIf
	EndIf
	If MouseDown(2) Then
        ChipmunkDemoRightDown = True
		ChipmunkDemoRightClick = True
	Else
        ChipmunkDemoRightDown = False
    EndIf
End Function

Function Event()
            Keyboard()
            ChipmunkDemoMouse = MouseToSpace()
            Click()
End Function

Function CleanUp()
	
End Function

'    Graphics (1024, 768, 0,, GRAPHICS_BACKBUFFER | GRAPHICS_ALPHABUFFER)
Function Main:Int()
    AppTitle = "Demo(" + Chr(97 + demo_index) + "): " + demos[0].Name	' demo_index].Name
    Graphics (1024, 768, 0,, GRAPHICS_BACKBUFFER | GRAPHICS_ALPHABUFFER)

		RunDemo(demo_index)

		While Not KeyHit(KEY_ESCAPE)
			If AppTerminate() Then End
			Display()
			
		Wend
		
End Function
