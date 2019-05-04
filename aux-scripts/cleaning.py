import xml.etree.ElementTree as ET
import io
import unidecode
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

swords = stopwords.words('spanish')

def addCustomStopwords():
    global swords
    print(len(swords))
    with open('../data/aux/custom-stopwords.csv', 'r', encoding='utf8') as f:
        for line in f:
            new_word = []
            new_word.append(unidecode.unidecode(line.strip()))
            swords.extend(new_word)
    print(len(swords))

def cleanWords(line):
    global swords
    words = line.split()
    cont = 1
    newLine = ''
    for r in words:
        r = unidecode.unidecode(r)
        if not r in swords and r.isalpha():
            if cont == 8:
                newLine = newLine + ' ' + r + '\n'
                cont = 1
            else:
                newLine = newLine + ' ' + r
                cont += 1
    return newLine

def cleanText(text):
    t = ''
    parts = text.split('\n')
    for part in parts[:-2]:
        if not part:
            continue
        else:
            cleanPart = cleanWords(part.lower())
            t += cleanPart
    return t

def getText(root):
    print('Empezamos a sacar y limpiar el texto...')
    with open('../data/cleaning/cleanWords1970.txt', 'a', encoding='utf8') as file:
        for child in root:
            ct = cleanText(child[2].text)
            file.write(ct)

def main():
    print('Inicio del script...')
    tree = ET.parse('../data/original/elpais1970.xml')
    root = tree.getroot()

    addCustomStopwords()
    getText(root)

if __name__ == '__main__':
    main()
