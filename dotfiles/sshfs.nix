{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.sshfs ];
  home.shellAliases = {
    opsidianfs =
      "sshfs -o follow_symlinks opsidian:/home/OPsidian ~/OPsidian/home";
    opsidianfs-umount = "umount ~/OPsidian/home";
  };
}
