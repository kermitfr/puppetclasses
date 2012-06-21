Facter.add('evenodd') do
  setcode do
      `hostname`.chomp.unpack("C*").inject(0) { |r,e| r+e } % 2
  end 
end
