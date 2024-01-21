%Function that takes the resolution of the streamlines, panel end point,
%panel strengths, free stream velocity, angle of attack, number of panels
%and NACA airfoil type as inputs and plots the streamlines and quivers

function [Output] = FlowLines(s,xP,zP,PStrengths,Uinfinity,AoA,N,AirfoilType)


xGrid=linspace(-0.2,1.2,s); %Finding the points at which the streamlines will be calculated from
zGrid=linspace(-0.7,0.7,s);


U2(1:s,1:s)=0;
V2(1:s,1:s)=0; %Initialising  the velocity arrays

i=1;
j=1;

for i=1:s
    for j=1:s
        U2(i,j)=Uinfinity*cosd(AoA);     %A triple loop is used to program equation 8a and 8b
        V2(i,j)=Uinfinity*sind(AoA);
        for k=1:N+1
            [u,v]=cdoublet([xGrid(i),zGrid(j)],[xP(k),zP(k)],[xP(k+1),zP(k+1)]);
            U2(i,j)=U2(i,j)+u*PStrengths(k);
            V2(i,j)=V2(i,j)+v*PStrengths(k);
        end
    end
end

U2=U2'; %Turning U2 and V2 into column arrays to allow us to use the streamslice and quiver function 
V2=V2';

[X,Z]=meshgrid(xGrid,zGrid);      %Putting the x and z arrays into a format that can be plotted by streamslice and quiver

PExcluded=inpolygon(X,Z,xP(1:N+1),zP(1:N+1));  %Finds the points that fall within the airfoil

xP(end)=[];
zP(end)=[];


U2(PExcluded)=NaN;    %Discards the values in U2 and V2 that fall within the airfoil
V2(PExcluded)=NaN;
figure()    %Creates a new figure
plot(xP(1:end-2),zP(1:end-2),'r','LineWidth',2)   %Plots the airfoil in red, ignoring the wake panel and the point made to
hold on
streamslice(X,Z,U2,V2,'Color','b');   %Plots the streamlines on the airfoil plot 
title(['Streamlines around a NACA ',AirfoilType, ' at an angle of attack of ',num2str(AoA), ' degrees using ',num2str(N),' panels using a free stream velocity of ',num2str(Uinfinity),' m/s']) %Titling each streamline plot appropiately
axis equal  %Makes the airfoil look more sightly 
axis([-0.2,1.2,-0.7,0.7])   %Makes the plot provide a clearer view of the needed part
fileNAME=['NACA',AirfoilType,'Streamlines',num2str(AoA)]; %Name of file which will be the png image of the figure
saveas(gcf,fileNAME,'png') %Saves the figure to the same folder we currently are in 
hold off 

xP(end)=[];
zP(end)=[];
res=1:10:length(xP); %Resolution for the quiver function

figure()
plot(xP(1:end-2),zP(1:end-2),'r','LineWidth',2)   %Plots the airfoil in red, ignoring the wake panel and the point made tom
hold on
quiver(X(res,res),Z(res,res),U2(res,res),V2(res,res),'b'); %Plots the quiver function on the airfoil plot using only some of the U2 and V2 arrays
title(['Quiver plot around a NACA ',AirfoilType, ' at an angle of attack of ',num2str(AoA), ' degrees using ',num2str(N),' panels using a free stream velocity of ',num2str(Uinfinity)],' m/s') %Titling the quiver plot appropiately
hold off
axis equal
axis([-0.2,1.2,-0.7,0.7])
fileNAME=['NACA',AirfoilType,'QuiverPlot',num2str(AoA)];
saveas(gcf,fileNAME,'png')




Output='NONE'; %There is no required output of the function but an output is required to define a function so a dummy is used