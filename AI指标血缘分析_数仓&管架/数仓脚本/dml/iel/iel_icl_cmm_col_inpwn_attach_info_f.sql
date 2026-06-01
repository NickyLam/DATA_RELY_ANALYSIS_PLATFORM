: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_col_inpwn_attach_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_col_inpwn_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t1.wat_id,chr(13),''),chr(10),'') as wat_id
,t1.inpwn_qtty as inpwn_qtty
,t1.col_cost as col_cost
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.spcl_info_type_cd,chr(13),''),chr(10),'') as spcl_info_type_cd
from ${icl_schema}.cmm_col_inpwn_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_col_inpwn_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes