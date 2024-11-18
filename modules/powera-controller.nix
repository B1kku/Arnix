{ pkgs, ... }:
{
  hardware.steam-hardware.enable = pkgs.lib.mkForce false;
  services.udev.extraHwdb = ''
    evdev:name:BDA NSW wired controller:*
      KEYBOARD_KEY_90002=btn_c      # A
      KEYBOARD_KEY_90003=btn_east   # B
      KEYBOARD_KEY_90001=btn_west   # X
      KEYBOARD_KEY_90004=btn_south  # Y
      KEYBOARD_KEY_90005=btn_z      # L
      KEYBOARD_KEY_90006=btn_tl     # R
      KEYBOARD_KEY_90007=btn_tr     # LT
      KEYBOARD_KEY_90008=btn_tl2    # RT
      KEYBOARD_KEY_9000b=btn_start  # L Joystick
      KEYBOARD_KEY_9000c=btn_mode   # R Joystick
      KEYBOARD_KEY_9000e=btn_tr2    # Select
      KEYBOARD_KEY_9000d=btn_select # Start
  '';
}
