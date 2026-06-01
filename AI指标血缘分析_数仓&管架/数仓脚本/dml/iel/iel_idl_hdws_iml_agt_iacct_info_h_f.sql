: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_iacct_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_iacct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.sub_num,chr(13),''),chr(10),'') as sub_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.open_evt_id,chr(13),''),chr(10),'') as open_evt_id
,replace(replace(t1.colse_evt_id,chr(13),''),chr(10),'') as colse_evt_id
,replace(replace(t1.off_flg,chr(13),''),chr(10),'') as off_flg
,t1.open_dt as open_dt
,t1.colse_dt as colse_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.acct_bal as acct_bal
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.gl_acct_flg,chr(13),''),chr(10),'') as gl_acct_flg
,t1.prev_trx_dt as prev_trx_dt
,replace(replace(t1.prev_trx_srl_id,chr(13),''),chr(10),'') as prev_trx_srl_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_IACCT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_IACCT_H') as etl_task_name 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.inter_acct_acct_typ_cd,chr(13),''),chr(10),'') as inter_acct_acct_typ_cd
,replace(replace(t1.int_flg,chr(13),''),chr(10),'') as int_flg
,replace(replace(t1.int_mode,chr(13),''),chr(10),'') as int_mode
,t1.rate as rate
from ${idl_schema}.hdws_iml_agt_iacct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_iacct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes