+++
title = "Rename cassandra keyspace"
description = "Cassandra don't allow renaming keyspaces. This utility script will help to rename keyspaces"
keywords = []
categories = ["programming", "cassandra"]
date = "2017-09-08T11:10:50+05:30"
+++

Cassandra don't allow renaming keyspaces. In reality, need to rename a keyspace rarely happens. It happened to me only once so far. But when you need to do it, there is no easy way to do.

Cassandra gives `copy` command which can be used to copy data as CSV and import that into another keyspace. But keyspace and table schema has to be created before using `copy` command.

I have created a small utility which will use the `copy` command provided by cassandra and automate keyspace and table schema creation.

This works for small data sets. I haven't tested with really huge tables.


```ruby
require 'fileutils'
require 'tmpdir'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner =  "usage: rename_keyspace --from <current-name> --to <new-name>"

  opts.on("--from=name", "Current keyspace name") do |name|
    options[:from] = name
  end
  opts.on("--to=name", "New keyspace name") do |name|
    options[:to] = name
  end

  opts.on("--verbose", "Verbose output") do |v|
    options[:verbose] = v
  end

end.parse!

if options[:from] == nil or options[:to] == nil
  puts "from and to expected"
  exit(1)
end

dir = Dir.mktmpdir # temp working dir

from = options[:from]
to = options[:to]
keyspace_cmd_file = File.join(dir, "target_keyspace.cql")
keyspace_cmd =  `cqlsh -e "describe #{from};"`.gsub("KEYSPACE #{from}", "KEYSPACE #{to}").gsub("#{from}\.", "#{to}\.")
File.write(keyspace_cmd_file, keyspace_cmd)

puts "create keyspace: #{to} and tables"
output = `cqlsh -f #{keyspace_cmd_file}`
puts output if options[:verbose]

puts "exporting data from #{options[:from]}"
tables = `cqlsh -e "use #{options[:from]}; describe tables;"`.split(" ")
tables.each do |table|
  full_path = File.join(dir, options[:from], "#{table}.csv")
  FileUtils.mkdir_p(File.dirname(full_path))
  puts "Exporting #{options[:from]}.#{table} > #{full_path}"
  output = `cqlsh -e "copy  #{options[:from]}.#{table} to '#{full_path}'"`
  puts output if options[:verbose]

  puts "copy #{from}.#{table} to #{to}.#{table}"
  output = `cqlsh -e "copy  #{options[:to]}.#{table} from '#{full_path}'"`
  puts output if options[:verbose]
end

```

Here is a [Gist](https://gist.github.com/navaneeth/627e03a36b359c9e2440716d47c0a32d) on Github.


To rename keyspace `keyspace1` to `keyspace2`:

```shell
./ rename_keyspace.rb --from keyspace1 --to keyspace2
```

This utility will look at the structure of `keyspace1` and create `keyspace2` with the same structure, replication strategy and table schema. It will move data from all tables to the new keyspace.

This script won't delete the old keyspace for safety reasons.