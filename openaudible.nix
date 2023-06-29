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
  version = "v3.7.6.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/openaudible/openaudible/releases/download/v3.7.6.2/OpenAudible_3.7.6.2_x86_64.AppImage";
    sha512 = "1k66hadkmh0iy45zwkirx2yli2v5sxr742nqmkfbc2nkcng6y9xfs9sisbxd3fbs5zcx9nsxx2qbag5lzidx8gx5n6jg56z1wgln5wi";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };

  appContents = runCommand "appContents" {
    buildInputs = [  ];
  } ''
    mkdir -p $out/bin $out/share/${pname}/applications $out/share/${pname}/resources
    cp ${appimageContents}/openaudible_gtk_x86_64.jar $out/share/${pname}/resources/openaudible.jar
  '';

  runScript = writeShellScriptBin pname ''
    ${jdk}/bin/java -jar ${appContents}/share/openaudible/resources/openaudible.jar
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "openaudible";
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