# This bash script accompanies the python script that downloads progress reports as PDFs.
# It needs to be run once per pod per copy needed
#
#for file in /home/rdegennaro/Documents/ProgressReportsQ2/Amy/*
#for file in /home/rdegennaro/Documents/ProgressReportsQ2/Judy/*
#for file in /home/rdegennaro/Documents/ProgressReportsQ2/June/*
#for file in /home/rdegennaro/Documents/ProgressReportsQ2/Kassandra/*
#for file in /home/rdegennaro/Documents/ProgressReportsQ2/Nora/*
for file in /home/rdegennaro/Documents/ProgressReportsQ2/Velma/*
do
  lp -d PrnAdmin "$file" >> results.out
done