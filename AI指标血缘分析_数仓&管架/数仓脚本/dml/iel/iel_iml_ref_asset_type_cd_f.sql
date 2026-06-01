: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_asset_type_cd_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_asset_type_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_type_abbr,chr(13),''),chr(10),'') as asset_type_abbr
,replace(replace(t1.asset_type_fname,chr(13),''),chr(10),'') as asset_type_fname
,create_dt
,update_dt

from ${iml_schema}.ref_asset_type_cd t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_asset_type_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
