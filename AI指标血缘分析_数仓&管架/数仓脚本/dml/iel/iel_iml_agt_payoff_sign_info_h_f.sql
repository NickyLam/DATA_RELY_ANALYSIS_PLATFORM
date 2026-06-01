: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_payoff_sign_info_h_f
CreateDate: 20220819
FileName:   ${iel_data_path}/agt_payoff_sign_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
    ,replace(replace(t.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
    ,replace(replace(t.entr_acct_id,chr(13),''),chr(10),'') as entr_acct_id
    ,replace(replace(t.entr_acct_name,chr(13),''),chr(10),'') as entr_acct_name
    ,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
    ,replace(replace(t.corp_addr,chr(13),''),chr(10),'') as corp_addr
    ,replace(replace(t.intnal_acct_id,chr(13),''),chr(10),'') as intnal_acct_id
    ,replace(replace(t.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
    ,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
    ,t.sign_dt as sign_dt
    ,replace(replace(t.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
    ,replace(replace(t.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
    ,replace(replace(t.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.obank_flg,chr(13),''),chr(10),'') as obank_flg
    ,replace(replace(t.obank_acct_id,chr(13),''),chr(10),'') as obank_acct_id
    ,replace(replace(t.obank_acct_name,chr(13),''),chr(10),'') as obank_acct_name
    ,replace(replace(t.obank_bank_no,chr(13),''),chr(10),'') as obank_bank_no
    ,replace(replace(t.obank_bank_name,chr(13),''),chr(10),'') as obank_bank_name
    ,replace(replace(t.tran_inside_acct_id,chr(13),''),chr(10),'') as tran_inside_acct_id
    ,replace(replace(t.tran_inside_acct_name,chr(13),''),chr(10),'') as tran_inside_acct_name
    ,replace(replace(t.rfued_flg,chr(13),''),chr(10),'') as rfued_flg
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_payoff_sign_info_h t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_payoff_sign_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes