set -x
#!/bin/bash
export SPLUNK_REALM="jp0"
export SPLUNK_MEMORY_TOTAL_MIB="512"

# Read the secret from instance metadata
export SPLUNK_ACCESS_TOKEN=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/SPLUNK_ACCESS_TOKEN" -H "Metadata-Flavor: Google")

# Download the Splunk OpenTelemetry Collector script and run it
curl -sSL https://dl.signalfx.com/splunk-otel-collector.sh -o /tmp/splunk-otel-collector.sh

if [ -f /tmp/splunk-otel-collector.sh ];then
    echo "Splunk OpenTelemetry Collector script downloaded successfully." >> /var/log/startup_script.log
    sudo sh /tmp/splunk-otel-collector.sh --realm $SPLUNK_REALM --memory $SPLUNK_MEMORY_TOTAL_MIB -- $SPLUNK_ACCESS_TOKEN
else
    echo "Failed to download Splunk OpenTelemetry Collector script."  >> /var/log/startup_script.log
    exit 1
fi

