#!/usr/bin/env python

from string import Template
import argparse
import json
import os
import sys


class TemplateProcessor:
    def __init__(self, kvs, delimiter="\n"):
        self.kvs = kvs
        self.out = []
        self.delimiter = delimiter
        self.reset()

    def reset(self):
        self.out = []

    def process_line(self, line):
        r"""Process a single line and adds it to output buffer.
        Use result() method to get the results.

        >>> p = TemplateProcessor({'foo' : 'bar', 'num': 1})
        >>> p.process_line('Hey $foo')
        >>> p.process_line('Number is $num')
        >>> p.result()
        'Hey bar\nNumber is 1'

        """
        template = Template(line)
        new_line = template.safe_substitute(self.kvs)
        self.out.append(new_line)

    def result(self):
        """Returns result after processing was done"""
        return self.delimiter.join(self.out)


def parse_args():
    """Parse commandline args"""

    parser = argparse.ArgumentParser(
        description='Substitute variables in template')

    parser.add_argument(
        '-t', '--template',
        required=True,
        help='Template to process')

    parser.add_argument(
        '-j', '--json',
        required=True,
        help='JSON file with variable values')

    parser.add_argument(
        '-o', '--out',
        required=True,
        help='File to write')

    parser.add_argument(
        '-f', '--force',
        action='store_true',
        help='Force overwrite of target file')

    return parser.parse_args()


def load_kvs(fil):
    kvs_file = open(fil, 'r')
    kvs = json.load(kvs_file)
    return kvs


if __name__ == "__main__":
    args = parse_args()

    if (not args.force) and os.path.exists(args.out):
        sys.stderr.write("File %s already exists\n" % args.out)
        exit(1)

    kvs = load_kvs(args.json)
    processor = TemplateProcessor(kvs, delimiter='')  # strings contain \n's when parsing

    with open(args.template, 'r') as f:
        for line in f:
            processor.process_line(line)

    result = processor.result()

    if args.out == '-':
        sys.stdout.write(result)
    else:
        with open(args.out, 'w') as f:
            f.write(result)
