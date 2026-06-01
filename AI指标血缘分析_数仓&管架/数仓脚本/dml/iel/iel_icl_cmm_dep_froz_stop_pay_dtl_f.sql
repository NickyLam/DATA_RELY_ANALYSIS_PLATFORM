: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_froz_stop_pay_dtl_f
CreateDate: 20221125
FileName:   ${iel_data_path}/cmm_dep_froz_stop_pay_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,froz_stop_pay_dt
,replace(replace(t1.froz_stop_pay_flow_num,chr(13),''),chr(10),'') as froz_stop_pay_flow_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t1.proof_cate_cd,chr(13),''),chr(10),'') as proof_cate_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.froz_stop_pay_bus_way_cd,chr(13),''),chr(10),'') as froz_stop_pay_bus_way_cd
,replace(replace(t1.froz_stop_pay_cate_cd,chr(13),''),chr(10),'') as froz_stop_pay_cate_cd
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,appl_froz_amt
,surp_froz_amt
,froz_end_dt
,replace(replace(t1.froz_rs,chr(13),''),chr(10),'') as froz_rs
,replace(replace(t1.exec_org_name,chr(13),''),chr(10),'') as exec_org_name
,replace(replace(t1.exec_cert_cd_1,chr(13),''),chr(10),'') as exec_cert_cd_1
,replace(replace(t1.exec_id_1,chr(13),''),chr(10),'') as exec_id_1
,replace(replace(t1.exec_cert_cd_2,chr(13),''),chr(10),'') as exec_cert_cd_2
,replace(replace(t1.exec_id_2,chr(13),''),chr(10),'') as exec_id_2
,replace(replace(t1.exec_ps_name_1,chr(13),''),chr(10),'') as exec_ps_name_1
,replace(replace(t1.jut_froz_stop_pay_flg,chr(13),''),chr(10),'') as jut_froz_stop_pay_flg
,replace(replace(t1.jut_froz_stop_pay_type_cd,chr(13),''),chr(10),'') as jut_froz_stop_pay_type_cd
,replace(replace(t1.inv_ctrl_sys_id,chr(13),''),chr(10),'') as inv_ctrl_sys_id
,replace(replace(t1.inv_ctrl_sys_name,chr(13),''),chr(10),'') as inv_ctrl_sys_name
,replace(replace(t1.inv_ctrl_char,chr(13),''),chr(10),'') as inv_ctrl_char
,replace(replace(t1.exec_ps_name_2,chr(13),''),chr(10),'') as exec_ps_name_2
,replace(replace(t1.apv_teller_id,chr(13),''),chr(10),'') as apv_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.old_sub_acct_id,chr(13),''),chr(10),'') as old_sub_acct_id
,froz_stop_pay_timestamp
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id

from ${icl_schema}.cmm_dep_froz_stop_pay_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_froz_stop_pay_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
