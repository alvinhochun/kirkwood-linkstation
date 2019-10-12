The LS-WVL has a power switch with three positions: OFF/ON/AUTO.

On stock firmware, flipping the switch to AUTO supposedly enables a feature
allowing the LS to automatically power off when all clients are disconnected,
and be woken up when any of the clients comes online.

I suspected the AUTO position probably triggers some WOL handling routine in
uboot, which causes the poweroff/restart routine to end up in WOL standby.


Experiments
---

### Trying to enable and trigger WOL

```shell_session
# apt install
[...]
# ethtool eth0
Settings for eth0:
[...]
        Supports Wake-on: g
        Wake-on: d
[...]
```
Wake-on: d means WOL is disabled. We want to set it to "g" to enable WOL by
magic packet.

```shell_session
# ethtool -s eth0 wol g
# ethtool eth0
Settings for eth0:
[...]
        Wake-on: g
[...]
```

Flipped the switch to AUTO and poweroff.

Checking the router, the link light for the port is on. Good news?

On another system:

```shell_session
# apt install wakeonlan
[...]
# wakeonlan 4c:xx:xx:xx:xx:xx
Sending magic packet to 255.255.255.255:9 with 4c:xx:xx:xx:xx:xx
```

The LS powered on and booted right into Debian!


### Determining u-boot's behaviour of the power switch

Without disabling WOL, the power switch is moved to OFF to trigger a poweroff.

Checking the router, the link light for the port is off, which means the
network interface is not active. Tried wakeonlan just in case - the LS didn't
power on.

Flipped the switch to AUTO - the LS powered up. Logged in and powered off. Now
router link light is off again and wakeonlan doesn't do anything.

Powered on by flipping the switch to ON. Back to AUTO after that.

Logged in and check that WOL is back to disabled, then re-enable it

```shell_session
# ethtool eth0
Settings for eth0:
[...]
        Wake-on: d
[...]
# ethtool -s eth0 wol g
# ethtool eth0
Settings for eth0:
[...]
        Wake-on: g
[...]
```

Moved the power switch to OFF again to poweroff. Then back to ON. Confirm again
that WOL is off:

```shell_session
# ethtool eth0
Settings for eth0:
[...]
        Wake-on: d
[...]
```

Re-enabled WOL, left the switch at ON and reboot. After rebooting, WOL is
still enabled.

Performed an unclean shutdown by cutting the power, then reconnected it. Power
switch is still at ON position so the LS powered up immediately. Rechecked and
WOL is off.
