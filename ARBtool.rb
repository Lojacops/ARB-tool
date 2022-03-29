#!usr/bin/env ruby
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'socket'
require 'colorize'


def help
    puts """\r
ARB commands:
lookup       => show infos of an user target (ip/domain)
portscan     => check the open port on a target (ip/domain)
ssl          => check the ssl certificate (ip/domain)
headers      => returns the headers of a site
fingerprint  => capture the html code of a site
linkshunt    => view the correlated links in a site
xml-parser   => parse an xml document of a site
fuzzer       => do the directory fuzzing in a site
-r           => reset & clear display
help         => help you :kek:\r""".light_magenta
end

def logo
    banner = '''
                  ___
 ▄▀█ █▀█ █▄▄     / | \
 █▀█ █▀▄ █▄█    |--0--|
                 \_|_/        By LoJacopS
'''.cyan[..-5]
    print banner
    puts "v1.8.2\n"
    print Time.now
    puts "\n"
end

=begin
Komodo, 5/02/2022
Hi reader of this code, i'm sorry for eventually
shitty codes in arb. It was my first ruby project in 2020...
Right now, I update it in randomly moments
=end

print logo
puts "Welcome to arb!"

prompt = "\rArb>".green[..-5]

while (input = gets.chomp)
break if input == "exit"
    print prompt && input
    if input == "headers"
        Thread.new{
            begin
                puts "\rTarget:"
                sessoinput = gets.chomp
                urii = URI("#{sessoinput}")
                response = Net::HTTP.get_response(urii) 
                response.to_hash['set-cookie']                      #get the sexy headers
                puts "Headers:\n #{response.to_hash.inspect.gsub("],","],\n")}".yellow
            rescue Errno::ENOENT, Errno::ECONNREFUSED, SocketError
                puts "\rselect a valid target! (example https://pornhub.com)".red
            end
        }.join
    end
    if input == "lookup"
        class Spidercute
            def target(oscuro)
                urrah = URI("https://ipwhois.app/json/#{oscuro}")
                mlml = Net::HTTP.get(urrah)
                puts "\n"
                puts mlml.gsub(",", ",\n").yellow
            end
        end
        Thread.new{
            puts "\rRemember to select a valid target! (example www.twitter.com or 104.244.42.1)".red
            puts "\rSelect a valid target:".green
            url_target = gets.chomp
            crawling = Spidercute.new()
            crawling.target(url_target) do |output|
                print output
                puts "\n"
            end
        }.join
    end
    if input == "fingerprint"
        begin
            puts "\rinsert a site target:"
            targett_ = gets.chomp
            puts "\rhere the html code\n"
            body_capture = Net::HTTP.get_response(URI(targett_))                 
            print "\n#{body_capture.body.yellow}\n"
        rescue Errno::ENOENT, Errno::ECONNREFUSED
            puts "\rselect a valid target! (example https://pornhub.com)".red
        rescue ArgumentError => ah 
            puts "\rERROR: #{ah}".red
        end
    end
    if input == "linkshunt"
        def owo
            Thread.new{
                begin
                    puts "\rinsert a link:"
                    url = gets.chomp
                    puts "\rtarget selected: #{url}"
                    doc = Nokogiri::HTML(open(url))
                    element = doc.at_xpath("//a/@href")
                    element.map{|amogus| amogus.value}
                    nodeset = doc.css('a[href]')
                    yay = nodeset.map {|element| element["href"]}
                    puts "\nCorrelateds link at #{url}:\n".yellow
                    yay.each do |link|
                        puts "\r#{link}".yellow
                    end
                rescue => eeeeh
                    puts "ERROR\n#{eeeeh}".red
                    puts ""
                end
            }.join
        end
        print owo
    end
    if input == "portscan"
        puts "\rtype an ip to check the ports open on:"
        puts "(example: www.google.com)"
        def scan_port
            port_input = gets.chomp
            ports = [15,21,22,23,25,26,50,51,53,67,58,69,80,110,119,123,
                    135,139,143,161,162,200,389,443,587,989,990,
                    993,995,1000,2077,2078,2082,2083,2086,      #most used ports
                    2087,2095,2096,3080,3306,3389
                ]      
            #ports = Range.new(1,5000)      Ranges? Nah.
            begin
                for numbers in ports
                    socket = Socket.new(:INET, :STREAM)
                    remote_addr = Socket.sockaddr_in(numbers, port_input)
                    begin
                        socket.connect_nonblock(remote_addr)
                    rescue Errno::EINPROGRESS
                        #next
                    end
                    time = 1
                    sockets = Socket.select(nil, [socket], nil, time)
                    if sockets
                        puts "\rPort #{numbers} is open".yellow
                    else
                        puts "\rPort #{numbers} is closed".red
                    end
                end
            rescue SocketError => sock_err
                puts "ERROR\n#{sock_err}".red
                puts ""
            end
        end
        print scan_port
    end
    if input == "xml-parser"
        def sus
            begin
                puts "\rSite with xml:  "
                xmlml = gets.chomp    
                ehm = Nokogiri::XML(open(xmlml)) do |config|  
                    puts "#{config.strict.noblanks}".yellow[..-5]
                    puts "All saved in the file document.xml!"
                end
                print ehm
                document = File.new("document.xml", 'a')
                document.write(ehm)
                document.close()
            rescue Errno::ENOENT, Errno::ECONNREFUSED, Nokogiri::XML::SyntaxError, URI::InvalidURIError
                puts "\rselect a valid target! (example https://google.com/sitemap.xml)".red
            end
        end
        print sus
    end
    if input == "fuzzer"
        def fuzzer(link, wordlist)
            begin
                Thread.new{
                    wordlist = File.open(wordlist)
                    ohyes = wordlist.map {|x| x.chomp }
                    ohyes.each do |dir|
                        uriiii = URI("#{link}/#{dir}/")
                        requestt = Net::HTTP.get_response(uriiii)
                        if requestt.code == '200'
                            puts "\ndirectory open! '#{dir}'".yellow
                            log = File.new("valid.log", 'a')
                            log.write(dir+"\n")
                            log.close()
                            puts "saved on file Valid-dir.log!"
                        else
                            puts "\nscanning...#{requestt.code}".cyan                    #directory closed
                        end
                    end
                }.join
            rescue Errno::ENOENT, Errno::ECONNREFUSED
                puts "\rERROR: Select a valid wordlist".red
            rescue Net::OpenTimeout
                puts "\rERROR: Select a valid link".red
            rescue => eeeh
                puts "ERROR\n#{eeeh}".red
                puts ""
            end
        end
        puts "\rlink: "
        fuzz_option = gets.chomp
        puts "\rselect a wordlist: (wordlist.txt for use the default wordlist)"
        wordlist_option = gets.chomp
        print fuzzer(fuzz_option, wordlist_option)
    end
    if input == "ssl"
        def sexssl?(oscuro)
            ssl = true
            string = "\n#{oscuro} ssl certificate: "
            begin
                URI.open("https://#{oscuro}")
                puts " ".yellow[..-5]
                puts string, ssl
            rescue OpenSSL::SSL::SSLError 
                ssl = false
                puts string, ssl
            rescue SocketError => lmao 
                puts "\nSelect a valid target! (example www.google.com)".red
                puts lmao.red
            end
        end
        print "\rTarget: "
        ssl_target = gets.chomp
        sexssl?(ssl_target)
    end
    if input == "-r"
        system('clear||cls')
        puts "Resetted!".cyan
        puts "\n"
    end
    if input == "help"
        print help
    elsif input == "banner"
        print logo
        commands = ["ssl",'headers', 'lookup', '-r', 'help', 'linkshunt','fingerprint',
                    'portscan',"fuzzer","xml-parser"]
    else input != commands
        puts "\r"
    end
system(input)
print prompt
end 
