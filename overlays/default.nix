{ ... }:

{
  
  nixpkgs.overlays = builtins.map import[ ./neovim.nix ./st.nix ];

}


