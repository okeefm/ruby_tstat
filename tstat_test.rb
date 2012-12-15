require_relative 'ruby_tstat'

# Configure to taste
TSTAT_IP = 'http://okeefm.dyndns-home.com:8888'

tstat = Tstat.new(TSTAT_IP)

# Show current setpoint
puts "Current target: #{ tstat.get_heat_target.to_s }"

# Get current temp (automatically parses JSON to Ruby hash)
puts "Current indoor temp: #{ tstat.get_current_temp.to_s}"
