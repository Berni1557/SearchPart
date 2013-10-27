function [mapH,mapV]=getResistor1206(S,scaleFactor,bar)
m=[5,5];
% use median filter to reduce noise
S1(:,:,1) = medfilt2(S(:,:,1),m);
S1(:,:,2) = medfilt2(S(:,:,2),m);
S1(:,:,3) = medfilt2(S(:,:,3),m);

% adaptive threshold to get binary image
ths=round(20*(0.4333/scaleFactor));
S2=adaptivethreshold(S1,[ths,ths],0,0);

bar.update();

% remove small objects (esepecially the number characters of the SMD parts
S4=bwareaopen(S2,round(800*(0.4333/scaleFactor)));
S5=~S4;

% size of the black recktangle of the SMD part
s1=55*(0.4333/scaleFactor);
s2=90*(0.4333/scaleFactor);

% filter all objects that area is to big
T2=bwareaopen(S5,round(s1*s2*1.3));
T3=S5;
T3(T2==1)=0;

% filter all objects that area is to small
T4=bwareaopen(T3,round(s1*s2*0.7));

STATS = regionprops(T4, 'Centroid','BoundingBox');
cent = cat(1, STATS.Centroid);
box = cat(1, STATS.BoundingBox);

% boundary size of the black rectangle of SMD parts
tol1=0.25*s1;
tol2=0.25*s2;
b11=s2-tol2;b12=s2+tol2;
b21=s1-tol1;b22=s1+tol1;

% filter all objects depending on height and width
indh=find((box(:,3)>b11) .* (box(:,3)<b12)  .* (box(:,4)>b21) .* (box(:,4)<b22));
indv=find((box(:,3)>b21) .* (box(:,3)<b22)  .* (box(:,4)>b11) .* (box(:,4)<b12));

bar.update();

% mark position of the SMD part in mapH for horizontal SMD parts
mapH=zeros(size(T4));
centh=cent(indh,:);
for i=1:size(indh,1)
    mapH(round(centh(i,2)),round(centh(i,1)))=1;
end

% mark position of the SMD part in mapV for vertical SMD parts
mapV=zeros(size(T4));
centv=cent(indv,:);
for i=1:size(indv,1)
    mapV(round(centv(i,2)),round(centv(i,1)))=1;
end

mapV=imrotate(mapV,90);

bar.update();

end

