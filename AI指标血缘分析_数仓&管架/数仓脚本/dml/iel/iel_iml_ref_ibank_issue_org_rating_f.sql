: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ibank_issue_org_rating_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_issue_org_rating.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.issue_org_name,chr(13),''),chr(10),'') as issue_org_name
,replace(replace(t1.rating_type_cd,chr(13),''),chr(10),'') as rating_type_cd
,replace(replace(t1.crdt_rating_cd,chr(13),''),chr(10),'') as crdt_rating_cd
,replace(replace(t1.rating_org_name,chr(13),''),chr(10),'') as rating_org_name
,effect_dt
,invalid_dt
,replace(replace(t1.rating_outl,chr(13),''),chr(10),'') as rating_outl
,input_dt
,create_dt
,update_dt

from ${iml_schema}.ref_ibank_issue_org_rating t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_issue_org_rating.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
