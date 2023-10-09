{
  config,
  lib,
  dream2nix,
  ...
}: let
  pyproject = lib.importTOML ../../pyproject.toml;
  buildWithSetuptools = {
    buildPythonPackage.format = "pyproject";
    mkDerivation.buildInputs = [
      config.deps.python.pkgs.setuptools
      config.deps.python.pkgs.poetry-core
    ];
  };
in rec {
  imports = [
    dream2nix.modules.dream2nix.pip
    buildWithSetuptools
  ];

  inherit (pyproject.project) name version;

  lock.invalidationData = lib.mkForce {};

  mkDerivation.src = ../..;

  buildPythonPackage.pythonImportsCheck = [
    "cashu"
  ];

  pip = {
    pypiSnapshotDate = "2023-09-19";
    requirementsList = [
      "${../..}"
    ];
  };
}
