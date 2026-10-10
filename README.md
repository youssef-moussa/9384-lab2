# Lab 2: Simple Antivirus Daemon

Youssef Mohamed | Group 5 | ID 9384

## Overview

This project is a simple antivirus written in bash. `antivirusd.sh` watches a folder, and whenever its contents change, it scans every file. Files that look malicious are printed to the terminal, copied into a quarantine folder, and deleted from the watched folder.

`restore.sh` lets the user review quarantined files one at a time and either restore a file (false positive), delete it permanently, or leave it for later.

## Folder Structure

```
9384-lab2/
├── antivirusd.sh   # The antivirus daemon: detects changes and quarantines files
├── restore.sh      # Interactive tool to restore or permanently delete quarantined files
├── Makefile        # Shortcuts to run both tools, plus a pre-build step
└── README.md       # This file
```

While running, the daemon also creates `directory-info.last` and `directory-info.new` in the project folder. These hold snapshots of the watched folder (`ls -l` output) used to detect changes.

## Prerequisites

- Ubuntu (or any Linux distribution)
- `bash`
- `make`
- Standard tools: `ls`, `cp`, `mv`, `rm`, `grep`, `cmp`

Most of these come with Ubuntu. To make sure everything is installed:

```bash
sudo apt update
sudo apt install -y make bash coreutils grep diffutils
```

## How to Run

### 1. Get the project

```bash
git clone git@github.com:<youssef-moussa>/9384-lab2.git
cd 9384-lab2
chmod +x antivirusd.sh restore.sh
```

### 2. Run the antivirus daemon

```bash
make
```

This first runs the `prebuild` step, which creates the quarantine folder if it doesn't exist, then starts the daemon. Every time something changes in the watched folder, the daemon scans it, and each malicious file is reported like this:

```
bad.txt is malicious and it is DELETED
```

Stop the daemon with **Ctrl+C**.

### 3. Run the restore tool

Run this after stopping the daemon. The two tools are not meant to run at the same time.

```bash
make restore
```

The tool lists the quarantined files with numbers. Pick a file by its number, then choose:

- **1:** restore the file to the watched folder (false positive)
- **2:** permanently delete the file (genuinely malicious)
- **3:** leave it and go back to the list

The list repeats until the quarantine folder is empty.

### Changing the settings

The folders and the check interval are variables at the top of the `Makefile`:

```make
DIR = watched          # folder being monitored
MAL_DIR = quarantine   # where flagged files are moved
INTERVAL = 5           # seconds between checks
```

You can also run the scripts directly:

```bash
./antivirusd.sh <dir> <malicious_dir> <interval-secs>
./restore.sh <dir> <malicious_dir>
```

## Detection Rules

A file is malicious if it matches at least one rule. Both lists are hardcoded inside the `scan()` function in `antivirusd.sh`:

- **Flagged extensions** (`.exe`, `.bat`, `.vbs`, `.scr`, `.ps1`): the `case` statement on **line 7**.
- **Flagged keywords** (`virus`, `trojan`, `malware`, `worm`, `ransomware`, case-insensitive): the `grep -qiE` command on **line 10**.

## How Change Detection Works

1. On the first run (no `directory-info.last` yet), the daemon scans immediately and saves `ls -l` of the folder into `directory-info.last`.
2. Every `interval-secs`, it saves a new listing into `directory-info.new` and compares the two with `cmp`.
3. If they are identical, nothing happens. If they differ, it scans the folder and copies `directory-info.new` into `directory-info.last`.

To start fresh, delete `directory-info.last`.
