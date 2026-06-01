: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_crdt_repay_int_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_crdt_repay_int_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.repay_int_seq_num,chr(13),''),chr(10),'') as repay_int_seq_num
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.repay_int_amt as repay_int_amt
,replace(replace(t.int_kind_cd,chr(13),''),chr(10),'') as int_kind_cd
,t.repay_int_dt as repay_int_dt
,replace(replace(t.term_num,chr(13),''),chr(10),'') as term_num
,replace(replace(t.loan_seq_num,chr(13),''),chr(10),'') as loan_seq_num
,replace(replace(t.int_cate_cd,chr(13),''),chr(10),'') as int_cate_cd
,replace(replace(t.pric_bal_seq_num,chr(13),''),chr(10),'') as pric_bal_seq_num
,t.pric_belong_perds as pric_belong_perds
from ${iml_schema}.evt_corp_crdt_repay_int_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_crdt_repay_int_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes