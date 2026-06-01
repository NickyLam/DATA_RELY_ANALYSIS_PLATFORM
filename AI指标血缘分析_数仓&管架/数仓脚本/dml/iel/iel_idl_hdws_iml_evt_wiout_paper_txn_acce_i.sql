: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_wiout_paper_txn_acce_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_wiout_paper_txn_acce.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.file_path,chr(13),''),chr(10),'') as file_path
,replace(replace(t1.main_flag,chr(13),''),chr(10),'') as main_flag
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,t1.txn_dt as txn_dt
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,t1.txn_amt as txn_amt
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,t1.scan_date as scan_date
,t1.etl_dt as etl_dt
,replace(replace(t1.evt_typ_cd,chr(13),''),chr(10),'') as evt_typ_cd
,replace(replace(t1.combinationseqno,chr(13),''),chr(10),'') as combinationseqno
from ${idl_schema}.hdws_iml_evt_wiout_paper_txn_acce t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_wiout_paper_txn_acce.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes