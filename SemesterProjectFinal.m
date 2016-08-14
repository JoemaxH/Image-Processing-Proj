%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Semester Project
%%% Split Depth Gifs and Image Processing
%%% CpE 5450
%%% Joseph Max Huhman 
%%% 11/21/15
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MUST HAVE gifread and gifwrite FUNCTIONS
%can be found here:
%http://www.mathworks.com/matlabcentral/fileexchange/52514-tools-to-read-and-write-animated-gif-files/content/gifread.m
%
% read gifread documentation for more details
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Program Description
%%%     Takes input variables (listed below) and an input .gif file
%%% and detects edges from in focus objects in the foreground
%%% and occludes around the foreground element. The gif is converted
%%% into a 4d array with the gifread function and then each frame is 
%%% converted into grayscale and hsv values and then use a 
%%% prespecified filter to create a "edge map". Then the origial
%%% RGB 4d array frames are edited to add white bars up to the edges
%%% found in the "edge maps". The result is then exported with gifwrite
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;
%%% Important input parameters
sdStartR = 300; %column # the right bar starts on
sdStartL = 80; %column # the left bar starts on
sdThickness = 10; %thickness of split depth bars
gifDelay = 0.1; %delay in seconds of each image
gifName = 'potter.gif'; %name of input gif
outputGifName = 'outpotter.gif'; %name of ouptput gif
edgeMethod = 'sobel';%type of filter to use
sdPadStart = 0;%solid bar frames to add bars at the beginning
sdPadEnd = 5;%solid bar frames to append to the end

%pass image
gif =gifread(gifName);

[r, c, z, frame] = size(gif);
gifBW = zeros(r, c, frame, 'uint8');
%edge detection

%info=imfinfo(gifName); old method for changing colormap 
edge1= logical(gifBW);
for i=1:frame
  HSV = rgb2hsv(gif(:,:,:,i));%convert frames from rgb to hsv
  gray = rgb2gray(gif(:,:,:,i));%convert frames from rgb to gray
  %figure, imshow(gray); %visual
  %figure, imshow(HSV(:,:,2));
  edge1(:,:,i)= edge(gray, edgeMethod);%creates edges using given method and grayscale
  edge2(:,:,i)= edge(HSV(:,:,3), edgeMethod);%creates edges using given method and hsv
  figure, imshow(edge1(:,:,i));%display edges
  figure, imshow(edge2(:,:,i));
  
end
for n =1:frame
  %add split depth stripes
  %for loop only traverses the potential area of the reference bar
  for i = sdStartL:sdStartL+sdThickness
      for j = 1:r
          if edge2(j,i,n)== 0%adds white bar if no edge detected
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
          else
              break;
          end
      end
  end

%same process but from the bottom of the frame
  for i = sdStartL:sdStartL+sdThickness
      for j = r:-1:1 %decrementing for loop
          if edge2(j,i,n)== 0
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
          else
              break;
          end
      end
  end
end
%%%Same process but for a second white reference bar
for n =1:frame
  %add split depth stripes
  for i = sdStartR:sdStartR+sdThickness
      for j = 1:r
          if edge2(j,i,n)== 0
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
          else
              break;
          end
      end
  end


  for i = sdStartR:sdStartR+sdThickness
      for j = r:-1:1 %decrementing for loop
          if edge2(j,i,n)== 0
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
          else
              break;
          end
      end
  end
end
%%% ADDING SOLID BAR FRAMES 
%simply appends the full area of the reference bar for that frame
%%%adding to the beginning
for n=1:sdPadStart
  for i = sdStartR:sdStartR+sdThickness
      for j = r:-1:1 %decrementing for loop
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
      end
  end
end
for n=1:sdPadStart
  for i = sdStartL:sdStartL+sdThickness
      for j = r:-1:1 %decrementing for loop
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
      end
  end
end
%%%appending to the end
for n=frame-sdPadEnd:frame
  for i = sdStartR:sdStartR+sdThickness
      for j = r:-1:1 %decrementing for loop
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
      end
  end
end
for n=frame-sdPadEnd:frame
  for i = sdStartL:sdStartL+sdThickness
      for j = r:-1:1 %decrementing for loop
              gif(j, i, 1, n) = 255;
              gif(j, i, 2, n) = 255;
              gif(j, i, 3, n) = 255;
      end
  end
end
gifwrite(gif, outputGifName, gifDelay);
