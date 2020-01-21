self: super:
{
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "jhaasdijk";
      repo = "st";
      rev = "master";
      sha256 = "0f1lbiprvna8l8xjqw73lj8awsswbl8fj4wgdwrx0raci2qb762h";
    };
  });
}
