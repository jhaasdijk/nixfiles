{ ... }:

{
  security.sudo.extraConfig = ''
    Defaults    lecture = always
    Defaults    lecture_file = /run/current-system/etc/sudo_lecture
  '';

  environment.etc."sudo_lecture" = {
    text = ''
           "Bee" careful    __
             with sudo!    // \
                           \\_/ //
         '''-.._.-'''-.._.. -(||)(')
                           ''''
    '';
    mode = "444";
  };
}
