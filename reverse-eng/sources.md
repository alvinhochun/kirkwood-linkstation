Buffalo has released the source code for some of the components on
https://opensource.buffalo.jp/gpl_storage_link.html.


LS-AVL,LS-CHL-V2,LS-QVL,LS-SL,LS-VL,LS-WSXL,LS-WVL,LS-WXL, LS-XHL,LS-XL series Firmware version 1.65 or later (https://opensource.buffalo.jp/ls-x-165.html):

- u-boot version 1.1.4
- There are two editions of u-boot. The one for LS-WVL is in
  u-boot-1.1.4_kw_testwol.tar.gz
- Upstream: https://gitlab.denx.de/u-boot/u-boot/tree/U-Boot-1_1_4


    $ git clone -b U-Boot-1_1_4 --single-branch https://gitlab.denx.de/u-boot/u-boot.git

Then removed all files and extract Buffalo's source in place, then committed
the changes in 3 parts (removed/changed/new).

Uploaded to https://github.com/alvinhochun/kirkwood-linkstation-uboot.
