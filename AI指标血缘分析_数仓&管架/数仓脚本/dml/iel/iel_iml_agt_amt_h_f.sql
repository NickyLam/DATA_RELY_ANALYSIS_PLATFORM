: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_amt_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_amt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(amt_type_cd,chr(13),''),chr(10),'')
,start_dt
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,amt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_amt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_amt_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
