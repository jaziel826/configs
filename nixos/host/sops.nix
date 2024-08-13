{ inputs, config, ...}:
{
  imports = [
    inputs.sops-nix.nixos.nixos.Modules.sops
];
  sops = {
   
    defultSopsFile = ../scerets.yaml;
    validateSopsFile = false;
    age = {
      # automatically import host SSH key
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;

    secrets = {
    tailscale-auth = {};
      };
    };
  };
}
