 for i=1:64
	no_of_node=cluster(i,1);
    if mod(i,8)==0 && i~=64
        cx=(((floor((i-1)/8)*64.5)*2)+64.5)/2;
        cy=(((mod((i-1),8)*64.5))+500)/2;
    elseif floor((i-1)/8)==7 && i~=64
         cx=(((floor((i-1)/8)*64.5))+500)/2;
         cy=(((mod((i-1),8)*64.5)*2)+64.5)/2;
    elseif i==64
          cx=(((floor((i-1)/8)*64.5))+500)/2;
          cy=(((mod((i-1),8)*64.5))+500)/2;
    else
        cx=(((floor((i-1)/8)*64.5)*2)+64.5)/2;
        cy=(((mod((i-1),8)*64.5)*2)+64.5)/2;
    end
	dist1=zeros(no_of_node,1);
	ener1=zeros(no_of_node,1);
    fval=zeros(no_of_node,1);
    sfval=zeros(no_of_node,1);
	frank=zeros(no_of_node,1);
	for j=1:no_of_node
	x11=node_x(cluster_node(i,j));
	y11=node_y(cluster_node(i,j));
	d1=sqrt(((cx-x11)*(cx-x11))+((cy-y11)*(cy-y11)));
	dist1(j,1)=1-(d1/45.61);
	ener1(j,1)=node_Energy(cluster_node(i,j));
	end
	for k=1:no_of_node
        fval(k,1)=dist1(k,1)+ener1(k,1);
    end
    for k=1:no_of_node
	sfval=sortrows(fval,1,'descend');
	end
	for n=1:no_of_node
		for p=1:no_of_node
		if fval(n,1)==sfval(p,1)			
		frank(n,1)=p;
		sfval(p,1)=0;
		break;
        end
        end
    end	
    ab=0;
    for n=1:no_of_node
        if frank(n,1)==1
            ab=cluster_node(i,n);
            break;
        end
    end
        fprintf('Cluster No. %d, Cluster Head : %d',i,ab)
        fprintf('\n')
 end
