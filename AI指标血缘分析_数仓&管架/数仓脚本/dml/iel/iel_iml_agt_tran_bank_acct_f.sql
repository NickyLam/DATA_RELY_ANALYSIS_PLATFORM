: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_tran_bank_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_tran_bank_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id 
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name 
,replace(replace(t1.acct_cate_cd,chr(13),''),chr(10),'') as acct_cate_cd 
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name 
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id 
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd 
,replace(replace(t1.sign_flg,chr(13),''),chr(10),'') as sign_flg 
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd 
,replace(replace(t1.hide_flg,chr(13),''),chr(10),'') as hide_flg 
,replace(replace(t1.prvlg_open_flg,chr(13),''),chr(10),'') as prvlg_open_flg 
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd 
,t1.fir_bind_tm as fir_bind_tm 
,t1.rels_dt as rels_dt 
,t1.core_open_tm as core_open_tm 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_tran_bank_acct t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_tran_bank_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes