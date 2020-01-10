# Offene Punkte

- AMQ Online über Operator
    - resolve differences in AMQ configuration between itandtel/AWS
- AMQ MQTT-SSL Acceptor - our current SSL Version is not supported due to a found vulnerability
- Templating von Konfigurationen
    - e.g. Dashboard & Datasource Grafana umstellen auf AWS Instanzen
    - Operator Group !!
- Grafana umstellen auf Operator
    - aktuell haben wir die Subscription und die CRD für den Operator erstellt, aber noch nicht mit unseren configs und datasources verknüpft
- fluentd fixen. Macht aktuell noch Probleme in der Konfiguration
- PVCs
- Force Flag durchpipen zu allen Wrappern von bootstrap-wrapper.sh
- Nexus?
- Jenkins?
- Configure GitHub webhook for hogajama-binary build
- Instance Scheduler
    - Script Scheduler creation
    - Add/Remove instances
    - Add/Remove periods/schedulers
    - Script for starting instance/disabling scheduler and vice versa

- Script deletion of all namespaces containing an operator: 
    1. delete custom resources provided by operator
    2. delete operator suscription
    3. delete all secrets
    4. delete all --all -n ${namespace}
    5. delete project ${namespace}
    
    6. in case something goes wrong rejoice and hail noam manos on stackoverflow and upvote https://stackoverflow.com/questions/58638297/project-deletion-struck-in-terminating