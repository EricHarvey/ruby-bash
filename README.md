## Install

Add this to your bash profile:

```bash
# change ~/.ruby_bash to wherever this directory is
function rb() {
  ruby ~/.ruby_bash/utils.rb $@
}

alias branches='rb git'
alias br='rb git 10'
```

```bash
bundle install
```

## Usage

### Release notes generator
#### Prerequisites
- make sure you're on the `master` branch of the repo you're generating release notes for
- make sure you're up to date (e.g. `git pull`)


#### Command
```bash
rb release-notes <diff_url>
```
