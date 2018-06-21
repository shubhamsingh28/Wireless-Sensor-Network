%------------background UI------------------
x_area=[0 0 500 500 0];
y_area=[0 500 500 0 0];
plot(x_area, y_area, 'k-', 'LineWidth', 3);
hold on;
xticks(0:64.5:500)
yticks(0:64.5:500)
grid on
ax=gca;
ax.XColor = 'k';
ax.YColor = 'k';
ax.GridLineStyle='--';
ax.GridAlpha = 1;
ax.GridColor = [0.5, 0.5, 0.5];
ax.LineWidth = 2;
%----------------node deploy part------------------
sensor_nodes=1000; % no of sensor node
sensor_loc=zeros(sensor_nodes,1);%storing the location of each sensor (in which cluster it is located)
node_x=randi([0,500],sensor_nodes,1); %size(no of sensor_nodes,1) having value random in 1-500 -for x coordinate 
node_y=randi([0,500],sensor_nodes,1); %size(no of sensor_nodes,1) having value random in 1-500 -for y coordinate 
plot(node_x,node_y,'mo',...
    'LineWidth',2,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0,0,1],...
    'MarkerSize',4)
%-------------base station----------------------------
base_x=[240 250 260 240];
base_y=[240 260 240 240];
fill(base_x,base_y,'g');
%--------------  Keeping records of each node in its cluster  -------------------------------------------
no_cluster=64;    % 500*500 / 64.5*64.5 ~ 64
cluster_node=zeros(no_cluster,sensor_nodes);  % size(no of cluster,total no of sensor_nodes) for stroring index of node in particular cluster 	
cluster=zeros(no_cluster,1);	% size(no of cluster) for storing total no of nodes in a particular cluster

%Note: for deciding cluster no for an area, we start from origin. take one column from bottom and move up. again we move to next column from bottom and repeat
% Ranges cluster 1 - x:0-64.5 y:0-64.5 ;;; cluster 8 - x:0-64.5, y=451.5-500;;;cluster 9- x:64.5-129, y:0-64.5

node_Energy=ones(sensor_nodes,1);	% giving each node 1 Joule energy
for i=1:sensor_nodes
    row_number=floor(node_y(i)/64.5);
    col_number=floor(node_x(i)/64.5);
    cluster_number=col_number*8+row_number+1;
    sensor_loc(i)=cluster_number;
    cluster(cluster_number)=cluster(cluster_number)+1;
    cluster_node(cluster_number,cluster(cluster_number))=i;
