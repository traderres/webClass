How to Empty a Kafka Topic (without restarting Kafka)
-----------------------------------------------------
The trick is to set the retention time to 1 second, give Kafka 300 seconds to process, and then set the retention time back

Assumptions:
 A) You have a $KAFKA_HOME variable set


Procedure
---------
 1. Create this bash script
    unix> vi emptyTopic.sh

    NOTE:  Remove any leading spaces

    #!/bin/bash

    echo "Enter name of topic to empty:"
    read topicName

    echo Setting the retention.ms=1000
    $KAFKA_HOME/bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name $topicName --add-config retention.ms=1000

    # Sleep for 300 seconds
    #   log.retention.check.interval.ms has a default value of 300000
    #   This setting determines the frequency that the log cleaner checks whether any log is eligible for deletion
    echo 'sleeping for 5 minutes (so kafka will process the changes)'
    echo I will return at `date --date 'now + 300 seconds' `
    sleep 300

    echo Deleting the rention.ms setting
    $KAFKA_HOME/bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name $topicName --delete-config retention.ms


 2. Make this script executable
    unix> chmod ugo+x emptyTopic.sh


 3. Create a sample topic called "stuff"
    unix> cd $KAFKA_HOME
    unix> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic stuff


 4. List the topics
    unix> cd $KAFKA_HOME
    unix>  bin/kafka-topics.sh --list --zookeeper localhost:2181
    -- You should see the topic called "stuff"


 5. Add some data to the topic
    unix> cd $KAFKA_HOME
    unix> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic stuff
        message #1
        message #2


 6. Use the consumer to pull those messages (from the beginning)
    unix> cd $KAFKA_HOME
    unix> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic stuff --from-beginning

    NOTE:  You should see message #1 and message #2


 7. Run the emptyTopic.sh script
    unix> ./emptyTopic.sh

    Enter name of topic to delete from zookeeper:
    stuff <enter>

 8. Use the consumer to pull those messages (from the beginning)
    unix> cd $KAFKA_HOME
    unix> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic stuff --from-beginning

     -- There should be no messages
