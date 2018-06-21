%------------background UI------------------
x_area=[0 0 200 200 0];
y_area=[0 200 200 0 0];
plot(x_area, y_area, 'k-', 'LineWidth', 3);
hold on;
xticks(0:25:200)
yticks(0:25:200)
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
node_x=randi([0,199],sensor_nodes,1);%size(no of sensor_nodes,1) having value random in 1-200 -for x coordinate 
node_y=randi([0,199],sensor_nodes,1);%size(no of sensor_nodes,1) having value random in 1-200 -for y coordinate 
plot(node_x,node_y,'mo',...
    'LineWidth',2,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0,0,1],...
    'MarkerSize',4)
%-------------base station----------------------------
base_x=[95 100 105 95];
base_y=[95 105 95 95];
fill(base_x,base_y,'g');
%--------------  Keeping records of each node in its cluster  -------------------------------------------
no_cluster=64;    % 500*500 / 64.5*64.5 ~ 64
cluster_node=zeros(no_cluster,sensor_nodes);  % size(no of cluster,total no of sensor_nodes) for stroring index of node in particular cluster 	
cluster=zeros(no_cluster,1);	% size(no of cluster) for storing total no of nodes in a particular cluster

%Note: for deciding cluster no for an area, we start from origin. take one column from bottom and move up. again we move to next column from bottom and repeat
% Ranges cluster 1 - x:0-64.5 y:0-64.5 ;;; cluster 8 - x:0-64.5, y=451.5-500;;;cluster 9- x:64.5-129, y:0-64.5

node_Energy=ones(sensor_nodes,1);	% giving each node 1 Joule energy
prev_count=zeros(sensor_nodes,1);
prevCH=zeros(no_cluster,1);
curCH=zeros(no_cluster,1);
d_count=0;
d_round=zeros(sensor_nodes,1);
for i=1:sensor_nodes
    row_number=floor(node_y(i)/25);
    col_number=floor(node_x(i)/25);
    cluster_number=col_number*8+row_number+1;
    sensor_loc(i)=cluster_number;
    cluster(cluster_number)=cluster(cluster_number)+1;
    cluster_node(cluster_number,cluster(cluster_number))=i;
end	
%------------------------------Selecting node nearer to centre of cluster as CH-------------------------------------------------------------
x1=0;
curCH=zeros(no_cluster,1);	% current CH in this array of each cluster
for i=1:8
    x2=x1+25;
	y1=0;
	c=(i-1)*8;
	for j=1:8
		y2=y1+25;
		mean_x=(x1+x2)/2;
		mean_y=(y1+y2)/2;
		d=200;
		no=0;
		for k=1:200	
			if cluster_node(c+j,k)==0	break;
			end
			nx=node_x(cluster_node((c+j),k));
			ny=node_y(cluster_node((c+j),k));
			d1=sqrt(((mean_x-nx)*(mean_x-nx))+((mean_y-ny)*(mean_y-ny)));
			if d>d1		d=d1; no=cluster_node((c+j),k);
			end			
		end
		curCH(8*(i-1)+j)=no;
        prev_count(no)=prev_count(no)+1;
        prevCH(8*(i-1)+j)=no;
		h=plot(node_x(no),node_y(no),'mo',...
    		'LineWidth',2,...
    		'MarkerEdgeColor','b',...
    		'MarkerFaceColor',[0,0,1],...
    		'MarkerSize',4);
		set(h,'Marker','p','MarkerSize',8,'MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[1,0,0]);
		y1=y1+25;
	end
	x1=x1+25;
end