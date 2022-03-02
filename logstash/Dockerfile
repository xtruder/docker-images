FROM docker.elastic.co/logstash/logstash-oss:7.13.2

# support for readint and writing S3 files
RUN logstash-plugin install logstash-input-s3

# postgresql jdbc driver for logstash-input-jdbc plugin
RUN curl https://jdbc.postgresql.org/download/postgresql-42.2.21.jar -o /usr/share/logstash/logstash-core/lib/jars/postgresql-jdbc.jar
