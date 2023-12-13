import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics




class('Grid').extends()
	function Grid:init(width, height)
		self.grid_width = width
		self.grid_height = height
		-- vertical major lines
		self.v1 = 0 + 1
		self.v4 = self.grid_width - 2
		self.v2 = (self.v4 - self.v1) / 3
		self.v3 = 2 * (self.v4 - self.v1) / 3
		-- horizontal major lines
		self.h1 = 0 + 1
		self.h4 = self.grid_width - 2
		self.h2 = (self.h4 - self.h1) / 3
		self.h3 = 2 * (self.h4 - self.h1) / 3
		-- vertical minor lines
		self.v1_1 = self.v1 + ((self.v2 - self.v1) / 3)
		self.v1_2 = self.v1 + (2 * (self.v2 - self.v1) / 3)
		self.v2_1 = self.v2 + ((self.v3 - self.v2) / 3)
		self.v2_2 = self.v2 + (2 * (self.v3 - self.v2) / 3)
		self.v3_1 = self.v3 + ((self.v4 - self.v3) / 3)
		self.v3_2 = self.v3 + (2 * (self.v4 - self.v3) / 3)
		-- horizontal minor lines
		self.h1_1 = self.h1 + ((self.h2 - self.h1) / 3)
		self.h1_2 = self.h1 + (2 * (self.h2 - self.h1) / 3)
		self.h2_1 = self.h2 + ((self.h3 - self.h2) / 3)
		self.h2_2 = self.h2 + (2 * (self.h3 - self.h2) / 3)
		self.h3_1 = self.h3 + ((self.h4 - self.h3) / 3)
		self.h3_2 = self.h3 + (2 * (self.h4 - self.h3) / 3)

		-- image
		self.grid_image = nil

    -- grid coordinates (useful for selection box)
    self.grid_coords_x = {
      self.v1, self.v1_1, self.v1_2,
      self.v2, self.v2_1, self.v2_2,
      self.v3, self.v3_1, self.v3_2,
      self.v4
    }
    self.grid_coords_y = {
      self.h1, self.h1_1, self.h1_2,
      self.h2, self.h2_1, self.h2_2,
      self.h3, self.h3_1, self.h3_2,
      self.h4
    }

    -- selection box
    self.box_x = 5
    self.box_y = 5

		self:make_image()
	end

	function Grid:make_image()
		self.grid_image = gfx.image.new(self.grid_width, self.grid_height)
		gfx.pushContext(self.grid_image)
			gfx.setColor(gfx.kColorBlack)

      -- Make the grid
			-- major lines
			gfx.setLineWidth(3)
			-- vertical
			gfx.drawLine(self.v1, 0, self.v1, self.grid_height)
			gfx.drawLine(self.v2, 0, self.v2, self.grid_height)
			gfx.drawLine(self.v3, 0, self.v3, self.grid_height)
			gfx.drawLine(self.v4, 0, self.v4, self.grid_height)
			-- horizontal
			gfx.drawLine(0, self.h1, self.grid_width, self.h1)
			gfx.drawLine(0, self.h2, self.grid_width, self.h2)
			gfx.drawLine(0, self.h3, self.grid_width, self.h3)
			gfx.drawLine(0, self.h4, self.grid_width, self.h4)

			-- minor lines
			gfx.setLineWidth(1)
			-- vertical
			gfx.drawLine(self.v1_1, 0, self.v1_1, self.grid_height)
			gfx.drawLine(self.v1_2, 0, self.v1_2, self.grid_height)
			gfx.drawLine(self.v2_1, 0, self.v2_1, self.grid_height)
			gfx.drawLine(self.v2_2, 0, self.v2_2, self.grid_height)
			gfx.drawLine(self.v3_1, 0, self.v3_1, self.grid_height)
			gfx.drawLine(self.v3_2, 0, self.v3_2, self.grid_height)
			-- horizontal
			gfx.drawLine(0, self.h1_1, self.grid_width, self.h1_1)
			gfx.drawLine(0, self.h1_2, self.grid_width, self.h1_2)
			gfx.drawLine(0, self.h2_1, self.grid_width, self.h2_1)
			gfx.drawLine(0, self.h2_2, self.grid_width, self.h2_2)
			gfx.drawLine(0, self.h3_1, self.grid_width, self.h3_1)
			gfx.drawLine(0, self.h3_2, self.grid_width, self.h3_2)
    gfx.popContext()

    -- draw the initial selection box
    self:draw_box()

  end

  function Grid:draw_box()
    gfx.pushContext(self.grid_image)
      local bx1 = self.grid_coords_x[self.box_x]
      local bx2 = self.grid_coords_x[self.box_x + 1]
      local by1 = self.grid_coords_y[self.box_y]
      local by2 = self.grid_coords_y[self.box_y + 1]
      gfx.setLineWidth(3)
      gfx.setColor(gfx.kColorBlack)
      gfx.drawLine(bx1,by1, bx2,by1)
      gfx.drawLine(bx1,by1, bx1,by2)
      gfx.drawLine(bx1,by2, bx2,by2)
      gfx.drawLine(bx2,by1, bx2,by2)
      gfx.setLineWidth(1)
      gfx.setColor(gfx.kColorWhite)
      gfx.drawLine(bx1,by1, bx2,by1)
      gfx.drawLine(bx1,by1, bx1,by2)
      gfx.drawLine(bx1,by2, bx2,by2)
      gfx.drawLine(bx2,by1, bx2,by2)
    gfx.popContext()
  end

  function Grid:erase_box()
    gfx.pushContext(self.grid_image)
      local bx1 = self.grid_coords_x[self.box_x]
      local bx2 = self.grid_coords_x[self.box_x + 1]
      local by1 = self.grid_coords_y[self.box_y]
      local by2 = self.grid_coords_y[self.box_y + 1]
      gfx.setLineWidth(3)
      gfx.setColor(gfx.kColorWhite)
      gfx.drawLine(bx1,by1, bx2,by1)
      gfx.drawLine(bx1,by1, bx1,by2)
      gfx.drawLine(bx1,by2, bx2,by2)
      gfx.drawLine(bx2,by1, bx2,by2)
      gfx.setLineWidth(1)
      gfx.setColor(gfx.kColorBlack)
      gfx.drawLine(bx1,by1, bx2,by1)
      gfx.drawLine(bx1,by1, bx1,by2)
      gfx.drawLine(bx1,by2, bx2,by2)
      gfx.drawLine(bx2,by1, bx2,by2)
    gfx.popContext()
  end




  function Grid:move_up()
    if self.box_y == 1 then
      return
    end
    -- erase the previous box/
    self:erase_box()
    self.box_y -= 1
  end

  function Grid:move_down()
    if self.box_y == 9 then
      return
    end
    self:erase_box()
    self.box_y += 1
  end

  function Grid:move_left()
    if self.box_x == 1 then
      return
    end
    self:erase_box()
    self.box_x -= 1
  end

  function Grid:move_right()
    if self.box_x == 9 then
      return
    end
    self:erase_box()
    self.box_x += 1
  end
