{ clangStdenv, fetchurl, llvm, openssl, bundlerEnv, ruby, git, which, locale
, glibcLocales, perl }:

let
  env = bundlerEnv {
    name = "rubinius-env";
    inherit ruby;

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in clangStdenv.mkDerivation rec {
  name = "rubinius-${version}";
  version = "4.3";

  src = fetchurl {
    url = "https://github.com/rubinius/rubinius/releases/download/v${version}/${name}.tar.bz2";
    sha512 = "1lhpizbjz7yxnna2fvx9lvlfl5dh23qrcq896438jlcvrs3adzqh34avd623f231mkk7njf47c5zmdlvbx6qzglg8w5zj6554akw0r7";
  };

  doCheck = true;

  nativeBuildInputs = [ ruby env which llvm git openssl perl ]
    ++ [(if glibcLocales != null then glibcLocales else locale)];

  patchPhase = ''
    patchShebangs .
  '';

  configurePhase = "true";

  buildPhase = ''
    mkdir -p $out
    ./build.sh --prefix=$out
  '';

  installPhase = "true";

  CXXFLAGS = "-Wno-unused-command-line-argument";
  LANG = "en_US.UTF-8";
  GEM_PATH = "${env}/${env.ruby.gemPath}";

  meta = with clangStdenv.lib; {
    description = "Rubinius is a modern language platform that supports a number of programming languages, including Ruby";
    homepage = https://github.com/rubinius/rubinius;
    license = with licenses; [ mpl20 bsd3 ];
    paltforms = platforms.linux;
  };
}
