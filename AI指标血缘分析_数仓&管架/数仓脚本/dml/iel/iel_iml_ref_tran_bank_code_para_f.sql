: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_tran_bank_code_para_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_tran_bank_code_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.fin_tran_flg,chr(13),''),chr(10),'') as fin_tran_flg

from ${iml_schema}.ref_tran_bank_code_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tran_bank_code_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
