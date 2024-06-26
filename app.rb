require 'date'
require 'optparse'

#https://ruby-doc.org/stdlib-2.7.1/libdoc/optparse/rdoc/OptionParser.html#method-i-getopts

class Logger
    attr_accessor :log_path

    def initialize
        @config_paths = [
            "/var/log/httpd/error_log", #RHEL / Red Hat / CentOS / Fedora
            "/var/log/apache2/error.log", #Debian / Ubuntu
            "/var/log/httpd-error.log", #FreeBSD
        ]
        @os_path = find_log_path #identify OS specific file name format
        @log_path = @os_path.split("/")[0..-2].join("/") + "/"

        options = parse_options
        if options[:error]
            view_error_log
        elsif options[:access]
            view_access_log
        elsif options[:date]
            view_logs_for_date(options[:date])
        elsif options[:search]
            search_logs(options[:search])
        else
            puts "No option selected"
        end
    end

    def view_logs_for_date(date)
        log_file_path = if @os_path == "/var/log/httpd/error_log"
                            @log_path + "error_log"
                        elsif @os_path == "/var/log/apache2/error.log"
                            @log_path + "error.log"
                        elsif @os_path == "/var/log/httpd-error.log"
                            @log_path + "httpd-error.log"
                        else
                            puts "Log file not found"
                            return
                        end 
        File.open(log_file_path, "r") do |file|
            puts "Logs for #{date.strftime('%a %b %d %Y')}"
            puts "-" * 50
            file.each_line.reverse_each do |line|
                log_date_str = line.match(/^\[(\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2}\.\d{6})\s\d{4}\]/)
                if log_date_str
                    log_date = DateTime.strptime(log_date_str[1], '%a %b %d %H:%M:%S.%N')
                    if log_date.to_date == date
                        puts line
                    end
                end
            end
        end
    end

    def search_logs(search_term)
        log_file_path = if @os_path == "/var/log/httpd/error_log"
                            @log_path + "error_log"
                        elsif @os_path == "/var/log/apache2/error.log"
                            @log_path + "error.log"
                        elsif @os_path == "/var/log/httpd-error.log"
                            @log_path + "httpd-error.log"
                        else
                            puts "Log file not found"
                            return
                        end
        File.open(log_file_path, "r") do |file|
            file.each_line.reverse_each do |line|
                if line.include?(search_term)
                    puts line
                end
            end
        end
    end

    def view_error_log
        if @os_path == "/var/log/httpd/error_log"
            open_log_file(@log_path + "error_log")
        elsif @os_path == "/var/log/apache2/error.log"
            open_log_file(@log_path + "error.log")
        elsif @os_path == "/var/log/httpd-error.log"
            open_log_file(@log_path + "httpd-error.log")
        else
            puts "Log file not found"
        end
    end

    def view_access_log
        if @os_path == "/var/log/httpd/error_log"
            open_log_file(@log_path + "access_log")
        elsif @os_path == "/var/log/apache2/error.log"
            open_log_file(@log_path + "access.log")
        elsif @os_path == "/var/log/httpd-error.log"
            open_log_file(@log_path + "httpd-access.log")
        else
            puts "Log file not found"
        end
    end

    def open_log_file(file_path)
        File.open(file_path, "r") do |file|
            file.each_line.reverse_each do |line|                
                puts line
            end
        end
    end

    def parse_options
        options = {}
        OptionParser.new do |opts|
            opts.banner = "Usage: app.rb [options]"
            opts.on("-e", "--error", "View error log") do |e|
                options[:error] = e
            end
            opts.on("-a", "--access", "View access log") do |a|
                options[:access] = a
            end
            opts.on("-d", "--date DATE", "View logs for a specific date (format: YYYY-MM-DD)") do |d|
                options[:date] = Date.parse(d)
            end
            opts.on("-s", "--search SEARCH", "Search for a specific string in the logs") do |s|
                options[:search] = s
            end
        end.parse!
        options
    end

    #find the correct path for the log file
    def find_log_path
        @config_paths.each do |path|
            if File.exist?(path)
                return path
            end
        end
        raise "Log file not found"
    end

    private :view_logs_for_date
    private :search_logs
    private :find_log_path
    private :open_log_file
    private :parse_options
end


if __FILE__ == $0

    #-a or --access to view access log
    #-e or --error to view error log
    #-d or --date to view error logs for a specific date
    #-s or --search to search for a specific string in the logs 

    logger = Logger.new
    puts "------------"
end