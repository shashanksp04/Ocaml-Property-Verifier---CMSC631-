# Ocaml Property Verifier 

## Project Description

This repository is dedicated to building a property-based testing framework for OCaml programs using QuickChick, a powerful testing library for Coq. The project aims to ensure that OCaml programs adhere to their executable specifications by defining properties that the programs must satisfy. A custom tool is developed to leverage QuickChick’s ability to generate extensive random inputs and execute them against the defined properties. The tool evaluates whether all tests pass or identifies counterexamples that violate the properties, enabling developers to detect and address potential issues efficiently. This project is a refactored and improved version of a program that converts OCaml file into Coq and builds on that to perform QuickChick testing. The original codebase was messy and non-functional. The main logic has been re-implemented, and the entire codebase has been refactored to ensure proper functionality.

## Logic

Given an OCaml file which serve as our starting program, we parse the file to see the input types of the target property test. If the input types are non-primitives or user-defined types, then we parse the OCaml file to get their type definitions and convert these type definitions to Coq using the coq-of-ocaml library. These coq type definitions are then used to create a Coq script which uses QuickChick to perform testing and verify if the given properties hold or not.

## Installation Process

The Project The Coq Proof Assistant, version 8.13.2 compiled with OCaml 4.13.1. Further it uses the coq-of-ocaml library primarily. In addition, it also uses core, core_unix, and qcheck which have to be installed manually.

To start with the installation process, we'll use opam - the OCaml Package Manager. Kindly note the instructions below are for WSL/Ubuntu.
```
sudo apt update
sudo apt install opam
opam init
eval $(opam env)
```
Once done with this setup, now we'll create a new environment using the "switch-create". This is done so that you can work on different versions of OCaml simulatneously by switching environments. Kindly note "4.13.1" is the ocaml version and "OcamlVerifier" is the name of our switch. You can also see it by doing "opam switch list"
```
opam switch create OcamlVerifier 4.13.1
opam switch OcamlVerifier
eval $(opam env)
```
Now we're done setting up are switch and we just need to install the various libraries
```
opam install coq
opam install qcheck
opam install core_unix
```
With this we're done with the installation process. As a check run "coqc --version" on terminal. It should show you the respective versions of coq and ocaml.


## How to Run the Program

Before running the program, make sure you're in the "lib" directory and your dune file looks the code shown below.
```
(library
 (name Example)
 (modules example))

(executable
 (name mainFile)
 (libraries core re str Example core_unix qcheck)
 (modules setup required driver files cmd mainFile)) 
```
Once done with the first step, you should run the following command on the terminal. This will create a temporary directory called "_build" in your root directory.
```
dune build
```
Now you need to create a holder ".v" file in the "_build" directory called "Example.v". The name of the file is case senstitive. Additionally, this file doesn't need to have any content before hand. Now you need to run the following command. 
```
dune exec ./mainFile.exe
```
If the above two commands are successful you won't see any errors. Now with this we're done compiling our program. An "Example_withQuickChick.v" will be created in the "_build" directory. This is our coq script. To run this file we use "coq".
```
coqc -w none ../_build/Example_withQuickChick.v
```
Now if you want to test another sample code, you need to copy the code into the "example.ml" file in the "lib" directory and accordingly change the code of the mainFile.ml. Don't change the names of the file otherwise the code won't run. 

Remember you always need to be in the "lib" directory otherwise the path of some commands would've to changed accordingly. Additionally, if you want to completely restart the compilation you should run the following command. This removes all the compiled files including the "_build" directory. Therefore to run the program again, you'll have to start from the "dune build" step again
```
dune clean
```
If you're just testing a different example then you can just do "dune build" and can reuse the Example.v file.    


## Contributing

Instructions for how to contribute to the project, if applicable.

## Acknowledgement

We would like to express our sincere gratitude to [Nikhil Kamath](https://github.com/nikhil-kamath/quickchick_ocaml) for their invaluable contributions, which served as the foundation for the development of our version of this Ocaml Program Verifier Project. Their original work provided critical insights, enabling us to build upon and adapt their ideas to suit our specific goals. We deeply appreciate their efforts, which have significantly shaped the direction and success of our endeavor.


## License

Information about the project's license.
