self: super:
{
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.fetchFromGitHub {
      owner = "jhaasdijk";
      repo = "st";
      rev = "master";
      sha256 = "15hvh3ys60zq1x0jg2dfg1szr2pa8ishfj6f861f28sjd30qncks";
    };
  });
}
