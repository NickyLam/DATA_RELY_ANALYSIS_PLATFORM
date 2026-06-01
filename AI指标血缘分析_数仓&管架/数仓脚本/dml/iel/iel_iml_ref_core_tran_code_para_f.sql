: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_core_tran_code_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_core_tran_code_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.cn_name,chr(13),''),chr(10),'') as cn_name 
,replace(replace(t1.use_flg,chr(13),''),chr(10),'') as use_flg 
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name 
,replace(replace(t1.descb,chr(13),''),chr(10),'') as descb 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ref_core_tran_code_para t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_core_tran_code_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes