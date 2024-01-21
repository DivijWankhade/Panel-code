clear;clc;clear all %housekeeping

AirfoilType=input('Enter the NACA Airfoil Type','s') ; %Asking the user for all the required inputs to plot the airfoil and streamlines
N=input('Enter the number of panels') ;
AoA=input('Enter the Angle of Attack') ;
Uinfinity=input('Enter the free stream velocity')
s=input('Enter the resolution of the streamlines (200 is recommended)');;

[xP,zP,xWake,zWake,AoARadians]=panelgen(N,AoA,Uinfinity,AirfoilType);


[PStrengths,C_l,xP,zP]=PanelStrengths(xP,zP,xWake,zWake,AoARadians,Uinfinity,N);  %Calling the function which calculates the panel strengths and lift coefficient
display(['The Lift Coefficient is ',num2str(C_l)]);  %Outputs lift coefficient when variables are inputted

FlowLines(s,xP,zP,PStrengths,Uinfinity,AoA,N,AirfoilType); %Calling the flowline function

%In order to save the figures of the streamlines and arrow plots for 2
%different NACA 4 series airfoils this main code was run inputting the
%Airfoil types (2405,2421) at an angle of attack of 1,5 and 5,10 degrees
%respectively and a free stream velocity of 15 m/s and a discretisation of
%200 panels




%Creating the required tables

if AirfoilType == '2412'   %The case where we are required to compare to the XFOIL data
    ClArray=zeros(11,3);   %Initalising the array that will hold the lift coefficients calculated using my program
    alphas=[0:1:10];   %Array holding range of angle of attacks we are required to compare
    N=[50,100,200]; %Array holding the different number of panels we are required to use 
    i=1;
    j=1;
    Uinfinity=15;   %Free stream velocity of the case we are required to run
    T=table2array(readtable('xf-naca2412-il-1000000.txt'));   %Converts the table stored in the data file to an array to extract data from
    for i=1:length(alphas)
        for j=1:length(N)
            [xP,zP,xWake,zWake,AoARadians]=panelgen(N(j),alphas(i),Uinfinity,AirfoilType);
            [PStrengths,C_l,xP,zP]=PanelStrengths(xP,zP,xWake,zWake,AoARadians,Uinfinity,N(j));
            ClArray(i,j)=C_l;    %Calculating the lift coefficients for all the cases of angle of attack and lift coefficient 
            
        end
    end
%     display(ClArray)
    XFoilArrayAoAs=(T(70:108,1));   %Indexes required to be extracted from the table
    XFoilArrayCls=(T(70:108,2));
    i=1;
    figure()
    for i=1:3
        ClsFromArray=ClArray(:,i);  %For each iteration it will take one of the columns of the ClArray 
        
        subplot(1,3,i)
        plot(alphas,ClsFromArray,'b','LineWidth',1.5)
        hold on
        plot(XFoilArrayAoAs,XFoilArrayCls,'k','LineWidth',1.5)  %Each subplot will compare the lift coefficents calculated using N panels to the XFOIL data
        xlabel('Angle of Attacks') %It should be observed as N increases, the lift coefficients calculated from the program get closer to the xfoil data
        ylabel('Lift Coeffiecient')
        title(['Lift Coefficient vs Angle of Attack for ', num2str(N(i)),' points'])
        legend('Matlab program generated Lift Coefficients','XFOIL data') %Adding aesthetics to make the graphs more sightly and easy to understand
        fileNAME=['NACA',AirfoilType,'ClVsAngleOfAttack'];
        saveas(gcf,fileNAME,'png')
    end
end
