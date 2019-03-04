-- hid events demo
--
-- plug in hid device 
-- and send some events
-- event data will 
-- print to Maiden REPL

-- connect to a device
-- connection is by vport number NOT device id
-- check the output for vports and use that number to connect
local keyb = hid.connect(3)

function init()
  --  print some device data to REPL
  print(" ")
  print("Devices:")
  --tab.print(hid.devices)
  for v in pairs(hid.devices) do
    print (v .. ": " .. hid.devices[v].name)
  end 
  print(" ")

  print("vports:")
  --tab.print(hid.vports)
  for w in pairs(hid.vports) do
    print (w .. ": " .. hid.vports[w].name)
  end 

  print(" ")
end


-- event callback function 
-- prints event data to Maiden REPL
function keyb.event(typ, code, val)
    print("hid.event ", typ, code, val)
end

