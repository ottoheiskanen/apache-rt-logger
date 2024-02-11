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
                #paint the line red if it contains 404
                if line.include?("Sat Feb")
                    puts "\e[31m#{line}\e[0m"
                else
                    puts line
                end
            end
        end
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

    private :find_log_path
    private :open_log_file
end


if __FILE__ == $0
    logger = Logger.new
    puts "------------"
    puts logger.inspect

    logger.view_error_log
    #logger.view_access_log
end