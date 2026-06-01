: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_pdagrlvl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_pdagrlvl_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
bkno
,cino
,acno
,subs
,acid
,iccd
,lvsq
,alul
,plul
,prmd
,cpru
,icbs
,iedt
,rrt1
,rrb1
,rrp1
,rrc1
,rrd1
,rrm1
,rrv1
,rrt2
,rrb2
,rrp2
,rrc2
,rrd2
,rrm2
,rrv2
,rrt3
,rrb3
,rrp3
,rrc3
,rrd3
,rrm3
,rrv3
,rrt4
,rrb4
,rrp4
,rrc4
,rrd4
,rrm4
,rrv4
,rrt5
,rrb5
,rrp5
,rrc5
,rrd5
,rrm5
,rrv5
,udul
,udll
,upul
,upll
,fxrv
,efdt
,eldt
,auto
from idl.irrs_o_cbs_pdagrlvl
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_pdagrlvl_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes