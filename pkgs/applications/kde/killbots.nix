{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio, libkdegames }:

mkDerivation {
  name = "killbots";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/games/org.kde.killbots";
    description = "A game where you avoid robots";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    libkdegames
    kdoctools
    ki18n
    kio
  ];
}
