require 'socket'

function love.load()
		
	math.randomseed(os.time())
	width = 1024
	height = 768
	--CELL_SIZE = height/math.random(100,120)
	CELL_SIZE = height/150
	
	love.graphics.setMode( width, height, false, true, 1 )
	--love.graphics.print("---------------------------------------------------------------")
	
	--math.randomseed(1)
	math.randomseed(os.time())
	grid = getNewGrid()
	for x = 0,width/CELL_SIZE do
		--grid[x] = {}
		for y = 0,height/CELL_SIZE do
			if x > 20 and x < 80 and y > 20 and y < 80 then
				--girid[x][y] = 0;			
				grid[x][y]["state"] = math.random(0,1)
			end
			--grid[x][y]["state"] = math.random(1,2)
			--grid[x][y]["state"] = 0;	
		end
	end

	colorGrid = getNewGrid()
	--colorGrid[1][1]["light"] = 100;
	for x = 1,width/CELL_SIZE do
		for y = 1,height/CELL_SIZE do
			colorGrid[x][y]["light"] = 100
		end
	end
	--grid[20][20] = 1;
	--grid[21][21] = 1;
	--grid[20][21] = 1;
	--grid[20][22] = 1;
	
end

-- initialises an empty grid
function getNewGrid()
	local newGrid = {}
	
	for x = 0,width/CELL_SIZE do
		newGrid[x] = {}
		for y = 0,height/CELL_SIZE do
			newGrid[x][y] = { state = 0, light = 100, color = 0 }	
		end
	end
	
	return newGrid
end

function love.update(dt)
	--love.timer.sleep(10)
	
	local newGrid = getNewGrid()
	
	
	
	for x = 0, width/CELL_SIZE do
		for y = 0, height/CELL_SIZE do
			oldVal = grid[x][y]["state"]
			ln = getNeighbours(x,y)
			
			if ln < 2 then newGrid[x][y]["state"] = 0 end
			if ln > 1 and ln < 4 and grid[x][y]["state"] == 1 then newGrid[x][y]["state"] = 1 end
			if ln > 3 then newGrid[x][y]["state"] = 0 end
			if ln == 3 then newGrid[x][y]["state"] = 1 end
			
			if oldVal == 0 and newGrid[x][y]["state"] == 1 then
				if colorGrid[x][y]["light"]  + 10 < 255 then colorGrid[x][y]["light"] = colorGrid[x][y]["light"] + 10 end
				if colorGrid[x][y]["color"] + 10 < 255 then colorGrid[x][y]["color"] = colorGrid[x][y]["color"] + 10 end
			end
		end
	end
	

	
	if love.mouse.isDown('l') then
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		x = x - (x%CELL_SIZE) 
		y = y - (y%CELL_SIZE)
		--love.graphics.rectangle('fill', x, y, 10, 10)
		grid[x/CELL_SIZE][y/CELL_SIZE] = 1
	end
	grid = newGrid
end

function getNeighbours(x,y)
	
--	x-1,y
--	x+1,y
--	x,y+1
--	x,y-1
--	x-1,y-1
--	x+1,y+1
--	x+1,y-1
--	x-1,y+1

	ln = 0 -- living neighbours
	if grid[x-1] ~= nil and grid[x-1][y]["state"] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y]["state"] == 1 then ln = ln + 1 end
	if grid[x][y-1] ~= nil and grid[x][y-1]["state"] == 1 then ln = ln + 1 end
	if grid[x][y+1] ~= nil and grid[x][y+1]["state"] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y+1] ~= nil and grid[x+1][y+1]["state"] == 1 then ln = ln + 1 end
	if grid[x-1] ~= nil and grid[x-1][y-1] ~= nil and grid[x-1][y-1]["state"] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y-1] ~= nil and grid[x+1][y-1]["state"] == 1 then ln = ln + 1 end
	if grid[x-1] ~= nil and grid[x-1][y+1] ~= nil and grid[x-1][y+1]["state"] == 1 then ln = ln + 1 end
	
	
	
	return ln
	
end

function love.draw()
	_=[[
	love.graphics.setColor( 50, 50, 50, 255 )
	for x = 0,height do
		love.graphics.line(x * CELL_SIZE, 0, x * CELL_SIZE , height) 
	end
	for y = 0,width do
		love.graphics.line(0, y * CELL_SIZE, width, y * CELL_SIZE)
	end
	]]
	
	for x = 0,width/CELL_SIZE do
		for y = 0,height/CELL_SIZE do
			if grid[x][y]["state"] == 1 then
				light = colorGrid[x][y]["light"]
				--love.graphics.print(light, 60,60)
				love.graphics.setColor( light, light, light, 100 )
				love.graphics.rectangle('fill', x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
				love.graphics.setColor( 0, 0, 0, 255 )
			else
				color = colorGrid[x][y]["color"]
				love.graphics.setColor( color, 0, 0, 100 )
				love.graphics.rectangle('fill', x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
				love.graphics.setColor( 0, 0, 0, 255 )
			end					
			-- love.graphics.polygon(fill, x, y, x + 10, y + 10)
		end
	end
	
    local x = love.mouse.getX()
    local y = love.mouse.getY()
	x = x - (x%CELL_SIZE) 
	 y = y - (y%CELL_SIZE)
	--love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
	--love.graphics.print("Height and width are (" .. height .. "," .. width .. ")", 50, 50)
	-- love.graphics.rectangle('fill', 10, 10, 10, 10)
	-- love.graphics.polygon('fill', 0, 0, 0, 10, 10, 10, 10, 10)
	-- love.graphics.polygon("fill", 0,0,10,10)
	-- love.graphics.setBackgroundColor(200,200,200)
end

function love.mousereleased(x, y, button)
		
	 x = x - (x%CELL_SIZE) 
	 y = y - (y%CELL_SIZE)
		--love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
	if button == 'l' then
		--grid[x][y]["state"] = 1
		love.graphics.rectangle('fill', x, y, 10, 10)
		grid[x/CELL_SIZE][y/CELL_SIZE] = 1
      --fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
	  
	end
end
