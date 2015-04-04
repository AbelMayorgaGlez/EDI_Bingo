{Unidad funcionesbingo. Contiene las funciones y procedimientos utilizados por el juego del bingo}
Unit funcionesbingo;

{Parte pública}
Interface
	Const
		MaxJugadores=4;{Para poder cambiar fácilmente el número máximo de jugadores}
	Type
		TPrimos=Array[1..90] Of Word;{El tipo de los números del bombo}
		TCarton=Array[1..3,1..5] Of Word;{El tipo de los números de un cartón}
		TCartones=Array[1..MaxJugadores]Of TCarton;{El tipo de los cartones}

	{Procedimiento que muestra el menú principal. El parámetro por variable "Elección" es donde se guarda el modo elegido}
	Procedure Menu(Var Eleccion:Byte);

	{Pide el numero de jugadores asegurandose de que  es un numero valido. El parámetro "Numero" es donde se va a guardar lo que introduzca el usuario.}
	Procedure PedirJugadores(Var Numero:Byte);

	{Pide un numero y se asegura de que esta en el rango.El parametro "Minimo" sera el numero minimo del bombo y "Modo" es el modo de juego.}
	Procedure PedirMinimo(Var Minimo:Word;Modo:Byte);

	{Genera un vector con 90 numeros primos mayores o iguales que el introducido. 
	El parametro "Primos" es un array en el que se guardaran los 90 numeros primos del bombo, "Min" es el numero mínimo y "Modo" es el modo de juego}
	Procedure GeneraBombo(Var Primos:TPrimos; Min:Word;Modo:Byte);

	{Muestra los numeros primos del bombo. "Primos" contiene los numeros del bombo"}
	Procedure MostrarBombo(Primos:TPrimos);

	{Genera cuantos cartones le pidamos. "Cuantos" es el numero de cartones. 
	"Cartones" es el array que contiene los cartones "Bombo" es el array que contiene a los numeros del bombo y "Opcion" es el modo de juego.}
	Procedure GenerarCartones(Cuantos:Byte;Var Cartones:TCartones;Bombo:TPrimos;Opcion:Byte);

	{Procedimiento que muestra todos los cartones en juego. "Cuantos" es el numero de cartones y "Cartones" es el array que contiene los cartones.}
	Procedure MostrarCartones(Cuantos:Byte;Cartones:TCartones);

	{Procedimiento que muestra la jugada en la que estamos y la bola que sale del bombo. 
	"Numero" es el numero de la jugada, "Bola" es el numero que sale del bombo, "Bombo" es el vector en el que se guardan los numeros del bombo y "Opcion" es el modo de juego.}
	Procedure AvanceJugada(Jugada:Byte;Var Bola:Word;Var Bombo:TPrimos;Opcion:Word);

	{Procedimiento que busca el numero que ha salido en los cartones. 
	"Cuantos" es el numero de jugadores, "Cartones" es el array donde se encuentran los cartones y "Numero" es el número a buscar}
	Procedure BuscarEnCartones(Cuantos:Byte; Var Cartones:TCartones;Numero:Word);

	{Función que devuelve verdadero si en algun cartón hay línea. "Cuantos" es el número de jugadores, "Cartones" es el array que contiene los cartones}
	Function ComprobarLinea(Cuantos:Byte; Cartones:TCartones):Boolean;

	{Función que devuelve verdadero si en algún cartón hay bingo. "Cuantos" es el número de jugadores, "Cartones" es el array que contiene los cartones}
	Function ComprobarBingo(Cuantos:Byte; Cartones:TCartones):Boolean;

{Parte privada}
Implementation

	Type{Lo he declarado en la parte privada porque es un tipo que utilizan los procedimientos para hacer cálculos, pero que no va a ser "utilizado" en el programa del bingo}
		TEnLinea=Array[1..15] Of Word;{El tipo de los números de un cartón todos seguidos}

{FUNCIONES Y PROCEDIMIENTOS PRIVADOS}{UTILIZADOS POR LAS FUNCIONES Y PROCEDIMIENTOS PÚBLICOS}

	{Procedimiento que ordena el bombo de números de menor a mayor por el método de selección. "Bombo" es el vector que contene los números del bombo}
	{Utilizado por el Procedimiento GeneraBombo cuando funciona en modo manual}
	Procedure OrdenarBombo(Var Bombo:TPrimos);
		Var
		        i,j:Integer;{Utilizados para recorrer el vector}
		Begin
		        For i:=Low(Bombo) To (High(Bombo)-1) Do
		                Begin
		                        For j:=i+1 To High(Bombo) Do
		                                Begin
		                                        If Bombo[j]<Bombo[i] Then
		                                                Begin {Éstas tres líneas sirven para intercambiar 2 Numeros sin utilizar una variable auxiliar}
		                                                        Bombo[j]:=Bombo[j]+Bombo[i];
		                                                        Bombo[i]:=Bombo[j]-Bombo[i];
		                                                        Bombo[j]:=Bombo[j]-Bombo[i];
		                                                End;{If}
		                                End;{For j}
		                End;{For i}
		End;

	{Procedimiento que ordena el vector de menor a mayor (tomado de la practica 4). "Vector" es el vector a ordenar, por el metodo de selección.}
	{Utilizado por el Procedimiento GenerarCarton}
        Procedure OrdenarVector(Var Vector:TEnLinea);

                Var
                        i,j:Integer;{Utilizadas para recorrer el vector}

                Begin
                        For i:=(Low(Vector)) To (High(Vector)-1) Do
                                Begin
                                        For j:=i+1 To High(Vector) Do
                                                Begin
                                                        If Vector[j]<Vector[i] Then
                                                                Begin {Éstas tres líneas sirven para intercambiar 2 Numeros sin utilizar una variable auxiliar}
                                                                        Vector[j]:=Vector[j]+Vector[i];
                                                                        Vector[i]:=Vector[j]-Vector[i];
                                                                        Vector[j]:=Vector[j]-Vector[i];
                                                                End;{If}
                                                End;{For j}
                                End;{For i}
                End;
                        
        {Procedimiento que convierte un vector en una matriz ordenada por columnas (Tomado de la practica 4). 
        "Vector" es el vector de 15 elementos que contiene los datos a colocar, y "Matriz" es el cartón donde los guardaremos.}
	{Se utiliza en el procedimiento GenerarCarton}
        Procedure VectorAMatriz(Vector:TEnLinea; Var Matriz:TCarton);

                Var
                        i,j:Byte;{Índices de la matriz}
			k:Byte;{Índice del vector}

                Begin
                        k:=Low(Vector);
                        i:=Low(Matriz);
                        For j:=Low(Matriz[i]) To High(Matriz[i]) Do{Recorre las columnas}
                                For i:=Low(Matriz) To High(Matriz) Do{Recorre las filas}
                                        Begin
                                                Matriz[i,j]:=Vector[k];
                                                k:=k+1;
                                        End;{For i}
                End;

	{Produce una matriz de 3x5 elementos tomados aleatoriamente del bombo. "Carton" es la matriz producida, "Bombo" es el array de donde escoger los Numeros que meter en el carton y "Opcion" es el modo de juego.}
	{Utilizado en el procedimiento GenerarCartones}
        Procedure GenerarCarton(Var Carton:TCarton;Bombo:TPrimos;Opcion,Jugador:Byte);
                Var
                        i:Byte;{Índice del vector}
			j:Byte;{Índice del bombo que se generará aleatoriamente}
                        EnLinea:TEnLinea;{Vector en el que inicialmente se guardan los Numeros del bombo}               
                Begin
			Case Opcion Of
			{Modo automático}
				0:Begin
				        i:=1;{Empezamos por el primer elemento del vector}
				        Repeat
				                Begin
				                        j:=Random(90)+1;{Genera un indice aleatorio del bombo}
				                        If Bombo[j]<>0 Then{Si lo que hay en esa posicion es 0 no hace nada}
				                                Begin
				                                        EnLinea[i]:=Bombo[j];{Copia el número del bombo al vector}
				                                        Bombo[j]:=0;{Pone un 0 en el bombo(El 0 no permanece porque el bombo no lo pasa por variable)}
				                                        i:=i+1;{Incrementa el indice del vector}
				                                End;{If}
				                End;{Repeat}
				        Until i=16;{Cuando se hayan obtenido los 15 números, sale}
				End;{Case 0}
			{Modo manual}
				1:Begin
				Writeln('Introduce los numeros del carton del jugador ', jugador);
					For i:=Low(EnLinea) To High(EnLinea) Do
						Read(EnLinea[i]);{Uno a uno manualmente}
				End;{Case 1}
			End;{Case}
                        OrdenarVector(EnLinea);{Ordena el vector generado. EnLinea está pasado por variable}
                        VectorAMatriz(EnLinea,Carton);{Lo pasa a matriz. Carton está pasado por variable}
                End;

	{Procedimiento que muestra un carton. "Matriz" es el cartón a mostrar, y "Numero" es el número de jugador}
	{Utilizado en el procedimiento MostrarCartones}
        Procedure VerCarton(Matriz:TCarton; Numero:Byte);
                Var
                        i,j:Byte;{Índices de la matriz}

                Begin
                        Writeln('El carton del jugador numero ',Numero,' es:');
                        For i:=Low(matriz) To High(matriz) Do
                                Begin
                                        For j:=Low(Matriz[i]) To High(Matriz[i]) Do
                                                If Matriz[i,j]=0 {El 0 es un Numero tachado}
                                                        Then Write('X':6) {Si en el carton hay un 0 muestra una X en su lugar}
                                                        Else Write(Matriz[i,j]:6);{Al ocupar todo 6 espacios, queda en columnas perfectamente}
                                        Writeln;{Salta de linea para escribir la siguiente fila}
                                End;{For}
                        Writeln;
                        Writeln;
                End;

	{Procedimiento que busca un Numero en un carton. "Carton" es la matriz en la que tiene que buscar el Numero, y "Numero" es el Numero a buscar.}
	{Utilizado en el procedimieto BuscarEnCartones}
        Procedure BuscarEnCarton(Var Carton:TCarton;Numero:Word);
                Var
                        i,j:Byte;{Índices de la matriz}
                        Encontrado:Boolean;
                Begin
                        Encontrado:=False;{Al principio no lo ha encontrado}
                        i:=1;{i son las columnas}
                        Repeat
				j:=Low(Carton);{j son las filas}
				Repeat					                                                	If Carton[j,i]=Numero Then
                                                Begin
                                                        Carton[j,i]:=0;{El 0 equivale al Numero tachado}
                                                        Encontrado:=True;
                                                End;{If}
					j:=j+1;{Avanzamos a la siguiente fila}
				Until Encontrado Or (j>High(Carton));{Si lo a encontrado termina ya que en un cartón no puede haber 2 veces el mismo número}
                                i:=i+1;{Avanzamos a la siguiente colummna}
                        Until Encontrado Or (i>High(Carton[j]));{Si lo a encontrado termina ya que en un cartón no puede haber 2 veces el mismo número}
                End;

	{Funcion que devuelve verdadero si en el carton dado hay linea. 
	"Carton" es la matriz en la que buscar si todos los elementos de una fila son 0, y "Jugador" es el Numero del jugador al que corresponde el carton.}
	{Utilizada en la función ComprobarLinea}
        Function LineaEnCarton(Carton:TCarton;Jugador:Byte):Boolean;
                Var
                        i,j:Byte;{Índices de la matriz}
			Linea:Boolean;
                Begin
                        i:=1;{Empezamos comprobando por la primera fila}
                        Repeat
				j:=1;{Empezamos por la primera columna}
				Repeat					
					Linea:=Carton[i,j]=0;{Si en algún momento hay un número distinto de 0, es porque no hay fila}
					j:=j+1;{Avanzamos a la siguente columna}
				Until (Not linea) Or (j>High(Carton[i]));{Si ve que en esa fila no hay línea o que j>que el numero de columnas, en cuyo caso hay línea y sale}
				i:=i+1;{Avanzamos a la siguiente fila}
                        Until Linea Or (i>High(Carton));{Sale si encuentra que hay línea o que i>que el número de filas, en cuyo caso no hay línea*}
                        If Linea Then
				Writeln('EL JUGADOR NUMERO ',Jugador,' HA CANTADO LINEA EN LA FILA ',i-1);					
                        Writeln;
			LineaEnCarton:=Linea;
                End;


	{Funcion que devuelve verdadero si en el carton dado hay Bingo. 
	"Carton" es la matriz en la que buscar si todos los elementos son 0, y "Jugador" es el Numero del jugador al que corresponde el cartón.}
	{Utilizada en la función ComprobarBingo}
	Function BingoEnCarton(Carton:TCarton;Jugador:Byte):Boolean;
		Var
			i,j:Byte;{Índices de la matriz}
			Bingo:Boolean;
		Begin
			Bingo:=True;{Si no se comprueba lo contrario, hay bingo}
			i:=1;{Empezamos por la primera fila}
			While (Bingo And (i<=High(Carton)))Do{Si comprueba que no hay bingo, se sale. Si se anula la otra condición es porque hay bingo}
				Begin
					j:=1;{Empezamos por la primera columna}
					While (Bingo And (j<=High(Carton[i]))) Do{Si comprueba que no hay bingo, se sale. Si se anula la otra condición es porque de momento, en esa línea no ha encontrado un número distinto de 0}
						Begin
							Bingo:=Not(Carton[i,j]<>0);{Si en algún momento hay un número distinto de 0 es porque no hay bingo}
							j:=j+1;{Avanzamos columna}
						End;{While}
					i:=i+1;{Avanzamos fila}
				End;{While}
			If Bingo Then				Writeln('BINGO PARA EL JUGADOR NUMERO ',jugador,'!!!');
			Writeln;
		        BingoEnCarton:=Bingo;
		End;	


{FUNCIONES Y PROCEDIMIENTOS PÚBLICOS}

	{Procedimiento que muestra el menú principal. El parámetro por variable "Elección" es donde se guarda el modo elegido}
	Procedure Menu(Var Eleccion:Byte);
		Var
			Seguro:Char;{para que no de error en tiempo de ejecución si se introduce por ejemplo una letra}
		Begin
			Writeln('Elige el modo de juego:');
			Writeln('0.Automatico');
			Writeln('1.Manual');
			Repeat{Para asegurarse que la elección es correcta}
				Readln(Seguro);
				If Not(Seguro in ['0','1']) Then Writeln ('Por favor, introduce un modo valido');
			Until Seguro in ['0','1'];
			val(Seguro,Eleccion);
		End;

	{Pide el numero de jugadores asegurandose de que  es un Numero valido. El parámetro "Numero" es donde se va a guardar lo que introduzca el usuario.}
	Procedure PedirJugadores(Var Numero:Byte);
		Var
			Seguro:char;{Para que no de error en tiempo de ejecución si se introduce una letra}
			CodError:Byte;{Para comprobar el error producido por la funcion Val}
		Begin
		        Repeat
				Repeat
		                	Write('Introduce el numero de jugadores(entre 2 y ',MaxJugadores,'):');
		                	Readln(Seguro);
					Val(Seguro,Numero,CodError);
				Until CodError=0;{Si el codigo de error es distinto de 0 es porque no se ha introducido un número}
		                If (Not (Numero in[2..Maxjugadores])) Then Writeln('Numero de jugadores incorrecto');
		        Until Numero in[2..Maxjugadores];
		        Writeln;
		End;

	{Pide un numero y se asegura de que esta en el rango.El parametro "Minimo" sera el numero minimo del bombo y "Modo" es el modo de juego.}
	Procedure PedirMinimo(Var Minimo:Word;Modo:Byte);
		Var
			NumSeguro:LongInt;{Utilizado para comprobar que el número introducido está en el rango ya que su rango es mayor. 
			Si no la utilizase, si el número introducido rebosa la capacidad del dato Word, daría la vuelta y pondría cualquier cosa}
			CarSeguro:String;{para que no de error en tiempo de ejecución si se introduce una letra}
			CodError:Byte;{Para comprobar el error producido por la funcion Val}
		Begin
			If modo=0 Then{En el modo  manual no se utiliza, por lo que en ese caso sale sin hacer nada}
			Begin
				Repeat   
					Repeat
						Write('Introduce el numero minimo que va a haber en el bombo:');
						Readln(CarSeguro);
						Val(CarSeguro,NumSeguro,CodError);
						If CodError<>0 Then Writeln('Tiene que ser un numero entero mayor que 0 y menor que 64499');
					Until CodError=0;{Si el codigo de error es distinto de 0 es porque la cadena de caracteres no es un Numero entero}
					If not((NumSeguro>=0)and(NumSeguro<=64499)) Then Writeln('El numero tiene que ser mayor que 0 y menor que 64499');
				Until (NumSeguro>=0) and (NumSeguro<=64499);
				Minimo:=NumSeguro;{Una vez que es seguro que el número está en el rango, lo copia en la variable Mínimo}
				Writeln;
			End;
		End;

	{Genera un vector con 90 numeros primos mayores o iguales que el introducido. 
	El parametro "Primos" es un array en el que se guardaran los 90 numeros primos del bombo, "Min" es el numero mínimo evaluado y "Modo" es el modo de juego}
	Procedure GeneraBombo(Var Primos:TPrimos; Min:Word;modo:Byte);
		Var
		        i:Byte;{Variable de control del modo manual}
			Divisor,Contador,Numero:Word;
		        Primo:boolean;
		Begin
			Case Modo Of
			{Modo automático}
				0:Begin
					Contador:=1;		
					While Contador<=90 Do {Cuando incluya 90 Numeros para}
						Begin
						        Primo:=True; {De momento todos son primos}
						        Divisor:=2;			
						        While (Primo) And (Divisor<Min) Do
						                Begin
						                        Primo:=Not((Min Mod Divisor)=0); {Si encuentra que no es primo deja de buscar}
						                        Divisor:=Divisor+1;
						                End;{Segundo While}			
						        If Min<Divisor Then Primo:=False; {Para evitar que incluya al 1 y al 0}
						        If Primo
						                Then
						                        Begin
						                                Primos[Contador]:=Min;
						                                Contador:=Contador+1;
						                        End;{If }	
						        Min:=Min+1;{Aumenta el Numero a evaluar}
						End;{Primer While}
				End;{Case 0}
			{Modo manual}
				1:Begin
					Writeln('Introduce los 90 numeros del bombo separados por espacios');
					For i:=Low(Primos) To High(Primos) Do
						Begin
							Read(Numero);
							Primos[i]:=Numero;
						End;{For}
					OrdenarBombo(Primos);{Primos está pasado por variable}
				End;{Case 1}
			End;{Case}
		End;

	{Muestra los numeros primos del bombo. "Primos" contiene los numeros del bombo"}
	Procedure MostrarBombo(Primos:TPrimos);
		Var
		        Contador,Fila:Byte;
		Begin
		        Writeln('Los numeros que hay en el bombo son:');
		        Contador:=1;
		        While (Contador<=90) Do{Hasta que escriba los 90 números}
		                Begin
		                        For Fila:=1 To 10 Do{Escribe 10 números, sale, salta de línea y vuelve a entrar en el bucle}
		                                Begin
		                                        Write(Primos[Contador]:6);{Ocupando 5 espacios quedan en columnas}
		                                        Contador:=Contador+1;
		                                End;{For}
		                        Writeln;
		                End;{While}
		        Writeln;
		End;

	{Genera cuantos cartones le pidamos. "Cuantos" es el numero de cartones. 
	"Cartones" es el array que contiene los cartones "Bombo" es el array que contiene a los numeros del bombo y "Opcion" es el modo de juego.}
	Procedure GenerarCartones(Cuantos:Byte;Var Cartones:TCartones;Bombo:TPrimos;Opcion:Byte);   
		Var
			i:Byte;{Es el numero del jugador del que se está creando el cartón}
		Begin
		        Randomize;{Si lo incluyo dentro del procedimiento para generar un carton, todos quedan iguales}
		        For i:=1 to Cuantos do
				GenerarCarton(Cartones[i],Bombo,Opcion,i);
		End;

	{Procedimiento que muestra todos los cartones en juego. "Cuantos" es el numero de cartones y "Cartones" es el array que contiene los cartones.}
	Procedure MostrarCartones(Cuantos:Byte;Cartones:TCartones);       
		Var
			i:Byte;{Índice de los cartones}
		Begin
		       	For i:=1 to Cuantos do
				VerCarton(Cartones[i],i);
		        Write('Pulse intro para continuar');
		        Readln;
		        Writeln;
		        Writeln;
		End;

	{Procedimiento que muestra la jugada en la que estamos y la bola que sale del bombo. 
	"Numero" es el numero de la jugada, "Bola" es el numero que sale del bombo, "Bombo" es el vector en el que se guardan los numeros del bombo y "Opcion" es el modo de juego.}
	Procedure AvanceJugada(Jugada:Byte;Var Bola:Word;Var Bombo:TPrimos;Opcion:Word);
		Var
		        i:Byte;{Será un índice aleatorio del bombo}
		        Anterior:Word;{Número que salió antes}
		Begin
		        Writeln('Numero de jugada: ',Jugada);
			Case Opcion Of
			{Modo automático}
				0:Begin
					Randomize;{Inicia el generador de números aleatorios}
					Repeat
						Anterior:=Bola;
						i:=Random(90)+1;
						If Bombo[i]<>0{Si el número es 0 es porque esa bola ya salió antes}
						        Then
						                Begin
						                        Bola:=Bombo[i];{La bola que sale del bombo}
						                        Bombo[i]:=0;{El 0 sustituye al Numero que ya ha salido}
						                End;{If}
					Until Anterior<>Bola;{Sale si la bola que ha salido es distinta de la que salio antes. 
					Si no fuese asi, en el caso de que el random diese un Numero que ya ha salido, saldria el mismo Numero en varias jugadas seguidas}
				End;{Case 0}
			{Modo manual}
				1:Begin
					Writeln('¿Que numero ha salido?');
					Read(Bola);
				End;{Case 1}
			End;{Case}
		        Writeln('El...',Bola);
		        Writeln;
		End;

	{Procedimiento que busca el numero que ha salido en los cartones. 
	"Cuantos" es el Numero de jugadores, "Cartones" es el array donde se encuentran los cartones y "Numero" es el número a buscar}
	Procedure BuscarEnCartones(Cuantos:Byte; Var Cartones:TCartones;Numero:Word);
		Var
			i:Byte;{El índice de los cartones}
		Begin
		        For i:=1 to Cuantos do
				BuscarEnCarton(Cartones[i],Numero);
		End;

	{Función que devuelve verdadero si en algun cartón hay línea. "Cuantos" es el número de jugadores, "Cartones" es el array que contiene los cartones}
	Function ComprobarLinea(Cuantos:Byte; Cartones:TCartones):Boolean;       
		Var
		        i:Byte;{Índice de los cartones}
			Linea:Boolean;
		Begin
			Linea:=False;
		        For i:=1 to Cuantos do{Comprueba todos los cartones debido a que puede haber línea en varios}
				Linea:=LineaEnCarton(Cartones[i],i) Or Linea;{Debido a la evaluación en cortocircuito, si lo pongo del revés solo comprueba hasta la primera linea cantada encontrada}
			ComprobarLinea:=Linea;
		End;

	{Función que devuelve verdadero si en algún cartón hay bingo. "Cuantos" es el número de jugadores, "Cartones" es el array que contiene los cartones}
	Function ComprobarBingo(Cuantos:Byte; Cartones:TCartones):Boolean;				
		Var
		        i:Byte;{Índice de los cartones}
			Bingo:Boolean;
		Begin
			Bingo:=False;
		        For i:=1 to Cuantos do{Comprueba todos los cartones debido a que puede haber bingo en varios}
				Bingo:=BingoEnCarton(Cartones[i],i) Or Bingo;{Debido a la evaluación en cortocircuito, si lo pongo del revés solo comprueba hasta el primer bingo encontrado}
			ComprobarBingo:=Bingo;
		End;

{Inicialización}
Begin
End.
