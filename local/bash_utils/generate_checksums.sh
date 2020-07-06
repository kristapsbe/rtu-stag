# we've encountered a rather annoying problem in that files may get slightly crippled while getting transferred over the network
#
# we need to ensure that they make it over in one piece
# current plan is:
#         fetch all files
#         verify that everything opens
#         save checksums to file that will be uploaded along with the samples
#         check against checksums after downloading to ensure that samples have not been crippled

cd ../../samples

rm checksums.txt
touch checksums.txt

for f in *.fq.gz
do
    shasum -a512 $f >> checksums.txt
done