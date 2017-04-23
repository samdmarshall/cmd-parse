import os
import influx
import tables
import strutils
import parseopt2

var database_name = ""
for kind, key, value in getopt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "database", "d":
      database_name = value
    else:
      discard
  else:
    discard

try:
  
  let input = readline(stdin)
  let args = parseCmdLine(input)
  if database_name.len > 0:
    let command = args[args.low()]
    let args_array = args[1..args.high()]
    let arguments = args_array.join(" ")
    
    let influxdb = InfluxDB(protocol: HTTP, host: "localhost", port: 8086)
    
    let values = @{
      "command": command,
      "arg_count": $len(args_array),
      "arguments": arguments,
      "location": getEnv("PWD"),
    }.toTable
    let write_data = LineProtocol(measurement: "cmd_hist", fields: values)
    
    discard influxdb.write("fish_history", @[write_data])
except:
  discard
