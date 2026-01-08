pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- spaceshipproject
-- by @jcambass - joel.am/games

-- art by @jcambass inspired by
-- https://kenney.nl/assets/space-shooter-redux

-- sfx by gruber
-- https://www.lexaloffle.com/bbs/?pid=64837

-- music by snabisch
-- https://snabisch.itch.io/free-music-sequences-for-pico-8

function new(c, o)
	o=o or {}
	setmetatable(o, c)
	c.__index = c
	function c:isa(o)
		return self.__index == o
	end
	return o
end

sc_title={}
function sc_title:init()
	return new(self)
end

function sc_title:update()
	if btnp(❎) then
		game:running()
	end
	
	if is_hs_set() and btnp(🅾️) then
		game:show_hs()
	end
end

function sc_title:draw()
	local t="space"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 35, 12)
	local t="ship"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 35+8, 8)
	local t="project"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 35+8+8, 12)

	local t="@jcambass"
	print("\^o7ff"..t, hcenter(t), 35+8+8+10, 13)

	█.earthbig:draw(32, 128-█.earthbig.h)
	█.player:draw(55, 95)
	
	if is_hs_set() then
		local t="🅾️ scores"
		print("\^o7ff"..t, 1+10, 121, 13)
		local t="play ❎"
		print("\^o7ff"..t, 128-(#t*4)-8-10, 121, 13)
	else
		local t="play ❎"
		print("\^o7ff"..t, hcenter(t), 121, 13)
	end
end

sc_running={}
function sc_running:init()
	init_bg()
	init●()
	init😐()
	init🐱()
	init_░()
	init_ui()
	
	local sc=new(self, {
		halted=false,
		♪timer=timer(1)
	})
	sc.♪timer:unpause()
	
	return sc
end

function sc_running:update()
	self.♪timer:update()
	if self.♪timer.d then
		-- reserving channels 0 and 1
		music(8, 500, 3) -- fade in
		-- disable timer
		self.♪timer:reset(99)
		self.♪timer:pause()
	end
	update_bg()
 😐:update()
 update🐱()
 update░()
 update●()
 update_ui()
end

function sc_running:draw()
	draw_bg()
	draw░()
	draw●()

	😐:draw()
	draw🐱()
	draw_ui()
end

sc_show_hs={}
function sc_show_hs:init()
	return new(self, {
		replay=true
	})
end

function sc_show_hs:update()
	if btnp(❎) then
		if self.replay then
			game:running()
		else
			game:title()	
		end
	end
end

function sc_show_hs:draw()
	local t="high"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 10, 12)
	local t="scores"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 10+8, 8)

	for i, hs in ipairs(get_hs()) do
		local sp=█.medal1
		if i==2 then
			sp=█.medal2
		end
		if i==3 then
			sp=█.medal3
		end
		
		sp:draw(30, 30+i*(sp.h+2))
		if hs.score > 0 then
			local nx=print("\^o9ff😐",
				30+3+sp.w,
				30+4+i*(sp.h+2),
				10
			)
			nx=print(hs.name,
				nx+1,
				30+4+i*(sp.h+2),
				7
			)
			nx=print("\^o9ff★",
				nx+1,
				30+4+i*(sp.h+2),
				10
			)
			nx=print(hs.score,
				nx+1,
				30+4+i*(sp.h+2),
				7
			)
		else
			print("-",
				30+3+sp.w,
				30+4+i*(sp.h+2),
				7
			)
		end
	end

	local t="❎ back"
	if self.replay then
		t="❎ play again"
	end
	print("\^o7ff"..t, hcenter(t), 121, 13)
end

sc_new_hs={}
function sc_new_hs:init()
	reset_picoboard()
	sfx(11)
	return new(self)
end

function sc_new_hs:update()
	update_picoboard(self.submit_score)
end

function sc_new_hs.submit_score()
	set_hs(txtstr)
	game:show_hs()
end

