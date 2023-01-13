self: { config, lib, pkgs, ... }:

let
  cfg = config.minidev;
in {
  options.minidev = {
    enable = lib.mkEnableOption "enable";
    enableBashIntegration = lib.mkOption { };
    enableZshIntegration = lib.mkOption { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ self.packages.x86_64-linux.default ];
    programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration (
      lib.mkAfter ''
        source "${self.packages.x86_64-linux.default}/dev.sh"
      '');
    programs.zsh.initExtra = lib.mkIf cfg.enableZshIntegration (
      lib.mkAfter ''
        source "${self.packages.x86_64-linux.default}/dev.sh"
      '');
  };
}
