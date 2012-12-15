#
#
# Tested with a 3M50. Public domain. --citrys
# 

require 'rubygems'
require 'httparty'
require 'json'

class Tstat

  attr_accessor :tstat_ip, :units

  # Need to trick the thermostat into returning JSON instead of plain text
  @headers = { 'User-Agent' => 'foo' }

  def initialize(tstat, units = :f)
    @tstat_ip = tstat
    @units = units
  end

  # Returns result of POST for setting the heat target
  def set_heat_target degrees
    if @units == :c || @units == :celsius
     degrees = degrees * 9 / 5 + 32
    end

    command = { :t_heat => degrees }.to_json

    HTTParty.post @tstat_ip + '/tstat/ttemp', :body => command, :headers => @headers
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

  def get_current_temp
    result = HTTParty.get( @tstat_ip + '/tstat/temp', :headers => @headers) 
    
    degrees = result['temp']

    if @units == :c || @units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end

  def get_usage(args= {})
    args = {:day=>"today", :type=>"heat"}.merge(args)
    result = HTTParty.get( @tstat_ip + '/tstat/datalog', :headers => @headers) 
    
    day = result[args[:day]]
    runtime = day[args[:type] + '_runtime']

    return runtime
  end

end
