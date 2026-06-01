: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_cms_risk_rat_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_cms_risk_rat_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,t1.rat_dt as rat_dt
,replace(replace(t1.rat_org_id,chr(13),''),chr(10),'') as rat_org_id
,replace(replace(t1.rat_oper_emply_id,chr(13),''),chr(10),'') as rat_oper_emply_id
,replace(replace(t1.auto_rat_flg,chr(13),''),chr(10),'') as auto_rat_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_cms_risk_rat_02 t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_cms_risk_rat_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes