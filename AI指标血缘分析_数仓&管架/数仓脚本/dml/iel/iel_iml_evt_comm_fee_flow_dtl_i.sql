: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_comm_fee_flow_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_comm_fee_flow_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.rgst_dt as rgst_dt
    ,replace(replace(t.rgst_flow_num,chr(13),''),chr(10),'') as rgst_flow_num
    ,replace(replace(t.charge_cd,chr(13),''),chr(10),'') as charge_cd
    ,replace(replace(t.charge_lev_cd,chr(13),''),chr(10),'') as charge_lev_cd
    ,t.recvbl_amt as recvbl_amt
    ,replace(replace(t.fee_bus_cd,chr(13),''),chr(10),'') as fee_bus_cd
    ,replace(replace(t.fee_org_id,chr(13),''),chr(10),'') as fee_org_id
    ,replace(replace(t.enter_acct_id,chr(13),''),chr(10),'') as enter_acct_id
    ,t.actl_recv_amt as actl_recv_amt
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,t.discnt_amt as discnt_amt
from iml.evt_comm_fee_flow_dtl t
where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_comm_fee_flow_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes