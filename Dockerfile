FROM python:3-alpine
WORKDIR /usr/src/app
EXPOSE 8000
COPY requirements.txt .
RUN pip install -qr requirements.txt
COPY server.py .

HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

CMD ["python3", "./server.py"]

FROM python:alpine AS dashboard-generator
RUN pip install grafanalib
COPY templates /tmp/templates
RUN mkdir /tmp/rendered && \
	generate-dashboards /tmp/templates/* && \
	mv /tmp/templates/*.json /tmp/rendered

FROM grafana/grafana:latest

COPY provisioning /etc/grafana/provisioning
COPY dashboards /var/lib/grafana/dashboards
COPY --from=dashboard-generator /tmp/rendered /var/lib/grafana/dashboards
