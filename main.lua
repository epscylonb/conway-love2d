require 'socket'

function love.load()
	width = 800
	height = 600
	
	--math.randomseed(1)
	math.randomseed(os.time()*10000)
	grid = getNewGrid()
	for x = 0,width/10 do
		grid[x] = {}
		for y = 0,height/10 do
			if x > 20 and x < 40 and y > 20 and y < 40 then
				--girid[x][y] = 0;			
				--grid[x][y] = math.random(0,1)
			end
			grid[x][y] = math.random(1,2)
			--grid[x][y] = 0;	
		end
	end

	colorGrid = getNewGrid()
	for x = 1,width/10 do
		for y = 1,height/10 do
			colorGrid[x][y] = 100
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
	
	for x = 1,width/10 do
		newGrid[x] = {}
		for y = 1,height/10 do
			newGrid[x][y] = 0		
		end
	end
	
	return newGrid
end

function love.update(dt)
	love.timer.sleep(10)
	
	local newGrid = getNewGrid()
	
	
	
	for x = 1, width/10 do
		for y = 1, height/10 do
			oldVal = grid[x][y]
			ln = getNeighbours(x,y)
			
			if ln < 2 then newGrid[x][y] = 0 end
			if ln > 1 and ln < 4 and grid[x][y] == 1 then newGrid[x][y] = 1 end
			if ln > 3 then newGrid[x][y] = 0 end
			if ln == 3 then newGrid[x][y] = 1 end
			
			if oldVal == 0 and newGrid[x][y] == 1 and colorGrid[x][y]  + 10 < 255 then colorGrid[x][y] = colorGrid[x][y] + 10 end
		end
	end
	

	
	if love.mouse.isDown('l') then
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		x = x - (x%10) 
		y = y - (y%10)
		--love.graphics.rectangle('fill', x, y, 10, 10)
		grid[x/10][y/10] = 1
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
	if grid[x-1] ~= nil and grid[x-1][y] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y] == 1 then ln = ln + 1 end
	if grid[x][y-1] ~= nil and grid[x][y-1] == 1 then ln = ln + 1 end
	if grid[x][y+1] ~= nil and grid[x][y+1] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y+1] ~= nil and grid[x+1][y+1] == 1 then ln = ln + 1 end
	if grid[x-1] ~= nil and grid[x-1][y-1] ~= nil and grid[x-1][y-1] == 1 then ln = ln + 1 end
	if grid[x+1] ~= nil and grid[x+1][y-1] ~= nil and grid[x+1][y-1] == 1 then ln = ln + 1 end
	if grid[x-1] ~= nil and grid[x-1][y+1] ~= nil and grid[x-1][y+1] == 1 then ln = ln + 1 end
	
	
	
	return ln
	
end

function love.draw()
	
	love.graphics.setColor( 255, 255, 255, 255 )
	for x = 1,800 do
		love.graphics.line(x * 10, 0, x * 10 , height) 
	end
	for y = 1,600 do
		love.graphics.line(0, y * 10, width, y * 10)
	end
	
	for x = 1,width/10 do
		for y = 1,height/10 do
			if grid[x][y] == 1 then
				color = colorGrid[x][y]
				love.graphics.print(color, 60,60)
				love.graphics.setColor( color, color, color, 255 )
				love.graphics.rectangle('fill', x * 10, y * 10, 10, 10)
				love.graphics.setColor( 0, 0, 0, 255 )
			end			
			-- love.graphics.polygon(fill, x, y, x + 10, y + 10)
		end
	end
	
    local x = love.mouse.getX()
    local y = love.mouse.getY()
	x = x - (x%10) 
	 y = y - (y%10)
	love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
	--love.graphics.print("Height and width are (" .. height .. "," .. width .. ")", 50, 50)
	-- love.graphics.rectangle('fill', 10, 10, 10, 10)
	-- love.graphics.polygon('fill', 0, 0, 0, 10, 10, 10, 10, 10)
	-- love.graphics.polygon("fill", 0,0,10,10)
	-- love.graphics.setBackgroundColor(200,200,200)
end

function love.mousereleased(x, y, button)
		
	 x = x - (x%10) 
	 y = y - (y%10)
		--love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
	if button == 'l' then
		--grid[x][y] = 1
		love.graphics.rectangle('fill', x, y, 10, 10)
		grid[x/10][y/10] = 1
      --fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
	  
	end
end
