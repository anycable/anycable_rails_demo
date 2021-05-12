#!/bin/sh

cp /redis/sentinel.conf.template /etc/sentinel.conf

sed -i "s/\$SENTINEL_MASTER/$SENTINEL_MASTER/g" /etc/sentinel.conf
sed -i "s/\$SENTINEL_QUORUM/$SENTINEL_QUORUM/g" /etc/sentinel.conf
sed -i "s/\$SENTINEL_DOWN_AFTER/$SENTINEL_DOWN_AFTER/g" /etc/sentinel.conf
sed -i "s/\$SENTINEL_FAILOVER/$SENTINEL_FAILOVER/g" /etc/sentinel.conf

redis-server /etc/sentinel.conf --sentinel
