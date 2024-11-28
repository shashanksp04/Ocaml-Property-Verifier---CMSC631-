# OCaml to Coq Converter and QuickChick Tester

## Acknowledgement

We would like to express our sincere gratitude to [Nikhil Kamath](https://github.com/nikhil-kamath/quickchick_ocaml) for their invaluable contributions, which served as the foundation for the development of our version of this Ocaml Program Verifier Project. Their original work provided critical insights, enabling us to build upon and adapt their ideas to suit our specific goals. We deeply appreciate their efforts, which have significantly shaped the direction and success of our endeavor.

## Installation Process

The Project The Coq Proof Assistant, version 8.13.2 compiled with OCaml 4.13.1. Further it uses the coq-of-ocaml library primarily. In addition it also uses core, core_unix, and qcheck which have to be installed manually.

To start with the installation process, we'll use opam - the OCaml Package Manager. Kindly note the instructions below are for WSL/Ubuntu.
```code
sudo apt update
sudo apt install opam
opam init
eval $(opam env)
```
Once done with this setup, now we'll create a new environment using the "switch-create". This is done so that you can work on different versions of OCaml simulatneously by switching environments


## Logic

Description of the logic implemented in the program, focusing on the conversion of OCaml files to Coq and the QuickChick testing process.

## How to Run the Program

Instructions on how to run the program and any relevant commands.

## Project Description

This project is a refactored and improved version of a program that converts OCaml files into Coq and performs QuickChick testing. The original codebase was messy and non-functional. The main logic has been re-implemented, and the entire codebase has been refactored to ensure proper functionality.

## Features

- Conversion of OCaml files to Coq
- QuickChick testing implementation
- Improved code structure and readability

## Contributing

Instructions for how to contribute to the project, if applicable.

## License

Information about the project's license.
