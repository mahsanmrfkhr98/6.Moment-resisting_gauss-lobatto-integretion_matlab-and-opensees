clc;clear all;close all;
%tarif hendeseye saze
 %L=[1,2,3];
 %teta_i=[teta1,teta2,teta3,teta4];
 %width of sections:W=[b1,b2,b3,b4];
 %height of sections:H=[h1,h2,h3,h4];
 %Area_section_i:A_i=[b1H1,b2H2,b3H3,b4H4];
 %number of elements:i
 %number of integeration points:j
 %number of fibers:k
 
teta=[61.2,0,0,-90];
L=[(156^2+(156/tand(61.2))^2)^0.5,120,240,120];
H=[12,14,14,16];
b=[30,30,30,24];
sigmay=36000;
E=30000000;
alpha=0.02;
strainy=sigmay/E;
p_Ext=[0;0;0;2100000;0;0;0;-300000;0;0;0;-100000;0;0;0];
tol=1*10^(-4);
Restr=[1;2;3;13;14;15];
DoFs=[1,2,3,4,5,6;
      4,5,6,7,8,9;
      7,8,9,10,11,12;
      10,11,12,13,14,15];
Nf=6;
%%%%%%%%%%%%%%%%%%%%
 Np=input('enter how many integration(j) do you want to use in calculating:');
 Nelem=size(L,2);
 ks=zeros(2*Np,2,Nelem);
 kel=zeros(3*Nelem,3);
 Ndof=size(p_Ext,1);
 free=(1:Ndof)'; free(Restr)=[];
 Kt=zeros(Ndof,Ndof);
     for i=1:Nelem
         a((3*i-2):(3*i),:)=[-sind(teta(i))/L(i),cosd(teta(i))/L(i),1,sind(teta(i))/L(i),-cosd(teta(i))/L(i),0;-sind(teta(i))/L(i),cosd(teta(i))/L(i),0,sind(teta(i))/L(i),-cosd(teta(i))/L(i),1;-cosd(teta(i)),-sind(teta(i)),0,cosd(teta(i)),sind(teta(i)),0];
         wf(i)=(b(i)*H(i))/Nf;
         if Np==4
           xp=[0.0000 0.2764 0.7236 1.0000];
           wp(i,:)=[0.0833 0.4167 0.4167 0.0833]*L(i);
         elseif Np==8
           xp=[0.0000 0.0641 0.2041 0.3954 0.6046 0.7959 0.9359 1.0000];
           wp(i,:)=[0.0179 0.1054 0.1706 0.2062 0.2062 0.1706 0.1054 0.0179]*L(i);  
         end
         for j=1:Np
             for k=1:Nf
                 as(k,(2*j-1):(2*j),i)=[-((Nf-(2*k-1))/Nf)*(H(i)/2), 1];
                 Et(k,j,i)=E;
                 ks((2*j-1):(2*j),:,i)=ks((2*j-1):(2*j),:,i)+as(k,(2*j-1):(2*j),i)'*Et(k,j,i)*as(k,(2*j-1):(2*j),i)*wf(i);
             end
             B((2*j-1):(2*j),:,i)=[(-4/L(i))+(6/L(i)*xp(j)) (-2/L(i))+(6/L(i)*xp(j)) 0; 0 0 1/L(i)];
             kel((3*i-2):(3*i),:)=kel((3*i-2):(3*i),:)+B((2*j-1):(2*j),:,i)'*ks((2*j-1):(2*j),:,i)*B((2*j-1):(2*j),:,i)*wp(i,j);
         end
         Kt(DoFs(i,:),DoFs(i,:))=Kt(DoFs(i,:),DoFs(i,:))+transpose(a((3*i-2):(3*i),:))*kel((3*i-2):(3*i),:)*a((3*i-2):(3*i),:);
      end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  calculate KT 
step=input('enter how many steps do you want to use in calculating:');
p_ext=p_Ext./step;

