: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_tb_voucher_info_hist_f
CreateDate: 20230423
FileName:   ${iel_data_path}/ncbs_tb_voucher_info_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.voucher_status,chr(13),''),chr(10),'') as voucher_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.tailbox_id,chr(13),''),chr(10),'') as tailbox_id
,replace(replace(t1.voucher_id,chr(13),''),chr(10),'') as voucher_id
,voucher_sum
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,update_date
,link_value
,tran_amt
,replace(replace(t1.voucher_end_no,chr(13),''),chr(10),'') as voucher_end_no
,replace(replace(t1.voucher_start_no,chr(13),''),chr(10),'') as voucher_start_no
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_tb_voucher_info_hist t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_voucher_info_hist.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
