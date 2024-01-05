# Assembly Algorithms :rocket:
Welcome to the Assembly Algorithms code repository where we dive into the world of assembly to implement iconic computer science algorithms in pure assembly! :computer:

## What is this repository? :mag_right:

This repository contains algorithms implemented in pure assembly language. It will be added to continuously to include more algorithms. It's designed to teach, inspire, and challenge programmers to understand and appreciate the power of assembly language - the closest form of communication we have to our underlying systems.

## Why learn assembly? :thinking:

- **Speed:** Experience the enhanced performance of code that's just a step away from binary.
- **Understanding:** Learn how higher-level constructs are built by controlling the CPU directly.
- **Appreciation:** Gain a newfound respect for compilers and high-level languages.
- **Fun:** There's a unique joy in making things work in assembly, and we're here to find it.

## Getting Started :runner:

Here's how to get started:

1. **Clone this repository:** `git clone https://github.com/LaurieWired/Assembly-Algorithms.git`
2. **Pick an algorithm:** Browse the repository and choose an algorithm to sink your teeth into.
3. **Use the default code or fill in your own version:** If you want to write your own version, simply go to the `algorithm_fillable.s` file and add your own code.
4. **Generate the executable:** Assemble the algorithm file and create the executable. For ARMv7, use the following:
```
arm-linux-gnueabi-as algorithm.s -o algorithm.o			# Update "algorithm" to the selected algorithm name
arm-linux-gnueabi-gcc -static algorithm.o -o algorithm
```
5. **Run the code:** Either run the executable directly or call `./run_algorithm.sh` to visualize the algorithm.


## Accompanying Videos :video_camera:
If you want more explanations of the algorithm, follow the accompanying video explanation on YouTube!

- **Fibonacci Sequence:** [Using recursion in assembly to compute the fibonacci sequence](https://youtu.be/rGg94EDHl6I)
