{ pkgs ? import <nixpkgs> {} }:

let
  arch_table = {
    "x86_64-linux" = "linux_amd64";
    "x86_64-darwin" = "darwin_amd64";
  };

  sha_table = {
    "x86_64-linux" =
      "1b8iqlbimaqvj3dlfy7jrfqjsqx4jnjgxgcxvax258v2mr2qvyfv";
    "x86_64-darwin" =
      "13vlahy2axlcls5wkngx69cl68jd36bp5igdaxadgpn0dgp15frh";
  };

  arch = arch_table.${pkgs.stdenv.system};
  sha = sha_table.${pkgs.stdenv.system};
in pkgs.stdenv.mkDerivation rec {
  name    = "terraform-provider-osc-0.8.0";
  src     = pkgs.fetchurl {
    url    = "https://github.com/remijouannet/terraform-provider-osc/releases/download/v0.8.0/terraform-provider-osc_${arch}_v0.8.0.zip";
    sha256 = sha;
  };
  phases  = ["installPhase" "patchPhase"];

  buildInputs = [ pkgs.unzip ];

  installPhase = ''
    unzip -x $src
    mkdir -p $out/bin
    cp terraform-provider-osc_${arch}_v0.8.0/terraform-provider-osc_v0.8.0 $out/bin/terraform-provider-osc_v0.8.0
    chmod +x $out/bin/terraform-provider-osc_v0.8.0
  '';

  meta = with pkgs.stdenv.lib; {
    description = "Terraform provider for Outscale (unofficial)";
    homepage = "https://github.com/remijouannet/terraform-provider-osc";
    license = licenses.mpl20;
  };
}
