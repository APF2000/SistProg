package montador;

import java.io.IOException;
import java.util.ArrayList;

import assemblerException.AssemblerException;
import util.SymbolTable;

// versão do aluno gerada em 01.02.2010
/**
 * Implementa o passo 1 do montador.<br>
 * Nesse passo os símbolos são resolvidos e colocados na tabela de símbolos e
 * também é verificado se as instruções estão corretas.
 *
 * @author RRocha
 * @author FLevy
 * @version 10.10.2005
 * @version 21.09.2006 (Montador absoluto - FLevy)
 * @version 28.01.2010 (Refatoramento - Tiago) : conversão para generics alterações na classe/enunciado do exercicio da aula.
 */
class Pass1 extends Pass {

    //Mensagens
    private final String MSG_PASS1_IO_ERROR = "Erro de I/O no passo 1, verifique o arquivo";
    private final String MSG_PASS1_LOC_ERROR = "Erro: Contador de instrucoes ultrapassou o limite de memoria.";
    private final String MSG_PASS1_CONST_ERROR = "Erro: Definicao de constante nao usa valores numericos: ";
    private final String MSG_PASS1_DATA_ERROR = "Erro: Definicao de dado numerico usa base desconhecida: ";
    private final String MSG_PASS1_ORG_ERROR = "Erro: Definicao de origem de dado deve ser um numero: ";
    private final String MSG_PASS1_PSEUDO_ERROR = "Instrucao invalida, verificar o programa: ";
    private final String MSG_PASS1_ARG_ERROR = "Erro: O argumento nao e numerico nem rotulo, ou a codificacao esta incorreta: ";
    private final String MSG_PASS1_SIMB_ERROR = "Erro: Simbolo redefinido: ";
    private final String MSG_PASS1_ASM_ERROR = "Erro na montagem no passo 1. Linha: ";

    public Pass1() {
        tab = new SymbolTable();
    }

    public SymbolTable getSymbolTable() {
        return tab;
    }

    @Override
    public String getIOErrorMessage() {
        return MSG_PASS1_IO_ERROR;
    }

    @Override
    public String getASMErrorMessage() {
        return MSG_PASS1_ASM_ERROR;
    }

    @Override
    protected void processComment(String data) throws IOException {
        /*
         * Passo 1 não precisa processar os comentários.
         *
         * */
    }

    @Override
    public boolean analyzeLine(ArrayList<String> symbols, String line)
            throws IOException {

        boolean result = false;

        System.out.println("AnalyzeLine PASS1 " + symbols);

        if (symbols.size() > 2) {
            // Quando a instrução contém label, entra-se aqui

            if (symbols.size() > 3) {
                // a linha contem mais símbolos do que devia
                System.out.println(MSG_PASS1_PSEUDO_ERROR);
                return false;
            }

            System.out.println("simbolo esta na tabela : " + tab.symbolInTable(symbols.get(0)));
            System.out.println("simbolo esta definido ? : " + tab.definedSymbol(symbols.get(0)));

            if (!tab.symbolInTable(symbols.get(0))) {
                // se símbolo ainda não usado, coloca na tabela e resolve
                tab.insertSymbol(symbols.get(0));
                tab.setSymbolValue(symbols.get(0), Integer.toHexString(locationCounter));
            } else if (!tab.definedSymbol(symbols.get(0))) {
                // se simbolo já usado, mas ainda não resolvido, coloca o
                // endereco na tabela
                tab.setSymbolValue(symbols.get(0), Integer.toHexString(locationCounter));
            } else {
                // símbolo já definido (ou seja, definido duas vezes!!!
                System.out.println(MSG_PASS1_SIMB_ERROR + symbols.get(0));
                return false;
            }

            // testa se o resto da linha é correta
            result = testForCode(symbols.get(1), symbols.get(2));
        } else if (symbols.size() == 2) {
            // não contem label

            System.out.println("Nao contem label");

            // adaptação para corrigir o posicionamento do operando
            result = testForCode(symbols.get(0), symbols.get(1));
        } else {
            // a linha contem menos tokens do que o utilizado
            System.out.println(MSG_PASS1_PSEUDO_ERROR);
            return false;
        }

        return result;
    }

    /**
     * Testa se é uma instrução ou pseudo-instrução.
     *
     * @param code
     *            O código da instrução.
     * @param arg
     *            O argumento da instrução.
     * @return Verdadeiro caso seja uma instrução ou pseudo-instrução, falso
     *         caso contrário.
     */
    private boolean testForCode(String code, String arg) {

        boolean result = false;

        System.out.println("code + arg = " + code + " " + arg);
        System.out.println("is number? " + isNumber(arg));

        // Testa se o argumento é número ou label
        if (!isNumber(arg)) {

            // testa se não é um erro na codificação do número
            String base = arg.substring(0, 1);
            System.out.println("base (dec, oct, hex?) = " + base);

            if (base.equals(HEX_CODE) || base.equals(ASCII_CODE)
                    || base.equals(DECIMAL_CODE)
                    || base.equals(OCTAL_CODE)
                    || base.equals(BINARY_CODE)) {

                System.out.println(MSG_PASS1_ARG_ERROR + arg);
                return false;
            }

            // coloca o simbolo na tabela
            if (!tab.symbolInTable(arg)) {
                tab.insertSymbol(arg);
            }
        }


        System.out.println("\ne' instrucao? " + InstructionsTable.getTable().instructionDefined(code));
        System.out.println("table = " + InstructionsTable.getTable().toString());

        // Testa se é instrução
        if (InstructionsTable.getTable().instructionDefined(code)) {
            locationCounter += 2;
            System.out.println("e' instrucao, location : " + locationCounter);
            if (locationCounter < LAST_VAL_ADDR) {
                System.out.println("Nao excedeu a memoria");
                result = true;
            } else {
                System.out.println(MSG_PASS1_LOC_ERROR);
            }
        } else {
            // É uma pseudo instrução
            System.out.println("Deve ser entao uma pseudo\n");
            result = testForPseudo(code, arg);
        }

        return result;
    }

