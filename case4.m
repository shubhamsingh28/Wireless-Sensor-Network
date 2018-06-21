deploy
while d_count<2
    for i=1:64
        check_CH_sel
        fis=readfis('ClusterHeadRot_804.fis');
        rounds=floor(evalfis([node_Energy(curCH(i)) prev_count(curCH(i))],fis)*10);
        check_node_CH_base
    end
end