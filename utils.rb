require 'pry'
require 'colorize'

def git_branches(limit: nil)
  branches_alias = 'git branch --sort=-committerdate --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - [%(color:red)%(objectname:short)%(color:reset)] - %(contents:subject) - (%(color:green)%(committerdate:relative)%(color:reset))"'
  results = `#{branches_alias}`.split("\n")
  parts_regex = /(?<branch>(\* |  )[a-z0-9\-]+) \- \[(?<commit>[a-z0-9]+)\] \- (?<message>[a-z0-9 \-,'\.\s\(\)#_\/\:]+) \- \((?<time>[a-z0-9 ]+)\)/i
  # binding.pry
  results.first(limit.nil? ? results.size : limit.to_i).each do |res|
    parts = res.match(parts_regex)
    branch_text = parts[:branch][2..parts[:branch].size]
    curr_branch = parts[:branch].match?(/^\* /)
    branch_text_colorized = curr_branch ? branch_text.colorize(:light_blue) : branch_text.colorize(:yellow)
    puts "#{branch_text_colorized} - [#{parts[:commit].colorize(:red)}] - #{parts[:message].colorize(:magenta)} - (#{parts[:time].colorize(:green)})"
  end
end

def prs
  list = `hub pr list`
  # binding.pry
  list
end

def pr_link(branch)
  `hub pr list -h $(#{branch}) --format='%sC[%i] %U'`
end

def parse
  args = ARGV
  return git_branches(limit: args[1]) if args.include?('git')
  return prs if args.include?('prs')
  puts ARGV
end

parse
