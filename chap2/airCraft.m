function airCraft(uu)
 
  % V = [ 0 3.5 0; ... % P1
  % 1 2 0.2; ... %P2
  % -1 2 0.2; ... %P3
  % -1 2 -0.2; ... %P4
  % 1 2 -0.2; ... %P5
  % 0 -5 0; ... %P6
  % 3 1 0; ... %P7
  % 3 -1 0; ... %P8
  % -3 -1 0; ... %P9
  % -3 1 0; ... %P10
  % 1.5 -4 0; ... %P11
  % 1.5 -5 0; ... %P12
  % -1.5 -5 0; ... %P13
  % -1.5 -4 0; ... %P14
  % 0 -3 0; ... %P15
  % 0 -5 1; ... %P16
  % ];

  V=[3.5000   0         0     ; ...
  2.0000   -1.0000    0.2000; ...
  2.0000    1.0000    0.2000; ...
  2.0000    1.0000   -0.2000; ...
  2.0000   -1.0000   -0.2000; ...
 -5.0000         0         0; ...
  1.0000   -3.0000         0; ...
 -1.0000   -3.0000         0; ...
 -1.0000    3.0000         0; ...
  1.0000    3.0000         0; ...
 -4.0000   -1.5000         0; ...
 -5.0000   -1.5000         0; ...
 -5.0000    1.5000         0; ...
 -4.0000    1.5000         0; ...
 -3.0000         0         0; ...
 -5.0000         0    -3.0000];

  F1 = [ 1 2 3; ...
   1 4 3; ...
   1 5 4; ...
   1 5 2; ...
   2 3 6; ...
   3 6 4; ...
   4 5 6; ...
   2 5 6; ...
   6 15 16];

  F2 = [ 7 8 9 10; ...
  11 12 13 14];

  drawSpacecraft(uu, V, F1, F2);

end


function drawSpacecraft(uu, V, F1, F2)    

    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);           
    u        = uu(4);       
    v        = uu(5);       
    w        = uu(6);       
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    p        = uu(10);       % roll rate
    q        = uu(11);       % pitch rate     
    r        = uu(12);       % yaw rate    
    t        = uu(13);       % time

    % define persistent variables 
    persistent spacecraft_handle_1;
    persistent spacecraft_handle_2;
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        spacecraft_handle_1 = drawSpacecraftBody(V,F1,'b',...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');

        spacecraft_handle_2 = drawSpacecraftBody(V,F2,'g',...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');
        title('Spacecraft')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        axis([-10,10,-15,15,-20,20]);
        grid on
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawSpacecraftBody(V,F1,'b',...
                           pn,pe,pd,phi,theta,psi,...
                           spacecraft_handle_1);

        drawSpacecraftBody(V,F2,'g',...
                           pn,pe,pd,phi,theta,psi,...
                           spacecraft_handle_2);
    end
end

  
%=======================================================================
% drawSpacecraft
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawSpacecraftBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle,mode)
  V = rotate(V', phi, theta, psi)';  % rotate spacecraft
  V = translate(V', pn, pe, pd)';  % translate spacecraft
  % transform vertices from NED to XYZ (for matlab rendering)
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V*R;
  
  if isempty(handle),
  handle = patch('Vertices', V, 'Faces', F, 'FaceColor', patchcolors);
  else
    set(handle,'Vertices',V,'Faces',F, 'FaceColor',patchcolors);
    drawnow
  end
end

%%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi);
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_roll*R_pitch*R_yaw;
  % rotate vertices
  XYZ = R*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
  XYZ = XYZ + repmat([pn;pe;pd],1,size(XYZ,2));
end

  