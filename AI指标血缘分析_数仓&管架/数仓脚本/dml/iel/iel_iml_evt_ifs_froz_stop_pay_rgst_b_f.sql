: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ifs_froz_stop_pay_rgst_b_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ifs_froz_stop_pay_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.froz_dt as froz_dt
,replace(replace(t1.froz_tm,chr(13),''),chr(10),'') as froz_tm
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.rec_cate_cd,chr(13),''),chr(10),'') as rec_cate_cd
,replace(replace(t1.bus_way_cd,chr(13),''),chr(10),'') as bus_way_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,t1.appl_froz_amt as appl_froz_amt
,t1.surp_froz_amt as surp_froz_amt
,t1.froz_end_dt as froz_end_dt
,replace(replace(t1.proof_cate_cd,chr(13),''),chr(10),'') as proof_cate_cd
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num
,replace(replace(t1.froz_rs,chr(13),''),chr(10),'') as froz_rs
,replace(replace(t1.exec_org,chr(13),''),chr(10),'') as exec_org
,replace(replace(t1.exec_cert_type_cd_1,chr(13),''),chr(10),'') as exec_cert_type_cd_1
,replace(replace(t1.exec_num_1,chr(13),''),chr(10),'') as exec_num_1
,replace(replace(t1.exec_cert_type_cd_2,chr(13),''),chr(10),'') as exec_cert_type_cd_2
,replace(replace(t1.exec_num_2,chr(13),''),chr(10),'') as exec_num_2
,replace(replace(t1.exec_ps_1,chr(13),''),chr(10),'') as exec_ps_1
,replace(replace(t1.exec_ps_2,chr(13),''),chr(10),'') as exec_ps_2
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
from ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ifs_froz_stop_pay_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes