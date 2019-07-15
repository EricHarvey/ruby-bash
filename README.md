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
```bash
# release notes
rb release-notes <diff_url>
```
