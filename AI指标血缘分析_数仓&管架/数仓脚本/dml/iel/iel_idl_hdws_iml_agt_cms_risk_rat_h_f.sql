: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_cms_risk_rat_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_cms_risk_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,t1.rat_dt as rat_dt
,replace(replace(t1.rat_org_id,chr(13),''),chr(10),'') as rat_org_id
,replace(replace(t1.rat_oper_emply_id,chr(13),''),chr(10),'') as rat_oper_emply_id
,replace(replace(t1.auto_rat_flg,chr(13),''),chr(10),'') as auto_rat_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_CMS_RISK_RAT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_CMS_RISK_RAT_H') as etl_task_name 
,replace(replace(t1.adj_emply_num,chr(13),''),chr(10),'') as adj_emply_num
,replace(replace(t1.aprv_emply_num,chr(13),''),chr(10),'') as aprv_emply_num
,replace(replace(t1.auth_emply_num,chr(13),''),chr(10),'') as auth_emply_num
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.loan_fifth_modal_chg_rsns,chr(13),''),chr(10),'') as loan_fifth_modal_chg_rsns
from ${idl_schema}.hdws_iml_agt_cms_risk_rat t1
where del_flg <> '1' and ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD')) and RISK_RAT_CATEG_CD = '2' ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_cms_risk_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes