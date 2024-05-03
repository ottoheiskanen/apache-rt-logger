if [ $# -eq 0 ]; then
    echo "Usage: $0 -s <errors by search term> -a <access logs> -e <error logs> -d <errors by date>"
    exit 1
fi

cd /home/null/Desktop/dev/apache-rt-logger/
ruby app.rb "$@"