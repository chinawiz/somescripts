# coding:utf-8
'''
可以分析中英文词频的脚本,基于jieba分词
'''

import collections
import re
import sys

import jieba
import jieba.analyse
from jieba.analyse import ChineseAnalyzer

analyzer = ChineseAnalyzer()


def get_words(file):
    with open(file) as f:
        words_box = []
        for line in f:
            for word in analyzer(line):
                if (not re.match(u'^[\u4E00-\u9FA5]', word.text)):  # ^[\u4E00-\u9FA5]中文字符
                    # print(word.text)
                    words_box.append(word.text)
    return collections.Counter(words_box)


USAGE = "usage:    python3 extract_tags_with_weight.py [file name] "
if len(sys.argv) < 2:
    print(USAGE)
    sys.exit(1)
file_name = sys.argv[1]
print(get_words(file_name))
