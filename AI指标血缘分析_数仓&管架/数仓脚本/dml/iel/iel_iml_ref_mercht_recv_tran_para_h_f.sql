: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_mercht_recv_tran_para_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_mercht_recv_tran_para_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.fin_tran_flg,chr(13),''),chr(10),'') as fin_tran_flg
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_mercht_recv_tran_para_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_mercht_recv_tran_para_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes