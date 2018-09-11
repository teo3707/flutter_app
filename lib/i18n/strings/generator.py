import os
import json
import yaml
import pprint


def main():
    with open('strings.dart', mode='w', encoding='utf-8') as out:
        out.write(
'''
////
//// this file is auto generate, please do not modify this file.
////
''')

        strings = {}
        languages = []
        for root, dirs, files in os.walk('.'):
            for filename in files:
                if filename.endswith('.yaml'):
                    languages.append(filename.split('_')[-1][:-5])
                    for k, v in yaml.load(open(filename, encoding='utf-8')).items():
                        if k in strings:
                            strings[k][filename.split('_')[-1][:-5]] = v
                        else:
                            strings[k] = {filename.split('_')[-1][:-5]: v}
        out.write('const List<String> LANGUAGES = {};\r\n'.format(languages))
        out.write('const Map<String, Map<String, String>> STRINGS = <String, Map<String, String>>')
        out.write(json.dumps(strings, indent=2, ensure_ascii=False))
        out.write(';')

if __name__ == '__main__':
    main()
