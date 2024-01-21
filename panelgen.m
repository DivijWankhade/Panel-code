%Panelgen function that takes the number of panels, angle of attack, free
%stream velocity and NACA airfoil tye as an input and outputs an arrat
%containing the panel end points including the wake panel
function [xP,zP,xWake,zWake,AoARadians]=panelgen(N,AoA,Uinfinity,AirfoilType)

m=str2double(AirfoilType(1)) /100;     %Obtains the max camber, location of max camber and aerofoil thickness from the inputted NACA airfoil string
p=str2double(AirfoilType(2)) /10;
t=str2double(AirfoilType(3:4)) /100;

N=2*ceil(N/2);  %Making sure the number of panels in the airfoil is even despite an odd input of panels

NwP=N+1;  %Number of Panels with the Wake Panel included

i=1;
x=zeros(ceil(NwP/2),1);         %Initialising the array for x which is the array holding the xvalues for the mean camber line
for i=1:ceil(NwP/2)
    x(i)=1-0.5*(1-cos(2*pi*(i-1)/N)); %Calculating the panel end points using equation 7 of the handout
end

yc=zeros(ceil(NwP/2));     %Initialising the arrays holding the mean camber line, rate of change of the camber line wrt to the non dimensional coordinate x and theta
dyc_dx=zeros(ceil(NwP/2));
theta=zeros(ceil(NwP/2));   

i=1;
for i=1:ceil(NwP/2)       %Using equation 1 and 6 of the handout
    if x(i)<p
        yc(i) = (m/p^2) * (2*p*x(i)-x(i)^2);
        dyc_dx(i) = (2*m/p^2)*(p-x(i));
    else
        yc(i) = (m/(1-p)^2)*((1-2*p)+2*p*x(i)-x(i)^2);
        dyc_dx(i) = (2*m/(1-p)^2)*(p-x(i));
    end
    theta(i)=atan(dyc_dx(i)); %Equation 5 of the handout 
end

yt=5.*t.*(0.2969.*sqrt(x)-0.126.*x-0.3516.*x.^2+0.2843.*x.^3-0.1036.*x.^4); %Thickness distribution using equation 5, note a different value of C5 was used in order to get a sharp closed trailing edge, this was found by research

i=1;
for i=1:ceil(NwP/2)                       %Equation 3 and 4 of the handout 
    xUp(i)= x(i)-yt(i)*sin(theta(i));
    zUp(i)= yc(i)+yt(i)*cos(theta(i));
    xLo(i)=x(i)+yt(i)*sin(theta(i));
    zLo(i)=yc(i)-yt(i)*cos(theta(i));
end

AoARadians=AoA*pi/180;   %Converting Angle of Attack to Radians
Mag = 999999999;
xWake = Mag;
zWake = Mag*tand(AoA)*-1;    %Making the coordinates for the wake panel 




xP = [xLo(1:floor(NwP/2)) flip(xUp(1:ceil(NwP/2))) 1 xWake];   %Making the array containing the panel end points, the xUp is flipped so the coordinates go in order of a shape of a loop
zP = [zLo(1:floor(NwP/2)) flip(zUp(1:ceil(NwP/2))) 0 zWake]; %Notice how if there is an odd number of NwP, then there will be 1 less panel on the bottom of the airfoil than the top
%The point (1,0) is used to join the wake panel onto the airfoil










