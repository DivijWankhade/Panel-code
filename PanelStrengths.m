% Panel Strength function that takes the panel end points, angle of attack,
% free stream velocity and number of panels as inputs and outputs the panel
% strengths and lift coefficients



function[PStrengths,C_l,xP,zP] = PanelStrengths(xP,zP,xWake,zWake,AoARadians,Uinfinity,N)

xP(end-1)=[];  %Gets rid of the point that was made to join the wake panel to the rest of the panels
zP(end-1)=[];

LEN=length(xP);    %Variable assigned to the length of xP
i=1;
% beta=zeros(N,1)
for i=1:LEN-1
    beta(i)=atan((zP(i+1)-zP(i))/(xP(i+1)-xP(i))); %Equation 10 of the handout
end


B=zeros(1,LEN-1);  %Initialising the B matrix
i=1;
for i=1:LEN-1
    B(i)=-Uinfinity*sin(AoARadians-beta(i));  %Creating the RHS of equation 12
end
B(1,N+1)=0; %Kutta condition
B=B'; %Making the row array a column array 

A=zeros(N+1,N+1); %Initialising the A matrix
A(N+1,1)=1;    %Inputting the coefficients as a result of the Kutta condition
A(N+1,N)=-1;
A(N+1,N+1)=1;

%Setting up the A matrix
i=1;
j=1;
for i=1:N
    pPoint = [(xP(i)+xP(i+1))/2,(zP(i)+zP(i+1))/2];  %Finding the midpoints of the panels
    for j=1:N+1
        pPointStart=[xP(j),zP(j)];    %For each iteration the panel start and end point are asigned a variable
        pPointEnd=[xP(j+1),zP(j+1)];
        [Uij,Vij]=cdoublet(pPoint,pPointStart,pPointEnd);   
        A(i,j)=Vij*cos(beta(i))-Uij*sin(beta(i)); %LHS of equation 12 which is multiplied by the panel strengths
    end
end









PStrengths= A \ B; %Finding the panel strengths using equation 14


C_l=-2*PStrengths(N+1)/Uinfinity; %Calculating lift coefficeint using equation 15

