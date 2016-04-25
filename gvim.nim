import os, osproc, streams, parsecsv, strutils, sequtils

let gvim = r"C:\Tools\Vim\vim74\gvim.exe"
let args = os.commandLineParams()
#let dir = r"C:\dev"
let dir = getCurrentDir()

proc last[T](s: seq[T]): T = s[s.high]

# Manages instances of vim.
proc serverlist(): seq[string] =
  result = @[]
  let (list, err) = execCmdEx("tasklist /FI \"IMAGENAME eq gvim.exe\" /V /NH /FO csv")
  if err != 0: return

  var p: CsvParser
  open(p, newStringStream(list), "")
  while readRow(p):
    result.add p.row[8].split('-').last.strip

proc options(args: seq[string]): seq[string] =
  let list = serverlist()
  var
    server = ""
    options, files: seq[string] = @[]
  for arg in items(args):
    case arg[0]:
      of ':': server = arg.toUpper[1..arg.high]
      of '-': options.add(arg)
      else:   files.add(arg)
  
  if server == "":
    server = if list.len > 0: list[0] else: "GVIM"

  # Add the server to the argument list
  options.add("--servername");
  options.add(server);
  options.add if list.contains(server): "--remote-silent" else: "--"

  # Join arguments into a single sequence
  concat(options, files)

discard startProcess(gvim, dir, options(args))

discard """
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Aug 10 2013 14:38:33)

usage: vim [arguments] [file ..]       edit specified file(s)
   or: vim [arguments] -               read text from stdin
   or: vim [arguments] -t tag          edit file where tag is defined
   or: vim [arguments] -q [errorfile]  edit file with first error

Arguments:
   --   Only file names after this
   --literal  Don't expand wildcards
   -register  Register this gvim for OLE
   -unregister  Unregister gvim for OLE
   -g   Run using GUI (like "gvim")
   -f  or  --nofork Foreground: Don't fork when starting GUI
   -v   Vi mode (like "vi")
   -e   Ex mode (like "ex")
   -E   Improved Ex mode
   -s   Silent (batch) mode (only for "ex")
   -d   Diff mode (like "vimdiff")
   -y   Easy mode (like "evim", modeless)
   -R   Readonly mode (like "view")
   -Z   Restricted mode (like "rvim")
   -m   Modifications (writing files) not allowed
   -M   Modifications in text not allowed
   -b   Binary mode
   -l   Lisp mode
   -C   Compatible with Vi: 'compatible'
   -N   Not fully Vi compatible: 'nocompatible'
   -V[N][fname]  Be verbose [level N] [log messages to fname]
   -D   Debugging mode
   -n   No swap file, use memory only
   -r   List swap files and exit
   -r (with file name) Recover crashed session
   -L   Same as -r
   -A   start in Arabic mode
   -H   Start in Hebrew mode
   -F   Start in Farsi mode
   -T <terminal> Set terminal type to <terminal>
   -u <vimrc>  Use <vimrc> instead of any .vimrc
   -U <gvimrc>  Use <gvimrc> instead of any .gvimrc
   --noplugin  Don't load plugin scripts
   -p[N]  Open N tab pages (default: one for each file)
   -o[N]  Open N windows (default: one for each file)
   -O[N]  Like -o but split vertically
   +   Start at end of file
   +<lnum>  Start at line <lnum>
   --cmd <command> Execute <command> before loading any vimrc file
   -c <command>  Execute <command> after loading the first file
   -S <session>  Source file <session> after loading the first file
   -s <scriptin> Read Normal mode commands from file <scriptin>
   -w <scriptout> Append all typed commands to file <scriptout>
   -W <scriptout> Write all typed commands to file <scriptout>
   -x   Edit encrypted files
   --remote <files> Edit <files> in a Vim server if possible
   --remote-silent <files>  Same, don't complain if there is no server
   --remote-wait <files>  As --remote but wait for files to have been edited
   --remote-wait-silent <files>  Same, don't complain if there is no server
   --remote-tab[-wait][-silent] <files>  As --remote but use tab page per file
   --remote-send <keys> Send <keys> to a Vim server and exit
   --remote-expr <expr> Evaluate <expr> in a Vim server and print result
   --serverlist  List available Vim server names and exit
   --servername <name> Send to/become the Vim server <name>
   --startuptime <file> Write startup timing messages to <file>
   -i <viminfo>  Use <viminfo> instead of .viminfo
   -h  or  --help Print Help (this message) and exit
   --version  Print version information and exit
   -P <parent title> Open Vim inside parent application
   --windowid <HWND> Open Vim inside another win32 widget
"""
