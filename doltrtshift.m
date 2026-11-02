function y=doltrtshift(arrA,alfa,sw,sw1)
%y=doltrtshift(arrA,alfa)
%arrA: spectrum data matrix
%alfa: the angle between vertical axis and data vector. if alfa>0, anti-clockwise shift. if alfa<0, clockwise shift.
global winMain

tic;	%Begin timer

if(nargin<2)
	alfa=1; % the shearing angle is arctan(alfa)
end

set(winMain,'Pointer','watch');
[iF1,iF2]=size(arrA);
disp('Begin LtRt shifting...');

if (alfa>0) %(alfa>0, anti-clockwise shift)
	for(ii=1:1:iF1/2)
	    kk=round(((iF1+1)/2-ii)*alfa*(sw1/sw)*(iF2/iF1));
	    if(kk>0)
	        for(jj=iF2-kk:-1:1)
	            arrA(ii,jj+kk)=arrA(ii,jj);
	            arrA(ii,jj)=0;
	        end
	    end
	end

	for(ii=(iF1/2+1):1:iF1)
	    kk=round((ii-(iF1+1)/2)*alfa*(sw1/sw)*(iF2/iF1));
	    if(kk>0)
	        for(jj=1+kk:1:iF2)
	            arrA(ii,jj-kk)=arrA(ii,jj);
	            arrA(ii,jj)=0;
	        end
	    end
	end
else	%(alfa<0, clockwise shift)
	alfa=-alfa;
	for(ii=1:1:iF1/2)
	    kk=round(((iF1+1)/2-ii)*alfa*(sw1/sw)*(iF2/iF1));
	    if(kk>0)
	        for(jj=1+kk:1:iF2)
	            arrA(ii,jj-kk)=arrA(ii,jj);
	            arrA(ii,jj)=0;
	        end
	    end
	end

	for(ii=(iF1/2+1):1:iF1)
	    kk=round((ii-(iF1+1)/2)*alfa*(sw1/sw)*(iF2/iF1));
	    if(kk>0)
	        for(jj=iF2-kk:-1:1)
	            arrA(ii,jj+kk)=arrA(ii,jj);
	            arrA(ii,jj)=0;
	        end
	    end
	end
end
y=arrA;
set(winMain,'Pointer','arrow');
disp(['Done of LtRt shift. It took ' num2str(toc) ' s']);
