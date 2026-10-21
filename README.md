# Dell Inspiron 16 5645 Fan Control

Simple bash scripts to control the fan on a Dell Inspiron 16 5645 (AMD 8840U).

## Use at your own risk
I have to put this in here, as I don't want to get blamed for anything that goes wrong with your laptop. These scripts write directly to EC's fan control registers. I have been using these scripts on my Dell Inspiron 16 5645, and haven't encountered any issues.

## Test using the standalone bash script

A simple bash script exists in the `standalone-script` directory. This can be used if you just want to control the Inspiron 16 5645's fan without installing a systemd service and daemon etc...


    $ curl -fsSL https://raw.githubusercontent.com/syddel/inspiron-5645-fan/main/standalone-script/fan -o fan
    $ chmod ./fan
    $ ./fan status
    $ ./fan 255
    $ ./fan status
    $ ./fan auto

## Installing the systemd managed daemon version

If you've tried out the standalone bash script and you like what you see (i.e. your laptop didn't overheat and catch fire), then you can install the systemd managed daemon:

    $ git clone https://github.com/syddel/inspiron-5645-fan.git
    $ cd inspiron-5645-fan/systemd-daemon
    $ sudo make install

When you install, the following files will be copied to the following directories:

|Filename| Directory  |
|--|--|
| `fan` | `/usr/local/bin` |
| `fan-control-daemon` | `/usr/local/bin` |
| `fan-watch.sh` | `/usr/local/bin` |
| `fan-control.service` | `/etc/systemd/system` |

### Testing it worked

    $ fan status
    $ fan 255
    $ fan auto

## Uninstalling

    sudo make uninstall
