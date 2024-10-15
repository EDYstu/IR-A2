function [objectLocation, objectVertices, objectModel] = pickUpAndDrop(r,objectLocation, objectVertices, objectModel, dropOff)
steps = 50;

    %---------PICKUP THE OBJECT---------
    q = r.model.getpos(); 
    T2 = transl(objectLocation)* trotz(-pi/2)* trotx(pi); %calculate the target/goal matrix
    q2 = r.model.ikcon(T2); %Calculate the joint angles for the goal based ont the target matrix
    qMatrix = jtraj(q,q2,steps); %generate a Q matrix
                %iterate over the Q matrix 
    for i = 1:steps
        self.r.model.animate(qMatrix(i, :));
        drawnow();   
        pause(0.01);
    end
    
    %-------DROP OFF OBJECT--------
    q = r.model.getpos(); 
    T2 = transl(dropOff)* trotz(-pi/2)* trotx(pi);%calculate the target/goal matrix   
    q2 = r.model.ikcon(T2); %Calculate the joint angles for the goal based ont the target matrix
    qMatrix = jtraj(q,q2,steps); %generate a Q matrix
    for i = 1:steps
        tr = self.r.model.fkine(qMatrix(i,:)); %generate the T matrix for the current pose
        transformedsBrickVertices = [objectVertices,ones(size(objectVertices,1),1)] * tr.T';%move vertices to the new location based on the endeffector 
        set(objectModel,'Vertices',transformedsBrickVertices(:,1:3)); %move the brick to the current end effector pose
        r.model.animate(qMatrix(i, :));
        drawnow();   
        pause(0.01);
    end
    objectLocation = dropOff;
    

end
                                    

