Program ElBingo;
Uses funcionesbingo;{Unidad que contiene todas las funciones y procedimientos usadas en el programa}
Var
        Bombo:TPrimos;{El bombo de números. Es un vector que contiene 90 números}
        Cartones:TCartones;{Es un array que contiene todos los cartones}
        Menor,Bola:Word;{El número menor del bombo y la bola que sale}
        Jugadores,Jugada,Opcion:Byte;{Número de jugadores, número de jugada y el modo de juego}
        Bingo,Linea:Boolean;
Begin
	Menu(Opcion);{Opcion esta pasada por variable}
	{Al principio nadie ha cantado ni línea ni bingo}
        Bingo:=False;
        Linea:=False;
        Jugada:=1;{Empezamos en la jugada número 1}
	PedirJugadores(Jugadores);{Jugadores está pasado por variable}
	PedirMinimo(Menor,Opcion);{Menor está pasado por variable}
	GeneraBombo(Bombo,Menor,Opcion);{Bombo está pasado por variable}
	MostrarBombo(Bombo);
	GenerarCartones(Jugadores,Cartones,Bombo,Opcion);{Cartones está pasado por variable}
	MostrarCartones(Jugadores,Cartones);
	
	Writeln('Jugamos para linea');
	Writeln;
	Repeat
		AvanceJugada(Jugada,Bola,Bombo,Opcion);{Bola y Bombo están pasadas por variable}
		Jugada:=Jugada+1;{Incrementamos el número de jugada}
		BuscarEnCartones(Jugadores,Cartones,Bola);{Cartones está pasado por variable}
		Linea:=ComprobarLinea(Jugadores,Cartones);
		MostrarCartones(Jugadores,Cartones);
	Until Linea;{Cuando se canta línea, sale del bucle}

	Writeln('Continuamos para Bingo');
	Writeln;
	
	Repeat
		AvanceJugada(Jugada,Bola,Bombo,Opcion);{Bola y Bombo están pasados por variable}
		Jugada:=Jugada+1;{Incrementamos el número de jugada}
		BuscarEnCartones(Jugadores,Cartones,Bola);{Cartones está pasado por variable}
		Bingo:=ComprobarBingo(Jugadores,Cartones);
		MostrarCartones(Jugadores,Cartones);
	Until Bingo;{Cuando se canta bingo, sale del bucle y el programa finaliza}
{Jugada solo será 91 cuando se cante bingo en la jugada número 90, por eso no he puesto ninguna condición de que si Jugada es mayor de 90, se acabe el bucle}
	Readln;
End.
