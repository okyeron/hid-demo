-- hid keyboard exec command
-- @okyeron
--
-- stdout goes to maiden REPL
--
-- with great power comes great responsibility

local keyb = hid.connect()

local keycodes = include("keycodes.lua")

local wordarray ={}
local keyinput = ""
local keyoutput = ""
local start_y = 10
local prompt = "> "

function init()
    screen.aa(1)
    --tab.print(hid.devices)
    
    pwd = os.capture("pwd")
    print (pwd .." ".. prompt )
    redraw()
end

function draw_firstscreen()
  screen.level(15)
  screen.line_width(1)
  screen.font_face(0)
  screen.font_size(8)
  screen.move(10,10)
  screen.text(prompt)
  screen.update()
end
   
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
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
      
        -- send exec
      keyoutput = table.concat(wordarray )
      print (prompt .. keyoutput)
      os.execute(keyoutput)
      
      wordarray = {}
      draw_firstscreen()
    elseif (code == hid.codes.KEY_BACKSPACE or code == hid.codes.KEY_DELETE) then
      table.remove(wordarray)
    end
  end   
end 

function keyb.event(typ, code, val)
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
  textwrap(keyoutput, 15, 10, prompt)
  
  screen.update()
end
