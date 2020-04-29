{ stdenv
, fetchFromGitHub
, buildGoPackage
}:

buildGoPackage rec {
  name    = "terraform-provider-outscale-${version}";
  version = "0.1.0-rc8.1";
  src     = fetchFromGitHub {
    owner  = "outscale-dev";
    repo   = "terraform-provider-outscale";
    rev    = "release-0.1.0RC8.1";
    sha256 = "13m741gnqn6vdvwiqzg93qmwqx6kygzpiyzaqm3nx07mrq5mxws2";
  };

  goPackagePath = "github.com/outscale-dev/terraform-provider-outscale";
  goDeps        = ./deps.nix;

  preBuild = ''
    find -name '*.go' -o -name 'go.mod' -o -name 'go.sum' | xargs sed -i 's#github.com/terraform-providers/terraform-provider-outscale#github.com/outscale-dev/terraform-provider-outscale#g'
  '';

  postInstall = ''
    mv $bin/bin/terraform-provider-outscale{,_v${version}}
  '';

  meta = with stdenv.lib; {
    description = "Terraform provider for Outscale";
    homepage = "https://github.com/outscale-dev/terraform-provider-outscale";
    license = licenses.mpl20;
  };
}
