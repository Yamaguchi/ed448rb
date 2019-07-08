def b2h(bin)
  bin.unpack1('H*')
end

def h2b(hex)
  [hex].pack('H*')
end
