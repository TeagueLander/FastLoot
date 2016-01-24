Scriptname FL_ContainerReference extends ObjectReference

FL_WidgetBuilder builderInstance

function FL_ContainerReference(FL_WidgetBuilder passedInstance)
	builderInstance = passedInstance
endfunction

Event OnItemAdded(Form takenForm, Int amount, ObjectReference takenRef, ObjectReference containerRef)
	builderInstance.removeAndResetWidget()
EndEvent