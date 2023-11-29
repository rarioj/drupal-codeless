# Drupal Codeless

> A "config only with no custom theme and modules" Drupal distribution.

## What is Drupal Codeless?

Drupal Codeless is an experimental attempt to build a [Drupal 10](https://www.drupal.org/about/10) distribution without involving a custom theme or custom modules. The goal of this project is to **_deliver composer and configuration files only_**.

Drupal Codeless uses the [Bootstrap 5](https://getbootstrap.com/) framework for most of the front-end styling. Any CSS and JS tweaking will use the [Asset Injector](https://www.drupal.org/project/asset_injector) module.

## Getting Started with Lando

**You don't need to clone this repository.** Instead, you can start by running the provided [Lando configuration file](https://raw.githubusercontent.com/rarioj/drupal-codeless/main/_lando.yml). Make sure you have the latest [Lando](https://lando.dev/) installed.

```shell
mkdir drupal-codeless
cd drupal-codeless
curl "https://raw.githubusercontent.com/rarioj/drupal-codeless/main/_lando.yml" -o .lando.yml
```

Open and adjust the Lando configuration file if needed (`.lando.yml`), especially in the environment variables section (`services.appserver.overrides.environment`). Default values are sufficient. *Adjustment is rarely necessary unless you know what you are doing.*

You can then start the service to build the latest project instance.

```shell
lando start
```

### Project Snapshot

When you have completed certain features or tasks, you can create a snapshot of your recent development progress.

```shell
# example: lando snapshot v10-added_admin_theme
lando snapshot [snapshot_name]
```

The `lando snapshot` command will pick the last created snapshot as the next build instance.

Directory `.project/snapshots` contains all the project snapshots created by the command above. You can use a symbolic link to pick a snapshot instance for your Drupal site installation.

```shell
# from the base directory of the project (e.g. where .lando.yml file is located)
cd .project
# remove any existing instance
rm -f instance
# symlink a snapshot to an instance
ln -sf "snapshots/v0.0.1-fresh_install" instance
```
