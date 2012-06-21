Facter.add("default_route") do
        setcode do
            irs = %x{/sbin/ip route show}
            pattern=/default via (\d+\.\d+\.\d+\.\d+)/
            m=pattern.match(irs)
            (defined? m) ? m[1] : nil
        end
end

