FROM ubuntu:20.04

# NOTE: ORIGINAL AUTHOR
MAINTAINER KiwenLau <kiwenlau@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
# NOTE :UPDATE openjdk-7-jdk to openjdk-8-jdk
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget

#copy hadoop package
COPY hadoop-3.1.4.tar.gz /root/

# NOTE:I FIND DOWNLOAD HADOOP PACKAGE FROM THE INTERNET ISNOT A GOOD CHOICE,SO,YOU MAY HAVE TO
# DOWNLOAD THE .tar.gz PACKAGE YOURSELF AND PUT THE PACKAGE IN THE REPOSITORY's ROOT DIRECTORY
# install hadoop 3.1.4
RUN tar -xzvf hadoop-3.1.4.tar.gz && \
    mv hadoop-3.1.4 /usr/local/hadoop && \
    rm hadoop-3.1.4.tar.gz

# set environment variable
# NOTE:UPDATE JAVA_HOME FROM /usr/lib/jvm/java-7-openjdk-amd64 to /usr/lib/jvm/java-8-openjdk-amd64 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    # NOTE:HADOOP VERSION 3.1.4 READS SLAVES'S HOSTNAMES FROM "worders" FILES
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

