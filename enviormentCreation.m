function [ur3Robot] = enviormentCreation()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
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

end