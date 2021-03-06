Scriptname FL_WidgetBuilder extends Quest  
{
Created by Teague Lander January 6th 2016
Called by the quest of the same name
Creates a linked list of forms in the container and sends info to the widget instance.
}

FL_WidgetInstance Property FL_WidgetQuest Auto
FL_SoundController Property FL_SoundControllerQuest Auto
ObjectReference curRef
int iCurRefNumItems
int iSelectorPosition = 0 ;Where our selector is relative to the top of the list that is currently displayed
bool bTakeInput = false ;If the display is being changed be cannot receive input
bool bStopCreating = false

;Linked-List Root
FL_FormNode rootNode ;rootNode will always stay empty of a form for simplicity!
FL_FormNode currentTopNode ;This will point to the top of our currently displayed list
FL_FormNode currentSelectedNode
FL_FormNode tailNode ;just used when building the list
MiscObject Property NodeType Auto
ObjectReference Property NodeSpawnPoint Auto
Actor Property PlayerRef Auto

;Properties to check
FormList Property PriorityList Auto
Form[] priorityArray

;Constants
int INITIAL_LINKED_LIST_SIZE = 6
String BOTTOM_LABEL = "E) TAKE   G) TRANSFER"

bool Property TakeInput
	bool function get()
		return bTakeInput
	endFunction
	function set(bool a_val)
		bTakeInput = a_val
	endFunction
endProperty

Event OnInit()
	NodeSpawnPoint = PlayerRef ;REplace this later
	priorityArray = PriorityList.ToArray()
EndEvent

;Functions
Function buildWidgetFromObj(ObjectReference obj)

	curRef = obj
	iCurRefNumItems = curRef.GetNumItems()
	
	getInitialItems() ;We will call displayItems inside sortItems after the first 5 nodes exist
	currentTopNode = rootNode.NextNode
	currentSelectedNode = currentTopNode
	iSelectorPosition = 0
	displayItems()
	FL_WidgetQuest.FadeInWidget()
	GetRemainingItems()
	
EndFunction


Function removeAndResetWidget()
	bStopCreating = true
	bTakeInput = false
	FL_WidgetQuest.FadeOutWidget()
	rootNode.NextNode.PrevNode = none
	rootNode.NextNode = none
	rootNode.NextNode.deleteAllNodes()
	rootNode.deleteNode()
	bStopCreating = false
	iSelectorPosition = 0
	;curRef.PlayGamebryoAnimation("close",false,1.0)
	;Here we should reset all the text and stuff
EndFunction

Function getInitialItems()

	tailNode = NodeSpawnPoint.PlaceAtMe(NodeType) as FL_FormNode
	rootNode = tailNode
	
	;BUILD FIRST 6 NODES
	int i = 0 ; Number of nodes we currently have
	int max = INITIAL_LINKED_LIST_SIZE ;max nodes to build
	if (iCurRefNumItems < max)
		max = iCurRefNumItems
	endif
	
	;Get Priority Items
	int j = 0
	while (j < priorityArray.Length)
		int curFormAmount = curRef.GetItemCount(priorityArray[j])
		if curFormAmount > 0
			tailNode = newTailNode(priorityArray[j], curFormAmount, tailNode)
			i += 1
		endif
		j += 1
	endwhile
	
	while (i < max)
		Form curForm = curRef.GetNthForm(i)
		if (curForm.GetName() == "" || (curForm as Ammo) || (curForm == priorityArray[0]));We skip this node if it is an empty item or a node we've already built
			if (max+1 <= iCurRefNumItems)
				max+=1
			endif
		else
			int curFormAmount = curRef.GetItemCount(curForm)
			tailNode = newTailNode(curForm, curFormAmount, tailNode)
		endif
		i += 1
	endwhile
	
EndFunction 

Function GetRemainingItems()
	int i = INITIAL_LINKED_LIST_SIZE
	while (i < iCurRefNumItems)
		if (curRef != Game.GetCurrentCrosshairRef())
			removeAndResetWidget()
			return
		endif 
		Form curForm = curRef.GetNthForm(i)
		if !(curForm.GetName() == "" || (curForm as Ammo) || (curForm == priorityArray[0]))
			int curFormAmount = curRef.GetItemCount(curForm);curRef.GetItemCount(curForm)
			tailNode = newTailNode(curForm, curFormAmount, tailNode)
		endif
		i += 1
	endwhile
EndFunction

;Function GetNextItem(Form curForm)
;	int curFormAmount = curRef.GetItemCount(curForm);curRef.GetItemCount(curForm)
;	tailNode = newTailNode(curForm, curFormAmount, tailNode)
;EndFunction

