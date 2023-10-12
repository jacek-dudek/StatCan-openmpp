import sys
import re
import os

# Working directory is assumed to be: /opt/openmpp/<openmpp-root-dir>/

with open("./etc/MPIJobTemplate.yaml") as template:
  manifest = template.read()

i = 1
while i < len(sys.argv):
  if (i + 1 < len(sys.argv) and re.match("^-modelName$", sys.argv[i])):
    manifest = manifest.replace("#<modelName>", f"{sys.argv[i+1]}".lower())
    i += 2

  elif (i + 1 < len(sys.argv) and re.match("^-n$", sys.argv[i]) and re.match("^[0-9]+$", sys.argv[i+1])):
    #print("Found the number of replicas option and argument.")
    manifest = manifest.replace("#<numberOfReplicas>", f"{sys.argv[i+1]}")
    manifest = manifest.replace("#<mpirunOption>", \
      f"- -n\n{12*' '}- '{sys.argv[i+1]}'\n{12*' '}#<mpirunOption>)")
    i += 2

  elif (i + 1 < len(sys.argv) and re.match("^--bind-to$", sys.argv[i]) \
  and re.match("^(core|socket|none)$", sys.argv[i+1])):
    #print("Found the bind-to option and argument.")
    manifest = manifest.replace("#<mpirunOption>", \
      f"- --bind-to\n{12*' '}- {sys.argv[i+1]}\n{12*' '}#<mpirunOption>")
    i += 2
  
  elif (i + 1 < len(sys.argv) and re.match("^-wdir$", sys.argv[i]) and os.path.isdir(sys.argv[i+1])):
    #print("Found the working directory option and valid path.")
    manifest = manifest.replace("#<mpirunOption>", \
      f"- -wdir\n{12*' '}- {sys.argv[i+1]}\n{12*' '}#<mpirunOption>")
    i += 2

  elif (i + 1 < len(sys.argv) and re.match("^-x$", sys.argv[i]) \
  and re.match("[a-zA-Z_][a-zA-Z0-9_]*=[^=]+$", sys.argv[i+1])):
    manifest = manifest.replace("#<mpirunOption>", \
      f"- -x\n{12*' '}- {sys.argv[i+1]}\n{12*' '}#<mpirunOption>")
    #print("Found mpirun environment variable option.")
    i += 2

  elif (i < len(sys.argv) and os.path.isfile(sys.argv[i]) and re.match(".*_mpi$", sys.argv[i])):
    #print("Found model executable name.")
    manifest = manifest.replace("#<modelExecutable>", f"- {sys.argv[i]}")
    i += 1

  elif (i + 1 < len(sys.argv) and re.match("^-OpenM\.", sys.argv[i]) \
  and re.match("[a-zA-Z0-9_/\.-]+", sys.argv[i+1])):
    #print("Found an OpenM option and argument.")
    manifest = manifest.replace("#<OpenMOption>", \
      f"- {sys.argv[i]}\n{12*' '}- '{sys.argv[i+1]}'\n{12*' '}#<OpenMOption>") 
    i += 2

  else:
    i += 1

print(manifest)
