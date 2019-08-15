{ ... }:
{
  nixpkgs.config.packageOverrides = pkgs: rec {

    # This repo includes my (custom) patches and config
    st = pkgs.st.overrideAttrs (oldAttrs: rec {
      src = pkgs.fetchFromGitHub {
        owner = "jhaasdijk";
        repo = "st";
        rev = "master";
        sha256 = "0gppx93rjq475v013q49hcjf80dsbr505sxx71dn227arjq0iw0v";
      };
    });

  };
}
