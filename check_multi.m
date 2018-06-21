%-----------------------------Simulating for multihop connection---------------------------------------------------------
INF=10^6;
lop=0;
while lop<rounds && d_count<2
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
                        fprintf('Node no : %d\t Round : %d\n',node_no,d_round(node_no))   
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
                        fprintf('Node no : %d\t Round : %d\n',node_no,d_round(node_no))  
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
       lop=lop+1;
end       
       