for m1=1:step
    m2=1;
         if m1==1
            p_r=m1*p_ext;
            p_int=zeros(Ndof,1);
            Delta_u=zeros(Ndof,1);
            U=zeros(Ndof,1);
         else 
            p_r=m1*p_ext-p_int;
         end
            while norm(p_r(free))>=tol
                m2=m2+1;
                 Delta_u(free)=inv(Kt(free,free))*p_r(free);
                 U=U+Delta_u;
                 s=zeros(2*Np,Nelem);
                 q=zeros(3*Nelem,1);
                 p_int=zeros(Ndof,1);
                 ks=zeros(2*Np,2,Nelem);
                 kel=zeros(3*Nelem,3);
                 Kt=zeros(Ndof,Ndof);
                 for i=1:Nelem
                     v((3*i-2):(3*i),1)=a((3*i-2):(3*i),:)*U(DoFs(i,:),1);
                     for j=1:Np
                         e((2*j-1):(2*j),i)=B((2*j-1):(2*j),:,i)*v((3*i-2):(3*i),1);
                         for k=1:Nf
                             strain(k,j,i)=as(k,(2*j-1):(2*j),i)*e((2*j-1):(2*j),i);
                             if abs(strain(k,j,i))<=strainy
                                stress(k,j,i)=E*strain(k,j,i);
                             else
                                Et(k,j,i)=alpha*E;
                                stress(k,j,i)=sign(strain(k,j,i))*(sigmay+Et(k,j,i)*(abs(strain(k,j,i))-strainy));           
                             end
                             s((2*j-1):(2*j),i)=s((2*j-1):(2*j),i)+as(k,(2*j-1):(2*j),i)'*stress(k,j,i)*wf(i);
                             ks((2*j-1):(2*j),:,i)=ks((2*j-1):(2*j),:,i)+as(k,(2*j-1):(2*j),i)'*Et(k,j,i)*as(k,(2*j-1):(2*j),i)*wf(i);
                         end
                         q((3*i-2):(3*i),1)=q((3*i-2):(3*i),1)+B((2*j-1):(2*j),:,i)'*s((2*j-1):(2*j),i)*wp(i,j);
                         kel((3*i-2):(3*i),:)=kel((3*i-2):(3*i),:)+B((2*j-1):(2*j),:,i)'*ks((2*j-1):(2*j),:,i)*B((2*j-1):(2*j),:,i)*wp(i,j);
                     end
                     p_int(DoFs(i,:),1)=p_int(DoFs(i,:),1)+a((3*i-2):(3*i),:)'*q((3*i-2):(3*i),1);
                     Kt(DoFs(i,:),DoFs(i,:))=Kt(DoFs(i,:),DoFs(i,:))+a((3*i-2):(3*i),:)'*kel((3*i-2):(3*i),:)*a((3*i-2):(3*i),:);
                 end
                 p_r=m1*p_ext-p_int;
            end
            F(:,m1)=p_int;
            D(:,m1)=U;
            Q(:,m1)=q;
            V(:,m1)=v;
            S(:,:,m1)=s;
            Ee(:,:,m1)=e;
            Strain(:,:,:,m1)=strain;
            Stress(:,:,:,m1)=stress;
end

%%
SCAN='%f'; for i=1:Ndof-1; SCAN=[SCAN '%f']; end
system('OpenSees.exe 4int.tcl');
fid=fopen('OSFCNodalDisplacements.txt','r');
vaset=textscan(fid,SCAN,'CollectOutput',1); OSDisplacements=vaset{1}; clear vaset;
fclose(fid);
fid=fopen('OSFCNodalReactions.txt','r');
vaset=textscan(fid,SCAN,'CollectOutput',1); OSForces=vaset{1}; clear vaset;
fclose(fid);
P1=plot(D(4,:),abs(F(1,:)+F(13,:)))
hold on;
p2=plot(OSDisplacements(:,4),abs(OSForces(:,1)+OSForces(:,13)));
hold on;



