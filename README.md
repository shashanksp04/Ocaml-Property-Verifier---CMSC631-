# Ocaml Property Verifier 

## Project Description

This repository is dedicated to building a property-based testing framework for OCaml programs using QuickChick, a powerful testing library for Coq. The project aims to ensure that OCaml programs adhere to their executable specifications by defining properties that the programs must satisfy. A custom tool is developed to leverage QuickChick’s ability to generate extensive random inputs and execute them against the defined properties. The tool evaluates whether all tests pass or identifies counterexamples that violate the properties, enabling developers to detect and address potential issues efficiently. This project is a refactored and improved version of a program that converts OCaml file into Coq and builds on that to perform QuickChick testing. The original codebase was messy and non-functional. The main logic has been re-implemented, and the entire codebase has been refactored to ensure proper functionality.

---

## Logic

Given an OCaml file which serve as our starting program, we parse the file to see the input types of the target property test. If the input types are non-primitives or user-defined types, then we parse the OCaml file to get their type definitions and convert these type definitions to Coq using the coq-of-ocaml library. These coq type definitions are then used to create a Coq script which uses QuickChick to perform testing and verify if the given properties hold or not.

---

## Installation

The project requires the following tools and libraries:

- **Coq Proof Assistant** (version 8.13.2)
- **OCaml** (version 4.13.1)
- **coq-of-ocaml** library
- Additional OCaml libraries: `core`, `core_unix`, and `qcheck`

### Step 1: Install OPAM
Install the OCaml package manager, OPAM, and initialize it:
```bash
sudo apt update
sudo apt install opam
opam init
eval $(opam env)
```

### Step 2: Create a Custom OPAM Switch
Set up a custom environment for OCaml 4.13.1 to avoid conflicts with other projects:
```bash
opam switch create OcamlVerifier 4.13.1
opam switch OcamlVerifier
eval $(opam env)
```

### Step 3: Install Dependencies
Install the required libraries:
```bash
opam install coq
opam install qcheck
opam install core_unix
```

Verify the installation by running:
```bash
coqc --version
```
You should see the Coq and OCaml versions as specified.

---

## Running the program

### Step 1: Configure the Dune File
Ensure the `dune` file in the `lib` directory contains the following configuration:
```lisp
(library
 (name Example)
 (modules example))

(executable
 (name mainFile)
 (libraries core re str Example core_unix qcheck)
 (modules setup required driver files cmd mainFile)) 
```

### Step 2: Build the Project
Run the following command to build the project. This creates a `_build` directory:
```bash
dune build
```

### Step 3: Create a Placeholder File
In the `_build` directory, create an empty `.v` file named `Example.v`. This serves as a placeholder for the generated Coq script.

### Step 4: Execute the Program
Run the main executable to generate the Coq script:
```bash
dune exec ./mainFile.exe
```

If successful, the script `Example_withQuickChick.v` will be generated in the `_build` directory.

### Step 5: Test with Coq
Run the generated Coq script using:
```bash
coqc -w none ../_build/Example_withQuickChick.v
```

### Testing with a New Example
1. Replace the content of `example.ml` in the `lib` directory with your new OCaml code.  
2. Update `mainFile.ml` as needed to accommodate the new example.  
3. Rebuild the project:
   ```bash
   dune build
   ```
4. Reuse the placeholder `Example.v` file and proceed as before.

### Clean Compilation
To start fresh and remove all compiled files:
```bash
dune clean
```

You will need to rebuild the project starting from `dune build`.  

You can also watch the first 3 minutes of this [tutorial video]() for help.

---

## Contributing

Instructions for how to contribute to the project, if applicable.

---

## Acknowledgement

We would like to express our sincere gratitude to [Nikhil Kamath](https://github.com/nikhil-kamath/quickchick_ocaml) for their invaluable contributions, which served as the foundation for the development of our version of this Ocaml Program Verifier Project. Their original work provided critical insights, enabling us to build upon and adapt their ideas to suit our specific goals. We deeply appreciate their efforts, which have significantly shaped the direction and success of our endeavor.

---

## Contact

For any questions or inquiries, please contact [Shashank](https://github.com/shashanksp04) and [Grace](https://github.com/gracek7689).

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
