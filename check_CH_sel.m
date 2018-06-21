no_of_node=cluster(i,1);
        cx=(((floor((i-1)/8)*25)*2)+25)/2;
        cy=(((mod((i-1),8)*25)*2)+25)/2;
	dist1=zeros(no_of_node,1);
	ener1=zeros(no_of_node,1);
    fval=zeros(no_of_node,1);
    sfval=zeros(no_of_node,1);
	frank=zeros(no_of_node,1);
	for j=1:no_of_node
        x11=node_x(cluster_node(i,j));
        y11=node_y(cluster_node(i,j));
        d1=sqrt(((cx-x11)*(cx-x11))+((cy-y11)*(cy-y11)));
        dist1(j,1)=1-(d1/17.67);
        ener1(j,1)=node_Energy(cluster_node(i,j));
	end
	for k=1:no_of_node
        if ener1(k,1)<=0
            fval(k,1)=-2;
        else
        fval(k,1)=dist1(k,1)+ener1(k,1);
        end
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
       
        curCH(i)=ab;
        prev_count(ab)=prev_count(ab)+1;
      %  fprintf('Cluster No. %d, Cluster Head : %d, prev_count: %d\n',i,ab,prev_count(ab))
      %  fprintf('\n')
        