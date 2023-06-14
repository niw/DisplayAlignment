DisplayAlignment
================

NAME
----

`display-alignment` -- A simple command line tool to align displays on macOS.

SYNOPSIS
--------

```
display-alignment subcommand [argument, options...]
```

DESCRIPTION
-----------

`display-alignment` is a simple command line tool that list, position and
align displays on macOS.

The following subcommands are available.

### `list`

List all displays and its id, position and size.
Leading `*` indicates the primary display.

### `position [options...]`

Position a single display. Following options are required.

- `-i, --id [value]` Display ID. Use `list` to find it.
- `-x [value]` Horizontal position.
- `-y [value]` Vertical position.

### `align [alignment]`

Align all displays.
Following alignment are available.

- `top`
- `middle`
- `bottom`
- `leading`
- `center`
- `trailing`

> **NOTE** All displays need to be lay outed in meaningful direction
before running this command.
For example, if all displays are lay outed horizontally, `top`,
`middle`, and `bottom` works as expected.
If not, the result is unknown.

USAGE
-----

It requires macOS 11.0 and later.
Install the latest Xcode and build `display-alignment` by using `swift build` command.

```
$ swift build -c release
```

This `swift build` should create `display-aligment` in `.build/release`.

EXAMPLES
--------

There a MacBook Pro with a Studio Display, which is used as a primary display.
When it's aligned by `middle`, the non-primary display is aligned to the middle of the primary display.

```
$ display-alignment list
  id:  1, position: (x: -1728, y:     0), size: (width:  1728, height:  1117)
* id:  2, position: (x:     0, y:     0), size: (width:  2048, height:  1152)

$ display-alignment align middle

$ display-alignment list
  id:  1, position: (x: -1728, y:    17), size: (width:  1728, height:  1117)
* id:  2, position: (x:     0, y:     0), size: (width:  2048, height:  1152)
```
