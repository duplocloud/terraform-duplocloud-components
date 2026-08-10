## Terraform DuploCloud Components — Agent Notes

Purpose: repo of Terraform modules that wrap DuploCloud patterns (plus a few AWS/GitHub/MongoDB helpers). Start with `README.md`, then jump into `modules/` and `examples/`.

### Where to look (quick prompts)
- Module docs live in `modules/*/README.md`; usage examples in `examples/<module>/`.
- If a module has no README (e.g., `modules/compose`, `modules/infrastructure`, `modules/loadbalancer`), read the module `.tf` files and check matching `examples/`.
- `modules/api-gateway` and `modules/lambda` README content appears copy‑pasted from `modules/retool-bastion`; verify the actual module code before using.

### Common module entry points (open these when relevant)
- `modules/configuration`: configmaps/secrets/SSM/Secrets Manager.
- `modules/context`: shared tenant context + JIT outputs.
- `modules/eks-nodes`: HA EKS node groups + optional ASG refresh.
- `modules/env-file`: parses env files into key/value outputs.
- `modules/gamelift-build`: GameLift build + fleet from S3 artifact.
- `modules/micro-service`: single Duplo service + optional LB.
- `modules/mongodb`: MongoDB Atlas cluster/user setup.
- `modules/retool-bastion`: bastion host for Retool ↔ private resources.
- `modules/tenant`, `modules/tenant-*`: tenant creation + GitHub/AWS integrations.
- `modules/tenant-data-aws`, `modules/vpn-data-aws`: data-only helpers.
- `modules/website-gcp`: GCP website deployment.

### Tests
- Module-level tests: run inside a module dir with `tf test -filter=tests/unit.tftest.hcl`.
