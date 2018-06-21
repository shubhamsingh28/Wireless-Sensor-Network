
%-----------------------------Simulating for all nodes to base station---------------------------------------------------------
d_count=0;
d_round=zeros(sensor_nodes,1);
while d_count<2
	for i=1:sensor_nodes
		E=node_Energy(i);
		flg_CH=0;
		if E>0
			dis=sqrt(((250-node_x(i))*(250-node_x(i)))+((250-node_y(i))*(250-node_y(i))));
			E=E- (( 51200 * (10 ^ (-9)) ) + ( 102400 * (10 ^ (-12)) * (dis ^ 2)));
			if E<=0
                fprintf('Node no : %d\t Round : %d\n',i,d_round(i));
				d_count=d_count+1;
				flg_CH=0; 
				for j=1:64
					if i==curCH(j) flg_CH=1;  end
				end
				if flg_CH==1			
					h=plot(node_x((i)), node_y((i)),'Marker','p','MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor',[1,0,0]);
					set(h,'Marker','p','MarkerSize',8,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
				else
						h=plot(node_x(i),node_y(i),'mo',...
    						'LineWidth',2,...
    						'MarkerEdgeColor','b',...
    						'MarkerFaceColor',[0,0,1],...
    						'MarkerSize',4);
						set(h,'Marker','o','MarkerSize',4,'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
				end	
				node_Energy(i)=0;
			else
				d_round(i)=d_round(i)+1;
				node_Energy(i)=E;
			end
		end
	end
end 
