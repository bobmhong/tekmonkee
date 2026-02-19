# Topic Index

Browse knowledge base entries organized by category and tag.

## Categories

### Architecture
*System design, patterns, and trade-offs*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [Istio Cross-Cluster Migration Guide](../topics/architecture/istio-cross-cluster-migration.md) | yaml | architectural | `istio`, `migration`, `service-mesh` | 2026-02 |
| [Istio Ingress TLS Overview](../topics/architecture/istio-ingress-tls-overview.md) | yaml | architectural | `istio`, `tls`, `mtls` | 2026-02 |
| [Kubernetes Fleet Management](../topics/architecture/kubernetes-fleet-management.md) | markdown | architectural | `kubernetes`, `rancher`, `fleet` | 2026-02 |
| [Kosmotron Implementation Guide](../topics/architecture/kosmotron-implementation.md) | yaml | architectural | `kubernetes`, `hosted-control-plane` | 2026-02 |
| [Supply Chain Security (FRSCA)](../topics/architecture/supply-chain-security-frsca.md) | — | architectural | `security`, `spiffe`, `tekton` | 2026-02 |
| [Container Building in Kubernetes](../topics/architecture/container-building-in-k8s.md) | — | architectural | `buildah`, `kaniko`, `buildkit` | 2026-02 |
| [Dapr Resiliency Patterns](../topics/architecture/dapr-resiliency-patterns.md) | yaml | behavioral | `dapr`, `circuit-breaker`, `retry` | 2026-02 |
| [SLO Observability with Pyrra](../topics/architecture/slo-observability-pyrra.md) | yaml | architectural | `prometheus`, `slo`, `monitoring` | 2026-02 |

### Automation
*CI/CD, scripting, workflow automation*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [Sounder Diagnostics Tool](../topics/automation/sounder-diagnostics-tool.md) | python | architectural | `kubernetes`, `diagnostics`, `cli` | 2026-02 |
| [OCI Image Cleanup for ACR](../topics/automation/oci-image-cleanup-acr.md) | bash | automation | `azure`, `acr`, `semver` | 2026-02 |
| [Rancher Orphaned Cluster Cleanup](../topics/automation/rancher-orphaned-cluster-cleanup.md) | bash | automation | `rancher`, `cleanup` | 2026-02 |
| [Flux Kustomization with Image Mirroring](../topics/automation/flux-kustomization-image-mirroring.md) | yaml | structural | `flux`, `gitops`, `acr` | 2026-02 |
| [Azure Container Registry Purge](../topics/automation/acr-image-purge.md) | bash | automation | `azure`, `acr`, `cleanup` | 2026-02 |
| [Kubernetes Resource Export Script](../topics/automation/k8s-resource-export.md) | bash | automation | `kubernetes`, `inventory` | 2026-02 |
| [CronJob Suspension with Flux](../topics/automation/cronjob-suspension-flux.md) | yaml | api | `flux`, `gitops`, `cronjob` | 2026-02 |

### Debugging
*Troubleshooting techniques, log analysis*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [etcd Health Check & Troubleshooting](../topics/debugging/etcd-health-troubleshooting.md) | bash | data | `etcd`, `kubernetes`, `diagnostics` | 2026-02 |
| [etcd Cluster Failure Incident Report](../topics/debugging/etcd-cluster-failure-incident.md) | markdown | debugging | `etcd`, `incident`, `rca` | 2026-02 |
| [Rancher RBAC ClusterRoleTemplateBinding Fix](../topics/debugging/rancher-rbac-crtb-fix.md) | bash, yaml | debugging | `rancher`, `rbac` | 2026-02 |
| [Control Plane Diagnostics Collection](../topics/debugging/control-plane-diagnostics.md) | bash | automation | `kubernetes`, `etcd`, `ssh` | 2026-02 |
| [Neo4j PR Metrics Queries](../topics/debugging/neo4j-pr-metrics.md) | cypher | data | `neo4j`, `metrics`, `devops` | 2026-02 |
| [Postgres Certificate Extraction](../topics/debugging/postgres-cert-extraction.md) | python | api | `postgres`, `tls`, `certificates` | 2026-02 |

### Infrastructure
*Cloud resources, networking, storage*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [vCenter DRS Configuration Script](../topics/infrastructure/vcenter-drs-configuration.md) | powershell | data | `vsphere`, `vmware`, `storage` | 2026-02 |
| [StatefulSet AZ PVC Migrator](../topics/infrastructure/statefulset-az-pvc-migrator.md) | powershell | data | `azure`, `pvc`, `migration` | 2026-02 |
| [Crossplane Installation Guide](../topics/infrastructure/crossplane-installation.md) | bash | automation | `crossplane`, `kubernetes`, `iac` | 2026-02 |
| [Terraform Azure Role Assignment](../topics/infrastructure/terraform-azure-role-assignment.md) | terraform | structural | `azure`, `iam`, `terragrunt` | 2026-02 |
| [vSphere StorageClass Configuration](../topics/infrastructure/vsphere-storageclass.md) | yaml | data | `vsphere`, `storage`, `flux` | 2026-02 |

### Kubernetes
*Container orchestration, pod management, deployments*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [Rancher Cluster Deletion Guide](../topics/kubernetes/rancher-cluster-deletion.md) | bash | operational | `rancher`, `cleanup`, `finalizers` | 2026-02 |
| [Kubernetes Scheduler Configuration](../topics/kubernetes/scheduler-configuration.md) | yaml | architectural | `scheduler`, `affinity`, `topology` | 2026-02 |
| [StatefulSet with Volume Claims](../topics/kubernetes/statefulset-volume-claims.md) | yaml | structural | `statefulset`, `pvc` | 2026-02 |
| [Namespace with Rancher Annotations](../topics/kubernetes/namespace-rancher-annotations.md) | yaml | data | `rancher`, `namespace` | 2026-02 |
| [Cross-Cluster Helm Charts](../topics/kubernetes/cross-cluster-helm-charts.md) | yaml | architectural | `helm`, `istio`, `cross-cluster` | 2026-02 |

### Performance
*Optimization, profiling, monitoring*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [RCP Alert Analysis Dataset](../topics/performance/rcp-alert-analysis.md) | markdown | data | `monitoring`, `alerts`, `analysis` | 2026-02 |
| [etcd Performance Degradation Analysis](../topics/performance/etcd-performance-degradation.md) | markdown | debugging | `etcd`, `latency`, `disk-io` | 2026-02 |

### Security
*Auth, secrets management, best practices*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [SOPS & AGE Encryption Setup](../topics/security/sops-age-encryption.md) | bash | security | `sops`, `age`, `secrets` | 2026-02 |
| [Vault Certificate Generation](../topics/security/vault-certificate-generation.md) | bash | automation | `vault`, `pki`, `tls` | 2026-02 |
| [Vault DR Replication Setup](../topics/security/vault-dr-replication.md) | bash | operational | `vault`, `dr`, `replication` | 2026-02 |
| [Vault Snapshot ACL Policy](../topics/security/vault-snapshot-policy.md) | hcl | security | `vault`, `raft`, `backup` | 2026-02 |
| [Istio mTLS Patterns](../topics/security/istio-mtls-patterns.md) | yaml | security | `istio`, `mtls`, `mesh` | 2026-02 |
| [PKCS12 Certificate Export](../topics/security/pkcs12-certificate-export.md) | bash | automation | `certificates`, `openssl` | 2026-02 |
| [Self-Signed Certificate Generation](../topics/security/self-signed-cert-generation.md) | bash | operational | `certificates`, `saml`, `rancher` | 2026-02 |

### Tooling
*IDE setup, CLI tools, developer experience*

| Topic | Language | Pattern | Tags | Updated |
|-------|----------|---------|------|---------|
| [SSH Helper Functions](../topics/tooling/ssh-helper-functions.md) | bash | tooling | `ssh`, `clipboard`, `known-hosts` | 2026-02 |
| [Git Multi-Email Configuration](../topics/tooling/git-multi-email-config.md) | gitconfig | data | `git`, `config`, `identity` | 2026-02 |
| [Docker Nginx Development Server](../topics/tooling/docker-nginx-dev-server.md) | bash | operational | `docker`, `nginx`, `ssl` | 2026-02 |
| [Maintenance Scripts Collection](../topics/tooling/maintenance-scripts.md) | bash | automation | `scripts`, `maint` | 2026-02 |

---

## Quick Reference

### Tags (Domain)
`aws`, `azure`, `docker`, `gcp`, `kubernetes`, `linux`, `rancher`, `istio`, `vault`

### Tags (Activity)
`debugging`, `deployment`, `migration`, `setup`, `cleanup`, `diagnostics`

### Tags (Concept)
`monitoring`, `networking`, `security`, `storage`, `mtls`, `gitops`

### Related Indexes
- **[Languages Index](./languages.md)** - Browse by programming language
- **[Patterns Index](./patterns.md)** - Browse by development pattern
- **[Timeline Index](./timeline.md)** - Browse by date

---

*Last updated: 2026-02*
