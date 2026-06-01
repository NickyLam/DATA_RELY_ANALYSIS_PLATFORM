: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_accti_prod_rela_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_accti_prod_rela_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.accti_id,chr(13),''),chr(10),'') as accti_id
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'') as prod_attr_cd
from ${iml_schema}.fin_accti_prod_rela_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_accti_prod_rela_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes