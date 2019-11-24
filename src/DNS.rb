##################################################################
# Libraries Used                                                 #
##################################################################

require 'socket'

##################################################################
# Global Variables                                               #
##################################################################

DOMAIN_PORT = 53
FLAGS = 0x0100
QUESTIONS = 0x0001
ANSWERS = 0x0000
AUTHORITY_RRS = 0x0000
ADDITIONAL_RRS = 0x0000
NULL = 0x00
TYPE_A = 0x0001
CLASS_IN = 0x0001

##################################################################
# usage() - Tells user what parameters are available             #
##################################################################

def usage()
  puts "ruby DNS.rb domain-host lookup-host1..lookup-hostN"
  puts "e.g. ruby DNS.rb 192.168.0.1 news.bbc.co.uk"
  puts "e.g. ruby DNS.rb 192.168.0.1 www.facebook.com www.twitter.com www.instagram.com"
  exit(0)
end

##################################################################
# encode_lookup_host(lookup_host) - Converts the hostname into a #
# string where each period is replaced with a byte specifying    #
# the length of the next string. e.g. news.bbc.co.uk goes to     #
# {4}new{3}bbc{2}co{2}uk{0}                                      #
##################################################################

def encode_lookup_host(lookup_host)
  # Split the input by periods  
  tokens = lookup_host.split(".")

  str = ""
  for token in tokens
    # For each token, add the length byte, followed by the data
    str += (token.length).chr
    str += token
  end

  # Add the null at the end
  str += [NULL].pack("C")
  return str
end

##################################################################
# create_packet() - Creates the actual byte array containing all #
# the hosts we want to query to get their IP                     #
##################################################################

def create_packet(lookup_host, transaction_ID)  
  packet = [transaction_ID, FLAGS, QUESTIONS, ANSWERS, AUTHORITY_RRS, ADDITIONAL_RRS].pack("S>S>S>S>S>S>")
  packet += encode_lookup_host(lookup_host)
  packet += [TYPE_A, CLASS_IN].pack("S>S>")
  
  return packet
end

##################################################################
# parse_response_packet(data_received) - Parse the received data #
# into an array of answers                                       #
##################################################################

def parse_response_packet(data_received)
  begin
    answers = Array.new
    transaction_ID, flags, questions, answers, authority_rrs, additional_rrs, lookup_host = data_received.unpack("S>S>S>S>S>S>Z*")
    lookup_host = decode_lookup_host_buffer(data_received)

    #answer = OpenStruct.new
    #answer.type = "foo"
    #answer.time_to_live = 123
    #answer.address = "bar"
    
    #answers.push(answer)
  rescue
    puts "Unable to parse response"
    return nil
  end
  return answers
end

##################################################################
# main()                                                         #
##################################################################

def main()
  # We need atleast 2 arguments (domain-host and lookup-hosts),
  # otherwise display usage and exit to OS
  if ARGV.length < 2
    usage()
  end

  # Get the hostname and array of ports from ARGV (arguments
  # to process from OS)
  domain_host = ARGV[0]

  lookup_hosts = Array.new
  for i in 1..(ARGV.length - 1)
    lookup_hosts.push(ARGV[i])
  end
  
  # Note that despite the DNS RFC suggesting that a single packet
  # can query multiple hosts, infact this just doesn't work :/
  # See https://stackoverflow.com/questions/4082081/requesting-a-and-aaaa-records-in-single-dns-query/4083071#4083071
  # for more details
  
  transaction_ID = 0
  for lookup_host in lookup_hosts
    begin
      packet = create_packet(lookup_host, transaction_ID)
      socket = UDPSocket.new()
      socket.send(packet, 0, domain_host, DOMAIN_PORT)      
      puts("'%s' DNS query sent to '%s'" % [lookup_host, domain_host])
      
      data, client = socket.recvfrom(1024)      
      answers = parse_response_packet(data)

      if answers != nil
      end

      if socket != nil
        socket.close
      end
    rescue
      puts("Unable to send packet to '%s'" % domain_host)
      if socket != nil
        socket.close
      end    
    end

    transaction_ID += 1
  end
  
  puts "Complete."

  # Exit to OS
  exit(0)
end

##################################################################
# Call main()                                                    #
##################################################################

main()