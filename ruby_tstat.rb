#!/usr/bin/env ruby

#
# tstat_test.rb
#
# Tested with a 3M50. Public domain. --citrys
#

require 'rubygems'
require 'httparty'
require 'json'

# Configure to taste
TSTAT_IP = '192.168.0.12'

class Tstat
  include HTTParty
  format :json
  base_uri TSTAT_IP
  
  # Need to trick the thermostat into returning JSON instead of plain text
  @headers = { 'User-Agent' => 'foo' }

  # Returns result of POST
  def self.set_heat_target degrees, units = :f
    if units == :c || units == :celsius
     degrees = degrees * 9 / 5 + 32
    end

    command = { :t_heat => degrees }.to_json

    self.post '/tstat/ttemp', :body => command, :headers => @headers
  end

  # Returns heat setpoint
  def self.get_heat_target units = :f
    result = self.get( '/tstat/ttemp', :headers => @headers )
    
    degrees = result['t_heat']

    if units == :c || units == :celsius
     degrees = ( degrees - 32 ) * 5 / 9
    end

    return degrees
  end
end


# Show current setpoint
puts "Current target: #{ Tstat.get_heat_target.to_s }"

# Set heat to 70F
puts "Setting target... #{ Tstat.set_heat_target( 25, :celsius ).parsed_response.inspect }"

# Show current setpoint
puts "Current target: #{ Tstat.get_heat_target }"

# Get current temp (automatically parses JSON to Ruby hash)
puts "Current indoor temp: #{ Tstat.get( '/tstat/temp' )['temp'] }"