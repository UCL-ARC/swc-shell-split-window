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

## Notes

To enable mouse scrolling of the output edit `$HOME/.tmux.conf` to include the
line:

~~~
setw -g mouse on
~~~

## Screenshot

![Screenshot of swc-shell-split-window](screenshot.png "Screenshot - only commands appear in top part of the shell, while instructor types in the bottom part and output is interleaved with commands")
