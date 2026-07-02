# SDD Barista Agent: Demo Replication Guide

This guide walks you through copying your Spec-Driven-Development (SDD) environment to a brand new folder, linking it to a fresh GitHub repository, and repeating the entire SDD demo workflow step-by-step.

---

## 📋 Table of Contents
1. [Prerequisites](#-prerequisites)
2. [Step 1: Replicating the Environment](#-step-1-replicating-the-environment)
3. [Step 2: Creating a New GitHub Repository](#-step-2-creating-a-new-github-repository)
4. [Step 3: Initializing and Pushing the Code](#-step-3-initializing-and-pushing-the-code)
5. [Step 4: Running the SDD Demo Workflow](#-step-4-running-the-sdd-demo-workflow)
   - [Phase A: Ingest the PRD (`/prd-to-backlog`)](#phase-a-ingest-the-prd-prd-to-backlog)
   - [Phase B: Specify a User Story (`/specify`)](#phase-b-specify-a-user-story-specify)
   - [Phase C: Implement Code via TDD (`/implement`)](#phase-c-implement-code-via-tdd-implement)
   - [Phase D: Commit and Ship (`/commit` and `/ship`)](#phase-d-commit-and-ship-commit-and-ship)
6. [Step 5: Cleaning Up the Demo Environment](#-step-5-cleaning-up-the-demo-environment)

---

## 🛠️ Prerequisites

Before you start, make sure you have:
- A GitHub personal access token or authorization for the `github` MCP server.
- The `sdd-plugin` installed in your Antigravity agent configuration.

---

## 📁 Step 1: Replicating the Environment

You can replicate the environment either automatically (recommended) or manually.

### Option A: Automatic Replication (Easiest)
We have provided an automated bash utility script, `duplicate-demo.sh`, in the root of the template repository. This script automates copying files, initializing Git, creating the GitHub repo, and pushing the initial structure. It automatically names the remote repository **identically to your target folder name** (the basename of your path) and automatically excludes replication-specific tools (such as the script itself and this replication guide) from your new workspace, keeping your environment perfectly clean.

Run the script by passing only the **target local directory**:
```bash
# Make sure you are in the template directory
cd /home/user/sdd-barista-reference

# Run the replication script with your folder path
./duplicate-demo.sh /home/user/my-new-barista-demo
```
This is a one-touch command that handles Steps 1, 2, and 3 for you! Once it finishes successfully, you can skip directly to **[Step 4: Running the SDD Demo Workflow](#-step-4-running-the-sdd-demo-workflow)**.

---

### Option B: Manual Replication
If you prefer to perform the steps manually, run the following commands in your shell:

```bash
# 1. Create a brand-new folder for your clean demo
mkdir -p /home/user/my-new-barista-demo
cd /home/user/my-new-barista-demo

# 2. Copy the template files from sdd-barista-reference
# We copy only the original tracked template files and configurations
cp -r /home/user/sdd-barista-reference/.agents /home/user/my-new-barista-demo/
cp -r /home/user/sdd-barista-reference/docs /home/user/my-new-barista-demo/
cp /home/user/sdd-barista-reference/AGENTS.md /home/user/my-new-barista-demo/
cp /home/user/sdd-barista-reference/.gitignore /home/user/my-new-barista-demo/
cp /home/user/sdd-barista-reference/pyproject.toml /home/user/my-new-barista-demo/

# 3. Clean up the replication-specific helper files in the new directory
rm -f /home/user/my-new-barista-demo/docs/REPLICATION.md

# 4. Double-check that there are no old demo artifacts (like SPEC.md, src/, tests/, etc.)
# The only directories should be '.agents' and 'docs', and the files 'AGENTS.md', '.gitignore', 'pyproject.toml'.
ls -la
```

---

## 🌐 Step 2: Creating a New GitHub Repository

*(Note: If you used Option A above, this has already been done for you!)*

You need a new GitHub repository named identically to your target folder to store your backlog and your code. You can do this in two ways:

### Option A: Using the `gh` CLI (Recommended)
If you have the GitHub CLI installed, run:
```bash
gh repo create my-new-barista-demo --public --description "Barista Agent Spec-Driven-Development Demo"
```

### Option B: Using the GitHub Web UI
1. Go to [github.com/new](https://github.com/new).
2. Name the repository `my-new-barista-demo`.
3. Keep it empty (**do not** initialize it with a README, `.gitignore`, or license, as we already have those files locally).
4. Click **Create repository**.

---

## 🚀 Step 3: Initializing and Pushing the Code

*(Note: If you used Option A above, this has already been done for you!)*

Now, initialize git in your new folder, commit the base structure, and push it to your brand-new remote.

```bash
# 1. Initialize git
git init
git checkout -b main

# 2. Add and commit the initial template structure
git add .
git commit -m "chore: initialize sdd-barista-reference template structure"

# 3. Link your new GitHub repository as origin
# (Replace [your-username] with your actual GitHub username or organization)
git remote add origin https://github.com/[your-username]/my-new-barista-demo.git

# 4. Push the base files to main
git push -u origin main
```

Now open your workspace in your Antigravity-enabled editor pointing to your new folder: `/home/user/my-new-barista-demo`.

---

## 🔄 Step 4: Running the SDD Demo Workflow

With your clean, fresh workspace linked to a new GitHub repository, you are ready to execute and repeat the Spec-Driven-Development demo! Follow these four phases sequentially.

### Phase A: Ingest the PRD (`/prd-to-backlog`)
In this phase, you (acting as the Product Owner) turn the PRD into user stories in your GitHub repository's backlog.

1. **Ask the Agent:**
   > "Please run the `/prd-to-backlog` command to parse our `docs/PRD.md` file and upload the user stories as draft issues to our new GitHub repository."
2. **What the Agent does:**
   - Reads `docs/PRD.md` to identify stories `US1` to `US4`.
   - Parses the acceptance criteria and maps MoSCoW priorities to metadata labels.
   - Leverages the `github` MCP server to create 4 draft issues with tags like `must-have`, `should-have`, and `status:draft`.
3. **Verify:** Check your repository's **Issues** page on GitHub. You will see 4 newly created issues representing your backlog!
4. **Publishing (PO Action):** In a real workflow, the PO reviews these issues. To publish a story for engineering, simply **remove the `status:draft` label** from Issue #1. Let's do that for Issue #1 (`[US1] Take an order`)!

---

### Phase B: Specify a User Story (`/specify`)
Now, switch to the developer role. We start the cycle for the first user story: **Issue #1 (`[US1] Take an order`)**.

1. **Ask the Agent:**
   > "Please specify Issue #1: `/specify #1`"
2. **What the Agent does:**
   - Fetches the content and acceptance criteria of Issue #1 from GitHub via MCP.
   - Evaluates the quality of the issue's criteria (ensuring concrete inputs → expected outcomes).
   - Translates the criteria into a technical specification, mapping them to rule definitions.
   - Generates a proposed draft of `SPEC.md` and presents it to you as an artifact.
   - **Waits for your explicit approval!** No code, branches, or files are touched in the repository yet.
3. **Your action:** Review the proposed spec. Once satisfied, tell the agent:
   > "The spec looks great. Please proceed!"
4. **Landing the Spec:**
   - The agent creates and checks out a branch: `issue/1-take-an-order`.
   - Writes the approved `SPEC.md` to the root of the repository.
   - Commits `SPEC.md` to version control.
   - Marks Issue #1 as `in-progress` on GitHub.

---

### Phase C: Implement Code via TDD (`/implement`)
With `SPEC.md` landed on your issue branch, the technical contract is defined. Now we implement the rules one unit at a time.

1. **Ask the Agent:**
   > "Please implement our first rule: `/implement R1`"
2. **What the Agent does:**
   - Reads the code-layout convention in `.agents/conventions/code-layout.md`.
   - **TDD (Red):** Writes failing unit tests and engine-level tests matching the acceptance criteria of Rule 1 (e.g., `tests/test_r1_make.py`).
   - **Implementation:** Writes the code in `src/barista/core/rules/r1_make.py` subclassing the `Rule` ABC, and registers it in `engine.py`.
   - **TDD (Green):** Runs the test suite to ensure all tests pass and coverage is ≥ 90%.
   - **Linting:** Runs `pylint` and static analysis hooks to guarantee code quality.
   - **Stops for review:** Presents the diff, tests, and linter results. It does not commit!
3. **Your action:** Review the implementation. Once you approve, tell the agent:
   > "Implementation looks clean and all tests are green. Let's commit it."

---

### Phase D: Commit and Ship (`/commit` and `/ship`)
Once the implementation is approved, you are ready to lock in the work and close the issue.

1. **Commit the Rule:**
   - Run `/commit` (using the `commit` skill) to auto-generate a Conventional Commit message linking the commit to Issue #1 and Rule R1 (e.g., `feat(rules): refuse unrecognized off-menu items [R1] (#1)`).
   - The agent stages and commits the code.
2. **Repeat for other rules:**
   - If there are other rules in `SPEC.md`, repeat Phase C and Phase D for each of them (e.g., `/implement R2`, `/implement R3`).
3. **Ship the entire story:**
   - Once all criteria of Issue #1 are implemented, tested, and committed, tell the agent:
     > "Please ship this issue: `/ship`"
   - The agent opens a Pull Request on GitHub from `issue/1-take-an-order` to `main`, waits for checks, merges it, deletes the branch, and automatically closes Issue #1 on GitHub!

---

## 🧹 Step 5: Cleaning Up the Demo Environment

To clean up and completely tear down a demo session, you can use our automated cleanup utility `cleanup-demo.sh` located in the root of the template repository.

This script will permanently delete both the remote GitHub repository and your local demo folder:

```bash
# Make sure you are in the template directory
cd /home/user/sdd-barista-reference

# Run the cleanup utility on your target directory
./cleanup-demo.sh /home/user/my-new-barista-demo
```
The script will fetch your GitHub username, confirm the target remote path, ask for confirmation, and cleanly wipe both locations.

---

### 🎉 Summary of SDD Commands Reference

| Persona | Command | Purpose |
| :--- | :--- | :--- |
| **Product Owner** | `/prd-to-backlog` | Transforms the PRD into GitHub Issues. |
| **Engineer** | `/specify #<issue>` | Pulls an issue, generates a proposed `SPEC.md` artifact, creates the branch, and commits the spec. |
| **Engineer** | `/implement R<rule>` | Follows TDD to write tests first, then writes OO code to implement one rule, ensuring gates pass. |
| **Engineer** | `/commit` | Generates a Conventional Commit message and commits the staged code. |
| **Engineer** | `/ship` | Opens a PR, merges it, deletes the branch, and closes the GitHub Issue. |

You are now fully equipped to replicate and showcase this powerful SDD flow to anyone!
