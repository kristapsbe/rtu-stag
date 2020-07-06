cd ../samples
all_good=true

for f in *.fq.gz
do
    checksum="$(shasum -a512 $f)"

    if ! grep -q "$checksum" checksums.txt ; then
        echo "The checksum for $f could not be matched - please either delete the sample or redownload it"
        all_good=false
    fi
done

if ! $all_good; then
    echo "Please review damaged sample files and restart the script"
    exit 1
fi