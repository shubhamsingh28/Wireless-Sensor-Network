%----------------------------Simulating for all nodes to cluster to base station---------------------------------------------------------
lop=0;
while lop<rounds && d_count<2
		no_node_cluster=cluster(i,1);
		for j=1:no_node_cluster
			node_no=cluster_node(i,j);
			if node_no==curCH(i)
				E=node_Energy(node_no);
				if E>0
				dis=sqrt(((100-node_x(node_no))*(100-node_x(node_no)))+((100-node_y(node_no))*(100-node_y(node_no))));
				E=E- (( 51200 * (10 ^ (-9))* (no_node_cluster+1) ) + ( 102400 * (10 ^ (-12)) * (dis ^ 2)));
					if E<=0
                        fprintf('Node no : %d\t Round : %d\n',node_no,d_round(node_no));
						d_count=d_count+1; 
						h=plot(node_x(curCH(i)), node_y(curCH(i)),'Marker','p','MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor',[1,0,0]);
						set(h,'Marker','p','MarkerSize',8,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
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
                        fprintf('Node no : %d\t Round : %d\n',node_no,d_round(node_no));
						d_count=d_count+1; 
						h=plot(node_x(node_no),node_y(node_no),'mo',...
    						'LineWidth',2,...
    						'MarkerEdgeColor','b',...
    						'MarkerFaceColor',[0,0,1],...
    						'MarkerSize',4);
						set(h,'Marker','o','MarkerSize',4,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
						node_Energy(node_no)=0;
					else
						d_round(node_no)=d_round(node_no)+1;
						node_Energy(node_no)=E;
					end
				end
			end
        end
        lop=lop+1;
end
