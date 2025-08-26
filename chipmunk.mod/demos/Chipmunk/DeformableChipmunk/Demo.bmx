
SuperStrict

Import hot.chipmunk

Type Demo

	Field space:CPSpace

	Method leftMouse(Pos:CPVect) Abstract
	Method rightMouse(Pos:CPVect) Abstract
	Method drag(Pos:CPVect) Abstract
	
	Method DoStep(dt:Double, bounds:CPBB) Abstract
	
	Method drawUnderlay()
	End Method
	
	Method drawOverlay()
	End Method
	
End Type
