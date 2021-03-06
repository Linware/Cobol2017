       IDENTIFICATION DIVISION.
          PROGRAM-ID. CRUCE-ARCHIVOS.
       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
           SOURCE-COMPUTER.           IBM-3083.
           OBJECT-COMPUTER.           IBM-3083.


        INPUT-OUTPUT SECTION.
        FILE-CONTROL.

            SELECT INFILE ASSIGN "ENTRADA.CSV"
            ORGANIZATION IS LINE SEQUENTIAL
            STATUS IS FS-INFILE.
            SELECT OUTFILE ASSIGN "INFORME.TXT"
            ORGANIZATION IS LINE SEQUENTIAL
            STATUS IS FS-OUTFILE.
            SELECT OUTFILE02 ASSIGN TO DISK
            ORGANIZATION IS LINE SEQUENTIAL
            STATUS IS FS-OUTFILE02.
            SELECT ORDENAR ASSIGN "SORT".

       DATA DIVISION.

       FILE SECTION.
        FD INFILE.
        01 IN-REG.
            05 IN-NUMERO    PIC X(07).
            05 FILLER        PIC X(01).
            05 IN-COGNOM    PIC X(20).
            05 FILLER        PIC X(01).
            05 IN-ZGEO        PIC X(09).
            05 FILLER        PIC X(01).
        FD OUTFILE.
        01 OF-REG.
            05 OF-NUMERO01       PIC X(07).
            05 FILLER            PIC X(01).
            05 OF-COGNOM01       PIC X(20).
            05 FILLER            PIC X(01).
            05 OF-ZGEO01         PIC X(09).
            05 FILLER            PIC X(01).
            05 OF-CONTADOR01     PIC 9(02).
        FD OUTFILE02.
        01 OF-REG02.
            05 OF-NUMERO         PIC X(07).
            05 FILLER            PIC X(01).
            05 OF-COGNOM         PIC X(20).
            05 FILLER            PIC X(01).
            05 OF-ZGEO           PIC X(09).
            05 FILLER            PIC X(01).
            05 OF-CONTADOR       PIC 9(02).
        SD ORDENAR.
        01 OR-REG.
            05 OR-NUMERO         PIC X(07).
            05 FILLER            PIC X(01).
            05 OR-COGNOM         PIC X(21).
            05 FILLER            PIC X(01).
            05 OR-ZGEO           PIC X(09).
            05 FILLER            PIC X(01).
            05 OR-CONTADOR       PIC 9(02).

       WORKING-STORAGE SECTION.
        01 WS-DADES.
            05 NUMERO            PIC X(07).
            05 FILLER            PIC X(1).
            05 COGNOM            PIC X(20).
            05 FILLER            PIC X(1).
            05 ZGEO              PIC X(09).
            05 FILLER            PIC X(1).
            05 WS-CONTADOR       PIC X(02).


        01 SWITCH             PIC X.
            88 FIN-FICHERO       VALUE "S".
            88 NO-FIN-FICHERO    VALUE "N".

        01 ESCRIBIR-LINIA.
           05 WR-NUMERO       PIC X(7).
           05 FILLER          PIC X(1).
           05 WR-COGNOM       PIC X(20).
           05 FILLER          PIC X(1).
           05 WR-ZGEO         PIC X(09).
           05 FILLER          PIC X(1).
           05 WR-CONTADOR     PIC X(02).

        01 FS-STATUS.
            05 FS-INFILE      PIC X(02).
            05 FS-OUTFILE     PIC X(02).
            05 FS-OUTFILE02   PIC X(02).

        01 TAULES.
            05 TAULA-INTERNA    OCCURS 20 TIMES.
                10 T-NUMERO   PIC X(07).
                10 FILLER     PIC X(01).
                10 T-COGNOM   PIC X(20).
                10 FILLER     PIC X(01).
                10 T-ZGEO     PIC X(09).
                10 FILLER     PIC X(01).
                10 T-CONTADOR PIC 9(02).

        01 CONTADOR            PIC 9(02).

       PROCEDURE DIVISION.

       PROCESO.

           PERFORM ABRIR-ARCHIVOS01    THRU FIN-ABRIR-ARCHIVOS01
           PERFORM LEER-ESCRIBIR       THRU FIN-LEER-ESCRIBIR
                                       UNTIL FIN-FICHERO
           PERFORM ORDENAR01           THRU FIN-ORDENAR01
           PERFORM CERRAR-ARCHIVOS     THRU FIN-CERRAR-ARCHIVOS
           PERFORM ABRIR-ARCHIVOS02    THRU FIN-ABRIR-ARCHIVOS02
           PERFORM LEERTEMPORAL        THRU FIN-LEERTEMPORAL
           MOVE 1 TO CONTADOR
           PERFORM ELIMINAREP          THRU FIN-ELIMINAREP
                                       UNTIL FIN-FICHERO
           PERFORM CERRAR-ARCHIVOS     THRU FIN-CERRAR-ARCHIVOS
           PERFORM ABRIR-ARCHIVOS03    THRU FIN-ABRIR-ARCHIVOS03
           PERFORM ORDENAR02           THRU FIN-ORDENAR02
                                       UNTIL FIN-FICHERO

           PERFORM FINALIZAR.

       FIN-PROCESO. EXIT.

       ABRIR-ARCHIVOS01.

           OPEN INPUT  INFILE
           OPEN OUTPUT OUTFILE
           OPEN OUTPUT OUTFILE02.

       FIN-ABRIR-ARCHIVOS01.EXIT.

       ABRIR-ARCHIVOS02.

           OPEN INPUT  OUTFILE02
           OPEN OUTPUT OUTFILE.

       FIN-ABRIR-ARCHIVOS02.EXIT.

       ABRIR-ARCHIVOS03.

           OPEN INPUT  OUTFILE
           OPEN OUTPUT OUTFILE02.

       FIN-ABRIR-ARCHIVOS03.EXIT.

       CERRAR-ARCHIVOS.

           CLOSE INFILE
                 OUTFILE
                 OUTFILE02.

       FIN-CERRAR-ARCHIVOS.EXIT.

       LEER-ESCRIBIR.
           READ INFILE

            EVALUATE FS-INFILE
               WHEN ZEROES
                   UNSTRING IN-REG DELIMITED BY ','
                   INTO NUMERO
                        COGNOM
                        ZGEO
                   END-UNSTRING
                   MOVE NUMERO TO WR-NUMERO
                   MOVE COGNOM TO WR-COGNOM
                   MOVE ZGEO   TO WR-ZGEO
                   WRITE OF-REG FROM ESCRIBIR-LINIA
               WHEN 10
                   SET FIN-FICHERO TO TRUE
               WHEN OTHER
                   PERFORM FINALIZAR
               END-EVALUATE.


       FIN-LEER-ESCRIBIR. EXIT.

       LEERINFORME.

           SET NO-FIN-FICHERO TO TRUE
           READ OUTFILE
           EVALUATE FS-OUTFILE
              WHEN ZEROES
                  MOVE OF-REG TO WS-DADES
              WHEN 10
                  SET FIN-FICHERO TO TRUE
              WHEN OTHER
                  PERFORM FINALIZAR
           END-EVALUATE.

       FIN-LEERINFORME. EXIT.

       LEERTEMPORAL.

       SET NO-FIN-FICHERO TO TRUE
       READ OUTFILE02

           EVALUATE FS-OUTFILE02
              WHEN ZEROES
                  MOVE OF-REG02 TO WS-DADES
              WHEN 10
                  SET FIN-FICHERO TO TRUE
              WHEN OTHER
                  PERFORM FINALIZAR
              END-EVALUATE.
       FIN-LEERTEMPORAL.EXIT.

       ORDENAR01.


           CLOSE         OUTFILE
                        OUTFILE02
           OPEN INPUT    OUTFILE
           OPEN OUTPUT     OUTFILE02


                   SORT ORDENAR
           ON ASCENDING     OR-COGNOM
           ON ASCENDING     OR-ZGEO
           INPUT PROCEDURE     I-PROCES
           OUTPUT PROCEDURE O-PROCES.

       FIN-ORDENAR01. EXIT.

       I-PROCES.

           SET NO-FIN-FICHERO TO TRUE
           PERFORM LEERINFORME THRU FIN-LEERINFORME

               PERFORM UNTIL FIN-FICHERO
                MOVE OF-REG TO OR-REG
                RELEASE OR-REG
                PERFORM LEERINFORME
           END-PERFORM

               CLOSE OUTFILE.

       O-PROCES.

           SET NO-FIN-FICHERO TO TRUE
           RETURN ORDENAR
                   AT END SET FIN-FICHERO TO TRUE
           END-RETURN

                PERFORM UNTIL FIN-FICHERO
                WRITE OF-REG02 FROM OR-REG
                RETURN ORDENAR
                    AT END SET FIN-FICHERO TO TRUE
                END-RETURN
            END-PERFORM.

               CLOSE OUTFILE02.

       ORDENAR02.

           SORT ORDENAR
           ON ASCENDING OR-CONTADOR
           USING     OUTFILE
           GIVING     OUTFILE02
           GOBACK.

       FIN-ORDENAR02.EXIT.

       ELIMINAREP.

           MOVE WS-DADES TO TAULA-INTERNA(CONTADOR)
           PERFORM LEERTEMPORAL THRU FIN-LEERTEMPORAL
               IF     T-COGNOM(CONTADOR) NOT EQUAL TO COGNOM
                    OR T-ZGEO(CONTADOR) NOT EQUAL TO ZGEO

                        MOVE T-COGNOM(CONTADOR) TO WR-COGNOM
                    MOVE T-NUMERO(CONTADOR) TO WR-NUMERO
                    MOVE T-ZGEO(CONTADOR)    TO WR-ZGEO
                    MOVE CONTADOR             TO WR-CONTADOR
                    WRITE OF-REG FROM ESCRIBIR-LINIA
                    MOVE 1 TO CONTADOR
               ELSE
                    ADD 1 TO CONTADOR
               END-IF.

       FIN-ELIMINAREP.EXIT.

       FINALIZAR.

           CLOSE INFILE
                 OUTFILE
                 OUTFILE02

               STOP RUN.
           GOBACK.