end	
%------------------------------Selecting node nearer to centre of cluster as CH-------------------------------------------------------------
x1=0;
curCH=zeros(no_cluster,1);	% current CH in this array of each cluster
for i=1:8
	if i==8 	x2=500;
	else 		x2=x1+64.5;	
	end
	y1=0;
	c=(i-1)*8;
	for j=1:8
		if j==8		
            y2=500;	
        else
            y2=y1+64.5;
		end
		mean_x=(x1+x2)/2;
		mean_y=(y1+y2)/2;
		d=500;
		no=0;
		for k=1:500	
			if cluster_node(c+j,k)==0
                break;
			end
			nx=node_x(cluster_node((c+j),k));
			ny=node_y(cluster_node((c+j),k));
			d1=sqrt(((mean_x-nx)*(mean_x-nx))+((mean_y-ny)*(mean_y-ny)));
			if d>d1		d=d1; no=cluster_node((c+j),k);
			end			
		end
		curCH(8*(i-1)+j)=no;
		h=plot(node_x(no),node_y(no),'mo',...
    		'LineWidth',2,...
    		'MarkerEdgeColor','b',...
    		'MarkerFaceColor',[0,0,1],...
    		'MarkerSize',4);
		set(h,'Marker','p','MarkerSize',8,'MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[1,0,0]);
		y1=y1+64.5;
	end
	x1=x1+64.5;
end

%-----------------------------Simulating for multihop connection---------------------------------------------------------
d_count=0;
INF=10^6;
d_round=zeros(sensor_nodes,1);
while d_count<2
	for i=1:64
		%convert into 2 D x,y coordinate with cluster i
		if(mod(i,8)==0)
			x=i/8;
			y=8;
		else
			x=i/8+1;
			y=mod(i,8);
        end
        x=floor(x);
        y=floor(y);
		no_node_cluster=cluster(i,1);%count total sensor in cluster(i) 
		for j=1:no_node_cluster
			node_no=cluster_node(i,j);
			if node_no==curCH(i)		%if node is cluster head
				E=node_Energy(node_no);
				if E>0
				%---calculate for the distance for 8 cluster and include that cluster also
				%--Calculate the the i=x*8+y+1 for(x,y) co-ordinate

                dis0=sqrt(((250-node_x(curCH(i)))*(250-node_x(curCH(i))))+((250-node_y(curCH(i)))*(250-node_y(curCH(i)))));
               % fprintf("%d ",dis0);
				if (((x+1)*8+y+2)<=64&&((x+1)*8+y+2)>0&&x+1>0&&y+1>0)  %---x+1,y+1
                    dis1=sqrt(((250-node_x(curCH((x+1)*8+y+2)))*(250-node_x(curCH((x+1)*8+y+2))))+((250-node_y(curCH((x+1)*8+y+2)))*(250-node_y(curCH((x+1)*8+y+2)))));
                   % fprintf("%d ",dis1);
                else
                    dis1=INF;
				end
				if (((x+1)*8+y+1)<=64&&((x+1)*8+y+1)>0&&x+1>0&&y>0)%---x+1,y
                    dis2=sqrt(((250-node_x(curCH((x+1)*8+y+1)))*(250-node_x((x+1)*8+y+1)))+((250-node_y((x+1)*8+y+1))*(250-node_y((x+1)*8+y+1))));
                   % fprintf("%d ",dis2);
                else
                    dis2=INF;
				end
				if (((x+1)*8+y)<=64&&((x+1)*8+y)>0&&x+1>0&&y-1>0)%----x+1,y-1
                    dis3=sqrt(((250-node_x(curCH((x+1)*8+y)))*(250-node_x(curCH((x+1)*8+y))))+((250-node_y(curCH((x+1)*8+y)))*(250-node_y(curCH((x+1)*8+y)))));
                    %fprintf("%d ",dis3);
                else
                    dis3=INF;
				end
				if (((x)*8+y)<=64&&((x)*8+y)>0&&x>0&&y-1>0)%---x,y-1
                    dis4=sqrt(((250-node_x(curCH((x)*8+y)))*(250-node_x(curCH((x)*8+y))))+((250-node_y(curCH((x)*8+y)))*(250-node_y((x)*8+y))));
                    %fprintf("%d ",dis4);
                else
                    dis4=INF;
				end
				if (((x)*8+y+2)<=64&&((x)*8+y+2)>0&&x>0&&y+1>0)%------x,y+1
                    dis5=sqrt(((250-node_x(curCH((x)*8+y+2)))*(250-node_x(curCH((x)*8+y+2))))+((250-node_y(curCH((x)*8+y+2)))*(250-node_y(curCH((x)*8+y+2)))));
                   % fprintf("%d ",dis5);
                else
                    dis5=INF;
				end
				if (((x-1)*8+y+2)<=64&&((x-1)*8+y+2)>0&&x-1>0&&y+1>0)%----x-1,y+1
                    dis6=sqrt(((250-node_x(curCH((x-1)*8+y+2)))*(250-node_x(curCH((x-1)*8+y+2))))+((250-node_y(curCH((x-1)*8+y+2)))*(250-node_y(curCH((x-1)*8+y+2)))));
                    %fprintf("%d ",dis6);
                else
                    dis6=INF;
				end
				if (((x-1)*8+y+1)<=64&&((x-1)*8+y+1)>0&&x-1>0&&y>0)%----x-1,y
                    %fprintf(" %d  %d ",(x-1)*8+y+1,(x)*8+y+1);
                    dis7=sqrt(((250-node_x(curCH((x-1)*8+y+1)))*(250-node_x(curCH((x-1)*8+y+1))))+((250-node_y(curCH((x-1)*8+y+1)))*(250-node_y(curCH((x-1)*8+y+1)))));
                    %fprintf("%d ",dis7);
                else
                    dis7=INF;
				end
				if (((x-1)*8+y)<=64&&((x-1)*8+y)>0&&x-1>0&&y-1>0)%-----x-1,y-1
                    dis8=sqrt(((250-node_x(curCH((x-1)*8+y)))*(250-node_x(curCH((x-1)*8+y))))+((250-node_y(curCH((x-1)*8+y)))*(250-node_y(curCH((x-1)*8+y)))));
                    %fprintf("%d ",dis8);
                else
                    dis8=INF;
				end
				dist=min(dis0,dis1);
                dist=min(dist,dis2);
                dist=min(dist,dis3);
                dist=min(dist,dis4);
                dist=min(dist,dis5);
                dist=min(dist,dis6);
                dist=min(dist,dis7);
                dist=min(dist,dis8);
                if (dist==dis0)
                    dis=dis0;
                end
                if(dist==dis1)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x+1)*8+y+2)))*(node_x(node_no)-node_x(curCH((x+1)*8+y+2))))+((node_y(node_no)-node_y(curCH((x+1)*8+y+2)))*(node_y(node_no)-node_y(curCH((x+1)*8+y+2)))));
                end
                if(dist==dis2)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x+1)*8+y+1)))*(node_x(node_no)-node_x(curCH((x+1)*8+y+1))))+((node_y(node_no)-node_y(curCH((x+1)*8+y+1)))*(node_y(node_no)-node_y(curCH((x+1)*8+y+1)))));
                end	
                if(dist==dis3)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x+1)*8+y)))*(node_x(node_no)-node_x(curCH((x+1)*8+y))))+((node_y(node_no)-node_y(curCH((x+1)*8+y)))*(node_y(node_no)-node_y(curCH((x+1)*8+y)))));
                end	
                if(dist==dis4)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x)*8+y)))*(node_x(node_no)-node_x(curCH((x)*8+y))))+((node_y(node_no)-node_y(curCH((x)*8+y)))*(node_y(node_no)-node_y(curCH((x)*8+y)))));
                end	
                if(dist==dis5)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x)*8+y+2)))*(node_x(node_no)-node_x(curCH((x)*8+y+2))))+((node_y(node_no)-node_y(curCH((x)*8+y+2)))*(node_y(node_no)-node_y(curCH((x)*8+y+2)))));
                end	
                if(dist==dis6)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x-1)*8+y+2)))*(node_x(node_no)-node_x(curCH((x-1)*8+y+2))))+((node_y(node_no)-node_y(curCH((x-1)*8+y+2)))*(node_y(node_no)-node_y(curCH((x-1)*8+y+2)))));
                end		
                if(dist==dis7)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x-1)*8+y+1)))*(node_x(node_no)-node_x(curCH((x-1)*8+y+1))))+((node_y(node_no)-node_y(curCH((x-1)*8+y+1)))*(node_y(node_no)-node_y(curCH((x-1)*8+y+1)))));
                end	
                if(dist==dis8)
					dis=sqrt(((node_x(node_no)-node_x(curCH((x-1)*8+y)))*(node_x(node_no)-node_x(curCH((x-1)*8+y))))+((node_y(node_no)-node_y(curCH((x-1)*8+y)))*(node_y(node_no)-node_y(curCH((x-1)*8+y)))));
                end
                
                E=E- (( 51200 * (10 ^ (-9))* (no_node_cluster+1) ) + ( 102400 * (10 ^ (-12)) * (dis ^ 2)));
					if E<=0
                        if mod(i,8)~=0
                        fprintf('Node no : %d\t Round : %d\n',node_no,d_round(node_no));    
						d_count=d_count+1; 
						h=plot(node_x(curCH(i)), node_y(curCH(i)),'Marker','p','MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor',[1,0,0]);
						set(h,'Marker','p','MarkerSize',8,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
						
                        end
                        node_Energy(node_no)=0;
					else
						d_round(node_no)=d_round(node_no)+1;
						node_Energy(node_no)=E;
					end
				end
			else
				E=node_Energy(node_no);
				if E>0
				dis=sqrt(  ((node_x (curCH(i))-node_x(node_no))*(node_x (curCH(i))-node_x(node_no)))+((node_y (curCH(i))-node_y(node_no))*(node_y (curCH(i))-node_y(node_no))) );
				E=E- (( 51200 * (10 ^ (-9)) ) + ( 102400 * (10 ^ (-12)) * (dis ^ 2)));
					if E<=0
                        if mod(i,8)~=0
						d_count=d_count+1; 
						h=plot(node_x(node_no),node_y(node_no),'mo',...
    						'LineWidth',2,...
    						'MarkerEdgeColor','b',...
    						'MarkerFaceColor',[0,0,1],...
    						'MarkerSize',4);
						set(h,'Marker','o','MarkerSize',4,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
                        end
						node_Energy(node_no)=0;
					else
						d_round(node_no)=d_round(node_no)+1;
						node_Energy(node_no)=E;
					end
				end
			end
        end
       % fprintf("%.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f\n",dis0,dis1,dis2,dis3,dis4,dis5,dis6,dis7,dis8,dis);
				
	end
end