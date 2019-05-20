import xml.etree.ElementTree as ET
import io
import unidecode

class tagsRetriever:
    def __init__(self, decade):
        self.decade = decade

    def getText(decade):
        originFile = '../../../data/'

t = []

def iterLoops(origin):
    global t

    for line in origin:
        if line.strip() not in t:
            t.append(line.strip())

    with open('../data/uniqTags00.txt', 'a', encoding='utf8') as f:
        for tag in t:
            tagLine = tag + '\n'
            f.write(tagLine)

def getText(root):
    print('Empezamos a sacar y limpiar el texto...')
    with open('../data/cleaning/tagsList00.txt', 'a', encoding='utf8') as file:
        for child in root:
            tags = child[1]
            for tag in tags:
                tagLine = str(tag.text) + '\n'
                file.write(tagLine)

def main():
    print('Inicio del script...')
    tree = ET.parse('../data/original/elpais2000.xml')
    root = tree.getroot()

    getText(root)

    fd = open('../data/cleaning/tagsList00.txt', 'r', encoding='utf-8')

    iterLoops(fd)

    fd.close()


if __name__ == '__main__':
    main()