    /**
     * Testa se é uma pseudo-instrução.
     *
     * @param code
     *            Código da pseudo-instrução.
     * @param arg
     *            Argumento da pseudo-instrução.
     * @return Verdadeiro caso seja uma pseudo-instrução, falso caso contrário.
     */
    private boolean testForPseudo(String code, String arg) {

        boolean result = false;

        System.out.println("testForPseudo()");

        // É código de pseudo-instrução.
        if (PseudoTable.getTable().pseudoDefined(code)) {
            int ps = PseudoTable.getTable().getPseudoCode(code);
            System.out.println("\ncode " + code + ",table "+ PseudoTable.getTable() + ",ps " + ps);
            switch (ps) {
                case PseudoTable.ORG:
                    System.out.println("arroba");

                    // Pseudo-Instrução que troca a origem
                    if (defineNewOrigin(arg)) {
                        System.out.println("definiu nova origem");
                        result = true;
                    }
                    System.out.println("agora sim deu ruim, " + defineNewOrigin(arg));
                    break;
                case PseudoTable.DC:
                    // Pseudo-Instrução para definição de constantes
                    if (defineConstant()) {
                        result = true;
                    }
                    break;
                case PseudoTable.END:
                    // Pseudo-Instrução para o fim do assembler
                    result = endAsm(arg);
                    break;
                case PseudoTable.MEM:
                    // Pseudo-Instrução de reserva um bloco de memória
                    result = reserveBlock(arg);
                    break;
                default:
                    System.out.println(MSG_PASS1_PSEUDO_ERROR + code);
            }
        } else {
            System.out.println(MSG_PASS1_PSEUDO_ERROR + code);
        }
        return result;
    }

    /**
     * Define uma nova origem (pseudo-instrução ORG).
     *
     * @param arg String com a nova origem em HEXADECIMAL, BINÁRIO, OCTAL,DECIMAL ou ASCII.
     *
     * @return <b>Verdadeiro</b> caso tenha sido possível alterar a origem, <b>falso</b> caso
     *         a origem solicitada seja maior do que a possível de ser
     *         processada pelo montador.
     *
     */
    private boolean defineNewOrigin(String arg) {
        int num;
        /*
         * TODO AULA 08 : defineNewOrigin
         * implementar método defineNewOrigin() conforme informações do método ( acima )
         *
         * */
        try {
            num = 0;
            locationCounter = getDecNumber(arg);
        } catch(AssemblerException ae){
            System.out.println(ae.toString());
            return false;
        }
        System.out.println("Define-se uma nova origem");
        return true;
    }

    /**
     * Define uma constante (pseudo-instrução DC). Permite que um valor esteja associado à um
     * símbolo (seja guardado no endereço do símbolo).<br>
     *
     * Na prática apenas move o contador de localização (as demais verificaç
     *         ões
     * já foram feitas).
     *
     * @return <b>Falso</b> caso tenha ocorrido um erro ao definir as constantes ( estouro de memória ).
     *
     */
    private boolean defineConstant() {

        /*
         * TODO AULA 08 : defineConstant
         * implementar método defineConstant()
         *
         * */

        System.out.println("Define-se uma nova constante\n");

        return true;
    }

    /**
     * Pára o assembler (pseudo-instrução END).<br>
     * Precisa apenas verificar se o locationCounter se encontra no intervalo válido.
     *
     * @param arg O endereço de execução do programa
     *
     * @return <b>Verdadeiro</b> se o locationCounter se encontra num intervalo válido, <b>falso</b> caso contrário.
     */
    private boolean endAsm(String arg) {

        /**
         * TODO AULA 08 : endAsm
         * implementar método endAsm()
         *
         * */

        System.out.println("Define-se o fim");

        return true;
    }

    /**
     * Reserva um bloco de dados (pseudo-instrução MEM)
     *
     * @param arg  O espaço a ser reservado ( em quantidade de <font color="red"><b>Words</b></font>).
     * @return <b>Verdadeiro</b> caso tenha sido possível alocar a área de dados e falso caso contrário.
     *
     */
    private boolean reserveBlock(String arg) {
        int space=0;
        /**
         * TODO AULA 08 : reserveBlock
         * implementar método reserveBlock(). Reservar explicitamente a área de dados.
         *
         * */
        try {
            space = getDecNumber(arg);
        }catch(NumberFormatException nfe){
            System.out.println("Formato errado");
        }catch (AssemblerException ae){
            System.out.println(ae.toString());
        }
        if(locationCounter + space > LAST_VAL_ADDR || space % 2 != 0){
            return false;
        }
        locationCounter += space;
        System.out.println("Reserva-se um bloco");
        return true;
    }
}
