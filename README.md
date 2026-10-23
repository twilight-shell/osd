# twilight-shell/osd

[![ci](https://github.com/twilight-shell/osd/actions/workflows/ci.yml/badge.svg)](https://github.com/twilight-shell/osd/actions/workflows/ci.yml)

The on-screen display of the [twilight-shell](https://github.com/twilight-shell)
organization: a pill that rises from the bottom edge of the screen whenever the
volume or the mute state changes, with a meter, a star riding its tip and the
number. It works on its own or as a piece of the full shell.

## Requirements

[Quickshell](https://quickshell.org) 0.3 or newer, with
[twilight-shell/core](https://github.com/twilight-shell/core) installed, and
PipeWire. It follows the default output device.

## Running on its own

```sh
qs -p /path/to/osd
```

If `Twilight.Core` is not in a directory Qt searches, point `QML_IMPORT_PATH` at
its parent directory. Change the volume (a media key, `wpctl set-volume
@DEFAULT_AUDIO_SINK@ 5%+`) to see it.

## Using it in a shell

```sh
sudo make install        # to /usr/lib/qt6/qml/Twilight/Osd
```

```qml
import Twilight.Osd

Osd { outputName: Compositor.focusedOutput }
```

| | |
|---|---|
| `outputName` | The output to show on; the first screen when empty. The osd doesn't know the compositor, so the host says which one is focused. |

The pop-up never takes input, and it stays quiet for the volume PipeWire reports
right after startup.

The colors come from `~/.config/twilight-shell/theme.toml` (see
[core](https://github.com/twilight-shell/core)).

## Contributing

Contributions are welcome: see [CONTRIBUTING.md](CONTRIBUTING.md). Agents and the like: [AGENTS.md](AGENTS.md).

## License

MIT, see `LICENSE`.
