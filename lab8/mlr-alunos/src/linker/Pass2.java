package linker;

import java.io.IOException;
import java.util.StringTokenizer;

import mvn.util.LinkerSymbolTable;

/**
 * Passo 2 do ligador.<br>
 * Nesse passo é gerado o código objeto a partir da tabela
 * de símbolos obtida.
 * @author FLevy
 * @version 23.10.2006
 * Preparação do arquivo para alunos - PSMuniz 1.11.2006
 * @version 01.01.2010 : atualização da classe de acordo com a definição dos slides. (Tiago)
 */
public class Pass2 extends Pass {

    /**Gerencia o arquivo de saída*/
    private Output out;
    /**Tabela de símbolos utilizada pelo Linker*/
    private LinkerSymbolTable symbolTable;
    /**Indica o endereçamento corrente da parte relocável do código. */
    private int relativeLocationCouter;
    /**A base de relocação a ser considerada no código. */
    private int base;

    /**Contador de variáveis externas que não foram resolvidas*/
    private int externalCounter = 0;


    public Pass2(LinkerSymbolTable symbolTable, String objFile) throws IOException {
        out = new Output(objFile);
        this.symbolTable = symbolTable;
        relativeLocationCouter = 0;
        base = 0;
    }

    /**
     * Processa uma linha de código.
     *
     * @param nibble O nibble do endereço da linha.
     * @param address O endereço da linha (sem o nibble).
     * @param code O código da linha.
     * @param currentFile O arquivo atual que está sendo processado.
     * @return Verdadeiro caso a análise teve sucesso, falso caso contrario.
     * @exception Caso tenha ocorrido algum problema de IO.
     */
    protected boolean processCode(int nibble, String address, String code, String currentFile)
            throws IOException {
        /*
         * TODO: processCode
         *
         * Aqui, deve-se gerar o código objeto a partir da tabela de simbolos (ST).
         * Deve-se avaliar as combinações apropriadas do nibble. Se houver pendência (relocável
         * ou absoluta), ela deve ter ser resolvida e seu valor inserido na ST.
         * O código resolvido deve ser enviado para a saída.
         *
         */

        int actualAddress = Integer.parseInt(address, 16);
        String actualCode = code;
        boolean argumentRelocable = false;
        if (isArgumentRelocable(nibble)) {
            argumentRelocable = true;
            nibble = Integer.parseInt(actualCode, 16) + base;
            actualCode = "0000" + Integer.toHexString(nibble);
            actualCode = actualCode.substring(actualCode.length() - 4, actualCode.length());
        }
        boolean relocable = false;
        if (isRelocable(nibble)) {
            actualAddress += base;
            relocable = true;
            relativeLocationCouter += 2;
        }
        int codeInteger = Integer.parseInt(code.substring(1), 16);
        String codeWithoutNibble = symbolTable.getAddressByCode(currentFile, codeInteger);
        boolean resolved = isResolved(nibble);

        if (codeWithoutNibble != null && codeWithoutNibble.startsWith("5")){
            codeWithoutNibble = "0000" + codeWithoutNibble;
            codeWithoutNibble = codeWithoutNibble.substring(codeWithoutNibble.length() - 3, codeWithoutNibble.length());
            if (instructionWithExternal(nibble)) {
                argumentRelocable = symbolTable.isRelocable(symbolTable.getAddressByCode(currentFile, codeInteger));
                actualCode = code.substring(0, 1) + codeWithoutNibble;
            }
            if (isResolved(nibble))
                actualCode = code.substring(0, 1) + codeWithoutNibble;

        }
        else if (instructionWithExternal(nibble)) {
            actualCode = code;
        }
        out.write(actualAddress, actualCode, relocable, argumentRelocable, resolved);
        return true;

    }//method

    protected boolean processSymbolicalAddress(int nibble, String address, String symbol, String currentFile, String originalLine)
            throws IOException {
        
        /**
         * TODO: processSymbolicalAddress
         * Tratamento do Endereçamento simbólico. 
         * Caso EntryPoint: escreve no arquivo de saída
         * Caso External: se resolvido ignora, caso contrário insere na tabela o arquivo com um novo endereçamento "virtual"
         *                  e escreve o external no arquivo de saída.
         * 
         *          
         */

        //Se for símbolo exportável: gero no arquivo de saída as informações a respeito dele
        //...
        //...
        if (isEntryPoint(nibble)) {
            out.writeExternal(Integer.toHexString(nibble), Integer.parseInt(symbolTable.getSymbolValue(symbol), 16), originalLine);
            return true;
        }
        if (!symbolTable.definedSymbol(symbol)) {
            symbolTable.insertSymbol(symbol);
            String addressToSet = "0000" + Integer.toHexString(externalCounter);
            addressToSet = "5" + addressToSet.substring(addressToSet.length() - 3, addressToSet.length());
            symbolTable.setSymbolValue(symbol, addressToSet);
            out.writeExternal("4", Integer.parseInt(symbolTable.getSymbolValue(symbol), 16), originalLine);
            externalCounter++;
        }
        StringTokenizer stringTokenizer = new StringTokenizer(originalLine);
        symbolTable.setCodeForSymbol(symbol, currentFile, Integer.parseInt(stringTokenizer.nextToken().substring(1, 4), 16));
        return true;
    }

    /**
     * Finaliza o arquivo lido (pode haver um próximo arquivo).
     */
    protected void fileEnd() {
        /*
         * TODO: fileEnd()
         * Quando há mudança de arquivo, deve-se atualizar a base e o relativeLocationCounter!
         * */
        base += relativeLocationCouter;
        relativeLocationCouter = 0;
    }

    public void closeOutput() throws IOException {
        out.close();
    }
}
