: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_evt_loan_putout_noti_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_evt_loan_putout_noti.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,t1.txn_dt as txn_dt
,replace(replace(t1.singl_bil_id,chr(13),''),chr(10),'') as singl_bil_id
,replace(replace(t1.putout_org_id,chr(13),''),chr(10),'') as putout_org_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.ibp_id,chr(13),''),chr(10),'') as ibp_id
,replace(replace(t1.biz_id_1,chr(13),''),chr(10),'') as biz_id_1
,replace(replace(t1.biz_id_2,chr(13),''),chr(10),'') as biz_id_2
,replace(replace(t1.biz_typ,chr(13),''),chr(10),'') as biz_typ
,replace(replace(t1.coll_typ_cd,chr(13),''),chr(10),'') as coll_typ_cd
,replace(replace(t1.coll_row,chr(13),''),chr(10),'') as coll_row
,t1.issue_dt as issue_dt
,t1.due_dt as due_dt
,replace(replace(t1.biz_ccy_cd,chr(13),''),chr(10),'') as biz_ccy_cd
,replace(replace(t1.biz_ccy_cd_3,chr(13),''),chr(10),'') as biz_ccy_cd_3
,t1.biz_amt as biz_amt
,t1.biz_rate as biz_rate
,replace(replace(t1.oper_org,chr(13),''),chr(10),'') as oper_org
,replace(replace(t1.oprt,chr(13),''),chr(10),'') as oprt
,t1.oper_dt as oper_dt
,replace(replace(t1.contr_num,chr(13),''),chr(10),'') as contr_num
,replace(replace(t1.dbill_num,chr(13),''),chr(10),'') as dbill_num
,replace(replace(t1.txn_status_cd,chr(13),''),chr(10),'') as txn_status_cd
,t1.rela_dt as rela_dt
,t1.rela_ratio_1 as rela_ratio_1
,t1.rela_ratio_2 as rela_ratio_2
,t1.rela_amt_1 as rela_amt_1
,t1.rela_amt_2 as rela_amt_2
,t1.rela_amt_3 as rela_amt_3
,t1.etl_dt as etl_dt
,NVL2(t1.data_src_cd,'EVT_LOAN_PUTOUT_NOTI'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_LOAN_PUTOUT_NOTI') as etl_task_name 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_evt_loan_putout_noti t1
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_evt_loan_putout_noti.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes