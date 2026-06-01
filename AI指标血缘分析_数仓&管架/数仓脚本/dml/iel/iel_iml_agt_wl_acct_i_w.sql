: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_acct_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_acct_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name 
,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd 
,replace(replace(t.cap_acct_id,chr(13),''),chr(10),'') as cap_acct_id 
,replace(replace(t.open_bank_name,chr(13),''),chr(10),'') as open_bank_name 
,replace(replace(t.open_bank_num,chr(13),''),chr(10),'') as open_bank_num 
,replace(replace(t.open_acct_name,chr(13),''),chr(10),'') as open_acct_name 
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd 
,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id 
,replace(replace(t.asset_acct_type_cd,chr(13),''),chr(10),'') as asset_acct_type_cd 
,replace(replace(t.bd_card_no,chr(13),''),chr(10),'') as bd_card_no 
,replace(replace(t.bind_mobile_no,chr(13),''),chr(10),'') as bind_mobile_no 
,replace(replace(t.pbc_fin_inst_code,chr(13),''),chr(10),'') as pbc_fin_inst_code 
,replace(replace(t.obank_card_flg,chr(13),''),chr(10),'') as obank_card_flg 
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id 
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_wl_acct t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6)" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_acct_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes