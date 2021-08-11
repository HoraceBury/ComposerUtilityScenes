local composer = require( "composer" )

local scene = composer.newScene()

local rndLow, rndHi = 10, 185
local defaultButtonHeight = display.safeActualContentWidth/5

local function rnd()
    return math.random(rndLow, rndHi)/255
end

local function randomFill()
    return { rnd(), rnd(), rnd() }
end

local function block( target )
    target:addEventListener( "touch", function() return true end )
    target:addEventListener( "tap", function() return true end )
end

local function createBackground( parent )
    parent.background = display.newRect( parent, display.safeActualCenterX, display.safeScreenOriginY+defaultButtonHeight/2, display.safeActualContentWidth, defaultButtonHeight )
    parent.background.isVisible = false
    block( parent.background )
end

local function createStackContainer( parent )
    scene.container = display.newGroup()
    parent:insert( scene.container )
    scene.container.x, scene.container.y = display.safeScreenOriginX, display.safeScreenOriginY

    scene.stackGroup = display.newHorizontalStack()
    scene.container:insert( scene.stackGroup )
end

local function newButton( parent, w, h, label, fill, isVisible, listener )
    fill = fill or randomFill()
    listener = listener or function() return true end

    local group = display.newGroup()
    group.class = "button:"..label
    parent:insert(group)

    group.isVisible = isVisible == nil or isVisible == true

    group.background = display.newRect( group, w/2, h/2, w, h )
    group.background.fill = fill

    group.label = display.newText{ parent=group, x=group.background.x, y=group.background.y, fontSize=100, text=label }

    group:addEventListener( "touch", function() return true end )
    group:addEventListener( "tap", listener )
end

local function buildButtons( parent, buttons )
    for i=1, #buttons do
        newButton( scene.stackGroup, display.safeActualContentWidth/#buttons, defaultButtonHeight, buttons[i].label, buttons[i].fill, buttons[i].isVisible, buttons[i].listener )
    end

    scene.stackGroup:refresh()
end

local function destroyButtons()
    while (scene.stackGroup.numChildren > 0) do
        scene.stackGroup[1]:removeSelf()
    end
end
 
function scene:create( event )
    local sceneGroup = self.view
    local params = event.params
    -- Code here runs when the scene is first created but has not yet appeared on screen

    createBackground( sceneGroup )
    createStackContainer( sceneGroup )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    local params = event.params

    scene.filename = params.filename
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        buildButtons( sceneGroup, params.buttons )
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        destroyButtons()
    end
end
 
function scene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene
