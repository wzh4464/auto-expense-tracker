# Contributing to auto-expense-tracker

Thank you for considering contributing to this project! We welcome issues, feature requests, and pull requests. Please review the following guidelines to help us maintain a high-quality codebase and efficient workflow.

---

## Table of Contents

- [Workflow Guidelines](#workflow-guidelines)
- [Python Coding Standards](#python-coding-standards)
- [Commit Message Conventions](#commit-message-conventions)
- [Code Review Checklist](#code-review-checklist)
- [Approval Process](#approval-process)
- [Getting Started](#getting-started)

---

## Workflow Guidelines

- All development should happen on feature branches, not directly on `main`.
- Before submitting a pull request (PR), ensure all tests pass and code quality checks succeed (see below).
- Use the provided PR template and fill out all sections clearly.
- Reference related issues and link them in your PR description.
- Ensure your branch is up-to-date with `main` before submitting a PR.

---

## Python Coding Standards

- **PEP 8 Compliance:**
  All Python code must adhere to [PEP 8](https://peps.python.org/pep-0008/) guidelines.
  Automated tools (Black, pylint, mypy) are configured in the CI pipeline and pre-commit hooks to help enforce this.

- **Docstring Format:**
  All public modules, classes, functions, and methods must include docstrings.
  We recommend using the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings).

  **Example (Google Style):**

  ```python
  def add_numbers(a, b):
      """Add two numbers.

      Args:
          a (int): First number.
          b (int): Second number.

      Returns:
          int: The sum of a and b.
      """
      return a + b
  ```

- **Enforcement:**
  The project uses [pydocstyle](https://pypi.org/project/pydocstyle/) to enforce docstring conventions. Please run pre-commit hooks locally before pushing.

---

## Commit Message Conventions

We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
This helps automate changelogs and streamline the review process.

**Format:**

```text
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]
```

**Types include:**
`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `build`, `ci`

**Examples:**

- `feat(expense): add OCR for receipt parsing`
- `fix(api): handle missing user ID error`
- `docs: update architecture diagram`
- `chore: update dependencies`

---

## Code Review Checklist

Before approving or merging any PR, reviewers (and authors) should verify:

- [ ] Code follows PEP 8 and passes all linters (Black, pylint, mypy, etc.)
- [ ] All public functions and classes have clear, complete docstrings in the required format
- [ ] No credentials, secrets, or sensitive data are committed
- [ ] Tests are added or updated for all new features/fixes
- [ ] Documentation is up-to-date for any relevant changes
- [ ] The PR description is complete, referencing related issues as needed
- [ ] Code is modular, readable, and maintainable

---

## Approval Process

- At least **one reviewer** (other than the author) must approve the pull request before merging.
- All CI checks must pass.
- Use GitHub's review feature to leave comments, request changes, or approve.
- For major features or refactoring, seek additional input from maintainers before merging.
- Minor fixes may be merged after a single approval if they do not introduce risk.

---

## Getting Started

1. Fork the repository and clone your fork.
2. Install dependencies and pre-commit hooks:

    ```bash
    pip install -r requirements.txt
    pre-commit install
    ```

3. Create a new feature branch:

    ```bash
    git checkout -b feat/your-feature
    ```

4. Make your changes and follow all guidelines above.
5. Push your branch and open a pull request using the provided template.

---

Thank you for helping us build a better auto-expense-tracker!

```text
