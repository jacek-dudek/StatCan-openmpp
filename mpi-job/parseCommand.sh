#!/bin/bash

# Copy openm web service command arguments to an array:
declare -a args
i=0
for arg in "$@"; do
  args[$i]="$arg"
  echo "${args[$i]}"
  ((i=i+1))
done

# Make a copy of the MPIJobManifest template:
cp -o ./MPIJobTemplate.yaml ./MPIJob.yaml

# Go through the command arguments and make corresponding
# changes to the template copy to create an MPIJob manifest:
# Note that we can simplify the golang template to not output the unnecessary stuff, like "mpirun".
j=0
while [[ j -lt i ]]; do
  if [[ ${args[$j]} =~ mpirun ]]; then
    # Corresponding command is already in the manifest,
    # so nothing needs to be done.
    echo "Argument matches mpirun"
    ((j=j+1))
  
  elif [[ ${args[$j]} =~ [-]n && ${args[$((j+1))]} =~ [0-9]+ ]]; then
    # Set number of replicas to matching value:
    sed "s/#<numberOfReplicas>/${args[$j]}" ./MPIJob.yaml
    ((j=j+2))

  elif [[ ${args[$j]} =~ --bind-to ]]; then
    # Not sure if we need to preserve this option in the manifest version of the mpirun command.
    # Maybe create a #bind-to placeholder in the manifest and copy the setting.
    sed "s/#<mpirunOption>/${args[$j]}" ./MPIJob.yaml
    ((j=j+2))

  elif [[ ${args[$j]} =~ -wdir && -d ${args[$((j+1))]} ]]; then
    # Will have to ask Pat about how filesystem contexts need to be set up for mpi operator execution.
    echo "Arguments match the working directory option."
    ((j=j+2))

  elif [[ ${args[$j]} =~ [-]x && ${args[$((j+1))]} =~ [a-zA-Z_]+[a-zA-Z0-9_]*=[~=]* []]

  else 
    echo "Unrecognized argument."
    ((j=j+1))
  fi

done


# Number of worker pods to use:
 
# Name of model file to run:
# Look for argument that's a valid path and whose file type is 

# Once we have all those, read in the yaml template
# and carry out substitutions: 
template=$(< MPIJob.yaml)


# Pipe the modified template out to kubectl:
echo $template
