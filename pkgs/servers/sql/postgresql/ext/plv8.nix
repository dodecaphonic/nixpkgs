{ stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
  name = "plv8-${version}";
  version = "2.3.8";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "0hrmn1zzzdf52zwldg6axv57p0f3b279l9s8lbpijcv60fqrzx16";
  };

  makeFlags = [ "--makefile=Makefile.shared" ];

  preConfigure = ''
    patchShebangs ./generate_upgrade.sh
  '';

  buildPhase = "make -f Makefile.shared all";

  installPhase = ''
    mkdir -p $out/bin
    install -D plv8*.so                                        -t $out/lib
    install -D {plls,plcoffee,plv8}{--${version}.sql,.control} -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "PL/v8 - A Procedural Language in JavaScript powered by V8";
    homepage = https://pgxn.org/dist/plv8/;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
    license = licenses.postgresql;
  };
}
