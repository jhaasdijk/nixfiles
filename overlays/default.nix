self: super:
{
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "jhaasdijk";
      repo = "st";
      rev = "master";
      sha256 = "0gppx93rjq475v013q49hcjf80dsbr505sxx71dn227arjq0iw0v";
    };
  });
}
