Facter.add("name_servers") do
        setcode do
            pattern=/^[ \t]*nameserver[\t ]+(\d+\.\d+\.\d+\.\d+)/
            fic = File.new("/etc/resolv.conf", "r")
            m=fic.read.scan(pattern)
            fic.close
            (defined? m) ? m.join(',') : nil 
        end
end