-- end grid class


-- make a grid object
local grid = Grid(238, 238)



function playdate.update()
  if playdate.buttonJustPressed(playdate.kButtonUp) then
    grid:move_up()
  end
  if playdate.buttonJustPressed(playdate.kButtonDown) then
    grid:move_down()
  end
  if playdate.buttonJustPressed(playdate.kButtonLeft) then
    grid:move_left()
  end
  if playdate.buttonJustPressed(playdate.kButtonRight) then
    grid:move_right()
  end

  grid:make_image()
  grid.grid_image:draw(1,1)

end

function playdate.debugDraw()
  local skip_debug = true
  if skip_debug then
    return
  end
  gfx.pushContext() -- must be the screen buffer for debug
    -- playdate.setDebugDrawColor(255, 0, 0, 0.5)
    gfx.setLineWidth(3)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawLine(0,40, 0,20)
  gfx.popContext()
end






--
-- -- Name this file `main.lua`. Your game can use multiple source files if you wish
-- -- (use the `import "myFilename"` command), but the simplest games can be written
-- -- with just `main.lua`.
--
-- -- You'll want to import these in just about every project you'll work on.
--
-- import "CoreLibs/object"
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
-- import "CoreLibs/timer"
--
-- -- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- -- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- -- Performance will be slightly enhanced, too.
-- -- NOTE: Because it's local, you'll have to do it in every .lua source file.
--
-- local gfx <const> = playdate.graphics
--
-- -- Here's our player sprite declaration. We'll scope it to this file because
-- -- several functions need to access it.
--
-- local playerSprite = nil
--
-- -- A function to set up our game environment.
--
-- function myGameSetUp()
--
-- 		-- Set up the player sprite.
-- 		-- The :setCenter() call specifies that the sprite will be anchored at its center.
-- 		-- The :moveTo() call moves our sprite to the center of the display.
--
-- 		local playerImage = gfx.image.new("Images/playerImage")
-- 		assert( playerImage ) -- make sure the image was where we thought
--
-- 		playerSprite = gfx.sprite.new( playerImage )
-- 		playerSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
-- 		playerSprite:add() -- This is critical!
--
-- 		-- We want an environment displayed behind our sprite.
-- 		-- There are generally two ways to do this:
-- 		-- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
-- 		-- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
-- 		--       and call :setZIndex() with some low number so the background stays behind
-- 		--       your other sprites.
--
-- 		local backgroundImage = gfx.image.new( "Images/background" )
-- 		assert( backgroundImage )
--
-- 		gfx.sprite.setBackgroundDrawingCallback(
-- 				function( x, y, width, height )
-- 						-- x,y,width,height is the updated area in sprite-local coordinates
-- 						-- The clip rect is already set to this area, so we don't need to set it ourselves
-- 						backgroundImage:draw( 0, 0 )
-- 				end
-- 		)
--
-- end
--
-- -- Now we'll call the function above to configure our game.
-- -- After this runs (it just runs once), nearly everything will be
-- -- controlled by the OS calling `playdate.update()` 30 times a second.
--
-- myGameSetUp()
--
-- -- `playdate.update()` is the heart of every Playdate game.
-- -- This function is called right before every frame is drawn onscreen.
-- -- Use this function to poll input, run game logic, and move sprites.
--
-- function playdate.update()
--
-- 		-- Poll the d-pad and move our player accordingly.
-- 		-- (There are multiple ways to read the d-pad; this is the simplest.)
-- 		-- Note that it is possible for more than one of these directions
-- 		-- to be pressed at once, if the user is pressing diagonally.
--
-- 		if playdate.buttonIsPressed( playdate.kButtonUp ) then
-- 				playerSprite:moveBy( 0, -2 )
-- 		end
-- 		if playdate.buttonIsPressed( playdate.kButtonRight ) then
-- 				playerSprite:moveBy( 2, 0 )
-- 		end
-- 		if playdate.buttonIsPressed( playdate.kButtonDown ) then
-- 				playerSprite:moveBy( 0, 2 )
-- 		end
-- 		if playdate.buttonIsPressed( playdate.kButtonLeft ) then
-- 				playerSprite:moveBy( -2, 0 )
-- 		end
--
-- 		-- Call the functions below in playdate.update() to draw sprites and keep
-- 		-- timers updated. (We aren't using timers in this example, but in most
-- 		-- average-complexity games, you will.)
--
-- 		gfx.sprite.update()
-- 		playdate.timer.updateTimers()
--
-- end



