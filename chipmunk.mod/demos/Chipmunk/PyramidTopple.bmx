
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

Const WIDTH:Float = 4.0
Const Height:Float = 30.0

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function add_domino(space:CPSpace, Pos:CPVect, flipped:Int)
    Local mass:Double = 1.0
    Local radius:Double = 0.5
    Local moment:Double = MomentForBox(mass, Width, Height)
    
	Local body:CPBody = New CPBody.Create(mass, moment)
    space.AddBody(body)
    body.SetPosition(Pos)

    Local shape:CPShape
    If flipped
        shape = New CPBoxShape.Create(body, Height, Width, 0.0)
    Else
        shape = New CPBoxShape.Create(body, Width - radius * 2.0, Height, radius)
    End If
    
    space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.6)
End Function

Function initSpace:CPSpace()
	init()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 300))
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    ' Add a floor.
    Local shape:CPSegmentShape = New CPSegmentShape.Create(space.GetStaticBody(), Vec2(-600, 240), Vec2(600, 240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    ' Add the dominoes.
    Local n:Int = 12
    For Local i:Int = 0 Until n
        For Local j:Int = 0 Until (n - i)
            Local offset:CPVect = Vec2((j - (n - 1 - i) * 0.5) * 1.5 * Height, -((i + 0.5) * (Height + 2 * Width) - Width - 240))
            add_domino(space, offset, False)
            add_domino(space, offset.Add(Vec2(0, -((Height + Width) / 2.0))), True)
            
            If j = 0 Then
                add_domino(space, offset.Add(Vec2(0.5 * (Width - Height), -(Height + Width))), False)
            End If
            
            If j <> n - i - 1 Then
                add_domino(space, offset.Add(Vec2(Height * 0.75, -((Height + 3 * Width) / 2.0))), True)
            Else
                add_domino(space, offset.Add(Vec2(0.5 * (Height - Width), -(Height + Width))), False)
            End If
        Next
    Next
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global PyramidTopple:ChipmunkDemo = New ChipmunkDemo( ..
	"Pyramid Topple",  ..
	1.0 / 180.0,  ..
	..
	initSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 5)

    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
