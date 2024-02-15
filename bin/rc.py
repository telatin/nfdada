#!/usr/bin/env python

import argparse

def rc(sequence):
    # Reverse complement using IUPAC degenerate base, maintain case as input
    # https://www.bioinformatics.org/sms/iupac.html
    complement = {'A': 'T', 
                  'T': 'A', 
                  'C': 'G', 
                  'G': 'C', 
                  'N': 'N',
                  'R': 'Y', 
                  'Y': 'R', 
                  'S': 'S', 
                  'W': 'W', 
                  'K': 'M',
                  'M': 'K', 
                  'B': 'V', 
                  'D': 'H', 
                  'H': 'D', 
                  'V': 'B',
                  'a': 't', 
                  't': 'a', 
                  'c': 'g', 
                  'g': 'c', 
                  'n': 'n',
                  'r': 'y', 
                  'y': 'r', 
                  's': 's', 
                  'w': 'w', 
                  'k': 'm',
                  'm': 'k', 
                  'b': 'v', 
                  'd': 'h', 
                  'h': 'd', 
                  'v': 'b'}
    return ''.join([complement[base] for base in sequence[::-1]])
def main():
    args = argparse.ArgumentParser()
    args.add_argument('SEQ', help='Input sequence')

    args = args.parse_args()

    print( rc(args.SEQ) )

if __name__ == '__main__':
    main()