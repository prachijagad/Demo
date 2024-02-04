close all;
clear all;

im = imread('Number Plate Images/image3.jpg');
figure;
subplot 231
imshow(im);
imgray = rgb2gray(im);
subplot 232
imshow(imgray);
imbin = imbinarize(imgray);
subplot 233
imwrite(imbin,'binimg.jpg') %save image
imshow(imbin);
im = edge(imgray, 'prewitt');  %detect edge from image
subplot 234
imshow(im);
imwrite(im,'edgebin.jpg')
%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;

   end
end    

im = imcrop(imbin, boundingBox);%crop the number plate area
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500
subplot 235
imshow(im);

 [h, w] = size(im);%get width

 
Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
noPlate=[]; % Initializing the variable of number plate string.
subplot 236
imshow(Iprops(2).Image)
for i=1:count
   ow = length(Iprops(i).Image(1,:)); %letter width
   oh = length(Iprops(i).Image(:,1));  %letter height
   if ow<(h/2) & oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter] % Appending every subsequent character in noPlate variable.
   end
end