# Repository Organisation Strategy

## Introduction

This document outlines the strategy for organising my personal repositories and their mirrors. The goal is to have a consistent structure across all repositories, making it easier to navigate and understand the contents whilst also making it easier to maintain and update.

## Monorepos

Each namespace should have a monorepo that contains anything that doesn't require a separate repository, such as notes, scripts, and other miscellaneous files. This repository should be named "monorepo" in the namespace. For example, the monorepo for the user "john" would be named "john/monorepo", and the monorepo for the organisation "example" would be named "example/monorepo".

## Mirrors

Each repository should have at least one mirror that it pushes to. Maintaining this mirror has the following benefits:

- Ensures that the repository is backed up in case the primary host goes down.
- Provides redundancy in case the primary host is unavailable.
- Allows for easy collaboration with others who may not have access to the primary host.
- Makes it easier to switch to a different host if needed.

The mirror should be hosted on a different platform than the primary host to provide the most redundancy. For example, if the primary host is my personal GitLab instance, the mirror should be on GitHub or Bitbucket. The more mirrors, the better.

Each repository's root README should contain the current list of active mirrors and the location of the primary host.

An example of a mirror list in a README:

```markdown
## Development

<!-- Whatever you want to say about the development of the project -->

### Mirrors

This repository uses mirrors!

The primary host is: https://gitlab.com/example/repo

Official mirrors are:

- [GitLab](https://gitlab.com/example/repo)
- [Bitbucket](https://bitbucket.org/example/repo)
```

You could also just provide a link to this document in the README.

## Root README

Each repository should have a root README that contains important information about the repository, such as the purpose, contents, and usage of the repository. This README should be concise and easy to read, with links to more detailed documentation if needed.
