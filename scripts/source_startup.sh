curl -sSL https://github.com/open-telemetry/opentelemetry-collector-releases/releases/latest/download/opentelemetry-collector-linux-amd64 -o otelcol
chmod +x otelcol

./otelcol --config otel-config.yaml
