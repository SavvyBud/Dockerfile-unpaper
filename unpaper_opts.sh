_pdfFile=$1
_pageNo=${2:-1}
pdftoppm -f $_pageNo -l $_pageNo $_pdfFile scan

nmb=1
for i in scan*.ppm
do
	nmb=`printf "%03d" $nmb`
	if [ "$i" != "$nmb" ]; then
		mv $i scan-$nmb.ppm
	fi
	nmb=$(($nmb+1))
done

echo "Created following files:"
ls scan*

nmb=0
while [ "$nmb" -le 9 ]
do

	str="0.$nmb"
	unpaper -v -gs 5,5 -gp 5,5 -gt $str --layout double --size a4-landscape scan-001.ppm unpaper-001-$nmb.ppm

	nmb=$(($nmb+1))
done
