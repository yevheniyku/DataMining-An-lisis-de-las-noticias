import xml.etree.ElementTree as ET
import io

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

def cleanWords(line):
    stop_words = set(stopwords.words('spanish'))
    words = line.split()
    newLine = ''
    for r in words:
        if not r in stop_words:
            if r.isalpha():
                newLine = newLine + ' ' + r
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
    with open('./data/articlesText70.txt', 'a', encoding='utf8') as file:
        for child in root:
            ct = cleanText(child[2].text)
            file.write(ct)


def main():
    print('Inicio del script...')
    tree = ET.parse('./data/elpais1970.xml')
    root = tree.getroot()

    getText(root)

if __name__ == '__main__':
    main()
