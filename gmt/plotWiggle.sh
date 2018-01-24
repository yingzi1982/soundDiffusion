#!/bin/bash
source /usr/share/modules/init/bash
module load apps gmt/intel/5.1.0

rm gmt.conf
rm gmt.history

gmt gmtset MAP_FRAME_AXES WeSn
gmt gmtset MAP_FRAME_TYPE plain
gmt gmtset MAP_FRAME_PEN thick
gmt gmtset MAP_TICK_PEN thick
gmt gmtset MAP_TICK_LENGTH_PRIMARY -3p
#gmt gmtset MAP_DEGREE_SYMBOL none
#gmt gmtset MAP_GRID_CROSS_SIZE_PRIMARY 0.0i
#gmt gmtset MAP_GRID_CROSS_SIZE_SECONDARY 0.0i
#gmt gmtset MAP_GRID_PEN_PRIMARY thin,black
#gmt gmtset MAP_GRID_PEN_SECONDARY thin,black
gmt gmtset MAP_ORIGIN_X 100p
gmt gmtset MAP_ORIGIN_Y 100p
#gmt gmtset FORMAT_GEO_OUT +D
gmt gmtset COLOR_NAN 255/255/255
gmt gmtset COLOR_FOREGROUND 255/255/255
gmt gmtset COLOR_BACKGROUND 0/0/0
gmt gmtset FONT 12p,Helvetica,black
#gmt gmtset FONT 9p,Times-Roman,black
#gmt gmtset PS_MEDIA custom_2.8ix2.8i
gmt gmtset PS_MEDIA letter
gmt gmtset PS_PAGE_ORIENTATION portrait
#gmt gmtset GMT_VERBOSE d

figfolder=../figures/
length=2.0i
height=2.2i
horizontal_shift=2.1i
#---------------------------------------------------------
type=sh
component=Y
name=combinedTrace_$component\_1
backupfolder=../$type/0/backup/
backupfolder2=../$type/12/backup/
lambda=`cat $backupfolder\lambda`
xy=$backupfolder$name
xy2=$backupfolder2$name
receiver=$backupfolder\receiver
receiver_range=`awk -v lambda="$lambda" '{print +$1/lambda}' $receiver`
receiver_number=`cat $receiver | wc -l`
receiver_start=`awk -v lambda="$lambda" 'NR==1 {print +$1/lambda}' $receiver`
receiver_end=`awk -v lambda="$lambda" 'END {print +$1/lambda}' $receiver`
receiver_spacing=`echo "($receiver_end-($receiver_start)) / ($receiver_number-1)" | bc -l`
scale=`echo "2/$receiver_spacing" | bc -l`
xmin=`echo "$receiver_start-$receiver_spacing" | bc -l`
xmax=`echo "$receiver_end+$receiver_spacing" | bc -l`
ymin=0
ymax=10
centralTime=15
region=$xmin/$xmax/$ymin/$ymax
projection=X$length/-$height
time_resample=5

ps=$figfolder\wiggle_$type.ps
eps=$figfolder\wiggle_$type.eps
pdf=$figfolder\wiggle_$type.pdf

#gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset (@~l@~@-s@-)" -Bya5f2.5+l"Time (s)" -K > $ps
gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset" -Bya5f2.5+l"Time (s)" -K > $ps


col=2
for range in $receiver_range
do
cat $xy2 | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-blue -G+blue -P -Wthinnest,black -O -K >> $ps
cat $xy | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-red -G+red -P -Wthinnest,black -O -K >> $ps
let "col++"
done
gmt pslegend -R -J -D-2.5/-11.25/3i/TL -Fthick -O -K << END >> $ps
S 0i s 0.05i 255/0/0 0.25p 0.1i 0% 
END
gmt pslegend -R -J -D0/-11.25/3i/TL -Fthick -O << END >> $ps
S 0i s 0.05i 0/0/255 0.25p 0.1i 12% 
END
#---------------------------------------------------------

