Facter.add('pupenv') do
  setcode do
      File.open('/var/lib/puppet/pupenv.txt', &:gets) if File.exists?('/var/lib/puppet/pupenv.txt')
  end 
end
