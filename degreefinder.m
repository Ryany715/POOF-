function [xdeg,ydeg,zdeg] = degreefinder(xcoor, ycoor, zcoor)
%this function finds the angle needed for the servo motors, based on the
%fact that our robot arm is at 90 degrees for all motors and that the exact
%arm design as used in V1 is used.  This code will need to be adjusted as
%the design iterations change
    if zcoor~=0
        zz= sind(zcoor/8);  % uses this to find sin inverse, 8 needs to be changed as design changes 
        zout= (1/ zz);
    else 
        zout=0;
    end 
    if ycoor~=0
        yy= sind(ycoor/11); % 11 needs to change as the design changes, as does 11 for x
        yout= (1/yy);
    else 
        yout=0;
    end
    if xcoor~=0
        xx= sind(xcoor/8);
        xout= (1/xx);
    else 
        xout=0;
    end 
    if zcoor<0
        zdeg= mod(90 + zout,180); 
    else
        zdeg=mod(90-zout,180);
    end 
    if ycoor<0
        ydeg= mod(90+yout,180); 
    else 
        ydeg= mod(90-yout,180);
    end
    if xcoor<0
        xdeg= mod(90-xout,180); 
    else 
        xdeg= mod(90+xout,180);
    end
   fprintf('X angle is %.2f, Y angle is %.2f , Z angle is %.2f', xdeg, ydeg, zdeg);
end 

