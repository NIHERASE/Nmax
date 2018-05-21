# Nmax

[![Build Status](https://travis-ci.org/NIHERASE/Nmax.svg?branch=master)](https://travis-ci.org/NIHERASE/Nmax)

This is a test project I've done for an interview at [Fun-box](https://fun-box.ru).

## The task

Create a script that performs the following:
* reads text data from the input stream;
* when the stream ends, it outputs `n` of the greatest numbers found in the stream.

Additional conditions:
* any uninterrupted sequence of **digits** is a number;
* there are no numbers that are more than 1000 digits long;
* `n` is the only argument of the script;
* the script should be covered by tests;
* the script should be set up as a `gem` (providing the executable `nmax`);
* integration with Travis CI is a plus.

## Highlights of my solution

* An implementation of the Red–black tree was used to keep track of the current greatest integers: [RBTree](https://www.rubydoc.info/gems/rbtree/0.4.2).
* Numbers are kept as strings, so time is not wasted on conversion.
* Subroutine that reads chunks from the input and splits them into numbers uses IoC.

## Install

```bash
git clone git@github.com:NIHERASE/Nmax.git && cd Nmax
bundle install
rake install
```

## Run

```bash
cat sample_data_40GB.txt | nmax 10000
```
