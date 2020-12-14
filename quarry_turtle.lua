--Ryan Yeung 12/1/20 
--y is normal to the floor
-- x and z are 2 d place parallel to ground

--if theres a block in front of the turtle break it
function digXZ()
    while turtle.detect() do
        turtle.dig()
    end
end
--dig down if theres a block
function digYdown()
    while turtle.detectDown() do
        turtle.digDown()
    end
end
--move down after digging down
function moveYdown()
    digYdown()
    refuel()
    turtle.down()
end
-- dig up while theres a block there
function digYup()
    while turtle.detectUp() do
        turtle.digUp()
    end
end
-- move up after diggin up 
function moveYup()
    digYup()
    refuel()
    turtle.up()
end
-- go forward after digging forward 
function moveForward()
    digXZ()
    refuel()
    turtle.forward()
end
--spin around BB
function oneEighty()
    turtle.turnRight();
    turtle.turnRight();
end
--which direction are you facing? Cardinal coordinates once the bot has intialized this orientation, it shouldnt need to ever do it again
--N = 1 (-z)
--E = 2 (+x)
--S = 3 (+z)
--W = 4 (-x)
function orientation()
    pos = vector.new(gps.locate());
    moveForward();
    newpos = vector.new(gps.locate());
    local xmove = newpos.x - pos.x;
    local zmove = newpos.z - pos.z
    if xmove > 0 then
        facing = 2;
    elseif xmove < 0 then
        facing = 4;
    end
    if zmove > 0 then
        facing = 3;
    elseif zmove < 0 then
        facing = 1;
    end 
    return facing
end
--orient in the desired x based on your desired final loc
function xOrient(final_location)
    pos = vector.new(gps.locate());
    local diffx = final_location[1] - pos.x;
    if facing == 1 and diffx > 0 then
        turtle.turnRight()
        facing = 2;
    elseif facing == 3 and diffx > 0 then 
        turtle.turnLeft()
        facing = 2;
    elseif facing == 1 and diffx < 0 then 
        turtle.turnLeft()
        facing = 4;
    elseif facing == 3 and diffx < 0 then
        turtle.turnRight()
        facing = 4;
    elseif facing == 2  and diffx < 0 then 
        oneEighty()
        facing = 4;
    elseif facing == 4 and diffx > 0 then
        oneEighty()
        facing = 2;
    end

end
-- orient in the desired z based on your desired final loc
function zOrient(final_location)
    pos = vector.new(gps.locate());
    local diffz = final_location[3] - pos.z;
    if facing == 2 and diffz < 0 then
        turtle.turnLeft();
        facing = 1;
    elseif facing == 3 and diffz < 0 then
        oneEighty()
        facing = 1;
    elseif facing == 4 and diffz < 0 then 
        turtle.turnRight();
        facing = 1;
    elseif facing == 2 and diffz > 0 then 
        turtle.turnRight()
        facing = 3;
    elseif facing == 4 and diffz > 0 then
        turtle.turnLeft()
        facing = 3;
    elseif facing == 1 and diffz > 0 then 
        oneEighty()
        facing = 3;
    end
end
--face to the north by  spinning until you are north
function faceNorth()
    while facing ~=1 do
        turtle.turnRight()
        facing = (facing % 4) + 1;
    end 
