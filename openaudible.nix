{ lib, appimageTools, stdenv, fetchurl, makeDesktopItem }:
let
  pname = "openaudible";
  version = "v3.7.6.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/openaudible/openaudible/releases/download/v3.7.6.2/OpenAudible_3.7.6.2_x86_64.AppImage";
    sha512 = "1k66hadkmh0iy45zwkirx2yli2v5sxr742nqmkfbc2nkcng6y9xfs9sisbxd3fbs5zcx9nsxx2qbag5lzidx8gx5n6jg56z1wgln5wi";
  };

  desktopItem = makeDesktopItem {
    name = "openaudible";
    exec = "openaudible";
    desktopName = "Open Audible";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    mkdir -p $out/bin $out/share/${pname}/applications $out/share/${pname}/resources

    cp ${appimageContents}/openaudible_gtk_x86_64.jar $out/share/${pname}/resources/openaudible.jar

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/icons/512x512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec="run.sh"  %U' 'Exec=${pname}'

  '';

  meta = with lib; {
    description = "Open Audible";
    platforms = [ "x86_64-linux" ];

  };
}