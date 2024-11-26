{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in with pkgs; {
          devShells.default = mkShell {
            buildInputs = [ gnumake helmfile k0sctl kubectl yamllint ];
            shellHook = ''
              export KUBECONFIG="$HOME/.kube/config"
              export PS1="╠ IAC ╣ $PS1"
              
              # -------------------------
              #  Aliases
              # -------------------------
              # Task
              alias m='make'
              alias install='make install'
              alias start='make start'
              alias update='make update'
              alias stop='make stop'
              alias uninstall='make uninstall'
              # K0s
              alias k0s='k0sctl'
              # Kubectl
              alias k='kubectl'
              alias ka='kubectl apply -f'
              alias kd='kubectl describe'
              alias kda='kubectl describe --all-namespaces'
              alias kg='kubectl get'
              alias kga='kubectl get --all-namespaces'
              alias kl='kubectl logs'
              alias kla='kubectl logs --all-namespaces'
              alias kr='kubectl delete'
              alias kra='kubectl delete --all-namespaces'
              alias ns='kubectl config set-context --current --namespace'
              alias namespace='kubectl config set-context --current --namespace'
            '';
          };
        }
      );
}