function sc_new_hs:draw()
	local t="new"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 10, 12)
	local t="high"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 10+8, 8)
	local t="score"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8), 10+8+8, 12)

	local _, at=is_new_hs()
	local sp=█.medal1
	if at==2 then
		sp=█.medal2
	end
	
	if at==3 then
		sp=█.medal3
	end
	
	local s=" "..score
	local lx=64-(sp.w+#tostring(s)*4)/2
	sp:draw(lx, 40)
	print(s, lx+sp.w, 40+4, 7)
	
	local sx=print("\^w\^t\^o7ff😐", lx, 40+4+12, 9)
	draw_picoboard(lx+16+2, 40+4+12+2)
end

sc_gameover={}
function sc_gameover:init()
	init●()
	local o=new(self, {
		ex_t=timer(1),
		hide_earth=false
	})
	
	o.ex_t:unpause()
	
	return o
end

function sc_gameover:update()
	self.ex_t:update()
	if self.ex_t.d then
		local ex=explode({
			x=64-█.earthmid.w/4,
			y=74-█.earthmid.h/4
		})
		ex.s=3
		ex.inter=0.06
		ex.high=function(_self)
			self.hide_earth=true
		end
		ex.done=function(_self)
			game:new_or_show_hs()
		end
		ex:add()
		sfx(13) 
		
		self.ex_t:reset(2)
		self.ex_t:pause()
	end
	
 update●()
end

function sc_gameover:draw()
	local t="game over!"
	print("\^w\^h\^o7ff"..t, hcenter(t, 8)+4, 30, 8)
	
	if not self.hide_earth then
		█.earthmid:draw(64-█.earthmid.w/2, 74-█.earthmid.h/2)
	end
	
	draw●()
end


game={
	sc=nil,
	title=function(self)
		self.sc=sc_title:init()
	end,
	running=function(self)
		self.sc=sc_running:init()
		music(-1, 1000)
	end,
	show_hs=function(self)
		local sc=sc_show_hs:init()
		if self.sc:isa(sc_title) then
			sc.replay=false
		end
		
		self.sc=sc
	end,
	new_or_show_hs=function(self)
		if is_new_hs() then
			self.sc=sc_new_hs:init()
		else
			self.sc=sc_show_hs:init()
		end
	end,
	gameover=function(self)
		-- reserving channels 0 and 1
		music(0, 500, 3) -- fade in
		self.sc=sc_gameover:init()			
	end,
}

function _init()
	cartdata("jcambass_ssp")
	-- btnp never repeats
	poke(0x5f5c, 255)
	game:title()
	-- reserving channels 0 and 1
	music(0, 500, 3) -- fade in
end

function _update60()
	game.sc:update()
end

function _draw()
	cls()
	game.sc:draw()
end
-->8
-- ui

function init_ui()
	earthh=1000
	score=0
	msg=nil
	♥shake=shake()
	😐♥bar=♥bar(100)
	eart♥bar=♥bar(earthh)
	earthshake=shake()
	inst=timer(3)
	inst:unpause()
end

function update_ui()
	inst:update()
	
	if msg then
		if msg.t <= 0 then
			msg=nil
		else
			msg.t -= 1
		end
	end
	
	if earthh <= 0 then
		-- skip halted state
		game:gameover()
	end
end

function draw_ui()	
		-- score
	█.score:draw(0, 1)
	print("\^o7ff"..score,
		█.score.w+2,
		1+2,
		9
	)
	
	rrectfill(
		128-#😐.weapons*7-2,
		1,
		#😐.weapons*7+1,
		9,
		2,
		😐.weapons[😐.wi].c
		)
		
	rrect(
		128-#😐.weapons*7-2,
		1,
		#😐.weapons*7+1,
		9,
		2,
		7
		)
		
		local name=😐.weapons[😐.wi].name
		print(
			name,
			center(
				name,
				128-#😐.weapons*7-1,
				#😐.weapons*7+1
			),
			3,
			7
		)

	for i, wp in ipairs(😐.weapons) do
		local outerc=6
		local innerc=5
		
		if 😐.level >= i then
			innerc=wp.c
		end
		
		if 😐.wi==i then
			outerc=7
		end
		local cx=128-25+((i-1)*6)
		circ(cx, 13, 2, outerc)
		rectfill(cx-1, 13-1, cx+1, 13+1, innerc)
	end
	
	-- player health
	♥shake:start_draw()
		█.heart:draw(1, 128-█.heart.h-1-12-1)
		print("\^o7ff"..😐.♥, █.heart.w+1+1+1+1,128-█.heart.h-1-12-1, 8) 
		😐♥bar:draw(😐.♥, 1+█.heart.w+1+1, 128-█.heart.h-1-12+7-1, 12)
	♥shake:stop_draw()
	
		-- earth health
	earthshake:start_draw()
		█.earth:draw(1, 128-█.earth.h-1+1-1)
		print("\^o7ff"..earthh, █.earth.w+1+2,128-█.earth.h-1+1-1, 12)
		eart♥bar:draw(earthh, █.earth.w+1+1, 128-█.earth.h-1+1+7-1, 16)
	earthshake:stop_draw()
	
	print("\^o7fffire ❎",128-29,128-7-9,13)
	print("\^o7ffswitch 🅾️",128-37,128-7, 13)
	
	-- start instructions
	if not inst.d then
		local t="protect    as long"
		local n=print("\^o7ff"..t, hcenter(t), 50, 12)
		█.earth:draw(n-41, 50-2)
		local t="as you can!"
		print("\^o7ff"..t, hcenter(t), 50+10, 12)
		
		-- msg are ignored while
		-- welcome inst is shown
		msg=nil
		return	
	end
	
	if msg then
		local pad=1
		rrectfill(
			hcenter(msg.text)-(pad*4)-1,
			61-2,
			(#msg.text+pad+pad)*4,
			9,
			5,
			msg.bg
		)
		rrect(
			hcenter(msg.text)-(pad*4)-1,
			61-2,
			(#msg.text+pad+pad)*4,
			9,
			5,
			msg.fg
		)
		print(msg.text, hcenter(msg.text), 61, msg.fg)	
	end
end

function setmsg(text, bg, fg, t)
	msg={
		text=text,
		t=t or 90,
		bg=bg,
		fg=fg,
	}
end

function hcenter(s, fw)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  fw=fw or 4
  return 64-#s*(fw/2)
end

function center(s, x, w, fw)
	fw=fw or 4
	local c=flr(x+w/2)
	return c-#s*(fw/2)
end

♥barh=4

function ♥bar(full♥)
	return {
		full♥=full♥,
		draw=function(self,♥, x, y, w)
			local hper=♥/self.full♥
			
			-- will always draw at least
			-- one pixel.
			
			rect(
				x,
				y,
				x+w,
				y+2,
				7
			)
			
			if hper < 0 then
				hper=0
			end
			
			local innerw=w-2			
		
			-- render before green
			-- to hide it
			line(
				x+1+(innerw*hper),
				y+1,
				x+1+innerw,
				y+1,
				8)
			
			if hper > 0 then
				line(
					x+1,
					y+1,
					x+1+(innerw*hper),
					y+1,
					11)
			end
		end
	}
end
-->8
-- backdrop

function init_bg()
	bgitems={}
	
	for i=1,15 do
		-- stars
		local s=rndrng(0.1, 0.2)
  add(bgitems,{
   x=randx(3),
   y=rnd(128),
   s=s,
   accs=s,
   w=3,
   h=3,
   draw=function(self)
   	█.star:draw(self.x, self.y)
   end,
   update=function(self)
   	move(self)
   	if self.y >= 128 then
   		self.s=rndrng(0.1, 0.2)
					self.accs=self.s
   		self.y=-self.h
  			self.x=randx(self.w)
   	end
   end
  })
 end
 
 -- planet
 local planetx=function(dwh)
 	return rnd({
			rndrng(-(dwh/2), 5),
			rndrng(128-(dwh/2), 128-dwh-5)
		})
 end
 
 local dwh=rndrng(32, 48)
 add(bgitems, {
		sp=rnd({█.planet1, █.planet2, █.planet3, █.planet4}),
		x=planetx(dwh),
		y=ytimer(5, 0.2)-32,
		s=0.2,
		accs=0.2,
		w=32,
		h=32,
		dwh=dwh,
		draw=function(self)
				self.sp:draw(self.x, self.y, self.dwh, self.dwh)
		end,
		update=function(self)
			move(self)
			if self.y >= 128 then
				self.sp=rnd({█.planet1, █.planet2, █.planet3, █.planet4})
				self.y=ytimer(rndrng(10, 20), self.s)-32
				self.accs=0.2
				self.dwh=rndrng(32, 48)
				self.x=planetx(self.dwh)
			end
		end
	})
	
	-- earth
	add(bgitems, {
		x=32,
		y=128-█.earthbig.h,
		s=0.075,
		accs=0.075,
		w=█.earthbig.w,
		h=█.earthbig.h,
		draw=function(self)
			█.earthbig:draw(self.x, self.y)
		end,
		update=function(self)
   	move(self)
   	if self.y >= 128 then
					del(bgitems, self)
   	end
   end
		})
end

function draw_bg()
	for bgi in all(bgitems) do
		bgi:draw()
 end
end

function update_bg()
	for bgi in all(bgitems) do
		bgi:update()
	end
end
-->8
-- 😐player

function init😐()
	😐={
		sp=█.player,
		x=55,
		y=95,
		w=█.player.w,
		h=█.player.h,
		s=0.75,
		level=1,
		wi=1,
		♥=100,
		full♥=100,
		shake=shake(),
		maxy=128-█.player.h,
		weapons={
		{
				name="ratata",
				unlockat=0,
				c=12,
				✽=ratata(true),
				gp={
					{x=0, y=5+4},
					{x=15,y=5+4},
				},
			},
			{
				name="biter",
				unlockat=1500,
				c=9,
				✽=biter(true),
				gp={
					{x=1,y=7+5},
					{x=12,y=7+5}
				},
			},
			{
				name="hammer",
				unlockat=3000,
				c=8,
				✽=hammer(true),
				gp={
					{x=0,y=4},
					{x=7,y=0},
					{x=15,y=4}
				},
			},
			{
				name="reaper",
				unlockat=6000,
				c=14,
				✽=grim(true),
				gp={
					{x=7, y=0}
				},
			},
		},
		damage=function(self, ✽)
			self.♥ -= ✽
			local mag=😐damage_mag(✽)
			♥shake:apply(mag)
		 self.shake:apply(mag)
		 sfx(16)
		end,
		push=function(self, pb)
			-- increase cooldown
			-- instead of pushing player
			if (pb == 0) return
			for weapon in all(self.weapons) do
		 	weapon.✽.cdt:reset(rndrng(1, 2))
		 end
		end,
		update=function(self)
			if game.sc.halted then
				return
			end
			
			if self.♥ <= 0 then
				self.♥=0
				local ex=explode(self)
				ex.done=function(self)
					game:gameover()
				end
				ex:add()
				sfx(13) 
				
				game.sc.halted=true
				music(-1, 500) -- fade out
			end
			
			if btn(0) then
				self.x-=self.s
			end
		 
		 if btn(1) then
		 	self.x+=self.s
		 end
		 
		 if btn(2) then
		 	self.y-=self.s
		 end
		 
		 if btn(3) then
		 	self.y+=self.s
		 end
		 
		 if self.x < 0 then
		 	self.x=0
		 end
		 
		 if self.y < 0 then
		 	self.y=0
		 end
		 
		 if self.x > 128-self.w then
		 	self.x=128-self.w
		 end
		 
		 if self.y > self.maxy then
		 	self.y=self.maxy
		 end
		 
		 for weapon in all(self.weapons) do
		 	weapon.✽.cdt:update()
		 end
				 
		 if btn(❎) then
		 	local weapon=self.weapons[self.wi]
		 	weapon.✽:fire(self, weapon.gp)
		 end
		 
		 if btnp(🅾️) then
		 	if self.level == 1 then
		 		-- do not set msg or play sfx if
		 		-- instructions are still shown
		 		if inst.d then
		 		-- extra space bc of wide glyph
		 		setmsg("unlocked at 1500★ ", 5, 6, 60)
		 		sfx(10)
		 		end
		 	else
			 	local oldwi=self.wi
			 	self.wi+=1
			 	sfx(15)
			 	if self.wi > self.level then
			 		self.wi=1
			 	end 
		 	end
		 end
		 
		 -- level up!
		 local nextwp=self.weapons[self.level+1]
		 if nextwp and score >= nextwp.unlockat then
		 		self.♥=100
		 		self.level +=1
		 		setmsg("unlocked "..nextwp.name.." ♥=100 ",nextwp.c, 7)
		 		sfx(11)
		 end
		end,
		draw=function(self)
			if game.sc.halted then
				return
			end
			
				self.shake:start_draw()
					self.sp:draw(self.x, self.y)
				self.shake:stop_draw()
		end
	}
end


-->8
-- util

function draw█(self, x, y,...)
	sspr(self.x, self.y, self.w, self.h, x, y, ...)
end

█={
	star={
		x=0,
		y=0,
		w=3,
		h=3,
		draw=draw█,
	},
	earth={
		x=16,
		y=22,
		w=10,
		h=10,
		draw=draw█,
	},
	earthbig={
		x=8,
		y=100,
		w=64,
		h=27,
		draw=draw█,
	},
	earthmid={
		x=0,
		y=64,
		w=32,
		h=32,
		draw=draw█,
	},
	heart={
		x=26,
		y=22,
		w=9,
		h=9,
		draw=draw█,
	},
	score={
		x=35,
		y=22,
		w=9,
		h=9,
		draw=draw█,
	},
	player={
		x=29,
		y=0,
		w=16,
		h=19,
		draw=draw█,
	},
	darklord={
		x=48,
		y=0,
		w=15,
		h=17,
		draw=draw█,
	},
	bigship={
		x=64,
		y=0,
		w=13,
		h=16,
		draw=draw█,
	},
	trespasser={
		x=78,
		y=0,
		w=15,
		h=17,
		draw=draw█,
	},
	spacecrusader={
		x=96,
		y=0,
		w=16,
		h=17,
		draw=draw█,
	},
	planet1={
		x=0,
		y=32,
		w=32,
		h=32,
		draw=draw█,
	},
	planet2={
		x=32,
		y=32,
		w=32,
		h=32,
		draw=draw█,
	},
	planet3={
		x=64,
		y=32,
		w=32,
		h=32,
		draw=draw█,
	},
	planet4={
		x=96,
		y=32,
		w=32,
		h=32,
		draw=draw█,
	},
	hammer={
		x=2,
		y=8,
		w=1,
		h=1,
		draw=draw█,
	},
	stomp={
		x=0,
		y=8,
		w=1,
		h=2,
		draw=draw█,
	},
	biter={
		x=6,
		y=8,
		w=3,
		h=2,
		draw=draw█,
	},
	grim={
		x=3,
		y=8,
		w=3,
		h=3,
		draw=draw█,
	},
	ratata={
		x=1,
		y=8,
		w=1,
		h=3,
		draw=draw█,
	},
	explosion={
		x=0,
		y=16,
		w=16,
		h=16,
		draw=draw█,
	},
	medal1={
		x=44,
		y=18,
		w=13,
		h=13,
		draw=draw█,
	},
	medal2={
		x=57,
		y=18,
		w=13,
		h=13,
		draw=draw█,
	},
	medal3={
		x=70,
		y=18,
		w=13,
		h=13,
		draw=draw█,
	}
}

function rndrng(min, max)
	if min > max then
		min,max=max,min
	end

	local r=max-min
	if r < 0 then
		return -rnd(-r) + -min
	else
		return rnd(r) + min
	end
end

function ytimer(seconds, speed)
	return -(speed * 60 * seconds)
end

function move(a)
	if game.sc.halted then
		return	
	end
	
	a.accs += a.s
 if a.accs >= 1 then
 	local d = flr(a.accs)
 	a.accs = a.accs % d
  a.y += d
 end
end

function moveup(a)
	if game.sc.halted then
		return	
	end
	
	a.accs += a.s
 if a.accs >= 1 then
 	local d = flr(a.accs)
 	a.accs = a.accs % d
  a.y -= d
 end
end

function timer(s)
	return {
		f=60*s,
		update=function(self)
			if self.d then
				return
			end
			
			if not self.p then
				self.f -= 1
			end
			if self.f <= 0 then
				self.d=true
			end
		end,
		p=true,
		d=false,
		pause=function(self)
			self.p=true
		end,
		unpause=function(self)
			self.p=false
		end,
		reset=function(self, ts)
			self.d=false
			self.f=60*(ts or s)
		end
	}
end

function randx(w)
	return rnd(128-w) -- 0..128-w
end

function aabbcol(r1, r2)
  return r1.x < r2.x+r2.w and r1.x+r1.w > r2.x and r1.y < r2.y+r2.h and r1.y+r1.h > r2.y
end

function shake()
	return {
		mag=0,
		apply=function(self, mag)
			self.mag=mag or 0.2
		end,
		start_draw=function(self)
			local shakex=16-rnd(32)
		 local shakey=16-rnd(32)
		
		 shakex*=self.mag
		 shakey*=self.mag
		 
		 camera(shakex,shakey)
		 
		 -- fade out the shake
		 -- reset to 0 when very low
		 self.mag = self.mag*0.95
		 if (self.mag<0.05) self.mag=0
		end,
		stop_draw=function(self)
			camera()
		end
	}
end
-->8
-- weapons

function init_░()
	░={}
end

function fire(w, a, gps)
	if game.sc.halted then
		return
	end
	
	if not(w.cdt.d or w.cdt.p) then
		return
	end
		
	if w.cdt.p then
		w.cdt:unpause()
	end
		
	-- shoot
	for gp in all(gps) do
		add(░, {
			sp=w.sp,
			x=a.x+gp.x,
			y=a.y+gp.y,
			s=w.s,
			w=w.sp.w,
			h=w.sp.h,
			accs=w.s,
			✽=w.✽,
			pb=w.pb,
			f=w.f,
			update=function(self)
				if self.f then
					moveup(self)
					
					for e in all(🐱) do
						if aabbcol(self, e) then
			 			e:damage(self.✽)
			 			e:push(self.pb)
							del(░, self)
							return
						end
					end
				
					if self.y <= self.h then
						del(░, self)
					end
				else
					move(self)
					
					if aabbcol(self, 😐) then
		 			😐:damage(self.✽)
		 			😐:push(self.pb)
		 			
						del(░, self)
						return
					end
				
					if self.y >= 128 then
						del(░, self)
					end
				end
			end,
			draw=function(self)
				self.sp:draw(self.x, self.y)
			end
		})
	end
	
	-- reset timer
	w.cdt:reset() 
end

function update░()
	for b in all(░) do
		b:update()
	end
end

function draw░()
	for b in all(░) do
		b:draw()
	end
end

function ratata(f)
	return {
		f=f,
		sp=█.ratata,
		cdt=timer(0.2),
		s=3,
		✽=6,
		pb=0.0,
		fire=fire
	}
end

function stomp(f)
	return {
		f=f,
		sp=█.stomp,
		cdt=timer(0.5),
		s=1,
		✽=4,
		pb=0.0,
		fire=fire
	}
end

function biter(f)
	return {
		f=f,
		sp=█.biter,
		cdt=timer(0.4),
		s=4,
		✽=14,
		pb=0.0,
		fire=fire
	}
end

function hammer(f)
	return {
		f=f,
		sp=█.hammer,
		cdt=timer((f and 0.6 or 2)),
		s=(f and 1.5 or 1),
		✽=(f and 10 or 4),
		pb=2,
		fire=fire,
	}
end

function grim(f)
	return {
		f=f,
		sp=█.grim,
		cdt=timer((f and 0.7 or 2)),
		f=f,
		s=(f and 2.5 or 1),
		✽=(f and 55 or 15),
		pb=0.0,
		fire=fire
	}
end
-->8
-- enemy

etypes={
	-- trespasser
	{
		sp=█.trespasser,
		s=0.5,
		♥=30,
		cd=13,
		★=35,
		✽=nil,
		gp={}
	},
	-- space crusader
	{
		sp=█.spacecrusader,
		s=0.15,
		♥=80,
		cd=55,
		★=180,
		✽=hammer,
		gp={
			{x=2,y=5},
			{x=7,y=5},
			{x=13,y=5},
		}
	},
	-- dark lord
	{
		sp=█.darklord,
		s=0.1,
		♥=200,
		cd=75,
		★=250,
		✽=grim,
		gp={
			{x=6,y=10},
		}
	},
	-- big ship
	{
		sp=█.bigship,
		s=0.15,
		♥=100,
		cd=35,
		★=120,
		✽=stomp,
		gp={
			{x=6,y=0},
		}
	}
}

min_✽=0
max_✽=0

for e in all(etypes) do
	if e.cd < min_✽ then
		min_✽=e.cd
	end
	
	if e.cd > max_✽ then
		max_✽=e.cd
	end
	
	if e.✽ then
		local w=e.✽(false)
		if w.✽ < min_✽ then
			min_✽=w.✽
		end
		
		if w.✽ > max_✽ then
			max_✽=w.✽
		end
	end
end

function 😐damage_mag(✽)
 return 0.1 + (✽ - min_✽) / (max_✽ - min_✽) * 0.9
end

function spawn🐱()
	local e=rnd(etypes)
 add(🐱, {
 	e=e,
 	s=e.s,
 	w=e.sp.w,
 	h=e.sp.h,
		x=randx(e.sp.w),
		y=-e.sp.h,
		accs=e.s,
		gp=e.gp,
		♥=e.♥,
		full♥=e.♥,
		♥bar=♥bar(e.♥),
		✽=(e.✽ and e.✽(false) or nil),
		draw=function(self)
				self.e.sp:draw(self.x, self.y)
				
				local pad=1
				local llen=self.w-2*pad-1
				local lstart=self.x+pad
				local ly=self.y-2-2
				self.♥bar:draw(self.♥, lstart, ly, llen)
		end,
		damage=function(self, ✽)
			self.♥ -= ✽
			sfx(14)
		end,
		push=function(self, pb)
			if (pb == 0) return
			self.y -= pb
			if self.y <= 0 then
				self.y=0
			end
		end,
		dead=function(self)
			del(🐱, self)
			score+=self.e.★
			self:explode():add()
			sfx(12)
		end,
		update=function(self)
			move(self)
			
			if aabbcol(self, 😐) then
 			😐:damage(self.e.cd)
				self:dead()
				return
			end
			
			if self.✽ then
				self.✽.cdt:update()
				
					-- if player within view shoot
				sb={
					x=self.x,
					y=self.y,
					w=self.w,
					h=128-self.y,
				}
				
				if self.y >=-(self.h/2) and aabbcol(sb, 😐) then
					self.✽:fire(self, self.gp)
				end
			end
			
			if self.y >= 128+♥barh then
				-- enemy made it to earth
				earthh -=self.e.★
				earthshake:apply()
				del(🐱, self)
			end
			
			if self.♥ <= 0 then
				self:dead()
			end
		end,
		explode=explode
	})
end

function init🐱()
	🐱={}
	sp=timer(rndrng(3, 7))
	sp:unpause()
end

function update🐱()
	sp:update()
	if sp.d then
		if #🐱 < 4 then
			spawn🐱()
			sp=timer(rndrng(3, 7))
			sp:unpause()
		end
	end
	
	for e in all(🐱) do
		e:update()
	end
end

function draw🐱()
	for e in all(🐱) do
		e:draw()
 end
end
-->8
-- animations

function init●()
	●={}
end

function update●()
	for anim in all(●) do
		anim:update()
	end
end

function draw●()
 for anim in all(●) do
		anim:draw()
	end
end

function explode(a)
	return {
			spn={2,4,8,16,16,8,4,2},
			s=1,
			x=a.x,
			y=a.y,
			inter=0.15,
			spi=0,
			sp=█.explosion,
			shake=shake(),
			add=function(self)
				add(●, self)
			end,
			done=function(self)
				-- do nothing by default
			end,
			high=function(self)
				-- do nothing by default
			end,
			update=function(self)
				self.spi+=self.inter
				
				-- midway
				if ceil(self.spi) == 4 then
					self.high()
				end
				
				if self.spi > #self.spn then
					del(●, self)
					self.done()
				end						
			end,
			draw=function(self)				
				local sl=self.spn[ceil(self.spi)]
				msl=sl*self.s
				local off=(16-msl)/2
				self.shake:apply(0.01*sl)
				self.shake:start_draw()
					self.sp:draw(
						self.x+off,
						self.y+off,
						msl,
						msl)
				self.shake:stop_draw()
			end
		}
end
-->8
-- highscore

function is_hs_set()
	return r_hs(1).score > 0
end

function get_hs()	
	return {
		r_hs(1),
		r_hs(2),
		r_hs(3)
	}
end

function is_new_hs()
	local old=get_hs()
	local at=0
	
	for i, hs in ipairs(old) do
		if score > hs.score then
			at=i
			break
		end
	end
	
	if at==0 then
		return false, 0
	end
	
	return true, at
end

function set_hs(name)
	local old=get_hs()
	
	local at=0
	
	for i, ohs in ipairs(old) do
		if score > ohs.score then
			at=i
			break
		end
	end
	
	if at == 0 then
		-- should never happen
		return
	end
	
	local hs={
		name=name,
		score=score
	}
	
	if at==1 then
		s_hs(1, hs)
		s_hs(2, old[1])
		s_hs(3, old[2])
	elseif at==2 then
		s_hs(2, hs)
		s_hs(3, old[2])
	else
		s_hs(3, hs)
	end
end

function r_hs(i)
	local i=i*4-1
	local n=chr(dget(i), dget(i+1), dget(i+2))
	if n=="" then
		n="-"
	end
	return {
		name=n,
		score=dget(i+3)
	}
end

function s_hs(i, hs)
	local i=i*4-1
	dset(i, ord(hs.name[1]))
	dset(i+1, ord(hs.name[2]))
	dset(i+2, ord(hs.name[3]))
	dset(i+3, hs.score)
end

--picoboard 1.3
--by afburgess
--(with beautiful optimisations by sibwara)
--https://www.lexaloffle.com/bbs/?tid=4076
--mddified by @jcambass

--initialising values
x=18
y=88

key = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
txtstr = {}
pr = 0
blk=0
keypos={x=0,y=0}
dspos={x=0,y=0}

function reset_picoboard()
	txtstr = {}
	pr = 0
	blk=0
	keypos={x=0,y=0}
	dspos={x=0,y=0}
end

function update_picoboard(confirm)
		local confirm=function()
		if #txtstr == 0 then
			return
		end
		
		confirm()
	end
	--keymappings
	local oldkp={
		x=keypos.x,
		y=keypos.y
	}
	
	if btnp(1) then keypos.x +=1 end
	if btnp(0) then keypos.x -=1 end
	if btnp(2) then keypos.y -=1 end
	if btnp(3) then keypos.y +=1 end
	if btnp(4) then backspace() end
	if btnp(5) then select(confirm) end
	
	--keyboard looping
	-- last raw only has 8 keys	
	if keypos.y == 2 then
		if oldkp.y == 1 then
			if oldkp.x == 6 or oldkp.x == 7 then
				keypos.x=6
			end
			
			if oldkp.x == 8 or oldkp.x == 9 then
				keypos.x=7
			end
		end
		
		if keypos.x > 7 then keypos.x=0 end
		if keypos.x < 0 then keypos.x=7 end
	else
		if keypos.x > 9 then keypos.x = 0 end
		if keypos.x < 0 then keypos.x = 9 end
		if keypos.y > 2 then keypos.y = 0 end
		if keypos.y < 0 then keypos.y = 2 end
	end
end

function draw_picoboard(sx, sy)
	--keyboard draw
	rectfill(x-7,y-7,x+99,y+31,0)
	rect(x-7,y-7,x+99,y+31,7)
	
	local tcol=7
	if #txtstr == 3 then
		tcol=6
	end
	for r1=0,9 do
	 print(key[r1+1+pr],x+r1*10,y,tcol)
	 print(key[r1+11+pr],x+r1*10,y+10,tcol)
	end
	for r2=0,5 do
	 print(key[r2+21+pr],x+r2*10,y+20,tcol)
	end
	
	local delc=8
	local entc=11
	if #txtstr == 0 then
		delc=6
		entc=6
	end
	print("del", x+6*10, y+20, delc)
	print("ent", x+8*10, y+20, entc)
	
	--cursor draw
	if keypos.y==2 and keypos.x==6 then
			rect(keypos.x*10+x-3,keypos.y*10+y-3,keypos.x*10+x+13,keypos.y*10+y+7,7)
	elseif keypos.y==2 and keypos.x==7 then
			rect((keypos.x+1)*10+x-3,keypos.y*10+y-3,(keypos.x+1)*10+x+13,keypos.y*10+y+7,7)
	else
			rect(keypos.x*10+x-3,keypos.y*10+y-3,keypos.x*10+x+5,keypos.y*10+y+7,7)
	end
	
	--displaystring
	str=""
	for i in all(txtstr) do
		str=str..i..""
		print(str,sx,sy,7)
	end

	--blinker
	blk+=1
 blk %= 20
 if blk>10 then 
 rectfill(sx+4*#txtstr,sy,sx+2+4*#txtstr,sy+4,8)
 end
end

function select(confirm)
newkey = keypos.x + keypos.y*10 + 1

if newkey > 26 then
 if newkey == 27 then backspace() end
 if newkey == 28 then confirm() end
else
if #txtstr < 3 then
	add(txtstr,key[newkey+pr])
end
end
end

function backspace()
 if #txtstr > 0 then txtstr[#txtstr]=nil end
end
__gfx__
06000000000000000000700000000000000000000000000000000000000000000006000006000000000000000000000000000000000000000000000000000000
67600000000000000007870000000000000077000000000077700600060077700067600067600000777000007770000000000066660000000000000000000000
0600000000000000806787608000000000078870000000007337006060073370067976667976000dccc70007cccd000000000666666000000000000000000000
0000000000000000867888768000000000078870000000007333706060733370679997679997600cccc70007cccc00000007666dd66670000000000000000000
00000000000000008678187680000000007888870000000057333d666d33375079999767999970dcccd66666dcccd000007266dddd6627000000000000000000
00000000000000008a78887a8000000000788887000000000733d66666d3370079999767999970cccd6666666dccc00007226dd11dd622700000000000000000
00000000000000000078887000000e00067888876000e0000733d66666d3370079999767999970cccd6666666dccc00072226d1111d622270000000000000000
0000000000000000000787000000080066788887660080000733d66666d3370079997565799970cccd6666666dccc00072226d1111d622270000000000000000
bc80e09090000000000000000000086667881188766680000573d66666d37500799756665799705cccd66666dccc50005722d611116d22750000000000000000
bc0e0e9990000000000000000000086667811118766680000073d66666d3700079756ddd6579700ccc5611165ccc000007222661166222700000000000000000
0c00e00000000000000000000000086aa78111187aa6800000733d666d3370005756666666575005c706666607c5000007222d6116d222700000000000000000
0000000000000000000000000000086aa78888887aa68000007377666773700005d6111116d50000c705666507c0000007225061160522700000000000000000
0000000000000000000000000000085aa78888887aa580000077766166777000005d61116d5000005c7055507c5000000572006dd60027500000000000000000
00000000000000000000000000000209978888887990200000556611166550000005d666d50000000c7000007c00000000720056650027000000000000000000
000000000000000000000000000000000788888870000000000066111660000000005d6d5000000005c70007c500000000720005500027000000000000000000
0000000000000000000000000000000005788887500000000000566666500000000005550000000000c70007c000000000550000000055000000000000000000
00000999999000000000000000000000005788750000000000000555550000000000000000000000005500055000000000000000000000000000000000000000
00099aaaaaa990000000000000000000000577500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009aa999999aa9000000000000000000000055000000000777777700000077777770000007777777000000000000000000000000000000000000000000000000
09a99aaaaaa99a900000000000000000000000000000007799999770000779999977000077999997700000000000000000000000000000000000000000000000
09a9a999999a9a900000000000000000000000000000077999999977007799999997700779999999770000000000000000000000000000000000000000000000
9a9a9aaaaaa9a9a900000000000000000000000000007799aaaa999777799aaaaa99777799aaaaa9977000000000000000000000000000000000000000000000
9a9a9a9999a9a9a900777777000777077700007770007999a00a999977999a000a99977999a000a9997000000000000000000000000000000000000000000000
9a9a9a9aa9a9a9a9077cbbb7707787778770077977007999aa0a999977999aaa0a99977999aaa0a9997000000000000000000000000000000000000000000000
9a9a9a9aa9a9a9a977cccbbc777888788877779a977779999a0a999977999a000a999779999a00a9997000000000000000000000000000000000000000000000
9a9a9a9999a9a9a97cccbbbbc77888888877999a99977999aa0aa99977999a0aaa99977999aaa0a9997000000000000000000000000000000000000000000000
9a9a9aaaaaa9a9a97cbcccbcc778888888779aaaaa977999a000a99977999a000a99977999a000a9997000000000000000000000000000000000000000000000
09a9a999999a9a907bbbccccc7778888877779aaa9777799aaaaa99777799aaaaa99777799aaaaa9977000000000000000000000000000000000000000000000
09a99aaaaaa99a907cbbbcbbc7077888770079a9a970077999999977007799999997700779999999770000000000000000000000000000000000000000000000
009aa999999aa90077cbbcbc77007787700079979970007799999770000779999977000077999997700000000000000000000000000000000000000000000000
00099aaaaaa99000077cbcc770000777000077707770000777777700000077777770000007777777000000000000000000000000000000000000000000000000
00000999999000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001111111100000000000000000000000033333333000000000000000000000000ffffffff00000000000000000000000022222222000000000000
0000000001116666666611100000000000000000033333333333333000000000000000000fff44444444fff000000000000000000222ddddddd2222000000000
0000000116666111166666611000000000000003333333333bb33333300000000000000ff444444444444ffff0000000000000022ddddddddddd222220000000
0000001666611166166116661100000000000033bbbb3333bbbbbbb333000000000000f444fffff444444fffff0000000000002dddddddd222dd2222dd000000
00000166661166666611111111100000000003bbbbbbb333bbbbbbb33330000000000f44ffffff44444444fffff00000000002dddddddddd2222222dddd00000
0000116611166111111111111111000000003bbbbbb33b3333bbbb33333300000000f4444fffff4444444444ffff0000000022dddddddddd22ddd22d2d220000
000111161116111111111661116110000003bbbbbb3333333333333333333000000ff444444fffff44444444fffff0000002ddddddd22dd22dd2222222222000
00161111116611111116666111666100003bbbb3333bbb333333333bb333330000fff4444444ffff44444444ff4fff00002ddddddd222222dd22dddddd222200
00166111111111111166666111666100003bbb33bbbbbb333bbbbbbbbb33330000fff444444ffffffff444ffff44ff00002dddddd2222222d222dddddd222200
0166666111111111166666666666661003bbbb3bbbbb3333bb33bbbbbbb333300fff444444fffffffff44ffffff44ff002ddddddd222222dd222ddddddd22220
0166666661111111166666666661661003bbbb3b33333333bbb333bbbbb333300ff444444444ffffff44444fff4444f002ddddddddd222222222ddddddd22220
0166666661111111116666666611661003333bbbbbb3333bbbbb33bbbbb333300ff4444f444444fff444444fff4444f002ddddddddddd2222d222ddddddddd20
166661116661111111166111166166613bbb333bbbb333333333333bb3333333fffff4ff44444ffff444444fff4444ff22dddddddd222222ddd22dddddddddd2
166111111166666111666111116166613bbbbbbbbbb33333333333333333bb33ffffffff4444fffff444444ffff4444f2ddddddddd22222dddd2222dddddddd2
116166111166661116611111111166613bb33bbbb3333333333333333333bbb3fffffffff44fffff44444444ffffffff2ddddddddd22222dddd22222ddddddd2
116666116666611116111111111666613333bbbb33333333333bbb333333bbb3ffff444ffffffff4444444444fffffff2ddddddd222222dddd222222ddddddd2
11611111666661111111111111166661333bbbbbbbb3333333bbbb33b33bb333fff4444fffffffff44444444444fffff22dddddddd2222dddd222222ddddddd2
16611166666611611111111111666661333333bbbbbb333bb3bbbbbb33bbbb33ff44444fff44ffff4f444444444fffff222dddddddd22dddd2222222ddddddd2
161166666666666111111111116666613bbbb3333bbbbbbbb33bbbb33bbbbbb3ff44444ff444fffffff444f444ffffff222dddddd222222dd2222dddddddddd2
166666611166611111111116611666613bbbbbbbbbbb3bbbbb3bbbb3bbbbbbb3ff4444444444fffffff444ff44ffffff2222dddd2222d22dd222ddddddddddd2
0116661161111111111111666616661003bb3bbbbbbb333bbb3333bbb3333b300ff4444444ffffffff44fffffffffff00222dddd22dd22222222dddddddddd20
0111666666611111111111666616661003bb333bbbbbbb33bbb333bb33bb33300ffff44444fffffffffffff44444fff00222dddddddd22222222dddddddddd20
0111666666661111111111116116661003bbbb33bbbbb33bbbbbbbbbbbbbbb300fffff444444ffffffffff444444fff00222dddddddd2222d22222ddd22ddd20
00111116666611111111111111666100003bbbb3bbb333bbbbbbbbbb33bbb30000fff4444444f44ffff4444444444f000022dddddddd2222dd22222222222200
001111166111111111111666166661000033bbb333333333bbbbb333333bb30000ffff44444ff444ff44444444444f0000222ddddddd2222ddd222222ddd2200
0001111111111116611666661666100000033333bbbbbb333333333333333000000ffff44fff4444f44444444444f00000022ddd222222dddddddd22ddd22000
000011111116611661166666166100000000333bbb33bbb333333333333300000000ffffffff444ff4444444444f00000000222222222dddddddd22dddd20000
00000111116661166666666116100000000003bbbbb333bbbbbbb3333330000000000fffffff444fff44444444f000000000022222222ddddddd22222dd00000
000000111166661166666666610000000000003bbbbbbbbbbbbbb33333000000000000fffff4444fffff44444f0000000000002222dddddddd22222222000000
00000001111116116666666110000000000000033bb333bbbbbb3333300000000000000ffff44444fff4444ff00000000000000222ddd222d222222220000000
0000000001111111166611100000000000000000033333333333333000000000000000000fff4444fffffff000000000000000000222dd222222222000000000
0000000000001111111100000000000000000000000033333333000000000000000000000000ffffffff00000000000000000000000022222222000000000000
000000000000cccbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000ccccccccbbbbbbbbcb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000ccccccccccbbbbbbbccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000cccccccccbbbbbbbbccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ccccccccbbbbbbbbbbcccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cccccccccbbbbbbbbbbbcccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccccccccccbbbbbbbbbbbbcccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccccccccccbbbbbbbbbbbbbbbccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccbbbbbbbbbbbbbbcccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccbcbbbbbbbbbbbccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccccbbbbbbbbbccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccbbbbbbbbbcccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccbbbbbbbbbccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccbccbcccccccccccbbbbccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbcbbbcccccccccccbbbccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbcccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbcccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccbbbbbbbbbbcccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cbbbbbbbbbcccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccbbbbbbbccccccccccbcccbcbcccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccbbbbbbbbbccccccbbbbbbbbbcccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccbbbbbbbbbcccccbbbbbbbbcccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccbbbbbbbbbcccccccbbbbbbbccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ccbbbbbbbbcccccccbbbccbbcc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ccbbbbbccccccccbbbbcccbc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000cccbbbbcccccccbbbbbccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000ccbbbbccccccbbbbbbcc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000cccbbcccccccbbbccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cbbccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000ccccccbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000cccccccbcbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000cccccccccbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000cccccccccccbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000ccccccccccccbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ccccccccccccbbbbbbbbbbbbbbbbbbbbbbbc0000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000cccccccccccccbbbbbbbbbbbbbbbbbbbbbbbcc000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000cccccccccccccccbbbbbbbbbbbbbbbbbbbbbbccccc0000000000000000000000000000000000000000000000000000000000000000000
000000000000000000cccccccccccccccccbbbbbbbbbbbbbbbbbbbbbcccccc000000000000000000000000000000000000000000000000000000000000000000
00000000000000000ccccccccccccccbbbcbbbbbbbbbbbbbbbbbbbbbbcccccc00000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccc0000000000000000000000000000000000000000000000000000000000000000
000000000000000cccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccc000000000000000000000000000000000000000000000000000000000000000
000000000000000cccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcc000000000000000000000000000000000000000000000000000000000000000
00000000000000ccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccc00000000000000000000000000000000000000000000000000000000000000
0000000000000cccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc0000000000000000000000000000000000000000000000000000000000000
000000000000ccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccc000000000000000000000000000000000000000000000000000000000000
000000000000ccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccc000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccc00000000000000000000000000000000000000000000000000000000000
00000000000cccccccccccccccccccccbbbcccbbbbbbbbbbbbbbbbbbbbbbccccccccc00000000000000000000000000000000000000000000000000000000000
0000000000ccccccccccccccccccccccbbbcccbbbbbbbbbbbbbbbbbbbbbbcccccccccc0000000000000000000000000000000000000000000000000000000000
0000000000cccbccccccccccccccccccbccccccbbbbbbbbbbbbbbbbbbbbbcccccccccc0000000000000000000000000000000000000000000000000000000000
0000000000cccbbcccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbcccccccccc0000000000000000000000000000000000000000000000000000000000
000000000cbbbbbccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbccccccccccc000000000000000000000000000000000000000000000000000000000
000000000bbbbbbbcbccbcccccccccccccccccbbbcbbbbbbbbbbbbbbbbccccccccccccc000000000000000000000000000000000000000000000000000000000
000000000bbbbbbbbbcbbccccccccccccccccccccccbbbbbbbbbbbbcccccccccccccccc000000000000000000000000000000000000000000000000000000000
000000000bbbbbbbbbbbbbcccccccccccccccccccccbbbbbbbcbbbccccccccccccccccc000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbcccccccccccccccccccccccbbbcccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000077777777777777777777770077777777777777000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000777cccc77cccccc77cccccc7777cccc77cccccc7000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007cc777777cc77cc77cc77cc77cc777777cc77777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007cccccc77cccccc77cccccc77cc700007cccc700000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000077777cc77cc777777cc77cc77cc777777cc77777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007cccc7777cc700007cc77cc7777cccc77cccccc7000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007777770077770000777777770077777777777777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007777777777777777777777777777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777888877887788778888887788888870000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000788777777887788777788777788778870000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000788888877888888700788700788888870000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777778877887788777788777788777770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000788887777887788778888887788700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777777007777777777777777777700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000777777777777777700777777777777777777777700777777777777770000000000000000000000000000000000000
000000000000000000000000000000000007cccccc77cccccc7777cccc77cccccc77cccccc7777cccc77cccccc70000000000000000000000000000000000000
000000000000000000000000000000000007cc77cc77cc77cc77cc77cc7777cc7777cc777777cc77777777cc7770000000000000000000000000000000000000
000000000000000000000000000000000007cccccc77cccc7777cc77cc7007cc7007cccc7007cc70000007cc7000000000000000000000000000000000000000
000000000000000000000000000000000007cc777777cc77cc77cc77cc7777cc7007cc777777cc77777007cc7000000000000000000000000000000000000000
000000000000000000000000000000000007cc700007cc77cc77cccc7777cccc7007cccccc7777cccc7007cc7000000000000000000000000000000000000000
00000000000000000000000000000000000777700007777777777777700777777007777777700777777007777000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007777777777777777777777777777777777770000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000077d77ddd77dd7ddd7ddd7ddd7ddd77dd77dd70000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000007d7d77d77d777d7d7ddd7d7d7d7d7d777d7770000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000007d7d77d77d707ddd7d7d7dd77ddd7ddd7ddd70000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000007d7777d77d777d7d7d7d7d7d7d7d777d777d70000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000077dd7dd777dd7d7d7d7d7ddd7d7d7dd77dd770000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007777777077777777777777777777777777700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007887000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007887000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000078888700000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000078888700000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000e00c67888876bbbe000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c8cc6678888766bb8bbb000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000cccc8666788118876668bbbbbb000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000cccccc8666781111876668bbbbbbbb0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cccccccc86aa78111187aa68bbbbbbbbbb00000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000ccccccccc86aa78888887aa68bbbbbbbbbbc0000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000cccccccccc85aa78888887aa58bbbbbbbbbbcc000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000cccccccccccc2c997888888799b2bbbbbbbbbccccc0000000000000000000000000000000000000000000
000000000000000000000000000000000000000000ccccccccccccccccc78888887bbbbbbbbbbbbbcccccc000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ccccccccccccccbbbc57888875bbbbbbbbbbbbbbcccccc00000000000000000000000000000000000000000
0000000000000000000000000000000000000000ccccccccccccccbbbbbb578875bbbbbbbbbbbbbbbccccccc0000000000000000000000000000000000000000
000000000000000000000000000000000000000cccccccccccccccbbbbbbb5775bbbbbbbbbbbbbbbbbbbccccc000000000000000000000000000000000000000
000000000000000000000000000000000000000cccccccccccccccbbbbbbbb55bbbbbbbbbbbbbbbbbbbbbbbcc000000000000000000000000000000000000000
00000000000000000000000000000000000000ccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccc00000000000000000000000000000000000000
0000000000000000000000000000000000000cccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc0000000000000000000000000000000000000
000000000000000000000000000000000000ccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccc000000000000000000000000000000000000
000000000000000000000000000000000000ccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccc000000000000000000000000000000000000
00000000000000000000000000000000000ccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccc00000000000000000000000000000000000
00000000000000000000000000000000000cccccccccccccccccccccbbbcccbbbbbbbbbbbbbbbbbbbbbbccccccccc00000000000000000000000000000000000
00000000000777777700000777777777777777777777777cccccccccbbbcccbbbbbbbbbbbbbbbbbbbbbbc7777777c77777777700007777777000000000000000
000000000077ddddd7700077dd77dd77dd7ddd7ddd77dd7cccccccccbccccccbbbbbbbbbbbbbbbbbbbbbc7ddd7d7c7ddd7d7d700077ddddd7700000000000000
00000000007dd777dd70007d777d777d7d7d7d7d777d777cccccccccccccccbbbbbbbbbbbbbbbbbbbbbbc7d7d7d7c7d7d7d7d70007dd7d7dd700000000000000
00000000007dd7d7dd70007ddd7d707d7d7dd77dd77ddd7ccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbc7ddd7d7c7ddd7ddd70007ddd7ddd700000000000000
00000000007dd777dd7000777d7d777d7d7d7d7d77777d7cccccccccccccccbbbcbbbbbbbbbbbbbbbbccc7d777d777d7d777d70007dd7d7dd700000000000000
000000000077ddddd770007dd777dd7dd77d7d7ddd7dd77ccccccccccccccccccccbbbbbbbbbbbbcccccc7d7c7ddd7d7d7ddd700077ddddd7700000000000000
0000000000077777770000777707777777777777777777cccccccccccccccccccccbbbbbbbcbbbccccccc777c777777777777700007777777000000000000000
00000000000000000000000000000000bbbbbbbbbbbbbbcccccccccccccccccccccccbbbcccccccccccccccccbbbbbbc00000000000000000000000000000000

__map__
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000e000021740217101c7401c710217402171023740237102474024710237402371021740217101f7401f7101d7401d71018740187101d7401d7101f7401f71021740217101f7401f7101d7401d7102174021710
000e00001f7401f7101a7401a7101f7401f7102174021710237402371021740217101f7401f71023740237101c7401c71017740177101c7401c7101e7401e7101f7401f7101e7401e7101c7301c7101e7301e710
000e00001511015110151101511015110151101511015110151101511015110151101511015110151101511011110111101111011110111101111011110111101111011110111101111011110111101111011110
001000002153121520215202152021520215202152021520215200000023520000002452000000215202152021520215202152021520215202152021520000000000000000000000000000000000000000000000
000e00001311013110131101311013110131101311013110131101311013110131101311013110131101311010110101101011010110101101011010110101101011010110101101011010110101101011010110
000e00002353123520235202352023520235202352023520235200000000000000000000000000245200000023520235202352023520235202352023520235202352000000000000000000000000000000000000
000e00002153121520215202152021520215202152021520215200000000000000002352000000245200000021520215202152021520215202152021520215202152000000000000000023520000002452000000
000e19002652026520265202652026520265202652026520265200000000000000002852000000295200000028520285202852028520285202852028520285202852001400014000140001400014000140001400
010f000000000000001a5001a50018500185001a5001a5000000015500155001a5001a5001d5001d5001a5001a50000000000001a5001a50018500185001a5001a5000000015500155001a5001a5001d5001d500
010f00001a5001a50000000000001a5001a50018500185001a5001a5000000015500155001a5001a5001d5001d5001a5001a50000000000001a5001a50018500185001a5001a5000000015500155001a5001a500
00020000160540a05105051060510b051160511270113701147011570500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002474526745297452e7453074532745357453a7452400526005290052e0053000532005350053a00500000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000c363236650935520641063311b6210432116611023210f611013110a6110361104600036000260001600016000460003600026000160001600016000160004600036000260001600016000160001600
000500001235311353103530f3530e3530e3530d3530d3430c3430c3430b3430b3430a3430a343093330933308333083330733307333063330632305323053230432304323033230332302313023130131301313
010c00000c34300300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
00010000352103751534100371003f10039100331001f1001f1001f1001f100231002a10034100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600002336311000103330400010705107031070513005306041070310705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001370000000137000000013700000001370000000137000000013700000001370000000137000000013700000001370000000137000000013700000001370000000137000000013700000001370000000
010f00001670000000167000000016700000001670000000167000000016700000001670000000167000000018700000001870000000187000000018700000001870000000187000000018700000001870000000
010f1f001670000000167000000016700000001670000000167000000016700000001670000000167000000018700000001870000000187000000018700000001870000000187000000018700000001870001400
000e000000000000000e0600000000000000000e060000000e06000000000000e06000000000000e0600000000000000000e0600000000000000000e060000000e06000000000000e06000000000000e06000000
010e00002154121510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151024510245102451000000
010e00000000000000110600000011000000001106000000110600000000000110600000000000110600000000000000001106000000000000000011060000001106000000000001106000000000001106000000
000e00002154121510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510
000e000000000000000a0600000000000000000a060000000a06000000000000a06000000000000a0600000000000000000a0600000000000000000a060000000a06000000000000a06000000000000a06000000
000e00001f5411f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101f5101d5101d5101d51000010
000e00000000000000130600000000000000001306000000130600000000000130600000000000130600000000000000001806000000000000000018060000001806000000000001806000000000001806000000
000e00002254122510225102251022510225102251022510225102251022510225102251022510225102251024511245102451024510245102451024510245102451024510245102451024510245102451024510
080e00001a751297541a7341a754297541a73429734297541a734297341a7341a754297541a7341a754297541a734297341a73429734297541a7341a754297541a734297541a73429734297541a7342973429754
180e00000000000000000002973400000000001a754000001a754297540000029734000000000029734000001a75429754000001a754000000000029734000001a75429734000001a75400000000001a75400000
080e00001d7512d7541d7341d7542d7541d7342d7342d7541d7542d7341d7342d7342d7541d7342d7342d7541d7342d7541d7341d7542d7541d7342d7342d7541d7342d7341d7342d7342d7541d7342d7342d754
180e00000000000000000002d73400000000001d754000001d7342d754000001d75400000000001d754000001d7542d734000002d73400000000001d754000001d7542d754000001d75400000000001d75400000
080e00001375122754137342273422754137341375422754137542273413734137542275413734137542275413734227541373413754227541373413754227541373422754137341375422754137341375422754
180e00000000000000000001375400000000002273400000137342275400000227340000000000227340000013754227340000022734000000000022734000001375422734000002273400000000002273400000
000e1d001306000000000000000013060000001306000000000001306000000000001306000000000000000018060000000000000000180600000018060000000000018060000000000018060014000140001400
080e00001675126754167341675426754167341675426754167342675416734267342675416734167542675418734287541873418754287541873418754287541873428754187341875428754187342873428754
180e1f000000000000000002673400000000002673400000167542673400000167540000000000267340000018754287340000028734000000000028734000001875428734000002873400000000001875401400
010e00000c053000000000000000306150000000000000000c053000000000000000306150000000000000000c053000000000000000306150000000000000000c05300000000000000030615000000000000000
__music__
01 00414240
00 01414240
00 00410240
00 01410440
00 00030240
00 01050440
00 00060240
02 01070440
01 14152540
00 16172544
00 18192544
00 1a1b2544
00 14251c1d
00 16251e1f
00 18252021
02 22252324

