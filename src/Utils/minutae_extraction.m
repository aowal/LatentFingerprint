

function [outImg] = minutae_extraction(binary_image)

    %Small region is taken to show output clear
    binary_image=im2bw(binary_image);
    binary_image = binary_image(120:400,20:250);

    %Thinning
    thin_image=~bwmorph(binary_image,'thin',Inf);

    %Minutiae extraction
    s=size(thin_image);
    N=3;%window size
    n=(N-1)/2;
    r=s(1)+2*n;
    c=s(2)+2*n;
    double temp(r,c);   
    temp=zeros(r,c);bifurcation=zeros(r,c);ridge=zeros(r,c);
    temp((n+1):(end-n),(n+1):(end-n))=thin_image(:,:);
    outImg=zeros(r,c,3);%For Display
    outImg(:,:,1) = temp .* 255;
    outImg(:,:,2) = temp .* 255;
    outImg(:,:,3) = temp .* 255;
    for x=(n+1+10):(s(1)+n-10)
        for y=(n+1+10):(s(2)+n-10)
            e=1;
            for k=x-n:x+n
                f=1;
                for l=y-n:y+n
                    mat(e,f)=temp(k,l);
                    f=f+1;
                end
                e=e+1;
            end;
             if(mat(2,2)==0)
                ridge(x,y)=sum(sum(~mat));
                bifurcation(x,y)=sum(sum(~mat));
             end
        end;
    end;

    % RIDGE END FINDING
    [ridge_x ridge_y]=find(ridge==2);
    len=length(ridge_x);
    %For Display
    for i=1:len
        outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),2:3)=0;
        outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),2:3)=0;
        outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;
        outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;

        outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),1)=255;
        outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),1)=255;
        outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
        outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
    end

    %BIFURCATION FINDING
    [bifurcation_x bifurcation_y]=find(bifurcation==4);
    len=length(bifurcation_x);
    %For Display
    for i=1:len
        outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),1:2)=0;
        outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),1:2)=0;
        outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;
        outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;

        outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),3)=255;
        outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),3)=255;
        outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
        outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
    end
end