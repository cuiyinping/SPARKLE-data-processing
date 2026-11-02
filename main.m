%%Code to process 1D TOCSY spectra-10.4142
clc;
clear all;
close all;

FIDpath='...\data1.fid';
updatedFidpath='...\data1-re.fid';
%setting parameter
fn=20000/2;
fn1=256;
focforfftspectra=0;
isatuoph=1;
pc1d=1;
pc2d=1;



%Read the some parameters that are required to process the data
Para=getpar(FIDpath,'ni','sw','np','sw1');

sw=Para.sw;
sw1=Para.sw1;
np=Para.np/2;
ni=Para.ni;


f=linspace(-sw/2,sw/2,fn);
f1=linspace(-sw1/2,sw1/2,fn1);



%Read the FID data
acount1=1;
FIDtime=zeros(ni,np);
for k=1:ni
    tic;
    [R,I]=load_fid(FIDpath(1:end-4),k);
    FIDdata=R+1i*I;
    FID2Dtime(k,:)=FIDdata;
    [R1,I1]=load_fid(updatedFidpath(1:end-4),k);

   toc;
   acount1=acount1+1;
end
acount2=1;
FF2Ddata=zeros(fn1,fn);

FF2Ddata(:,:)=fftshift(fft2(FID2Dtime(:,:),fn1,fn));
       
figure(1);
contour(f,f1,abs(FF2Ddata),10);

figure(2);
 plot(real(sum(FF2Ddata))) 
figure(3);
  plot(sum(real(FF2Ddata))) 
  
  
  
%  F1F2ok=zeros(fn1,fn);
%  for m=1:fn1
%      F1F2ok(m,:)=circshift(FF2Ddata(m,:),[0,round(fn*sw1*(m-fn1/2)/fn1/sw)]);
%  end

F1F2ok=doltrtshift(FF2Ddata,-1,sw,sw1);%改旋转角
figure(4);
contour(f,f1,abs(F1F2ok),10);

figure(5);
contour(f,f1,real(F1F2ok),10);
figure(6);
 plot(sum(real(F1F2ok))); 
figure(7);
plot(sum(abs(F1F2ok)));

updata=ifft2(F1F2ok');


for k=1:fn1
   updateFIDfile(updatedFidpath,updata(:,k),k);
end
  
  if(pc1d==1)
    phcf=[0 0];
    aph1dat=sum(F1F2ok);
    [aph1datph,phc0,phc1]=acme(aph1dat,phcf);
     figure(9);
    plot(real(aph1datph)) 
  end
  
  if(pc2d==1)
        phcf=[0 0];
    for ikk=1:fn1
       aph1dat=F1F2ok(ikk,:);
       [aph1datph,phc0,phc1]=acme(aph1dat,phcf);
       
       F1F2ok_PC(ikk,:)=aph1datph;
        phc0all(ikk)=phc0;
        phc1all(ikk)=phc1;
        
    end

 %%phase adjust
 if(isatuoph==1)
      figure(10);
 contour(real(F1F2ok_PC),4);
 
 figure(11);
 plot(real(sum(F1F2ok_PC))) 
     
 end

      
      
      
      
  end
  
  
%foc
 
 
if(focforfftspectra==1)        
FF2Ddatashearing1=doupdnshift(FF2Ddata_full,-1,sw,sw1);%该旋转角
figure(5);
contour(f,f,abs(FF2Ddatashearing1),10);
figure(6);
contour(f,f1,real(FF2Ddatashearing1),10);
figure(7);
 plot(real(sum(FF2Ddatashearing1))) 
 figure(8);
  plot(abs(sum(FF2Ddatashearing1)))


  
 aa7=zeros(fn,fn);
 
 aa7(fn/2-fn1/2+1:fn/2+fn1/2,:)=FF2Ddatashearing1;
 
     
 aa8=doupdnshift(aa7,1,sw,sw);
figure(10);
  contour(f,f,abs(aa8),10);
  
FF2Ddatashearing2=doltrtshift(FF2Ddatashearing1,-1,sw,sw1);%改旋转角
figure(9);
contour(f,f1,abs(FF2Ddatashearing2),10);
figure(10);
contour(f,f1,real(FF2Ddatashearing2),4);
figure(11);
plot(real(sum(FF2Ddatashearing2))) ;
figure(12);
plot(abs(sum(FF2Ddatashearing2))) ;

end



