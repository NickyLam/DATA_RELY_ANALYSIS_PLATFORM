: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_bond_asset_cate_def_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_bond_asset_cate_def.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bond_asset_cate_cd,chr(13),''),chr(10),'') as bond_asset_cate_cd
,replace(replace(t1.bond_asset_cn_name,chr(13),''),chr(10),'') as bond_asset_cn_name
,create_dt
,update_dt

from ${iml_schema}.ref_bond_asset_cate_def t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bond_asset_cate_def.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
