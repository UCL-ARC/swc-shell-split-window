# Software Carpentry Shell Split Window

This is a script to split window for the shell lesson.

## License

Under MIT.

## Requirement

-   [tmux](https://tmux.github.io/)

## Use

~~~
$ ./swc-shell-split-window.sh
~~~

Various environment variables affect the behaviour of the script, these are:

 * `LOG_FILE`:      The location where the log file will be stored (default: /tmp/swc-split-log-file)
 * `HISTORY_LINES`: How many lines of history to be shown (default: 5)
 * `SESSION`:       The name of the session (default: swc)
 * `BGCOLOR`:       Background colour of the session

These can be used with, e.g.:

    LOG_FILE=/tmp/log HISTORY_LINES=10 ./swc-shell-split-window.sh

## Notes

### Mouse scrolling

To enable mouse scrolling of the output edit `$HOME/.tmux.conf` to include the
line:

~~~
setw -g mouse on
~~~

### Background colours

You may wish to set the background color of a session in case you have to role
play to different people. This comes in handy if, for instance, you are teaching
about Git Conflicts.

To do so, you would want to start to sessions in separate terminal windows with,
e.g.:

      LOG_FILE=/tmp/session1 BGCOLOR=12 ./swc-shell-split-window.sh
      LOG_FILE=/tmp/session2 BGCOLOR=90 ./swc-shell-split-window.sh

You can print all the available colours using:

    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
    done

## Screenshot

![Screenshot of swc-shell-split-window](screenshot.png "Screenshot - only commands appear in top part of the shell, while instructor types in the bottom part and output is interleaved with commands")