;LL FUNCTION
FL_FormNode Function newTailNode(Form aForm, int aAmount, FL_FormNode pNode)
	FL_FormNode newNode = pNode.PlaceAtMe(NodeType) as FL_FormNode
	pNode.NextNode = newNode
	newNode.NodeForm = aForm
	newNode.Amount = aAmount
	newNode.PrevNode = pNode
	return newNode
EndFunction

Function takeItem()
	if (true && currentSelectedNode.NodeForm.IsPlayable())
		bTakeInput = false
		FL_FormNode tempNode = currentSelectedNode;Holds the node because we will delete it after
		
		;Actually take the item
		;curRef.PlayGamebryoAnimation("open", false, 1.0)
		curRef.RemoveItem(tempNode.NodeForm, tempNode.Amount, true, PlayerRef)
		if (tempNode != rootNode && tempNode != none)	
			FL_SoundControllerQuest.PlayPickupSound(tempNode.NodeForm)
		endif
		
		;Rearrange the widget nodes
		if (tempNode.NextNode)
			currentSelectedNode = tempNode.NextNode
			if (currentTopNode == tempNode)
				currentTopNode = currentTopNode.NextNode
			endif

		elseif(tempNode.PrevNode != rootNode)
			currentSelectedNode = tempNode.PrevNode
			if (iSelectorPosition == 0)
				currentTopNode = currentTopNode.PrevNode
			else
				iSelectorPosition -= 1
				FL_WidgetQuest.SetSelectorPosition(iSelectorPosition)
			endif

		else
			currentSelectedNode = none
			currentTopNode = rootNode
		endif
		tempNode.deleteNode()
		displayItems()
	endif
EndFunction

Function scrollDown()
	if (currentSelectedNode.NextNode && bTakeInput && iSelectorPosition < 4) 
		bTakeInput = false
		currentSelectedNode = currentSelectedNode.NextNode
		if (iSelectorPosition == 3)
			if (currentSelectedNode.NextNode)
				currentTopNode = currentTopNode.NextNode
				displayItems()
			else
				iSelectorPosition += 1
				FL_WidgetQuest.SetSelectorPosition(iSelectorPosition)
			endif
		else
			iSelectorPosition += 1
			FL_WidgetQuest.SetSelectorPosition(iSelectorPosition)
		endif
		;remove this
		;FL_WidgetQuest.SetContainerName(currentTopNode.NodeForm.GetName())
		bTakeInput = true
	endif
EndFunction

Function scrollUp()
	if (currentSelectedNode.PrevNode != rootNode && bTakeInput)
		bTakeInput = false
		currentSelectedNode = currentSelectedNode.PrevNode
		if (iSelectorPosition != 0)
			iSelectorPosition -= 1
			FL_WidgetQuest.SetSelectorPosition(iSelectorPosition)
		else
			currentTopNode = currentTopNode.PrevNode
			displayItems()
		endif
		;remove this
		;FL_WidgetQuest.SetContainerName(currentTopNode.NodeForm.GetName())
		bTakeInput = true
	endif
EndFunction

int Function displayItems()
	bTakeInput = false
	FL_FormNode itNode = currentTopNode ;this will change
	String[] itemLabels = new String[5]
	bool[] blueText = new bool[5]
	bool[] redText = new bool[5]
	bool[] greyText = new bool[5]
	
	
	;Loop through first 5 nodes, setup their text and whether they are magical or stolen
	int i = 0
	while (i < 5)
		
		;Setup labels and amounts
		itemLabels[i] = itNode.NodeForm.GetName()

		if (itNode.Amount > 1)
			itemLabels[i] = itemLabels[i] + " (" + itNode.Amount + ")"
		endif
		
		;Setup magical
		if ( (itNode.NodeForm as Armor).GetEnchantment() || (itNode.NodeForm as Weapon).GetEnchantment() )
			blueText[i] = true
		endif
		
		;Setup stolen
		;NOTWORKING YET
		
		;Setup greyed
		if (!itNode.NodeForm.isPlayable())
			greyText[i] = true
		endif
		
		itNode = itNode.NextNode	
		i += 1
	endwhile
	
	;Check if there are still items left and make the last string "..." if so
	if (itNode) ;ITNODE SHOULD POINT TO THE ITEM AFTER THE END OF OUR LIST
		itemLabels[4] = ". . ."
		redText[4] = false
		blueText[4] = false
		greyText[4] = false
	endif
	
	bool arrowVisible = false
	if (rootNode.NextNode)
		arrowVisible = true
	endif
	
	;ACTUALLY DISPLAY THE ITEMS
	;THIS IS BUILT LIKE THIS: DisplayBuiltWidget(String containerName, String actionText, String[] itemNames, int arrowPosition, bool arrowVisible)
	FL_WidgetQuest.DisplayBuiltWidget(curRef.GetDisplayName(),  BOTTOM_LABEL, itemLabels,  iSelectorPosition,  arrowVisible, blueText, redText, greyText) ;
	bTakeInput = true
EndFunction


