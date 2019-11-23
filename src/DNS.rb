##################################################################
# Libraries Used                                                 #
##################################################################

require 'socket'

##################################################################
# Global Variables                                               #
##################################################################

DOMAIN_PORT = 53

##################################################################
# usage() - Tells user what parameters are available             #
##################################################################

def usage()
  puts "ruby DNS.rb domain-host lookup-host"
  puts "e.g. ruby DNS.rb 192.168.0.1 news.bbc.co.uk"
  exit(0)
end

def create_packet(lookup_host, transaction_ID)
  packet = [transaction_ID, 0x0100, 0x0001, 0x0000, 0x0000, 0x0000, 0x03].pack("S>S>S>S>S>S>C")
  packet += lookup_host.gsub('.', 0x02.chr)
  packet += [0x00, 0x0001, 0x0001].pack("CS>S>")
  return packet
end

##################################################################
# main()                                                         #
##################################################################

def main()
  # We need precisely 2 arguments (domain-host and lookup-host),
  # otherwise display usage and exit to OS
  if ARGV.length != 2
    usage()
  end

  # Get the hostname and array of ports from ARGV (arguments
  # to process from OS)
  domain_host = ARGV[0]
  lookup_host = ARGV[1]
  
  trancation_ID = 0
  packet = create_packet(lookup_host, trancation_ID)

  sender = UDPSocket.new()

  sender.send(packet, 0, domain_host, DOMAIN_PORT)
  sender_port = sender.addr[1]
  puts "sent over port %d" % sender_port
  
  puts "Complete."

  # Exit to OS
  exit(0)
end

##################################################################
# Call main()                                                    #
##################################################################

main()