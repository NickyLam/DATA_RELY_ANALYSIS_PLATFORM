: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_bank_acct_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_corp_bank_acct_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd 
,replace(replace(t.basic_open_bank_no,chr(13),''),chr(10),'') as basic_open_bank_no 
,replace(replace(t.basic_open_bank_name,chr(13),''),chr(10),'') as basic_open_bank_name 
,replace(replace(t.basic_acct_id,chr(13),''),chr(10),'') as basic_acct_id 
,t.basic_open_acct_dt as basic_open_acct_dt 
,replace(replace(t.obank_acct_num,chr(13),''),chr(10),'') as obank_acct_num 
,replace(replace(t.obank_acct_bank_name,chr(13),''),chr(10),'') as obank_acct_bank_name 
,replace(replace(t.hxb_acct_num,chr(13),''),chr(10),'') as hxb_acct_num 
,replace(replace(t.hxb_acct_bank_name,chr(13),''),chr(10),'') as hxb_acct_bank_name 
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_corp_bank_acct_info_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6)" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_bank_acct_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes