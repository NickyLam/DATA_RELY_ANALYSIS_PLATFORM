: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_public_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_public_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.cd_id,chr(13),''),chr(10),'') as cd_id
,replace(replace(t.cd_cn_name,chr(13),''),chr(10),'') as cd_cn_name
,replace(replace(t.cd_en_name,chr(13),''),chr(10),'') as cd_en_name
,replace(replace(t.cd_val,chr(13),''),chr(10),'') as cd_val
,replace(replace(t.cd_desc,chr(13),''),chr(10),'') as cd_desc
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
from iol.ilss_ghb_public_code t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_public_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes