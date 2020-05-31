<h1 align='center'>Yet Another Java ByteCode Generator</h1>

Built using Flex & Bison to take in any java source code and emits its equivalent bytecode. This is a project developed for the PLT (**P**rogramming **L**anguage **T**ranslation) course at Faculty of Engineering, Alexandria University in Spring 2020 Offering.

<p align='center'><img src='./images/cover.png'/></p>

## Running & Testing

To run the program, use the script `run.sh` as follows:

    ./run.sh file_name
where filename, can be any file that contains java source code.

For testing purposes while development use this,

    ./run.sh --debug file_name
or

    ./run.sh -d file_name

where file_name is a file that exists in the `test-cases` folder. The extra argument will ensure we keep all our test files from the `test-cases` folder and picking the suitable unit test case for the part you're developing.

## Resources

### Understanding Flex & Bison

- [Flex & Bison by John Levine. The definitive textbok for them.](http://web.iitd.ac.in/~sumeet/flex__bison.pdf)
- [Tutorial for complete novices needing to use Flex and Bison for some real project.](https://aquamentus.com/flex_bison.html)
- [Bison Official Doumentation.](https://www.cs.auckland.ac.nz/references/gnu/bison/bison_toc.html)
