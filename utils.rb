require 'pry'
require 'colorize'

def git_branches(limit: nil)
  branches_alias = 'git branch --sort=-committerdate --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - [%(color:red)%(objectname:short)%(color:reset)] - %(contents:subject) - (%(color:green)%(committerdate:relative)%(color:reset))"'
  results = `#{branches_alias}`.split("\n")
  parts_regex = /(?<branch>(\* |  )[a-z0-9\-]+) \- \[(?<commit>[a-z0-9]+)\] \- (?<message>[a-z0-9 \-,'\.\s\?\(\)#_\/\:"\[>\]]+) \- \((?<time>[a-z0-9 ]+)\)/i
  # binding.pry
  results.first(limit.nil? ? results.size : limit.to_i).each do |res|
    parts = res.match(parts_regex)
    branch_text = parts[:branch][2..parts[:branch].size]
    curr_branch = parts[:branch].match?(/^\* /)
    branch_text_colorized = curr_branch ? branch_text.colorize(:light_blue) : branch_text.colorize(:yellow)
    puts "#{branch_text_colorized} - [#{parts[:commit].colorize(:red)}] - #{parts[:message].colorize(:magenta)} - (#{parts[:time].colorize(:green)})"
  end
end

def release_notes(url)
  hashes = url.split('/').last.split('...').join('..')
  parts_regex = /(?<commit>[a-z0-9]+) (?<message>[a-z0-9 \-,'\.\s\?\(\)#_\/\:"\[>\]]+)/i
  pivotal_regex = /\[#(?<tracker_id>\d{9})\]/
  pr_regex = /\(#(?<pr_id>\d{3,5})\)/
  repo_url = `git config --get remote.origin.url`.split('.git').first
  results = `git log #{hashes} --oneline`.split("\n")
  output = []
  results.each do |result|
    # pivotal URL
    pivotal = result.match(pivotal_regex)
    tracker_id = pivotal[:tracker_id] if pivotal
    ticket_url = "https://www.pivotaltracker.com/story/show/#{tracker_id}" if tracker_id
    # PR URL
    pr_match = result.match(pr_regex)
    pr_id = pr_match[:pr_id] if pr_match
    pr_url = "#{repo_url}/pull/#{pr_id}" if pr_id
    # ticket name
    parts_match = result.match(parts_regex)
    message = parts_match[:message] if parts_match
    message = message.gsub("[\##{tracker_id}]", '') if tracker_id
    message = message.gsub("(\##{pr_id})", '') if pr_id
    message = message.strip
    output << [message, ticket_url, pr_url]
  end
  puts "*Release notes for #{Time.now.strftime('%b %-d, %Y %I:%M%P')}*"
  puts "*Diff URL:* #{url}"
  output.each do |row|
    puts "#{row[0]}\n#{row[1]}\t#{row[2]}\n\n"
  end
  # puts result
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
  return release_notes(args[1]) if args.include?('release-notes')
  return git_branches(limit: args[1]) if args.include?('git')
  return prs if args.include?('prs')
  puts ARGV
end

parse
