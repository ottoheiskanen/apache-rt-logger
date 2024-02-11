class Logger
    attr_accessor :log_path

    def initialize
        @log_path = find_log_path
    end

    #find the correct path for the log file
    def find_log_path
        config_paths = [
            "/var/log/httpd/error_log", #RHEL / Red Hat / CentOS / Fedora
            "/var/log/apache2/error.log", #Debian / Ubuntu
            "/var/log/httpd-error.log", #FreeBSD
        ]
        config_paths.each do |path|
            if File.exist?(path)
                #remove log file from path and return it
                path = path.split("/")[0..-2].join("/") + "/"
                return path
            end
        end
        raise "Log file not found"
    end

    def inspect
        @log_path
    end

    def view_error_log

        if @log_path == "/var/log/httpd/error_log"
            

        File.open(@log_path + "error_log", "r") do |file|
            file.each_line do |line|
                puts line
            end
        end
    end

    def view_access_log
        File.open(@log_path + "access_log", "r") do |file|
            file.each_line do |line|
                puts line
            end
        end
    end


end


if __FILE__ == $0
    logger = Logger.new
    puts "------------"
    puts logger.inspect

    logger.view_error_log
end