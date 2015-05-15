if [ $# -ne 2 ]; then
	cat <<HERE 

	Usage unpaper.sh <pdf file> <output-pages>
	where 
		output-pages 1 means single page to single page
		output-pages 2 means single page to double page
	
HERE
	exit 0;
fi

if [ "$2" -eq 2 ]; then
	opts="--layout double --size a4-landscape --input-pages 1 --output-pages 2"
else
	opts="--layout single --size a4 -ip 1 -op 1"
fi
echo $opts
echo "Converting PDF to ppm....."
echo pdftoppm "$1" scan
pdftoppm "$1" scan

echo "Renaming files for unpaper consumption..."
nmb=1
for i in scan*.ppm
do
	str=`printf "%03d" $nmb`
	if [ "$i" != "$str" ]; then
		mv $i scan-$str.ppm
	fi
	nmb=$(($nmb+1))
	echo $i/scan-$str.ppm
done

echo "Running unpaper....."
# this is for converting 2 sided to 1 sided on a4-landscape input to 
# a4 portrait output
unpaper -v -gs 5,5 -gp 5,5 -gt 0.5 $opts scan-%03d.ppm unpaper-%03d.ppm
for i in unpaper*.ppm
do
	echo "Converting $i to ${i%%.ppm}.tiff....."
	ppm2tiff $i ${i%%.ppm}.tiff 
done
echo "Combining all tiff files into all.tiff"
tiffcp *.tiff all.tiff
echo "Converting back to pdf"
echo tiff2pdf -z -o ${1%%.pdf}_unpaper.pdf all.tiff 
tiff2pdf -z -o ../${1%%.pdf}_unpaper.pdf all.tiff 
rm -f *.tiff 
rm -f scan*.ppm
rm -f unpaper*.ppm
#rm $1
