#simplest ruby program to read from arduino serial, 
#using the SerialPort gem
#(http://rubygems.org/gems/serialport)

require "serialport"
require "net/http"
require "uri"

#params for serial port
port_str = ARGV[0]  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity) 

  #just read forever
  str = ""
  while true do
    char = sp.getc

    case char
    when "\n"
      begin
        temp = str.to_f
        puts temp
        res = Net::HTTP.post_form(URI.parse(ENV["PULSETEMP_URL"] || "http://localhost:9000/"), {'current_temp' => temp.to_s})
      rescue => e
        puts e.inspect
      end
      str = ""
    else
      str << char
    end

  end

sp.close
