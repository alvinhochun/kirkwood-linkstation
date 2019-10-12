(This is a WIP)

Useful Defs
---

Functions for power switch and function button (search for these to find code
that reads these states):

- `bfGppInRegBitTest`: https://github.com/alvinhochun/kirkwood-linkstation-uboot/blob/52537304cd0407afdb5c5280c57304befc34c0bd/board/mv_feroceon/mv_hal/gpp/mvGpp.c#L366

    Check GPIO input pin state.

    - `BIT_PWRAUTO_SW`: Power switch in AUTO position
    - `BIT_PWR_SW`: Power switch in ON position
    - `BIT_FUNC_SW`: Function button

- `bfIsPWR_or_PWRAUTO_SignalAsserted`: https://github.com/alvinhochun/kirkwood-linkstation-uboot/blob/52537304cd0407afdb5c5280c57304befc34c0bd/board/mv_feroceon/mv_kw/kw_family/boardEnv/mvBoardEnvLib.c#L2247

    Check that power switch is either in ON or AUTO (used to detect OFF position)

Preprocessor ifdefs to pay attention to:

- `CONFIG_BUFFALO_PLATFORM`: Ignore blocks that checks for this to be un-def.

Important routines:

- `board_late_init `: https://github.com/alvinhochun/kirkwood-linkstation-uboot/blob/kirkwood-linkstation/board/mv_feroceon/mv_kw/mv_main.c#L1159

    This contains some code that probably triggers WOL standby.

- `recoveryHandle`: https://github.com/alvinhochun/kirkwood-linkstation-uboot/blob/kirkwood-linkstation/board/mv_feroceon/mv_kw/mv_main.c#L1762

    This handles recovery mode and contains some interesting code on possibly a
    USB recovery mode.

- `bfIsStartBootProcess`: https://github.com/alvinhochun/kirkwood-linkstation-uboot/blob/kirkwood-linkstation/board/mv_feroceon/mv_kw/mv_main.c#L1762

    This shows how booting with holding the function button works. It checks
    for function button held on boot, wait for button to be released, then
    count 50ms of function button held again within 60s. `bootargs_func` is
    then set to `func=1` and passed to the kernel cmdline.
