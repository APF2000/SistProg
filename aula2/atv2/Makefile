SHELL=/bin/bash

# Este Makefile contém 4 regras, descritas abaixo.

groceries.txt : fruits.txt vegetables.txt
	echo -e "Fruits:\n" > groceries.txt
	cat fruits.txt >> groceries.txt
	echo -e "\nVegetables:\n" >> groceries.txt
	cat vegetables.txt >> groceries.txt

fruits.txt vegetables.txt:
	echo "Please create the file $@"

clean:
	rm -f groceries.txt

print : groceries.txt
	cat groceries.txt

