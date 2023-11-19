// project_name: Monte Carlo Simulation of stock price in Odin with chatgpt 4 turbo.
// description:  How to use chatgpt to program in Odin a Monte Carlo simulation
//               of the GOOG stock closing price from a yahoo finance .csv file
//               of 5 years period, from the beginning to last day of the file.
//               So we can compare the simulated price with the real price.
//               The trick was to ask chatgpt 4 turbo to read the overview manual
//               of odin renamed as a overview.txt instead of overview.md and the
//               renamed demo.txt instead of demo.odin, and then ask chatgpt to
//               write it along several responses, and then I had to manually
//               add the package main, and some imports, and the main function,
//               that it lacked.
//               I also had to manually add the line to remove the header line.
//               And corrected little errors like i++ -> i += 1.
//               The result is really nice.
//               This tells as the current state of chatgpt 4 turbo in respect to
//               Odin, and is a really big step up from what it could do in chatgpt 4.
//
//               The links for the files are:
//               overview.md:
//                  https://github.com/odin-lang/odin-lang.org/blob/master/content/docs/overview.md
//               demo.odin:
//                  https://github.com/odin-lang/Odin/blob/master/examples/demo/demo.odin
//         
// author: João Carvalho
// date: 2023-11-19
// license: MIT Open Source License

/*
Given files overview.md as overview.txt and demo.odin as demo.txt.

What I asked chatgpt to do:

Having read this two files one with the manual of odin and other with the demo
code examples of odin programming language, write a program that makes a
monte carlo simulation of the GOOG stock closing price from a yahoo finance
.csv file of 5 years period, from the beginning to that day in the next five
responses.

*/

/*
Result:

(base) joaocarvalho@soundofsilence:~/src_odin_chatgpt> make run
./stock_monte_carlo.exe
Monte Carlo Simulation Summary:
SummaryStats{mean = 130.972, median = 99.487, percentile_25 = 61.349, percentile_75 = 163.939}
GOOG price: 130.370

*/


package main  // Line manually added.

import "core:fmt"
import "core:os"
import "core:math/rand"

import "core:strings"  // Line manually added.
import "core:math"     // Line manually added.
import "core:slice"   // Line manually added.

import "core:strconv"   // Chat found this import when I asked to find in the net how to do a parse of a f64 from a string.

main :: proc() {
    // Assuming "GOOG.csv" 5 years is in the same directory as the executable
    file_name := ".//GOOG.csv"
    file_contents, err := os.read_entire_file(file_name)
    if err != true {    // chat error err != nil  ->  err != true
        fmt.println("Error reading file:", err)
        os.exit(1)
    }
    
    historical_prices := parse_csv(string(file_contents))
    num_simulations := 1000
    // days_to_simulate := 252 // Number of trading days in a year
    days_to_simulate := len(historical_prices) // chat error 252 -> len(historical_prices)


    simulations := make([dynamic][]f64, 0, num_simulations)
    for i := 0; i < num_simulations; i += 1 {  // chat error i++ -> i += 1
        simulated_path := run_monte_carlo_simulation(historical_prices[:], days_to_simulate)  // chat error added "[:]"
        append(&simulations, simulated_path)
        // fmt.printf("simulated_path: %v", simulated_path )  // Not chat error, I added this line to see the simulated_path.
    }
    
    summary_stats := analyze_simulations(simulations)
    fmt.println("Monte Carlo Simulation Summary:")
    fmt.println(summary_stats)
    fmt.printf("GOOG price: %f\n", historical_prices[len(historical_prices)-2]) // Not chat error, I added this line to see the difference between the simulated and the read value.
}

