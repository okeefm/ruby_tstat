require_relative 'ruby_tstat'

# Configure to taste
TSTAT_IP = 'http://okeefm.dyndns-home.com:8888'

tstat = Tstat.new(TSTAT_IP)

# Show current setpoint
puts "Current target: #{ tstat.get_setpoint.to_s }"

# Get current temp (automatically parses JSON to Ruby hash)
puts "Current indoor temp: #{ tstat.get_current_temp.to_s}"

#Get today's/yesterday's system usage (today's heat by default)
usage = tstat.get_usage
puts "Yesterday's heat usage: #{ usage.to_s}"

#Get thermostat mode
puts "Thermostat mode: #{ tstat.get_thermostat_mode.to_s}"

#set thermostat mode

puts "Results of setting the thermostat mode: #{ tstat.set_thermostat_mode(1) }"

