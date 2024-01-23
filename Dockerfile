FROM flink:1.16

RUN mkdir /opt/flink/usrlib
ADD target/flink-sql-runner-*.jar /opt/flink/usrlib/flink-sql-runner.jar
ADD sql-scripts /opt/flink/usrlib/sql-scripts