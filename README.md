## devops

** Модуль 5б задача 3 **

| NAME               | PROMPT                        | DESCRIPTION                                                                 | EXAMPLE                         |
|--------------------|-------------------------------|-----------------------------------------------------------------------------|---------------------------------|
| `app`              | Basic Pod                     | Базовий Pod із одним контейнером.                                          | `yaml/app.yaml`                |
| `app-livenessProbe`| Liveness Probe                | Pod із livenessProbe для перевірки, чи додаток живий.                      | `yaml/app-livenessProbe.yaml`  |
| `app-readinessProbe`| Readiness Probe              | Pod із readinessProbe для перевірки готовності до трафіку.                | `yaml/app-readinessProbe.yaml` |
| `app-volumeMounts` | Volume Mounts                | Под, що монтує томи (volumes) до контейнера.                               | `yaml/app-volumeMounts.yaml`   |
| `app-cronjob`      | CronJob                      | CronJob для періодичного запуску задач.                                    | `yaml/app-cronjob.yaml`        |
| `app-job`          | Job                          | Одноразове виконання задачі.                                               | `yaml/app-job.yaml`            |
| `app-multicontainer`| Multi-container Pod          | Pod із кількома контейнерами.                                              | `yaml/app-multicontainer.yaml` |
| `app-resources`    | Resource Limits              | Контейнер з обмеженнями CPU та памʼяті.                                    | `yaml/app-resources.yaml`      |
| `app-secret-env`   | Secret via Environment       | Секрет у вигляді змінної середовища.                                       | `yaml/app-secret-env.yaml`     |
