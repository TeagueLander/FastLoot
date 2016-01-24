Scriptname FL_FormNode extends ObjectReference
{
Created by Teague Lander January 6th 2016
Root is created by FL_WidgetBuilder
Nodes are doubly linked and hold some info about the forms
}
Form _nodeForm
int _iAmount ;amount of the item that exists in the container
FL_FormNode _prevNode
FL_FormNode _nextNode

Form Property NodeForm
	Form function get()
		return _nodeForm
	endFunction
	function set(Form a_val)
		_nodeForm = a_val
	endFunction
endProperty

int property Amount
	int function get()
		return _iAmount
	endFunction
	function set(int a_val)
		_iAmount = a_val
	endFunction
endProperty

FL_FormNode property PrevNode
	FL_FormNode function get()
		return _prevNode
	endFunction
	function set(FL_FormNode a_val)
		_prevNode = a_val
	endFunction
endProperty

FL_FormNode property NextNode
	FL_FormNode function get()
		return _nextNode
	endFunction
	function set(FL_FormNode a_val)
		_nextNode = a_val
	endFunction
endProperty

Function deleteNode()
	PrevNode.NextNode = NextNode
	NextNode.PrevNode = PrevNode
	delete()
EndFunction

;Call on the head node to delete all
Function deleteAllNodes()
	NextNode.deleteAllNodes()
	delete()
EndFunction