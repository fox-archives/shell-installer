import os
import parseopt
import "./do.nim"
import "./util.nim"

when not isMainModule:
  echo "Not main module. Exiting"
  quit 1

proc writeHelp() =
  echo "subcommands: list, add"

proc writeVersion() =
  echo "version"

if paramCount() < 1:
  quit("Error: Expected subcommand. Exiting", errorcode = QuitFailure)

var p = initOptParser(commandLineParams())
for kind, key, val in p.getopt():
  case kind
  of cmdEnd: break
  of cmdShortOption, cmdLongOption:
      case key
      of "help", "h": writeHelp(); quit 0
      of "version", "v": writeVersion(); quit 0
  of cmdArgument:
    let dir = xdgDataDir()
    createDir(joinPath(dir, "dls"))
    createDir(joinPath(dir, "bin"))
    createDir(joinPath(dir, "completions"))

    if not dirExists(xdgDataDir()):
      createDir(xdgDataDir())

    case key:
    of "list":
      doList()
    of "add":
      if paramCount() < 2:
        quit("Error: Repository not passed as param. Exiting", QuitFailure)

      doAdd(paramStr(2))
      quit QuitSuccess
    of "remove":
      if paramCount() < 2:
        quit("Error: Repository not passed as param. Exiting", QuitFailure)

      doRemove(paramStr(2))
      quit QuitSuccess
    of "update":
      if paramCount() < 2:
        quit("Error: Repository not passed as param. Exiting")

      doUpdate(paramStr(2))
      quit QuitSuccess
    of "reshim":
      doReshim()
      quit QuitSuccess
    else:
      quit("Error: Subcommand not recognized. Exiting")
