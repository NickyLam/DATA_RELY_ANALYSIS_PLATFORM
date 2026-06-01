: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_priv_founs_agt_sign_h_f
CreateDate: 20240603
FileName:   ${iel_data_path}/agt_priv_founs_agt_sign_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,coll_start_dt
,coll_end_dt
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd

from ${iml_schema}.agt_priv_founs_agt_sign_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_priv_founs_agt_sign_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
