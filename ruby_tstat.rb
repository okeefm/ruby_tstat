#
#
# Tested with a 3M50. Public domain. --citrys
# 

require 'rubygems'
require 'httparty'
require 'json'

class Tstat

  @@modes = { 0 => "off", 1 => "heat", 2 => "cool", 3 => "auto" }

  attr_accessor :tstat_ip, :units

  # Need to trick the thermostat into returning JSON instead of plain text
  @headers = { 'User-Agent' => 'foo' }

  def initialize(tstat, units = :f)
    @tstat_ip = tstat
    @units = units
  end

  # Returns result of POST for setting the heat target
  def set_temp_target(degrees, type="heat")
    if @units == :c || @units == :celsius
     degrees = degrees * 9 / 5 + 32
    end

    command = { "t_" + type  => degrees }.to_json

    HTTParty.post @tstat_ip + '/tstat/ttemp', :body => command, :headers => @headers
  end

  #Sets thermostat mode
  def set_thermostat_mode(mode)

    #find the number for the string mode
    if mode.is_a?(String)
      mode = @@modes.key(mode.downcase)
    end

    command = { "tmode"  => mode }.to_json

    result = HTTParty.post( @tstat_ip + "/tstat/tmode", :body => command, :headers => @headers )
    return result
  end

  #Returns thermostat mode
  def get_thermostat_mode
    result = HTTParty.get( @tstat_ip + "/tstat/tmode", :headers => @headers )
    return @@modes[result["tmode"]]
  end

  # Returns setpoint (heat by default)
  def get_setpoint(type="heat")
    result = HTTParty.get( @tstat_ip + '/tstat/ttemp', :headers => @headers )
    
    degrees = result['t_' + type]

    if @units == :c || @units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end

  #Returns the current temperature at the thermostat
  def get_current_temp
    result = HTTParty.get( @tstat_ip + '/tstat/temp', :headers => @headers) 
    
    degrees = result['temp']

    if @units == :c || @units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end

  #Returns the system usage (today's heat by default; cooling and/or yesterday's usage available by passing hash arguments)
  def get_usage(args= {})
    args = {:day=>"today", :type=>"heat"}.merge(args)
    result = HTTParty.get( @tstat_ip + '/tstat/datalog', :headers => @headers) 
    
    day = result[args[:day]]
    runtime = day[args[:type] + '_runtime']

    return runtime
  end

end
