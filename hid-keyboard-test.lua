-- hid keyboard test
-- 1.1.1 - @okyeron
--
-- type some text
-- enter clears the screen

-- Device can be selected on the parameters screen.

-- note - connection is by vport number
-- default is vport 1
-- set this up in SYSTEM > DEVICES > HID



local keyb

local keycodes = include("lib/keycodes")

local wordarray ={}
local keyinput = ""
local keyoutput = ""
local start_y = 10

function init()
    screen.aa(1)
    connect()
    
    tab.print(hid.devices)

    local hids = {}
  -- Get a list of HID devices
    for id,device in pairs(hid.vports) do
      hids[id] = string.sub(device.name, -24, string.len(device.name)) -- device.name
    end
      -- setup params
  
  params:add{type = "option", id = "keyb", name = "HID:", options = hids , default = 1,
    action = function(value)
      keyb = nil
      keyb = hid.connect(value)
      keyb.event = keyboard_event
      devicepos = value
      print ("HID selected " .. hid.vports[devicepos].name)
    end}

    redraw()
end

function connect()
  keyb = hid.connect()
  keyb.event = keyboard_event
  
end

function draw_firstscreen()
  screen.level(15)
  screen.line_width(1)
  screen.font_face(0)
  screen.font_size(8)
  screen.move(10,10)
  screen.text("NORNS> ")
  screen.update()
end
    
function textwrap(s, w, offset, prefix)
  local len =  string.len(s)
  local strstore = {}
  local k = 1
    if len == 0 then
      screen.text(prefix)
    else 
      while k <= len do
        table.insert(strstore, string.sub(s, k, k+w-1))
        k = k + w
      end
      strposition = start_y + offset
      for v in pairs(strstore) do
        screen.text(prefix .. strstore[v])
        screen.move(0, strposition)
        strposition = strposition + offset
      end 
    end 
end

function get_key(code, val, shift)
  if keycodes.keys[code] ~= nil and val == 1 then 
    if (shift) then
      if keycodes.shifts[code] ~= nil then 
        --print (keycodes.shifts[code])
        return(keycodes.shifts[code])    
      else
        return(keycodes.keys[code])
      end
    else
      return(lowercase(keycodes.keys[code]))
    end
  elseif keycodes.cmds[code] ~= nil and val == 1 then 
    if (code == hid.codes.KEY_ENTER) then
      
      --print ("do enter things")
      
      wordarray = {}
      draw_firstscreen()
    elseif (code == hid.codes.KEY_BACKSPACE or code == hid.codes.KEY_DELETE) then
      table.remove(wordarray)
    end
  end   
end 

function keyboard_event(typ, code, val)
    --print("hid.event ", typ, code, val)
    if (code == hid.codes.KEY_LEFTSHIFT) and (val == 2) then
      shift = true;
    elseif (code == hid.codes.KEY_LEFTSHIFT) and (val == 0) then
      shift = false;
    end
    keyinput = get_key(code, val, shift)
    --print (keyinput)
    buildword(keyinput)
end

function lowercase(str)
   return string.lower(str)
end

function buildword()
    if keyinput ~= "Enter" then
        table.insert(wordarray,keyinput)
        keyoutput = table.concat(wordarray )
        redraw()
    else
        redraw()
        keyoutput = ""
        wordarray = {}
    end
end
    
-- screen redraw function
function redraw()
  -- clear screen
  screen.clear()
  -- set pixel brightness (0-15)
  screen.level(15)
  screen.line_width(1)
  screen.font_face(0)
  screen.font_size(8)

  screen.move(0,10)
  textwrap(keyoutput, 15, 10, "NORNS> ")
  
  screen.update()
end
