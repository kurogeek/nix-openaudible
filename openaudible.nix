{ lib
, appimageTools
, stdenv
, fetchurl
, makeDesktopItem
, symlinkJoin
, runCommand
, jdk
, writeShellScriptBin
}:
let
  pname = "openaudible";
  version = "3.8.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/openaudible/openaudible/releases/download/v3.8.1/OpenAudible_3.8.1_x86_64.AppImage";
    sha512 = "1bvzrfnf87av1wg51d682iq0wa49mxwbhcmpl1rcjihgldnincwadid92c74b30zfzf5acg2l283pqykjg61g4d3lgyvsp6rqyifhf4";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };

  appContents = runCommand "appContents" {
    buildInputs = [  ];
  } ''
    mkdir -p $out/bin $out/share/${pname}/applications $out/share/${pname}/resources
    
    install -m 444 -D ${appimageContents}/icons/512x512.png $out/share/icons/${pname}.png

    cp ${appimageContents}/openaudible_gtk_x86_64.jar $out/share/${pname}/resources/openaudible.jar
  '';

  runScript = writeShellScriptBin pname ''
    ${jdk}/bin/java -jar ${appContents}/share/openaudible/resources/openaudible.jar
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "openaudible";
    icon = "${appContents}/share/icons/${pname}.png";
    desktopName = "Open Audible";
    comment = "OpenAudible is a cross-platform audiobook manager designed for Audible users. Manage all your audiobooks with this easy-to-use desktop application.";
  };
in
symlinkJoin {
  name = pname;
  paths = [ desktopItem runScript ];

  meta = {
    description = "OpenAudible is a cross-platform audiobook manager designed for Audible users. Manage all your audiobooks with this easy-to-use desktop application.";
  };
}