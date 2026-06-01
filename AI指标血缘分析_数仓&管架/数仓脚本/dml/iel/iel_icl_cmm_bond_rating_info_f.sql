: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_bond_rating_info_f
CreateDate: 20240819
FileName:   ${iel_data_path}/cmm_bond_rating_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.bond_market_type_cd,chr(13),''),chr(10),'') as bond_market_type_cd
,replace(replace(t1.rating_corp_id,chr(13),''),chr(10),'') as rating_corp_id
,replace(replace(t1.rating_corp_cn_name,chr(13),''),chr(10),'') as rating_corp_cn_name
,replace(replace(t1.rating_corp_en_name,chr(13),''),chr(10),'') as rating_corp_en_name
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.bond_abbr,chr(13),''),chr(10),'') as bond_abbr
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,replace(replace(t1.bond_cls_name,chr(13),''),chr(10),'') as bond_cls_name
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.rating_rest_cd,chr(13),''),chr(10),'') as rating_rest_cd
,replace(replace(t1.rating_type_cd,chr(13),''),chr(10),'') as rating_type_cd
,rating_dt
,replace(replace(t1.src_sys_idf,chr(13),''),chr(10),'') as src_sys_idf

from ${icl_schema}.cmm_bond_rating_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bond_rating_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
