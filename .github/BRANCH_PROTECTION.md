# Branch Protection Configuration

This repository uses GitHub branch protection rules to ensure code quality and testing before merging to the main branch.

## Branch Protection Rules for `main`

To enable branch protection on GitHub, follow these steps:

### Via GitHub Web Interface:

1. Go to your repository on GitHub
2. Click on **Settings** → **Branches**
3. Under "Branch protection rules", click **Add rule**
4. Configure the following settings:

   **Branch name pattern:** `main`

   ✅ **Require a pull request before merging**
   - Require approvals: 1 (recommended)
   - Dismiss stale pull request approvals when new commits are pushed
   - Require review from Code Owners (optional)

   ✅ **Require status checks to pass before merging**
   - Require branches to be up to date before merging
   - Status checks that are required:
     - `test` (from the Test GLAuth Configuration workflow)

   ✅ **Require conversation resolution before merging**

   ✅ **Do not allow bypassing the above settings**

   ⚠️ **Include administrators** (recommended for strict enforcement)

5. Click **Create** or **Save changes**

## Continuous Integration Workflow

The repository includes a GitHub Actions workflow (`.github/workflows/test.yml`) that:

1. **Generates self-signed certificates** for LDAPS testing
2. **Starts the GLAuth service** using docker compose
3. **Verifies service health** by checking container status
4. **Runs LDAP connectivity tests** using the test-ldap.sh script
5. **Performs LDAP search queries** to validate functionality
6. **Tests authentication** by binding as different users
7. **Shows detailed logs** on failure for debugging

### Workflow Triggers

The workflow runs on:
- **Pull requests** targeting the `main` branch
- **Pushes** to the `main` branch (to verify main stays healthy)

### Required Status Checks

Before a pull request can be merged to `main`, the following must pass:
- ✅ All LDAP connectivity tests
- ✅ Service health checks
- ✅ Authentication tests
- ✅ LDAP search functionality

## Development Workflow

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes and commit:**
   ```bash
   git add .
   git commit -m "Add new feature"
   ```

3. **Push to GitHub:**
   ```bash
   git push origin feature/my-new-feature
   ```

4. **Create a Pull Request:**
   - Go to GitHub and create a PR from your feature branch to `main`
   - The CI tests will automatically run
   - Wait for tests to pass (green checkmark)

5. **Request review:**
   - Get approval from a reviewer (if required)
   - Ensure all conversations are resolved

6. **Merge:**
   - Once tests pass and approval is given, merge the PR
   - The feature branch will be merged into `main`

## Local Testing

Before pushing, you can run tests locally:

```bash
# Run all tests
make test

# Or manually
make up
./test-ldap.sh
make down
```

## Troubleshooting CI Failures

If the GitHub Actions workflow fails:

1. **Check the workflow logs** in the Actions tab
2. **Review the "Show logs on failure" step** for detailed error messages
3. **Test locally** using `make test` to reproduce the issue
4. **Fix the issue** and push another commit
5. **Re-run the workflow** if it was a transient failure

## Security Considerations

- The `main` branch is protected and requires PR reviews
- Direct pushes to `main` are blocked
- All changes must pass automated tests
- Administrators can be included in branch protection rules for consistency
- Self-signed certificates are generated for testing only (not for production)

## Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GLAuth Documentation](https://glauth.github.io/)

