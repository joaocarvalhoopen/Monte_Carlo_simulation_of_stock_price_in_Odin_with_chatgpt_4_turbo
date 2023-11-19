all:
	odin build . -out:stock_monte_carlo.exe -o:speed

clean:
	rm stock_monte_carlo.exe

run:
	./stock_monte_carlo.exe