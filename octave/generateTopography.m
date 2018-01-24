#!/usr/bin/env octave
clear all
close all
clc

topoType = input('Please input the topography type of interface: ','s');

[xminStatus xmin] = system('grep xmin ../backup/Par_file_part | cut -d = -f 2');
xmin = str2num(xmin);

[xmaxStatus xmax] = system('grep xmax ../backup/Par_file_part | cut -d = -f 2');
xmax = str2num(xmax);

[nxStatus nx] = system('grep nx ../backup/Par_file_part | cut -d = -f 2');
nx = str2num(nx);
xNumber = nx + 1;

%[NELEM_PML_THICKNESSStatus NELEM_PML_THICKNESS] = system('grep NELEM_PML_THICKNESS ../backup/Par_file_part | cut -d = -f 2');
%NELEM_PML_THICKNESS = str2num(NELEM_PML_THICKNESS);

%win = [zeros(2*NELEM_PML_THICKNESS,1); transpose(welchwin(xNumber - 4*NELEM_PML_THICKNESS)); zeros(2*NELEM_PML_THICKNESS,1)];

%dx = (xmax-xmin)/xNumber;


x = transpose(linspace(xmin,xmax,xNumber));

topoMean = max(x)*0.6;
topoCorrLen = 0.2;
topoAmp = 1/4*topoCorrLen;

switch topoType
  case 'flat'
  topo = topoMean * ones(size(x));
  case 'cos'
  topo = topoMean + topoAmp*cos(2*pi/topoCorrLen*x);
  otherwise
  error('Wrong topography type\n')
end

wallThickness = 0.3;
backTopo = topoMean * ones(size(x)) + wallThickness;

topo = [x topo];
backTopo = [x backTopo];

save('-ascii','../backup/topo','topo')
save('-ascii','../backup/backTopo','backTopo')

topoPolygon = [topo; flipud(backTopo)];

save('-ascii','../backup/topoPolygon','topoPolygon')
