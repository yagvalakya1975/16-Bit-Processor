import binascii
import serial
ser = serial.Serial(port="COM14", baudrate = 9600)
while True: 
    instruction_text = input()

    if instruction_text == '1':
        value = ser.read()
        print(value)
    else:

        spaces = [-1]

        for x in range(0,len(instruction_text)):
            if instruction_text[x]==' ':
                spaces.append(x)

        instructions_seperated = []

        for x in range(0,len(spaces)):
            if x!= len(spaces)-1:
                instructions_seperated.append(instruction_text[spaces[x]+1:spaces[x+1]])
            else:
                instructions_seperated.append(instruction_text[spaces[x]+1:len(instruction_text)+1])


        def decimalToBinaryString(n):
            n = int(n)
            snum = ''
            while n>= 1:
                snum = snum+str(n%2)
                n = n//2

            snum = snum[::-1]
            if len(snum) != 6:
                snum = '0'*(6-len(snum)) + snum
            return snum

        def register_location(n):
            location = None
            match n:
                case '0': location = "000"
                case '1': location = "001"
                case '2': location = "010"
                case '3': location = "011"
                case '4': location = "100"
                case '5': location = "101"
                case '6': location = "110"
                case '7': location = "111"
            
            return location

        opcode = None
        itype = None
        ttype = None
        condition = ''
        instruction_binary = None

        match instructions_seperated[0]:
            case 'ADD':  #ADD R1 R2 R3
                opcode = "00011"
                itype = "00"
                ttype = 'R'
            case 'ADDI': #ADDI R1 6
                opcode = "00100"
                itype = "00"
                ttype = 'I'
            case 'SUB': #SUB R1 R2 R3
                opcode = "00101"
                itype = "00"
                ttype = 'R'
            case 'SUBI': #SUBI R1 6
                opcode = "00110"
                itype = "00"
                ttype = 'I'
            case 'MUL': #MUL R1 R2 R3
                opcode = "01110"
                itype = "00"
                ttype = 'R'
            case 'MULI': #MULI R1 6
                opcode = "01111"
                itype = "00"
                ttype = 'I'
            case 'LTHAN': #LTHAN R1 R2
                opcode = "11001"
                itype = "00"
                ttype = 'C'
            case 'GTHAN':  #GTHAN R1 R2
                opcode = "10000"
                itype = "00"
                ttype = 'C'
            case 'LTHANI': #LTHANI R1 6
                opcode = "00111"
                itype = "00"
                ttype = 'I'
            case 'GTHANI':  #GTHANI R1 6
                opcode = "10001"
                itype = "00"
                ttype = 'I'
            case 'EQTI':  #EQTI R1 6
                opcode = "10011"
                itype = "00"
                ttype = 'I'
            case 'EQT': #EQT R1 R2
                opcode = "10010"
                itype = "00"
                ttype = 'C'
            case 'LSF': #LSF R1 R2 R3
                opcode = "01000"
                itype = "00"
                ttype = 'R'
            case 'RSF': #RSF R1 R2 R3
                opcode = "01001"
                itype = "00"
                ttype = 'R'
            case 'BITA': #BITA R1 R2 R3
                opcode = "01010"
                itype = "00"
                ttype = 'R'
            case 'BITO': #BITO R1 R2 R3
                opcode = "01011"
                itype = "00"
                ttype = 'R'
            case 'BITX': #BITO R1 R2 R3
                opcode = "01100"
                itype = "00"
                ttype = 'R'
            case 'NOT': #NOT R1 R2 R3
                opcode = "01101"
                itype = "00"
                ttype = 'R'
            case 'DISA': #DISA 
                opcode = "10101"
                itype = "11"
                instruction_binary = itype + opcode + '1'*9
            case 'DISR': #DISR R1
                opcode = "10110"
                itype = "11"
                instruction_binary = itype + opcode + register_location(instructions_seperated[1][1]) + '101010'
            case 'DISM': #DISM DM1
                opcode = "10111"
                itype = "11"
                instruction_binary = itype + opcode + decimalToBinaryString(instructions_seperated[1][2:4]) + '101'
            case 'DISB': #DISB
                opcode = "11000"
                itype = "11"
                instruction_binary = itype + opcode + '101010101'
            case 'DISP': #DISP
                opcode = "11001"
                itype = "11"
                instruction_binary = itype + opcode + '101010101'
            case 'JUMPU': #JUMPU IM1
                opcode = "10100"
                itype = "10"
                condition = '000'
            case 'JUMPB': #JUMPB IM1
                opcode = "10100"
                itype = "10"
                condition = '001'
            case 'JUMPZ': #JUMPZ IM1
                opcode = "10100"
                itype = "10"
                condition = '010'
            case 'JUMPC':  #JUMPC IM1
                opcode = "10100"
                itype = "10"
                condition = '011'
            case 'JUMPO':  #JUMPO IM1
                opcode = "10100"
                itype = "10"
                condition = '100'
            case 'LOAD': #LOAD R1 IM1
                opcode = "00000"
                itype = "01"
                instruction_binary = itype + opcode + register_location(instructions_seperated[1][1]) + decimalToBinaryString(instructions_seperated[2][2:4])
            case 'LOADI': #LOAD R1 6
                opcode = "00001"
                itype = "01"
                ttype = 'I'
            case 'STORE':  #STORE R1 M1
                opcode = "00010"
                itype = "01"
                instruction_binary = itype + opcode + register_location(instructions_seperated[1][1]) + decimalToBinaryString(instructions_seperated[2][2:4])
            case 'HALT':
                instruction_binary = '11' + '11001' + '101010101'

        if ttype=='R':
            instruction_binary = itype + opcode + register_location(instructions_seperated[1][1]) + register_location(instructions_seperated[2][1]) + register_location(instructions_seperated[3][1])

        if ttype=='I':
            instruction_binary = itype + opcode + register_location(instructions_seperated[1][1]) + decimalToBinaryString(instructions_seperated[2])

        if ttype=='C':
            instruction_binary = itype + opcode + '000'+ register_location(instructions_seperated[1][1]) + register_location(instructions_seperated[2][1])

        if itype=='10':
            instruction_binary = itype + opcode + decimalToBinaryString(instructions_seperated[1][2:4])+ condition

        print(instruction_binary)


        # Function to convert binary to ASCII value
        def binary_to_string(bits):
            return ''.join([chr(int(i, 2)) for i in bits])
        
        # Driver Code
        
        # This is the binary equivalent of string "GFG"
        bin_values = ['01' + instruction_binary[0:6],'01' + instruction_binary[6:12], '0101' + instruction_binary[12:16]] 
        
        # calling the function
        # and storing the result in variable 's'
        s = binary_to_string(bin_values)

        print(s)

        ser.write(s[0].encode())
        ser.write(s[1].encode())
        ser.write(s[2].encode())

