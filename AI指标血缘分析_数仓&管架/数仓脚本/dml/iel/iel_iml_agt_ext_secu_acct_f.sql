: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ext_secu_acct_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_ext_secu_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.trust_site_id,chr(13),''),chr(10),'') as trust_site_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.stl_site_id,chr(13),''),chr(10),'') as stl_site_id
,replace(replace(t1.stl_site_name,chr(13),''),chr(10),'') as stl_site_name
,create_dt
,update_dt

from ${iml_schema}.agt_ext_secu_acct t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ext_secu_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
