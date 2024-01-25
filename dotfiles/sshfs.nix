{pkgs, lib, ...}:

{
  home.packages = [
    pkgs.sshfs
  ];
  programs.zsh.shellAliases = {
    opsidianfs = "sshfs -o follow_symlinks opsidiansshfs:/home/OPsidian ~/OPsidian";
  };
}
