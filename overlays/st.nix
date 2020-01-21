self: super:
{
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "jhaasdijk";
      repo = "st";
      rev = "master";
      sha256 = "0gbv8s2l8h8vysr6200dk69f06lwaa5z5c3cxdxc2icpldylq2sy";
    };
  });
}
