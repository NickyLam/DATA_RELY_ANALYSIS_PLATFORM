: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_trust_corp_credit_risk_ac_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_trust_corp_credit_risk_ac.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,ed
,normal_category
,concern_category
,seondary_category
,suspicious_category
,loss_category
,credit_risk_total_asset
,total_bad_assets
,bad_assets_ratio
,isvalid

from ${iol_schema}.uxds_trust_corp_credit_risk_ac t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_trust_corp_credit_risk_ac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
