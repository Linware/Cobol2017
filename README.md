# Cobol2017
	Programas simples utilizando cobol.
  
	Sino se dispone de un copilador/IDE en el pc puede utiltizar el siguiente copilador online:
	https://www.tutorialspoint.com/compile_cobol_online.php
	
	Algunos de los códigos que trabajan con ficheros son optimizables,
	devido a que el copilador online y rm/cobol no acepta ficheros i/o.
	
	CSV_SIMPLETXT:  -Convierte un fichero csv a un fichero de texto line-sequencial.
			-Elimina el delimitador, en este caso la ','.
			-Utiliza SORT para ordenar los registros.
			-Elimina repeticiones y muestra numero de repeticiones.	
			-Crea el informe en un documento .txt , pudiendo cambiar el formato en la input-ouput section.
	
	SIMPLETXT-XML:	-Utilizando el informe generado en el CSV_SIMPLETXT, convertimos el texto a formato xml simple.
			-Se podria utilizar este proceso para grandes cantidades de datos.
			-Con poca modificacíon creariamos elementos raiz.
			
	
