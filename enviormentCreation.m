function [ur3Robot] = enviormentCreation()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
    clc;
    clf; 

    r = UR3(transl(0.5,0,0.5)); 
    ur3Robot = r;

    hold on;
    grid on
    axis equal
            
    %Using the method from Tutorial 4

    %table
    table = PlaceObject('tableBrown2.1x1.4x0.5m.ply');
    vertices = get(table,'Vertices');
    transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0,0,0)';
    set(table,'Vertices',transformedVertices(:,1:3));
            
            %barriers
    barrier1 = PlaceObject('fenceAssemblyGreenRectangle4x8x2.5m.ply');
    vertices1 = get(barrier1,'Vertices');
    transformedVertices1 = [vertices1,ones(size(vertices1,1),1)] * transl(0,1,-1)';
    set(barrier1,'Vertices',transformedVertices1(:,1:3));
            
    fireEx = PlaceObject('fireExtinguisher.ply');
    verticesFire = get(fireEx,'Vertices');
    transformedVerticesFire = [verticesFire,ones(size(verticesFire,1),1)] * transl(3,-1,0)';
    set(fireEx,'Vertices',transformedVerticesFire(:,1:3));

    person = PlaceObject('personMaleConstruction.ply');
    verticesPerson = get(person,'Vertices');
    transformedVerticesPerson = [verticesPerson,ones(size(verticesPerson,1),1)] * transl(3,0,0)';
    set(person,'Vertices',transformedVerticesPerson(:,1:3));

            %estop
    estop = PlaceObject('emergencyStopWallMounted.ply'); %use the wall moutned one as its an appropriate scale
    estopV = get(estop,'Vertices');
    transformedsEstopVertices1 = [estopV,ones(size(estopV,1),1)] * trotx(-pi/2) *transl(0.8,0.6,0.55)';
    set(estop,'Vertices',transformedsEstopVertices1(:,1:3));

    %RedCan
    redCan = PlaceObject('soda can- 350ml.ply'); 
    redCanV = get(redCan,'Vertices');
    transformedRedCanVertices = [redCanV,ones(size(redCanV,1),1)] * transl(0.8,0,0.625)';
    set(redCan,'Vertices',transformedRedCanVertices(:,1:3));

    %Milkcarton
    mcarton = PlaceObject('milkcarton.ply'); 
    mcartonV = get(mcarton,'Vertices');
    transformedmcartonVertices = [mcartonV,ones(size(mcartonV,1),1)] * transl(0.8,-0.2,0.715)';
    set(mcarton,'Vertices',transformedmcartonVertices(:,1:3)); %%Error upon this line

    zlim([0, 3]); % limit the figure
    xlim([-2, 2]);
    ylim([-1.5, 1.5]);

    %Apple
    Apple = PlaceObject('Apple.ply'); 
    AppleV = get(Apple,'Vertices');
    transformedAppleVertices = [AppleV,ones(size(AppleV,1),1)] * transl(0.8,0.2,0.575)';
    set(Apple,'Vertices',transformedAppleVertices(:,1:3)); 

    %RedBin
    redBin = PlaceObject('RedDeskTrashBin.ply'); 
    redBinV = get(redBin,'Vertices');
    transformedRedBinVertices = [redBinV,ones(size(redBinV,1),1)]* trotz(pi/2) * transl(-1.2,0,0.5)';
    set(redBin,'Vertices',transformedRedBinVertices(:,1:3));

    %BlueBin
    BlueBin = PlaceObject('BlueDeskTrashBin.ply'); 
    BlueBinV = get(BlueBin,'Vertices');
    transformedBlueBinVertices = [BlueBinV,ones(size(BlueBinV,1),1)]* trotz(pi/2) * transl(-1.2,0.4,0.5)';
    set(BlueBin,'Vertices',transformedBlueBinVertices(:,1:3));

    %GreenBin
    GreenBin = PlaceObject('GreenDeskTrashBin.ply'); 
    GreenBinV = get(GreenBin,'Vertices');
    transformedGreenBinVertices = [GreenBinV,ones(size(GreenBinV,1),1)]* trotz(pi/2) * transl(-1.2,-0.4,0.5)';
    set(GreenBin,'Vertices',transformedGreenBinVertices(:,1:3));



    zlim([0, 3]); % limit the figure
    xlim([-4.5, 4.5]);
    ylim([-2.5, 2.5]);

end