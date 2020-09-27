# Docker-Hadoop-Script

**Inherited from** [https://github.com/kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker)

**Original author:** kiwenlau

# Few Updates

1. Update hadoop version from 2.7.2 to 3.1.4
2. Update java version from openjdk-7-jdk to openjdk-8-jdk(may be to follow up hadoop version)
3. Resources on port 50070 has been moved to port 9870 due hadoop version update
   
# Alertation

1. You can search in github(in this repository) `# NOTE` to find out where I edited.Compare with the original repository and customize your own hadoop-docker-script
2. From hadoop3.0,config file that records slaves' host(or ip),has been moved to $HADOOP_HOME/etc/hadoop/workers instead of $HADOOP_HOME/etc/hadoop/slaves.Attention here!
   
# Simple usage

## Get the hadoop docker image

### Using the docker image from dockerhub
```
docker pull cherrooo/hadoop:1.0
./start-container.sh
```

### Build your hadoop image
First you need download hadoop-3.1.4.tar.gz from hadoop's official website(place it in the repository's root directory). There is no need for you to unpack the as the script would do it for you

Type
```
./resize-cluster.sh 3
```

Then you would be in the hadoop-master container
type the command
```
./start-hadoop.sh
```

To test your hadoop cluster, type
```
./run-wordcount.sh
```

Also, you can find more information in **127.0.0.1:8088** and **127.0.0.1:9870**
