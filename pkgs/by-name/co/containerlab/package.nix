{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "containerlab";
  version = "0.64.0";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    rev = "v${version}";
    hash = "sha256-ijqylVQKt7N3rc+HVc34XfU3LMXAtn+mhVWIzZZIikw=";
  };

  vendorHash = "sha256-9p4J9qkIQCubn3W4b3qNHfq1M2kMiqG0eGFaBxGdrAk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/srl-labs/containerlab/cmd.version=${version}"
    "-X github.com/srl-labs/containerlab/cmd.commit=${src.rev}"
    "-X github.com/srl-labs/containerlab/cmd.date=1970-01-01T00:00:00Z"
  ];

  preCheck = ''
    # Fix failed TestLabelsInit test
    export USER="runner"
  '';

  postInstall = ''
    local INSTALL="$out/bin/containerlab"
    installShellCompletion --cmd containerlab \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  meta = {
    description = "Container-based networking lab";
    homepage = "https://containerlab.dev/";
    changelog = "https://github.com/srl-labs/containerlab/releases/tag/${src.rev}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "containerlab";
  };
}
