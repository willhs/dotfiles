---
description: investigate and fix deployment issues
---

Investigate why the latest gh workflow/s (incl. deployment) didn't work and attempt to fix.

Github workflows are found in .github/workflows

The app deploys in google cloud platform.
infra:
- nextjs server in cloud run with min instances = 0
- gcs storage for map tiles (data deployed by a local process, not gh)

Follow this diagnostic workflow:

0. Quick health check (saves time):

- **Test app first**: Run `curl -I https://footsteps.willhs.me/` to check if app is actually working—helps prioritize issues
- **Check git sync**: Run `git status` and `git push --dry-run` to verify local changes are pushed—workflow file mismatches are very common
- **Lint, type check & terraform format**: Run `pnpm lint`, `npx tsc --noEmit` in footsteps-web/, and `terraform fmt -check -recursive` to catch config issues that block CI
- If using feature branches: check for merge conflicts with main first

1. Confirm and identify the issue:

- Use the github and/or gcloud cli to find the status of the last workflow that ran. Current workflows are 'ci' and 'deploy'
- Distinguish between deployment infrastructure issues vs code/branch issues (merge conflicts, linting, test failures)
- **Common infrastructure issues**: 
  - Stale terraform state locks (use `terraform force-unlock [LOCK_ID]`)
  - GitHub artifact storage quotas (temporary, resolve in 6-12 hours)
- **Common CI issues** (often don't affect actual deployment):
  - Terraform formatting errors (run `terraform fmt -check -recursive` locally)
  - ESLint/TypeScript configuration conflicts (redundant React rules in TypeScript projects)  
  - Test environment mismatches (CI missing data files, missing web API mocks)
  - Workflow file architecture mismatches (pnpm vs Docker, API vs GCS)
- If there are any issues, do any investigation needed to understand the problem well enough to come up with a solution to fix it

2. Fix the issue

- Come up with one or more solutions to try
- Try them until the problem is likely to be solved 

3. Deploy and evaluate

- Deploy the app by committing your fix in git and deploying. This will trigger the gh workflows
- Monitor both GitHub workflow completion AND actual Cloud Run service status (`gcloud run services list`)
- **Test app directly with curl/browser even if workflow still running**—deployment often succeeds before workflow completes, and app may be working despite workflow failures
- If success: go to phase 4
- If still failing: go back to phase 1

4. Done

- Read this document at @.claude/commands/fix-deploy.md
- In the Guest book section below, 
  - If there are more than 10 entries then delete then delete the top one
  - Add an entry to the bottom: write a few sentences about how this document could be improved, taking into account your experience of this task and how this document could have better prepared you for the task
  - Now, consider the guest book entries and decided whether you think you can improve this document in terms of simplicity, reducing the number of steps to fix a deployment.
  - If so: make any changes you think would improve this document. Don't change the title or main themes.


Guest book:

**Entry 1**: The workflow diagnostics were straightforward—GitHub CLI helped quickly identify recent failures. The fix was simple once I understood that tiles API tests were obsolete after the GCS migration. This document could benefit from: (1) mentioning checking environment variables when API tests fail, (2) noting that architecture changes might make workflow tests outdated, and (3) suggesting to verify what the current deployment actually uses (API vs direct GCS) before assuming test validity.

**Entry 2**: ESLint errors caused CI failure, specifically react/prop-types rule triggering on non-React object properties. Fix was disabling the redundant rule in TypeScript project. Document could be improved by: (1) mentioning common ESLint/TypeScript configuration issues that can block CI, (2) noting that lint errors vs warnings have different CI impacts, and (3) suggesting to run `pnpm lint` locally first to catch config issues before committing.

**Entry 3**: Successfully merged Codex-generated binary tiles branch with minimal issues. Main challenge was merge conflict in tileMetrics.ts requiring manual resolution to preserve both binary implementation and TileMetrics interface. Tests passed, only minor ESLint fix needed. Document could be improved by: (1) adding guidance for feature branch merges vs deployment fixes, (2) recommending test-driven verification of changes before assuming deployment issues, and (3) including merge conflict resolution as a common step when multiple developers/tools modify similar code areas.

**Entry 4**: Primary issue was TypeScript compilation errors blocking CI (FootstepsViz null assertion, missing webworker lib, incomplete PickingInfo mocks). Secondary issue was stale Terraform state lock from 2 days ago preventing deployment. Document improvements: (1) add "run type check" to health checks alongside lint, (2) mention terraform state lock resolution (`force-unlock`) as common infrastructure issue, (3) emphasize checking actual app response even if workflow still running—Cloud Run deployment succeeded before workflow completion.

**Entry 5**: Main issue was GitHub workflow trying to use `pnpm` caching without pnpm being installed, caused by outdated remote deploy.yml that still had Node.js/pnpm setup steps while local version used Docker artifacts. Required git rebase with conflict resolution to push the Docker artifact approach. App was actually working despite workflow failures. Document improvements: (1) emphasize checking git push status—local vs remote workflow differences are a common issue, (2) add step to verify workflow files match expected architecture before debugging, (3) note that successful app response can occur even with workflow failures due to previous deployments.

**Entry 6**: Primary issue was Python test failing in CI due to missing HYDE data files, plus GitHub artifact storage quota hit. App was actually deployed and working fine (HTTP 200). Fixed by making test environment-aware to handle both local (with data) and CI (without data) scenarios. Document improvements: (1) add "test app first" to quick health check—knowing if app works helps prioritize issues, (2) mention that CI test failures don't always indicate deployment problems if using separate data workflows, (3) note that GitHub storage quotas are temporary (6-12 hours) and shouldn't block deployment validation.

**Entry 7**: Issue was Terraform formatting errors in main.tf blocking CI workflow. GitHub CLI quickly identified the problem (`terraform fmt -check` failing). Simple fix with `terraform fmt main.tf` then commit/push resolved it. App responded HTTP 200 immediately after deployment succeeded. Document improvements: (1) add Terraform formatting to common CI issues list, (2) emphasize that `terraform fmt -check -recursive` should be run locally as part of health checks, (3) note that Terraform validation failures are easy to fix but completely block deployment workflows.
