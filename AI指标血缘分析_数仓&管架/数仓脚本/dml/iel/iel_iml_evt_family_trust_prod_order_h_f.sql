: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_family_trust_prod_order_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_family_trust_prod_order_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.indent_flow_num,chr(13),''),chr(10),'') as indent_flow_num
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.tran_amt as tran_amt
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
    ,replace(replace(t.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num
    ,t.tran_tm as tran_tm
    ,replace(replace(t.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
    ,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
    ,replace(replace(t.cntpty_ibank_no,chr(13),''),chr(10),'') as cntpty_ibank_no
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_family_trust_prod_order_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_family_trust_prod_order_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes