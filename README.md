# Adaptive construction for the SRoCS platform

This repository contains the ARGoS controllers and loop functions for investigating adaptive construction using the SRoCS platform.

## Dependencies
* [ARGoS3 (beta56 or higher)](https://www.argos-sim.info/core.php)
* [ARGoS3-SRoCS (commit #178c98c
or later)](https://github.com/allsey87/argos3-srocs)

## Compilation and installation
1. It is recommended that you uninstall older versions of ARGoS that may be installed on your system and to remove any local configuration that you may have for ARGoS as follows.

```bash
# on Linux
rm $HOME/.config/Iridia-ULB/ARGoS.conf
# on mac
defaults write info.argos-sim.ARGoS
```

2. Install ARGoS3 from the package or compile from source and install as follows:
```bash
git clone https://github.com/ilpincy/argos3.git
cd argos3
mkdir build
cd build
cmake -DARGOS_DOCUMENTATION=OFF -DCMAKE_BUILD_TYPE=Release ../src
make
sudo make install
```

3.  Compile from source and install ARGoS3-SRoCS as follows:
```bash
git clone https://github.com/allsey87/argos3-srocs.git
cd argos3-srocs
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../src
make
sudo make install
```

4. Compile the loop functions and configure the experiments
```bash
# clone this repository (and its submodules)
git clone --recursive https://github.com/allsey87/srocs-dc.git
# configure and compile
cd srocs-dc
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../src
make
```

## Running experiments
The ARGoS configuration files for running experiments are configured automatically by CMake and placed in `build/experiments`. These configuration files will be updated everytime cmake or make is executed and the input configuration (e.g., `src/experiments/srocs.argos.in`) has been modified. To this end, you may want to consider modifying `src/experiments/srocs.argos.in` instead of `build/experiments/srocs.argos` to avoid your changes being overwritten.

The Lua controllers for the experiments use behavior trees to implement a robot's behavior. Support for these behavior trees is provided by [luabt](https://github.com/allsey87/luabt). This module is cloned recursively into this repository.

In order to find the luabt module, it is recommended that you run the experiments from the same directory that the configuration file is located in. For example:

```bash
cd build/experiments
argos3 -c srocs.argos
```

