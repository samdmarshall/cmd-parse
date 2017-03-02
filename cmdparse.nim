import os
import strutils
import parseopt2
import httpclient

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
    let arguments = args[1..args.high()].join(" ")
    let body = "cmd_hist command=\"" & command & "\",arguments=\"" & arguments & "\",location=\"" & getEnv("PWD") & "\""
    var client = newHttpClient()
    discard client.postContent("http://localhost:8086/write?db=" & database_name, body)
except:
  discard
