local int2bin = {};

local r = bit32.rshift;
local a = bit32.band;
local l = bit32.lshift;
local o = bit32.bor;

function int2bin.byte(b)
  return string.char(a(b,0xff));
end

function int2bin.hword(h)
  return string.char(a(r(h,8),0xff),a(h,0xff))
end

function int2bin.word(w)
  return string.char(a(r(w,24),0xff),a(r(w,16),0xff),a(r(w,8),0xff),a(w,0xff));
end

function int2bin.dword(d)
  local lo = (d%0x100000000);
  local hi = (d-lo)/0x100000000;
  return int2bin.word(hi)..int2bin.word(lo);
end

function int2bin.str2byte(s)
  return s:byte(1,1),s:sub(2,-1);
end

function int2bin.str2hword(s)
  local a,b = s:byte(1,2);
  return o(l(a,8),b),s:sub(3,-1);
end

function int2bin.str2word(s)
  local a,b,c,d = s:byte(1,4);
  return o(l(a,24),l(b,16),l(c,8),d),s:sub(5,-1);
end

function int2bin.str2dword(s)
  local a,b,c,d,e,f,g,h = s:byte(1,8);
  return o(l(a,24),l(b,16),l(c,8),d)*0x100000000+o(l(e,24),l(f,16),l(g,8),h);
end

return int2bin;