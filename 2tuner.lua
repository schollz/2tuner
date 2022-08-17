-- 2tuner
--
-- 2 channel pitch monitor
-- 2 volts in crow outputs

musicutil=require("musicutil")

pitches={
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
}

function math.average(t)
  local sum = 0
  for _,v in pairs(t) do -- Get the sum of all numbers in t
    sum = sum + v
  end
  return sum / #t
end

function init()
  for i=1,4 do 
    crow.output[i].volts=2
  end
  local p={0,0}
  local it={10,10}
  for i,v in ipairs({"pitch_in_l","pitch_in_r"}) do 
    p[i] = poll.set(v)
    p[i].callback = function(val) 
      if val>10 then 
        pitches[i][it[i]%#pitches[i]+1]=val
        it[i]=it[i]+1
      end
      if i==1 then 
        redraw()
      end
    end
    p[i].time = 0.05
    p[i]:start()
  end

end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(32,16)
  screen.font_size(16)
  screen.text_center("LEFT")
  screen.move(32,32)
  screen.font_size(16)
  screen.text_center(string.format("%3.2f",math.average(pitches[1])))

  screen.level(3)
  screen.move(32,48)
  local note=musicutil.freq_to_note_num(math.average(pitches[1]))
  screen.text_center(musicutil.note_num_to_name(note,true))
  screen.move(32,48+16)
  screen.text_center(string.format("%3.2f",musicutil.note_num_to_freq(note)))

  screen.level(15)
  screen.move(32+64,16)
  screen.font_size(16)
  screen.text_center("RIGHT")
  screen.move(32+64,32)
  screen.text_center(string.format("%3.2f",math.average(pitches[2])))

  screen.level(3)
  screen.move(32+64,48)
  local note=musicutil.freq_to_note_num(math.average(pitches[2]))
  screen.text_center(musicutil.note_num_to_name(note,true))
  screen.move(32+64,48+16)
  screen.text_center(string.format("%3.2f",musicutil.note_num_to_freq(note)))
  screen.update()
end