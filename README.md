# gvim-launcher
Starts GVim instances on Windows and sends existing instances files to open.

Used to manage multiple instances of GVim from command line. With the argument `:name` mapping to
the gvim command-line `--servername name`. Use existing instances if found. Open new instances if
needed.

### Usage

Add the executable to your path ahead of the regular gvim.exe.

    gvim.exe :dev file1.txt file2.txt

