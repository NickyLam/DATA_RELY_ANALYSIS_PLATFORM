: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_eacct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/oass_agt_eacct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.agt_id
,t.lp_id
,t.acct_id
,t.acct_name
,t.open_acct_tm
,t.clos_acct_tm
,t.eacct_id
,t.cust_id
,t.open_acct_org_id
,t.vouch_id
,t.vouch_status_cd
,t.acct_status_cd
,t.tran_chn_status_cd
,t.froz_status_cd
,t.vrif_status_cd
,t.curr_cd
,t.eacct_level_cd
,t.netw_vrfction_rest_cd
,t.open_acct_chn_cd
,t.tran_chn_status_modif_org_id
,t.acct_type_cd
,t.acct_level_cd
,t.sav_type_cd
,t.tran_kind_cd
,t.prvy_acct_flg
,t.drawdown_way_cd
,t.vouch_kind_cd
,t.cust_lev_cd
,t.acct_orgnz_form_cd
,t.ec_idf_cd
,t.cross_tx_cd
,t.chip_card_cd
,t.co_card_type_cd
,t.blip_retnd_cd
,t.real_name_cert_cd
,t.bus_type_cd
,t.legal_flg
,t.legal_tm
,t.mercht_id
,t.mercht_name
,t.non_bind_enter_acct_flg
,t.sleep_acct_flg
,t.descb
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.oass_agt_eacct t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_eacct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes