liball: 
	make -C main
	make -C db
	make -C dok
	make -C rpt
	make -C sif
	make -C param
	make -C razdb
	make -C exe exe 
	

cleanall:
	make -C main clean
	make -C exe clean
	make -C db clean
	make -C dok clean
	make -C rpt clean
	make -C sif clean
	make -C razdb clean
	make -C param clean

mat: cleanall liball
