: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_eacct_bd_card_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_eacct_bd_card_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.bd_card_id,chr(13),''),chr(10),'') as bd_card_id
    ,t.bind_tm as bind_tm
    ,t.unbind_tm as unbind_tm
    ,t.resv_bd_amt as resv_bd_amt
    ,replace(replace(t.bd_card_open_acct_bank_id,chr(13),''),chr(10),'') as bd_card_open_acct_bank_id
    ,replace(replace(t.bd_card_open_acct_bank_name,chr(13),''),chr(10),'') as bd_card_open_acct_bank_name
    ,replace(replace(t.bd_card_open_acct_name,chr(13),''),chr(10),'') as bd_card_open_acct_name
    ,replace(replace(t.bd_card_open_acct_brac_id,chr(13),''),chr(10),'') as bd_card_open_acct_brac_id
    ,replace(replace(t.bd_card_type_cd,chr(13),''),chr(10),'') as bd_card_type_cd
    ,replace(replace(t.bd_card_belong_lev_cd,chr(13),''),chr(10),'') as bd_card_belong_lev_cd
    ,replace(replace(t.card_bind_status_cd,chr(13),''),chr(10),'') as card_bind_status_cd
    ,replace(replace(t.open_bank_fin_inst_id,chr(13),''),chr(10),'') as open_bank_fin_inst_id
    ,replace(replace(t.this_obank_flg,chr(13),''),chr(10),'') as this_obank_flg
    ,replace(replace(t.scut_pay_flg,chr(13),''),chr(10),'') as scut_pay_flg
    ,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
    ,replace(replace(t.mercht_name,chr(13),''),chr(10),'') as mercht_name
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
    ,replace(replace(t.rela_acct_num,chr(13),''),chr(10),'') as rela_acct_num
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_eacct_bd_card_h t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_eacct_bd_card_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes