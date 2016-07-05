import os
import sys


def read_ln_file(filename):
  fp = open(filename, 'r')
  content = fp.read()
  fp.close()
  accum = []
  for line in content.split('\n'):
    if not line:
      continue
    if line[0] == ';':
      continue
    (oper, address, label) = line.split()
    accum.append([address, label])
  accum.sort(key=lambda x: x[0])
  return accum

def run():
  file_ln = sys.argv[1]
  ln_data = read_ln_file(file_ln)
  for address,label in ln_data:
    address = address[2:]
    label = label[1:]
    if label[0:6] == '__BSS_':
      continue
    rom_start = ('%04x' % ((int(address,16) / 0x4000) * 0x4000)).upper()
    sys.stdout.write('$%s#%s#\n' % (address,label))


if __name__ == '__main__':
  run()
