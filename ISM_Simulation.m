close all;clear;clc;

%% PSF and target
PSF_nonscatter = imread('PSF_Gauss.png');
PSF_nonscatter=double(PSF_nonscatter);
PSF_nonscatter=PSF_nonscatter/max(PSF_nonscatter(:));
sample=imread('Lines.png');
sample=double(sample);
sample=sample/max(sample(:));
PSF_scatter = imread('PSF_scatter.png');
PSF_scatter=double(PSF_scatter);
PSF_scatter=PSF_scatter/max(PSF_scatter(:));
%% ====Wide field Non-Scattering imaging==== %%
I_Scan1 = zeros(256,256);
for i= 1:256  
        for j=1:256
            Scan1 =  PSF_nonscatter.* sample(i:i+256-1,j:j+256-1);
            I_Scan1(i,j) = sum(Scan1(:));        
        end
end
figure(4)
imshow(I_Scan1,[])
title('Wide field Non-Scattering')
% imwrite(I_Scan1/max(I_Scan1(:)),'Wide field Non-Scattering.png')

%% ==== Wide field Scattering imaging ==== %%
I_Scan2 = zeros(256,256);
for i= 1:256  
        for j=1:256
            Scan2 =  PSF_scatter.* sample(i:i+256-1,j:j+256-1);
            I_Scan2(i,j) = sum(Scan2(:));        
        end
end
figure(5)
imshow(I_Scan2,[])
title('Wide field Scattering')
% imwrite(I_Scan2/max(I_Scan2(:)),'Wide field Scattering.png')

%% ==== Wide field Scattering Correction imaging ==== %%
I_Scan3 = zeros(256,256);
PSF_Correct = imread('PSF_Correct.png');
PSF_Correct = double(PSF_Correct);
PSF_Correct = PSF_Correct/max(PSF_Correct(:));
PSF_Det = PSF_Correct;
for m= 1:256 
        for n=1:256
            Scan3 =  PSF_Correct.* sample(m:m+256-1,n:n+256-1);
            I_Scan3(m,n) = sum(Scan3(:));
            Scan3 = conv2(Scan3,PSF_Det,'same');
            I_max(m,n) = max(Scan3(:));
            Scan3 = Scan3/ 3.6479;
            imwrite(Scan3,strcat('Scan\','I_',num2str(m),'_',num2str(n),'.png'))
        end
end
max(I_max(:))
figure(6)
imshow(I_Scan3,[])
title('Wide field Scattering Correction')
% imwrite(I_Scan3/max(I_Scan3(:)),'Wide field Scattering Correction.png')

%% ====ISM Reconstruction/ PSF resize====== %%
ISM_Resize=zeros(384,384);
for p=1:256
    for q=1:256
        IPSF_Ori_1=imread(strcat('Scan\','I_',num2str(p),'_',num2str(q),'.png'));
        IPSF_Ori_1=double(IPSF_Ori_1);
        IPSF_Resize=imresize(IPSF_Ori_1, 0.5);
        ISM_Resize(p:p+128-1,q:q+128-1)= IPSF_Resize+ISM_Resize(p:p+128-1,q:q+128-1);  
     end
end
ISM_Resize = ISM_Resize/max(ISM_Resize(:));
figure(7)
imshow(ISM_Resize,[])
title('ISM Reconstruction')
% imwrite(ISM_Resize(65:320,65:320),'ISM_Reconstruction.png')
ISM_Resize_deconv = deconvlucy(ISM_Resize,(PSF_Correct.*PSF_Det));
ISM_Resize_deconv = ISM_Resize_deconv/max(ISM_Resize_deconv(:));
figure(8)
imshow(ISM_Resize_deconv,[])
title('ISM Reconstruction Deconvolution')
% imwrite(ISM_Resize_deconv(65:320,65:320),'ISM Reconstruction Deconvolution.png'))