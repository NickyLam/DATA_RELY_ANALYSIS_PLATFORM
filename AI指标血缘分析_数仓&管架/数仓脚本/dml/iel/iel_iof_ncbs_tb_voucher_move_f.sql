: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_tb_voucher_move_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_voucher_move.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.from_tailbox_id,chr(13),''),chr(10),'') as from_tailbox_id
,replace(replace(t1.move_id,chr(13),''),chr(10),'') as move_id
,replace(replace(t1.move_type,chr(13),''),chr(10),'') as move_type
,replace(replace(t1.to_tailbox_id,chr(13),''),chr(10),'') as to_tailbox_id
,replace(replace(t1.tran_desc,chr(13),''),chr(10),'') as tran_desc
,t1.tran_date as tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.from_user_id,chr(13),''),chr(10),'') as from_user_id
,replace(replace(t1.oth_reference,chr(13),''),chr(10),'') as oth_reference
,replace(replace(t1.to_branch,chr(13),''),chr(10),'') as to_branch
,replace(replace(t1.to_user_id,chr(13),''),chr(10),'') as to_user_id
,replace(replace(t1.from_branch,chr(13),''),chr(10),'') as from_branch
,replace(replace(t1.contra_branch_type,chr(13),''),chr(10),'') as contra_branch_type
,replace(replace(t1.move_status,chr(13),''),chr(10),'') as move_status
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_tb_voucher_move t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_voucher_move.f.${batch_date}.dat" \
        charset=utf8
        safe=yes