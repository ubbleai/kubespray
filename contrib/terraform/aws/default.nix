{ pkgs ? import (
  builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/438a0cd40b2e40c0b85f6ea2eafaca094bd16bae.tar.gz";
    sha256 = "1nbc9nnlq21h2z954bhsz7jxxlknl9bn4dnl4xsjvrg4065hmbcr";
  }
) {} }:

with pkgs;

let
  terraform-provider-outscale = pkgs.callPackage ../pkgs/terraform-provider-outscale {};
  terraform-provider-osc = pkgs.callPackage ../pkgs/terraform-provider-osc {};
  terraform_0_12_24 = pkgs.terraform_0_12.overrideAttrs (oldAttrs: rec {
    name = "terraform-0.12.24";
    src = pkgs.fetchFromGitHub {
      owner  = "hashicorp";
      repo   = "terraform";
      rev    = "v0.12.24";
      sha256 = "128mrqib8rigy6kk6fby0pjh4jh2qm2qwkrlbn0wgfln0637d9ff";
    };
  });
  terraform_0_12_24_with_plugins = terraform_0_12_24.withPlugins (p: [
    terraform-provider-outscale
    terraform-provider-osc
    p.aws p.kubernetes
    p.local p.null p.random p.tls p.template
  ]);
  terraform = terraform_0_12_24_with_plugins;
in
mkShell {
  buildInputs = [
    awscli
    bats
    direnv
    git
    gnused
    ipcalc
    jq
    kops
    kubectl
    kubernetes-helm
    terraform
    zsh
  ];
}
