: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ic_card_offline_tran_flow_i
CreateDate: 20230111
FileName:   ${iel_data_path}/evt_ic_card_offline_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.offline_flow_num,chr(13),''),chr(10),'') as offline_flow_num
,replace(replace(t1.offline_batch_no,chr(13),''),chr(10),'') as offline_batch_no
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_ser_num,chr(13),''),chr(10),'') as card_ser_num
,replace(replace(t1.app_idf,chr(13),''),chr(10),'') as app_idf
,replace(replace(t1.offline_tran_type_cd,chr(13),''),chr(10),'') as offline_tran_type_cd
,tran_amt
,plat_tran_dt
,plat_tran_tm
,replace(replace(t1.unionpay_curr_cd,chr(13),''),chr(10),'') as unionpay_curr_cd
,unionpay_clear_dt
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.serv_status_descb,chr(13),''),chr(10),'') as serv_status_descb
,replace(replace(t1.tran_addr_desc,chr(13),''),chr(10),'') as tran_addr_desc
,elec_cash_acct_bal
,other_amt
,replace(replace(t1.adj_entry_flg,chr(13),''),chr(10),'') as adj_entry_flg
,replace(replace(t1.entry_flg,chr(13),''),chr(10),'') as entry_flg
,enter_acct_dt
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.termn_flow_num,chr(13),''),chr(10),'') as termn_flow_num
,replace(replace(t1.termn_cty_cd,chr(13),''),chr(10),'') as termn_cty_cd

from ${iml_schema}.evt_ic_card_offline_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ic_card_offline_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