parse_csv :: proc(contents: string) -> [dynamic]f64 { // chat error []f64 -> [dynamic]f64
    // Implementation to parse CSV data
    // Assume each line corresponds to a trading day and the last value is the closing price
    lines := strings.split(contents, "\n")       // chat ->string. -> strings. // chat error '\n' -> "\n"
    lines = lines[1:] // Remove the header line  // chat error I added this line to remove the header line.
    prices := make([dynamic]f64, 0, len(lines))  // chat error []f64 -> [dynamic]f64
    for line in lines {
        values := strings.split(line, ",")  // chat ->string. -> strings.  // chat error ',' -> ","
        closing_price, _ := string_to_float64(values[len(values)-2]) // chat error this function was remade in the end by telling the  chat to go look online, so the _ was added.
        // chat error in the previous line fior yahoo the closing price is the second to last value, so len(values)-2
        append(&prices, closing_price)
    }
    return prices
}

string_to_float64 :: proc(str: string) -> (f64, bool) {
    value, ok := strconv.parse_f64(str, nil)
    return value, ok
}

run_monte_carlo_simulation :: proc(historical_prices: []f64, days: int) -> []f64 {
    last_price := historical_prices[len(historical_prices) - 1]
    simulated_path := make([]f64, days)
    volatility := calculate_historical_volatility(historical_prices)
    
    // Initialize the first day of the simulated path
    simulated_path[0] = last_price

    // Generate the simulated path
    for i := 1; i < days; i += 1 {   // chat error i++ -> i += 1
        // daily_return := rand.normal_distribution() * volatility 
        daily_return := rand.norm_float64() * volatility        // chat error rand.normal_distribution() -> rand.norm_float64()
        simulated_path[i] = simulated_path[i-1] * (1.0 + daily_return)
    }

    return simulated_path
}


calculate_historical_volatility :: proc(historical_prices: []f64) -> f64 {
    // Placeholder for actual calculations
    log_returns := make([]f64, len(historical_prices)-1)
    for i := 0; i < len(historical_prices)-1; i += 1 {    // chat error i++ -> i += 1
        log_returns[i] = math.log(historical_prices[i+1] / historical_prices[i], math.E) // chat error added ", math.E" base parameter.
    }
    
    // Compute the standard deviation of log returns
    mean_log_return := mean(log_returns)
    variance := 0.0
    for lr in log_returns {
        variance += (lr - mean_log_return) * (lr - mean_log_return)
    }
    variance /= f64(len(log_returns) - 1)
    return math.sqrt(variance)
}

SummaryStats :: struct {
    mean: f64,
    median: f64,
    percentile_25: f64,
    percentile_75: f64,
    // ...other statistics you wish to calculate
}

analyze_simulations :: proc(simulations: [dynamic][]f64) -> SummaryStats {
    last_day_prices := make([dynamic]f64, 0, len(simulations))  // chat error []f64 -> [dynamic]f64
    for sim in simulations {
        append(&last_day_prices, sim[len(sim) - 1])
    }
    
    // Sort the array to calculate the median and percentiles
    slice.sort(last_day_prices[:]) // chat error last_day_prices -> last_day_prices[:]

    summary := SummaryStats{
        mean = mean(last_day_prices[:]),             // chat error : -> =   // chat error added "[:]"
        median = median(last_day_prices[:]),                   // chat error : -> =       // chat error added "[:]"
        percentile_25 = percentile(last_day_prices[:], 0.25),  // chat error : -> =   // chat error added "[:]"
        percentile_75 = percentile(last_day_prices[:], 0.75),  // chat error : -> =   // chat error added "[:]"
    }

    return summary
}

mean :: proc(values: []f64) -> f64 {
    sum := 0.0
    for value in values {
        sum += value
    }
    return sum / f64(len(values))
}

median :: proc(sorted_values: []f64) -> f64 {
    mid := len(sorted_values) / 2
    if len(sorted_values) % 2 != 0 {
        return sorted_values[mid]
    } else {
        return (sorted_values[mid-1] + sorted_values[mid]) / 2.0
    }
}

percentile :: proc(sorted_values: []f64, p: f64) -> f64 {
    index := int(f64(len(sorted_values)) * p)
    return sorted_values[index]
}

