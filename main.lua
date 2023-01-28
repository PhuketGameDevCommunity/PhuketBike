-- main.lua

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Create a group to hold our game objects
local gameGroup = display.newGroup()


-- Add a background image to the game
local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
background.x = display.contentCenterX
background.y = display.contentCenterY
gameGroup:insert( background )

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

-- Create the first tiled rectangle 
local streetBackground1 = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
streetBackground1.x = 0
streetBackground1.y = display.contentHeight-50
streetBackground1.fill = { type = "image", filename = "streetBG.png" }
streetBackground1.fill.scaleX=0.15
streetBackground1.fill.scaleY=0.15
gameGroup:insert( streetBackground1 )

-- Create the second tiled rectangle 
local streetBackground2 = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
streetBackground2.x = streetBackground1.x + streetBackground1.contentWidth 
streetBackground2.y = display.contentHeight-50
streetBackground2.fill = { type = "image", filename = "streetBG2.png" }
streetBackground2.fill.scaleX=0.15
streetBackground2.fill.scaleY=0.15
gameGroup:insert( streetBackground2 )

-- Add the movement of the rectangle
local function moveStreetBackground()
    streetBackground1.x = streetBackground1.x - 6
    streetBackground2.x = streetBackground2.x - 6
    if streetBackground1.x < -streetBackground1.contentWidth/2 then
        streetBackground1.x = streetBackground2.x + streetBackground2.contentWidth
    end
    if streetBackground2.x < -streetBackground2.contentWidth/2 then
        streetBackground2.x = streetBackground1.x + streetBackground1.contentWidth
    end
end


local player = display.newImageRect( "player.png", 50, 50 )
player.x = 100
player.y = display.contentCenterY
gameGroup:insert( player )

frames = { "PlayerAnimated/frame1.png", "PlayerAnimated/frame2.png", "PlayerAnimated/frame3.png", "PlayerAnimated/frame4.png", "PlayerAnimated/frame5.png", "PlayerAnimated/frame6.png" }
--local playerAnimated = display.newAnimation(frames,2)

--for i=1,6 do
 --   playerAnimated:setFrame( i, graphics.newImageSheet("PlayerAnimated/frame" .. i .. ".png") )
--end

--playerAnimated.looping=true
--sprite:play(playerAnimated)

local NPCBike = {}

local playerLocationAtSlot = 1

--Move up function
function moveUp()
    if playerLocationAtSlot>1 then
    	playerLocationAtSlot=playerLocationAtSlot-1
    end
end

--Move down function
function moveDown()
    if playerLocationAtSlot<4 then
    	playerLocationAtSlot=playerLocationAtSlot+1
    end
end

-- Add "move up" button
local moveUpButton = display.newImageRect( "button_moveup.png", 50, 100 )
moveUpButton.x = 25
moveUpButton.y = display.contentHeight/4
gameGroup:insert( moveUpButton )
moveUpButton:addEventListener( "tap", moveUp )

-- Add "move down" button
local moveDownButton = display.newImageRect( "button_movedown.png", 50, 100 )
moveDownButton.x = 25
moveDownButton.y = display.contentHeight*(3/4)
gameGroup:insert( moveDownButton )
moveDownButton:addEventListener( "tap", moveDown )

local function addNewNPC()
    local newNPC =    display.newImageRect( "player.png", 50, 50 )
    math.randomseed(os.time())
    local NPClaneSlot = math.random(1, 4)
    newNPC.y = 100 + (50*(NPClaneSlot-1))
    newNPC.x = math.random(480)
    table.insert(NPCBike,newNPC);
    
    
end

local NPCSpawnTimer=0

local function checkIfAnyNPCExitScreen()
    local loopIterator=0
    if #NPCBike > 0 then
        while loopIterator < #NPCBike do
           -- if NPCBike[loopIterator].x < -50 then
                --table.remove(NPCBike,loopIterator)
            --    NPCBike[loopIterator].x = 480+50
            --end
            NPCBike[loopIterator].x = NPCBike[loopIterator].x - 2
            
            loopIterator=loopIterator+1
        end
    end
end

local function moveNPCToScreenLeft()

end

-- Create a function to handle updating our game objects
local function gameLoop()
	moveStreetBackground()

    if #NPCBike < 30 then
     if NPCSpawnTimer<30 then
         NPCSpawnTimer=NPCSpawnTimer+1
     else
           NPCSpawnTimer=0
           addNewNPC()
        end
    end

    moveNPCToScreenLeft()

    checkIfAnyNPCExitScreen()

   local _targetPlayerYlocation = 100 + (50 * (playerLocationAtSlot-1))

    player.y=player.y+((_targetPlayerYlocation-player.y)*(1/30))
   
end


-- Start the game loop
Runtime:addEventListener( "enterFrame", gameLoop )

