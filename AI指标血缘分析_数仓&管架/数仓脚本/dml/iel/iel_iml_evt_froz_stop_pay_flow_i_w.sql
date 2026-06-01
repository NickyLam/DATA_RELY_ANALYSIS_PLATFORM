: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_froz_stop_pay_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_froz_stop_pay_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.froz_stop_pay_dt as froz_stop_pay_dt
,replace(replace(t.froz_stop_pay_flow_num,chr(13),''),chr(10),'') as froz_stop_pay_flow_num
,t.seq_num as seq_num
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.froz_stop_pay_cate_cd,chr(13),''),chr(10),'') as froz_stop_pay_cate_cd
,replace(replace(t.froz_stop_pay_bus_way_cd,chr(13),''),chr(10),'') as froz_stop_pay_bus_way_cd
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,t.appl_froz_amt as appl_froz_amt
,t.surp_froz_amt as surp_froz_amt
,t.froz_end_dt as froz_end_dt
,replace(replace(t.proof_cate_cd,chr(13),''),chr(10),'') as proof_cate_cd
,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t.froz_rs,chr(13),''),chr(10),'') as froz_rs
,replace(replace(t.exec_org_name,chr(13),''),chr(10),'') as exec_org_name
,replace(replace(t.exec_cert_cd_1,chr(13),''),chr(10),'') as exec_cert_cd_1
,replace(replace(t.exec_id_1,chr(13),''),chr(10),'') as exec_id_1
,replace(replace(t.exec_cert_cd_2,chr(13),''),chr(10),'') as exec_cert_cd_2
,replace(replace(t.exec_id_2,chr(13),''),chr(10),'') as exec_id_2
,replace(replace(t.exec_ps_name_1,chr(13),''),chr(10),'') as exec_ps_name_1
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
from ${iml_schema}.evt_froz_stop_pay_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_froz_stop_pay_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes