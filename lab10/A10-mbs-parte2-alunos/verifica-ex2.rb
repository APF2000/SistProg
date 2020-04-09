#!/usr/bin/env ruby

MEM = <<-STR
[ 0]: 00 04 00 20 80 02 F0 EF 3A BC 60 1E 40 1C 90 1A
[10]: C0 10 00 00 00 00 00 00 00 00 AB CD 00 0D 00 10
[20]: 30 00 40 2C 60 2E 90 2A C0 28 00 08 00 02 00 04
Final do dump.
STR

TEST_10_OUT = <<-STR
0020 3000 0022 3000 0003 0000 0000 
0022 402C 0024 402C 0004 002C 0002 
0024 602E 0026 602E 0006 002E 0008 
0026 902A 0028 902A 0009 002A 0008 
0028 C028 0008 C028 000C 0028 0008 
0008 3ABC 000A 3ABC 0003 0ABC 0ABC 
000A 601E 000C 601E 0006 001E ABC0 
000C 401C 000E 401C 0004 001C ABCD 
000E 901A 0010 901A 0009 001A ABCD 
0010 C010 0010 C010 000C 0010 ABCD 
STR


def check_default_case
  file = ".ex2/os_0ef_test.mem"

  if !File.exist?(file)
    puts "[erro] Arquivo #{file} não existe"
    return false
  end

  contents = File.read(file)

  if contents.strip == MEM.strip
    puts "[OK] Caso básico está correto"
    return true
  else
    puts "[Incorreto] Caso básico incorreto."
    puts
    puts "Obtido:"
    puts contents.strip
    puts
    puts "Esperado:"
    puts MEM.strip
    puts
    return false
  end
end

def check_case_00
  out_file = ".ex2/os_0ef_test_case_00.stdout"

  if !File.exist?(out_file)
    puts "[erro] Arquivo #{out_file} não existe"
    return false
  end

  contents = File.read(out_file)

  if contents.match("MAR  MDR  IC   IR   OP   OI   AC")
    puts "[Incorreto] Neste teste, a MVN não deve exibir o conteúdo dos registradores"
    return false
  else
    puts "[OK] Caso de teste 00 está correto"
    return true
  end
end

def check_case_10
  out_file = ".ex2/os_0ef_test_case_10.stdout"

  if !File.exist?(out_file)
    puts "[erro] Arquivo #{out_file} não existe"
    return false
  end

  contents = File.read(out_file)

  if contents.match(TEST_10_OUT)
    puts "[OK] Caso de teste 10 está correto"
    return true
  else
    puts "[Incorreto] Teste 10 incorreto. A MVN deve exibir o conteúdo dos registradores em todos os passos da execução!"
    return false
  end
end

def check_case_11
  out_file = ".ex2/os_0ef_test_case_11.stdout"

  if !File.exist?(out_file)
    puts "[erro] Arquivo #{out_file} não existe"
    return false
  end

  contents = File.read(out_file)

  if contents.scan("Continua (s/n)[s]").size > 10
    puts "[OK] Caso de teste 11 está correto"
    return true
  else
    puts "[Incorreto] Teste 11 incorreto. A MVN deve exibir o conteúdo dos registradores em todos os passos da execução e perguntar se deseja continuar em cada passo."
    return false
  end
end

nota = 0

nota = nota + (check_default_case ? 7 : 0)

cases = 0

cases = cases + (check_case_00 ? 1 : 0)
cases = cases + (check_case_10 ? 1 : 0)
cases = cases + (check_case_11 ? 1 : 0)

nota = nota + (cases.to_f/3) * 3

puts
puts "Nota: #{nota.round(3)}"
