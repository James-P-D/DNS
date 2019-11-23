##################################################################
# Libraries Used                                                 #
##################################################################

require 'socket'

##################################################################
# Global Variables                                               #
##################################################################


##################################################################
# usage() - Tells user what parameters are available             #
##################################################################

def usage()
  puts "ruby DNS.rb domain-host lookup-host"
  puts "e.g. ruby DNS.rb 192.168.0.1 news.bbc.co.uk"
  exit(0)
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
  
  # Tell the user the total of open/closed ports
  puts "Complete."

  # Exit to OS
  exit(0)
end

##################################################################
# Call main()                                                    #
##################################################################

main()