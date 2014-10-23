% Aysar Khalid and Gonghe Shi
% Problem 1: Adaptive Thresholding
% The following function takes an image, fits a plane, It, and then
% thresholds the image with the plane.
% Ensure an image, I, is uncommented first before running.
function [  ] = p1(  )
    close all;
%     I = rgb2gray(imread('images/2x2.png'));
%     I = rgb2gray(imread('images/small2.png')); b_1=140; b_2=200;
%     I = rgb2gray(imread('images/jack.png')); b_1=140; b_2=200;
%     I = rgb2gray(imread('images/brain.jpg')); b_1=140; b_2=200;
%     I = rgb2gray(imread('images/virus.jpg')); b_1=140; b_2=200;
%     I = rgb2gray(imread('images/bacteria.jpg')); b_1=140; b_2=200;
%      I = rgb2gray(imread('images/light.jpg')); b_1=240; b_2=260;
     I = rgb2gray(imread('images/winter.jpg')); b_1=100; b_2=150;
     
    [n m] = size(I);
    
    It = ones(n,m);
    It_adaptive = zeros(n,m);
    w_size = floor(n/2); %create an NxN window
    
    % Adaptive Threshold v2
%     for p= 1+w_size: 50 : n-w_size
%         for q= 1+w_size: 50 : m-w_size
%             sub_n = p+w_size;
%             sub_m = q+w_size;
%             subimage = I(p-w_size:sub_n, q-w_size:sub_m);
%             I_avg = mean(mean(subimage));
%             b = [I_avg; I_avg*130; I_avg*160];
%             M = [1 (sub_n+1)/2 (sub_m+1)/2; 
%                 (sub_n+1)/2 ((sub_n+1)*(2*sub_n+1))/6 ((sub_n+1)*(sub_m+1))/4;
%                 (sub_m+1)/2 ((sub_n+1)*(sub_m+1))/4 ((sub_m+1)*(2*sub_m+1))/5];
% 
%             alpha = M\b; %solves for a in Ma=b
%             
%             get the threshold
%             for i=1:sub_n
%                for j=1:sub_m
%                    It_temp = alpha(1) + alpha(2)*i + alpha(3)*j;
%                    if (It(i,j) == 1)
%                        It(i,j) = It_temp;
%                        if (I(i,j) < It(i,j))
%                            It_adaptive(i,j) = 0; %black
%                        elseif (I(i,j) > It(i,j))
%                            It_adaptive(i,j) = 255;
%                        end
%                    end
%                end
%             end
%         end
%     end

    % Adaptive Threshold v1
    I_avg = mean(mean(I));
    b = [I_avg; I_avg*b_1; I_avg*b_2];
    M = [1 (n+1)/2 (m+1)/2; 
        (n+1)/2 ((n+1)*(2*n+1))/6 ((n+1)*(m+1))/4;
        (m+1)/2 ((n+1)*(m+1))/4 ((m+1)*(2*m+1))/5];

    alpha = M\b; %solves for a in Ma=b
    
    It = I;
    for i=1:n
       for j=1:m
           It(i,j) = alpha(1) + alpha(2)*i + alpha(3)*j;
           if (I(i,j) < It(i,j))
               It_adaptive(i,j) = 0;
           elseif (I(i,j) > It(i,j))
               It_adaptive(i,j) = 255;
           end
       end
    end
    
    % Simple thresholding
    It_simple = I;
    for i=1:n
       for j=1:m
           if (I(i,j) < I_avg)
               It_simple(i,j) = 0; 
           elseif (I(i,j) > I_avg)
               It_simple(i,j) = 255;
           end
       end
    end
    
    subplot(1,4,1);
    imshow(I);
    title('Original');
    
    subplot(1,4,2);
    imshow(It_simple);
    title('Simple Threshold');
    
    subplot(1,4,3);
    imshow(It);
    title('Planar Threshold');
    
    subplot(1,4,4);
    imshow(It_adaptive);
    title('Adaptive Threshold');    
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
end

