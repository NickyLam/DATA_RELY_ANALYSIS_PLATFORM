: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_pub_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_pub_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cd_id,chr(13),''),chr(10),'') as cd_id
,replace(replace(t1.cd_tab_en_name,chr(13),''),chr(10),'') as cd_tab_en_name
,replace(replace(t1.cd_tab_cn_descb,chr(13),''),chr(10),'') as cd_tab_cn_descb
,replace(replace(t1.cd_val,chr(13),''),chr(10),'') as cd_val
,replace(replace(t1.cd_descb,chr(13),''),chr(10),'') as cd_descb
,replace(replace(t1.data_std_flg,chr(13),''),chr(10),'') as data_std_flg
,replace(replace(t1.quote_data_std,chr(13),''),chr(10),'') as quote_data_std
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.parent_cd,chr(13),''),chr(10),'') as parent_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,t1.invalid_dt as invalid_dt
from ${iml_schema}.ref_pub_cd t1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_pub_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes