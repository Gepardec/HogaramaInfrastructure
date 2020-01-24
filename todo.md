# Offene Punkte

- AMQ Online über Operator
    - resolve differences in AMQ configuration between itandtel/AWS
- AMQ MQTT-SSL Acceptor - our current SSL Version is not supported due to a found vulnerability
- IMPORTANTE: revoke gepardec client secret & key. keycloak realm parametrisiert mit diesen anlegen. nicht in github speichern
- Templating von Konfigurationen
    - e.g. Dashboard & Datasource Grafana umstellen auf AWS Instanzen
    - Operator Group !!!!
    - eap-crd: registry namespace  
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
    
- Keycloak: 
    1. realm = hogarama nennen, ansonsten spießt es sich mit der keycloak json im war file (Rückwärtskompatibilität mit itandtel)
    2. group anlegen, default group für neue user 