# pjmgmt

Managing projects is a painful task, it often leads to files and folders on your desktop long to be forgotten about.

I originally had a project management script in `python` that would create my notes file and project folders. In an effort to lean and use more Swift, I decided to port it over to swift and add in the ability to zip up the project folder.

## Dependencies

You'll need a folder at `~/Documents/Projects` and Swift 5. There is also a check to make sure that your on macOS 10.11 or newer.

## Installation

After you clone this project.

```bash
cd pjmgmt
swift build --configuration release
cp -f .build/release/pjmgmt /usr/local/bin/pjmgmt
```

## Usage
After compiling and installing the program, you can now run `pjmgmt` to manage your project folder. 

```bash
% pjmgmt
Error: Missing expected argument '<id>'

USAGE: project <id> [--archive]

ARGUMENTS:
  <id>                    project identifier

OPTIONS:
  --archive               archive project
  -h, --help              Show help information.
```

### What do you get

The script makes the following folders 

**Documents**
I tend to use this for any relevant documents that I may have been given by the client.

**Logs**
I typically save my `nmap` scans and/or burp project here.

**Reporting**
I use this folder to keep all the itterations of the final report.

**Screenshots**
All good pentests have screenshots.
 
Because `org-mode` is the best, it also makes an `notes.org` file.

