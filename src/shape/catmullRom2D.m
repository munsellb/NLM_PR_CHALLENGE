function [contour,tangent,normals]=catmullRom2D(data, Tension)

[m,n]=size(data);

x=data(:,1);
y=data(:,2);

Px=zeros(1,m+2);
Py=zeros(1,m+2);

Px(1)=x(1);
Px(m+2)=x(m);
Px(2:m+1)=x(1:m);

Py(1)=y(1);
Py(m+2)=y(m);
Py(2:m+1)=y(1:m);
 
ix=[];
iy=[];

ixt=[];
iyt=[];

ixn=[];
iyn=[];

N=10;
u=[0:1/N:N/N]';
%s=(1-Tension)./2;
%M=[-s 2-s s-2 s; 2.*s s-3 3-(2.*s) -s; -s 0 s 0; 0 1 0 0];
M=[-1 3 -3 1; 2 -5 4 -1; -1 0 1 0; 0 2 0 0];
s=0.5;

for k=1:length(Px)-3
    P0=[Px(k),Py(k)];
    P1=[Px(k+1),Py(k+1)];
    P2=[Px(k+2),Py(k+2)];
    P3=[Px(k+3),Py(k+3)];
    P=[P0;P1;P2;P3];
    %U=[u.^3 u.^2 u ones(size(u,1),1)];
    U=[s*u.^3 s*u.^2 s*u s*ones(size(u,1),1)];
    Ut=[s*3*u.^2 s*2*u s*ones(size(u,1),1) zeros(size(u,1),1)];
    Un=[s*6*u s*2*ones(size(u,1),1) zeros(size(u,1),1) zeros(size(u,1),1)];
    pts=U*M*P;
    tpts=Ut*M*P;
    npts=Un*M*P;
    [mm,nn]=size(pts);
    if k~=1,
        ix=[ix, pts(2:mm,1)'];
        iy=[iy, pts(2:mm,2)'];
        ixt=[ixt, tpts(2:mm,1)'];
        iyt=[iyt, tpts(2:mm,2)'];
        ixn=[ixn, npts(2:mm,1)'];
        iyn=[iyn, npts(2:mm,2)'];
        
    else,
        ix=[ix, pts(:,1)'];
        iy=[iy, pts(:,2)'];
        ixt=[ixt, tpts(:,1)'];
        iyt=[iyt, tpts(:,2)'];
        ixn=[ixn, npts(:,1)'];
        iyn=[iyn, npts(:,2)'];
    end;
end

contour=[ix' iy'];
tangent=[ixt' iyt'];
normals=[ixn' iyn'];

    