end 
-- move to the target location( y first, then x, and then z)( down and then within the XZ plane)
-- The bot will move forward in the XZ place first is order to orient itself, then move to the point in space based on its start rotation
function moveTo(final_location)
    pos = vector.new(gps.locate());
    local diffx = final_location[1] - pos.x;
    local diffy = final_location[2] - pos.y;
    local diffz = final_location[3] - pos.z;
    --move y first
    while diffy ~= 0 do
        if diffy > 0 then
            moveYup();
            pos = vector.new(gps.locate());
            diffy = final_location[2] - pos.y;
        end
        if diffy < 0 then
            moveYdown();
            pos = vector.new(gps.locate());
            diffy = final_location[2] - pos.y;
        end
    end
    --now we should be facing the right way for moving in the X so all we gotta do is go forward 
    if diffx ~= 0 then
        xOrient(final_location);
    end
    while diffx ~= 0 do
        moveForward();
        pos = vector.new(gps.locate());
        diffx = final_location[1] - pos.x;
        end
    if diffz ~= 0 then
        zOrient(final_location);
    end
    while diffz ~= 0 do
        moveForward();
        pos = vector.new(gps.locate());
        diffz = final_location[3] - pos.z;
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- now we dig this quarry this only works currently if the dimensions of the quarry are even in width
function quarry_dig(quarry_size)
    faceNorth()
    moveYdown()
    local width = quarry_size[1];
    local depth = quarry_size[2];
    local height = quarry_size[3];
    pos = vector.new(gps.locate());
    --dig using moveTo's dope ass properties
    local j
    local i
    -- odd row matrix v good v happy hehehe
    if width % 2 == 1 then
        for j = 1, depth, 1 do
            imSoFULL()
            if j % 2 == 1 then -- if on the first laye or any odd layer, increment towards northeast
                for i = 0, width -1, 1 do
                    if i == 0 then
                        moveTo({pos.x,pos.y,pos.z - (height - 1)})
                        pos = vector.new(gps.locate())
                    elseif i % 2 == 0 and i ~= 0 then
                        moveTo({pos.x + 1, pos.y, pos.z - (height - 1)})
                        pos = vector.new(gps.locate());
                    elseif i % 2 == 1 and i ~= 0 then 
                        moveTo({pos.x + 1, pos.y, pos.z + (height - 1)})
                        pos = vector.new(gps.locate());
                    end
                end
            end
            if j % 2 == 0 then -- if on second layer or any even layer increament towards the southwest
                for i = 0, width - 1, 1 do
                    if i == 0 then
                        moveTo({pos.x,pos.y,pos.z + (height - 1)})
                        pos = vector.new(gps.locate())
                    elseif i % 2 == 0 and i ~= 0 then
                        moveTo({pos.x - 1, pos.y, pos.z + (height - 1)})
                        pos = vector.new(gps.locate());
                    elseif i % 2 == 1 and i ~= 0 then 
                        moveTo({pos.x - 1, pos.y, pos.z - (height - 1)})
                        pos = vector.new(gps.locate());
                    end
                end
            end
            if j < depth then 
                moveYdown()
            end 
            pos = vector.new(gps.locate());
        end
        --- code for edge case when columns of the grid are even-- needs to aim at - height first instead if + height first
    end 

    --- even rows uh oh stinky haha NOT stinky we did it ez
    if width % 2 == 0 then 
        for j = 1, depth, 1 do
            imSoFULL()
            if j % 2 == 1 then -- if on the first laye or any odd layer, increment towards southeast
                for i = 0, width - 1, 1 do
                    if i == 0 then
                        moveTo({pos.x,pos.y,pos.z - (height - 1)})
                        pos = vector.new(gps.locate())
                    elseif i % 2 == 0 then
                        moveTo({pos.x + 1, pos.y, pos.z - (height - 1)})
                        pos = vector.new(gps.locate());
                    elseif i % 2 == 1 then
                        moveTo({pos.x + 1, pos.y, pos.z + (height - 1)})
                        pos = vector.new(gps.locate());
                    end
                end
            end
            if j % 2 == 0 then -- if on second layer or any even layer increament towards the southwest
                for i = 0, width - 1, 1 do
                    if i == 0 then
                        moveTo({pos.x,pos.y,pos.z - (height - 1)})
                        pos = vector.new(gps.locate());
                    elseif i % 2 == 0 and i ~= 0 then
                        moveTo({pos.x - 1, pos.y, pos.z - (height - 1)})
                        pos = vector.new(gps.locate());
                    elseif i % 2 == 1 and i ~= 0 then 
                        moveTo({pos.x - 1, pos.y, pos.z + (height - 1)})
                        pos = vector.new(gps.locate());
                    end
                end
            end
            if j < depth then
                moveYdown()
            end 
            pos = vector.new(gps.locate());
        end
        --- code for edge case when columns of the grid are even-- needs to aim at - height first instead if + height first
    end
    moveTo(home)
end
-------------------------inventory management and state checking-----------------


--check your fuel level nad fill if below a certain level(we are going to run this before we move at any point)
function refuel()
    fuel = turtle.getFuelLevel()
    if fuel <= 100 then
        for slot = 1, 16, 1 do
            turtle.select(slot)
            data = turtle.getItemDetail(slot)
            if data.name == "minecraft:coal" then
                turtle.refuel()
                return
            end
        end
    end
end
-- table adding and checking generally
-- add the key to the table
function addToSet(set, key)
    set[key] = true
end
-- remove the key from the table
function removeFromSet(set, key)
    set[key] = nil
end
--check if the table has the key
function setContains(set, key)
    return set[key] ~= nil
end
--drop stuff if inventory is full and the stuff we dont want is in the inventory
function dropTrash()
    trash = {}
    addToSet(trash, "minecraft:cobblestone")
    addToSet(trash, "minecraft:dirt")
    addToSet(trash, "minecraft:andesite")
    addToSet(trash, "minecraft:diorite")
    addToSet(trash, "minecraft:granite")
    for slot = 1, 16 ,1 do
        turtle.select(slot)
        data = turtle.getItemDetail(slot)
        if setContains(trash, data.name) then
            turtle.drop()
        end
    end
end

--are all the slots full?
function imSoFULL()
    for slot = 1,16,1 do
        data = turtle.getItemDetail(slot)
        if data == nil then
            return
        end
    end
    dropTrash()
end 
------ 
--home_plusz = {-46,87,304}
--home_negz= {-46,87,304} 
--function goHome()
  --  pos = 
   -- moveTo()
--end 

--rednet.open("left")
--while rednet.recieve()
--orientation()

--testcases
moveTo({})
quarry_dig({})
moveTo({})