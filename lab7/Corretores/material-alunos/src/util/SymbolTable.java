package util;

import java.util.Hashtable;
import java.util.Map;

//Versão do aluno gerada em 01/2010
/**
 * Representação de uma tabela de símbolos.<br>
 * O símbolo é considerado igual independente da presença de letras minúsculas
 * ou maiúsculas diferentes em outras chamadas (<i>case insensitive</i>).
 *
 * @author RRocha
 * @version 04.10.2005
 * @version 28.01.2010 ( refatoramento - Tiago) : mudança da especificação dos métodos e classe. Introdução das restrições
 * 												  da implementação.
 */
public class SymbolTable {

    /**Map que guarda os símbolos.*/
    protected Map<String, String> symbolTable;

    /*
     * TODO Aula 08:
     *
     * A fazer:
     *
     * 1) Criar o construtor da classe
     * 2) Inicializar a tabela de símbolos ( symbolTable) nele, como sendo uma classe
     * 	HashTable (http://java.sun.com/javase/6/docs/api/java/util/Hashtable.html)
     * 3) Especificar que classe deverá ter na key e no valor ( ver como exemplo a InstructionTable ou PseudoTable)
     * 4) Implementar os métodos necessários.
     *
     *
     * */
    public SymbolTable(){
        String index1 = new String("index1");
        symbolTable = new Hashtable<String, String>();
        String bla = new String("bla");
        //symbolTable.putIfAbsent(index1, bla);
        //symbolTable.putIfAbsent(bla, index1);
        //System.out.println(symbolTable.elements());
    }

    /**
     * Verifica se um símbolo está na tabela.
     *
     * @param sym O símbolo a ser verificado.
     *
     * @return <b>true</b> se o símbolo estiver na tabela ou <b>false</b> caso contrário.
     *
     * @throws  NullPointerException se o símbolo passado for <b>null</b>.
     *
     */
    public boolean symbolInTable(String sym) {


        System.out.println("o simbolo esta na tabela?? " + symbolTable.containsKey(sym));

        if (symbolTable.containsKey(sym)) {
            return true;
        }

        //TODO Aula 08: implementar o método symbolInTable

        return false;
    }//

    /**
     * Define um valor para um símbolo.<br>
     * <b><font color="red">O símbolo já deve existir na tabela.</font><b>
     *
     * @param sym O símbolo.
     *
     * @param address O valor.
     *
     * @return <b>true</b> caso a definição tenha obtido sucesso, <b>false</b> caso contrário.
     *
     * @throws NullPointerException se acaso a key (sym) ou valor(address) forem nulos (<b>null</b>).
     */
    public boolean setSymbolValue(String sym, String address) {
        //TODO Aula 08: implementar o método setSymbolValue

        return false;
    }//

    /**
     * Verifica se um símbolo já foi definido (já há o endereço).
     *
     * @param sym O símbolo o qual se deseja saber se já está definido.
     *
     * @return <b>true</b> se o símbolo estiver definido, <b>false</b> caso contrário.
     *
     * @throws NullPointerException se a key (sym) for <b>null</b>.
     *
     */
    public boolean definedSymbol(String sym) {

        /*
         * TODO Aula 08: implementar método definedSymbol
         *
         * A pensar: o que indica que um símbolo não está definido ?
         *
         * */
        System.out.println("\nIS SYMBOL " + sym + " DEFINED? ");

        if(symbolTable.containsKey(sym)){
            System.out.println("esta na lista");
            if(symbolTable.get(sym).equals("")) {
                System.out.println("nao esta definido");
                return false;
            }
            return true;
        }
        return false;
    }//

    /**
     * Insere um símbolo na tabela.
     *
     * @param sym O símbolo a ser inserido.
     *
     * @return Falso caso o símbolo já esteja definido, verdadeiro caso contrário.
     *
     * @throws NullPointerException se acaso a key (sym) for <b>null</b>
     *
     */
    public boolean insertSymbol(String sym) {

        //TODO Aula 08: implementar método insertSymbol

        System.out.println("\nINSERTING SYMBOL " + sym + "\n");


        symbolTable.putIfAbsent(sym, "");
        System.out.println("INSERTED " + symbolTable.get(sym) + "\n");


        if(definedSymbol(sym)){
            return false;
        }

        return true;
    }

    /**
     * Obtêm o valor definido para um símbolo.
     *
     * @param sym O símbolo o qual se deseja saber o valor.
     *
     * @return O valor do símbolo.
     *
     * @throws NullPointerException se acaso a key (sym) for <b>null</b>
     *
     */
    public String getSymbolValue(String sym) {

        //TODO Aula 08: implementar getSymbolValue

        return null;
    }//m
}//class
