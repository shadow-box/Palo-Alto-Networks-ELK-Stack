Palo Alto Networks PAN-OS v8.0.x Elastic Stack v5.5.x Configuration

The goal of this project was to create a configuration which parses and stores ALL syslog fields within PAN-OS v8.0.x. Most other configurations I came across required editing which fields PAN-OS sent, which inherently meant loss of data fidelity.

Currently this configuration correctly parses all fields from the following log types:
- Traffic
- Threat

For a complete description of all of the syslog fields for PAN-OS v8.0.x please see the documentation below:
https://www.paloaltonetworks.com/documentation/80/pan-os/pan-os/monitoring/syslog-field-descriptions

Installation Instructions:

First follow the excellent instructions available online for setting up the following components:
- syslog-ng
- Logstash, Elasticsearch & Kibana v5.5.x

After the setup perform the following:

syslog-ng:
- Overwrite the default syslog-ng.conf with the configuration provided in this repository. This configuration listens for syslog connections on TCP/514.

Firewall(s)/Panorama: 
- Configure both the traffic and the threat logs to be sent to the syslog-ng server over TCP/514. 
- Reference PAN-OS v8.0.x Documentation: https://www.paloaltonetworks.com/documentation/80/pan-os/pan-os/monitoring/configure-syslog-monitoring
- Ensure syslog-ng is properly receiving and creating two separate logs; traffic.log and threat.log. 

Logstash:
- Download a copy of the MaxMind [GeoLite2 City database](http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz) and place at /opt/logstash/GeoLite2-City.mmdb.
- Copy PAN-OS.conf to the Logstash configuration location and restart the service.

Elasticsearch:
- Put the Elasticsearch templates provided in this repository with the following commands:

`curl -XPUT http://<your-elasticsearch-server>:9200/_template/traffic?pretty -H 'Content-Type: application/json' -d @traffic_template_mapping-v1.json`

`curl -XPUT http://<your-elasticsearch-server>:9200/_template/threat?pretty -H 'Content-Type: application/json' -d @threat_template_mapping-v1.json`

Kibana:
- Create the index patterns for both traffic and threat with the time filter of @timestamp.
- Optionally upload the Visualizations provided in the Visualizations sub-directory.
