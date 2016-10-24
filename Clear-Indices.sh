#!/bin/bash
sudo service logstash stop
curator delete indices --all-indices
