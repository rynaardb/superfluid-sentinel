let
  pkgs = import <nixpkgs> {};
  dockerTools = pkgs.dockerTools;
in
rec {

  nodeFromDockerHub = dockerTools.pullImage {
    imageName = "node";
    imageDigest = "sha256:43b162893518666b4a08d95dae49153f22a5dba85c229f8b0b8113b609000bc2";
    sha256 = "f386d5ab570ff0dd6ac6e5b3fe86edb23a9f9aa7333d4fc3d05ee443df9e32d4";
    finalImageTag = "16-alpine";
  };
  customImage = dockerTools.buildImage {
    name = "sentinel";
    tag = "latest";
    fromImage = nodeFromDockerHub;
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" ];
      paths = [
        pkgs.gpp
        pkgs.python3
        pkgs.tini
      ];
    };
    config = {
      Cmd = [ "node" "main.js" ];
      runAsRoot = ''
        #!${pkgs.runtimeShell}
        ${pkgs.dockerTools.shadowSetup}
        groupadd -r node
        useradd -r -g node node
        mkdir /app/data && chown node:node /app/data
      '';
      Entrypoint = [ "/bin/tini" "--" ];
      Env = [ "NODE_ENV=production" ];
      WorkingDir = "/app";
    };
  };
}