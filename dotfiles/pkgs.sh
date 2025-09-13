set -euo pipefail

print_help() {
  echo "Usage: pkgs package1 package2 ... [options]"
  echo "  Simple wrapper that runs either nix run or shell with the specified package(s)."
  echo "  Prepends a channel (nixpkgs unless specified otherwise) to the specified package(s),"
  echo "  for example, unzip would become nixpkgs#unzip, if the package contains #, no channel will be prefixed,"
  echo "  if multiple packages are found, shell instead of run will be used."
  echo "Options:"
  echo "  -i, --input,    Specify an absolute input for all packages."
  echo "  -c, --channel,  Same as above but shorthand, unstable will become nixpkgs-unstable."
  echo "  -s, --shell,    Add the packages to your shell instead of running them."
  echo "  --,             Passes all arguments left to the nix command."
}

if [[ "$#" -eq 0 ]]; then
  print_help
  exit 1
fi
while [ "$#" -gt 0 ]; do
  arg="$1"
  case "$arg" in
    "-h" | "--help")
      print_help 
      exit 1;;
    "-c" | "--channel")
      channel="nixpkgs-$2"
      shift 2;;
    "-i" | "--input")
      channel="$2"
      shift 2;;
    "-s" | "--shell")
      verb="shell"
      shift;;
    "--")
      shift
      extra=("$@")
      break;;
    *)
      packages+=("$arg")
      shift;;
  esac
done

if  [[ -z "${packages+x}" ]]; then
  echo "Not enough packages, must specify at least one."
  exit 1
fi
# Set verb if it hasn't been set
if [[ -z "${verb+x}" ]]; then
  if [[ ${#packages[@]} -gt 1 ]]; then
    verb="shell"
  else
    verb="run"
  fi
fi

if [[ -z "${channel+x}" ]]; then
  channel="nixpkgs"
fi

for ((i=0; i<${#packages[@]}; i++)); do
  package="${packages[$i]}"
  if [[ "$package" == *"#"* ]]; then
    continue
  fi
  packages[i]="$channel#$package"
done

if [[ -z "${NIXPKGS_ALLOW_UNFREE+x}" ]]; then
  export NIXPKGS_ALLOW_UNFREE=1
fi
#Read by p10k
export IN_NIX_SHELL="impure"

NIXPKGS_ALLOW_UNFREE=1 nix "$verb" "${packages[@]}" "${extra[@]}" --impure
