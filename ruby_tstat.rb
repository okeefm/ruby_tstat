#
#
# Tested with a 3M50. Public domain. --citrys
# 

require 'rubygems'
require 'httparty'
require 'json'

class Tstat

  attr_accessor :tstat_ip

  # Need to trick the thermostat into returning JSON instead of plain text
  @headers = { 'User-Agent' => 'foo' }

  def initialize(tstat)
    @tstat_ip = tstat
  end

  # Returns result of POST for setting the heat target
  def set_heat_target degrees, units = :f
    if units == :c || units == :celsius
     degrees = degrees * 9 / 5 + 32
    end

    command = { :t_heat => degrees }.to_json

    HTTParty.post @tstat_ip + '/tstat/ttemp', :body => command, :headers => @headers
  end

  # Returns heat setpoint
  def get_heat_target units = :f
    result = HTTParty.get( @tstat_ip + '/tstat/ttemp', :headers => @headers )
    
    degrees = result['t_heat']

    if units == :c || units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end

  def get_current_temp units = :f
    result = HTTParty.get( @tstat_ip + '/tstat/temp', :headers => @headers) 
    
    degrees = result['temp']

    if units == :c || units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end

end
