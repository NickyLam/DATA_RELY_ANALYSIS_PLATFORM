: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_jh_mercht_stl_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_jh_mercht_stl_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.agency_id,chr(13),''),chr(10),'') as agency_id
    ,replace(replace(t.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
    ,replace(replace(t.clear_ped_cd,chr(13),''),chr(10),'') as clear_ped_cd
    ,replace(replace(t.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
    ,replace(replace(t.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.open_acct_acct_addr,chr(13),''),chr(10),'') as open_acct_acct_addr
    ,t.t1_fee_rat as t1_fee_rat
    ,t.d0_fee_rat as d0_fee_rat
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_jh_mercht_stl_acct t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') 
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_jh_mercht_stl_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes