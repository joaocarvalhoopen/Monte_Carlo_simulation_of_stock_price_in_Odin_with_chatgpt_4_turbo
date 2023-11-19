# Monte Carlo simulation of stock price in Odin with chatgpt 4 turbo
A simple experiment in what is the current state of the Odin programming language in chatgpt.

## The problem
In the previous version of chatgpt 4 normal, without turbo, the Odin language was really badly served, and in turbo it is really better served by adding this two files and by complementing, one simple program part (parse f64 from string) by telling it to go online search for the response.

## Description
How to use chatgpt to program in Odin a Monte Carlo simulation of the GOOG stock closing price from a yahoo finance .csv file of 5 years period, from the beginning to last day of the file. So we can compare the simulated price with the real price. The trick was to ask chatgpt 4 turbo to read the overview manual of odin renamed as a overview.txt instead of overview.md and the renamed demo.txt instead of demo.odin, and then ask chatgpt to write it along several responses, and then I had to manually add the package main, and some imports, and the main function, that it lacked. I also had to manually add the line to remove the header line. And corrected little errors like ```i++ -> i += 1```. The result is really nice. This tells as the current state of chatgpt 4 turbo in respect to Odin, and is a really big step up from what it could do in chatgpt 4.

## The links for the files are
* ```overview.md```, renamed as ```overview.txt```:
  [https://github.com/odin-lang/odin-lang.org/blob/master/content/docs/overview.md](https://github.com/odin-lang/odin-lang.org/blob/master/content/docs/overview.md)
* ```demo.odin```, renamed as ```demo.txt```:
  [https://github.com/odin-lang/Odin/blob/master/examples/demo/demo.odin](https://github.com/odin-lang/Odin/blob/master/examples/demo/demo.odin)

## The question to chatgpt 4 turbo

```
Given files overview.md as overview.txt and demo.odin as demo.txt.

What I asked chatgpt to do:

Having read this two files one with the manual of odin and other with the demo
code examples of odin programming language, write a program that makes a
monte carlo simulation of the GOOG stock closing price from a yahoo finance
.csv file of 5 years period, from the beginning to that day in the next five
responses.
```

## The output of the execution of the file

```
Result:

(base) joaocarvalho@soundofsilence:~/src_odin_chatgpt> make run
./stock_monte_carlo.exe
Monte Carlo Simulation Summary:
SummaryStats{mean = 130.972, median = 99.487, percentile_25 = 61.349, percentile_75 = 163.939}
GOOG price: 130.370
```

## License
MIT Open Source License

## Have fun
Best regards, <br>
Joao Carvalho <br>