ps2raster -A -Te $figfolder$ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps
#---------------------------------------------------------
gmt gmtset MAP_FRAME_AXES WeSn
type=psv
component=X
name=combinedTrace_$component\_1
backupfolder=../$type/0/backup/
backupfolder2=../$type/12/backup/
lambda=`cat $backupfolder\lambda`
xy=$backupfolder$name
xy2=$backupfolder2$name
receiver=$backupfolder\receiver
receiver_range=`awk -v lambda="$lambda" '{print +$1/lambda}' $receiver`
receiver_number=`cat $receiver | wc -l`
receiver_start=`awk -v lambda="$lambda" 'NR==1 {print +$1/lambda}' $receiver`
receiver_end=`awk -v lambda="$lambda" 'END {print +$1/lambda}' $receiver`
receiver_spacing=`echo "($receiver_end-($receiver_start)) / ($receiver_number-1)" | bc -l`
scale=`echo "2/$receiver_spacing" | bc -l`
xmin=`echo "$receiver_start-$receiver_spacing" | bc -l`
xmax=`echo "$receiver_end+$receiver_spacing" | bc -l`
ymin=0
ymax=10
centralTime=15
region=$xmin/$xmax/$ymin/$ymax
projection=X$length/-$height
time_resample=5

ps=$figfolder\wiggle_$type.ps
eps=$figfolder\wiggle_$type.eps
pdf=$figfolder\wiggle_$type.pdf

#gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset (@~l@~@-s@-)" -Bya5f2.5+l"Time (s)" -K > $ps
gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset" -Bya5f2.5+l"Time (s)" -K > $ps


col=2
for range in $receiver_range
do
cat $xy2 | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-blue -G+blue -P -Wthinnest,black -O -K >> $ps
cat $xy | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-red -G+red -P -Wthinnest,black -O -K >> $ps
let "col++"
done
echo "-5.5 -0.95 (a)" | gmt pstext -R -J -F+jTL -N -O -K >> $ps
gmt pslegend -R -J -D-2.5/-11.25/3i/TL -Fthick -O -K << END >> $ps
S 0i s 0.05i 255/0/0 0.25p 0.1i 0% 
END
gmt pslegend -R -J -D0/-11.25/3i/TL -Fthick -O -K << END >> $ps
S 0i s 0.05i 0/0/255 0.25p 0.1i 12% 
END
#---------------------------------------------------------
gmt gmtset MAP_FRAME_AXES wesn
component=Z
name=combinedTrace_$component\_1
backupfolder=../$type/0/backup/
backupfolder2=../$type/12/backup/
lambda=`cat $backupfolder\lambda`
xy=$backupfolder$name
xy2=$backupfolder2$name
receiver=$backupfolder\receiver
receiver_range=`awk -v lambda="$lambda" '{print +$1/lambda}' $receiver`
receiver_number=`cat $receiver | wc -l`
receiver_start=`awk -v lambda="$lambda" 'NR==1 {print +$1/lambda}' $receiver`
receiver_end=`awk -v lambda="$lambda" 'END {print +$1/lambda}' $receiver`
receiver_spacing=`echo "($receiver_end-($receiver_start)) / ($receiver_number-1)" | bc -l`
scale=`echo "2/$receiver_spacing" | bc -l`
xmin=`echo "$receiver_start-$receiver_spacing" | bc -l`
xmax=`echo "$receiver_end+$receiver_spacing" | bc -l`
ymin=0
ymax=10
centralTime=15
region=$xmin/$xmax/$ymin/$ymax
projection=X$length/-$height
time_resample=5

#gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset (@~l@~@-s@-)" -Bya5f2.5+l"Time (s)" -X$horizontal_shift -K -O >> $ps
gmt psbasemap -R$region -J$projection -Bxa5f2.5+l"Horizontal offset" -Bya5f2.5+l"Time (s)" -X$horizontal_shift -K -O >> $ps


col=2
for range in $receiver_range
do
cat $xy2 | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-blue -G+blue -P -Wthinnest,black -O -K >> $ps
cat $xy | awk -v centralTime="$centralTime" -v col="$col" -v range="$range" -v time_resample="$time_resample" 'NR%time_resample==0 { print range,$1-centralTime,$col}' | gmt pswiggle -R -J -Z$scale -G-red -G+red -P -Wthinnest,black -O -K >> $ps
let "col++"
done
echo "-5.5 -0.95 (b)" | gmt pstext -R -J -F+jTL -N -O >> $ps
#---------------------------------------------------------

ps2raster -A -Te $figfolder$ps -D$figfolder
epstopdf --outfile=$pdf $eps
rm -f $ps
