: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tsafebox_bus_flow_f
CreateDate: 20240330
FileName:   ${iel_data_path}/evt_tsafebox_bus_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,tran_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.safe_box_id,chr(13),''),chr(10),'') as safe_box_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_sub_acct_num,chr(13),''),chr(10),'') as pay_sub_acct_num
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_prod_id,chr(13),''),chr(10),'') as payer_prod_id
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_sub_acct_num,chr(13),''),chr(10),'') as recvbl_sub_acct_num
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recver_prod_id,chr(13),''),chr(10),'') as recver_prod_id
,margin
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,vouch_invalid_dt
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.unpacker_9elmnt,chr(13),''),chr(10),'') as unpacker_9elmnt
,replace(replace(t1.unpacker_20elmnt,chr(13),''),chr(10),'') as unpacker_20elmnt
,replace(replace(t1.unpacker_open_acct_vrfction_pass_flg,chr(13),''),chr(10),'') as unpacker_open_acct_vrfction_pass_flg
,replace(replace(t1.unpacker_kyc_pass_flg,chr(13),''),chr(10),'') as unpacker_kyc_pass_flg
,replace(replace(t1.unpacker_anti_mon_lau_vrfction_pass_flg,chr(13),''),chr(10),'') as unpacker_anti_mon_lau_vrfction_pass_flg
,replace(replace(t1.unpacker_netw_vrfction_pass_flg,chr(13),''),chr(10),'') as unpacker_netw_vrfction_pass_flg
,replace(replace(t1.co_sign_unpacker_9elmnt,chr(13),''),chr(10),'') as co_sign_unpacker_9elmnt
,replace(replace(t1.co_sign_unpacker_open_acct_vrfction_pass_flg,chr(13),''),chr(10),'') as co_sign_unpacker_open_acct_vrfction_pass_flg
,replace(replace(t1.co_sign_unpacker_kyc_pass_flg,chr(13),''),chr(10),'') as co_sign_unpacker_kyc_pass_flg
,replace(replace(t1.co_sign_unpacker_anti_mon_lau_vrfction_pass_flg,chr(13),''),chr(10),'') as co_sign_unpacker_anti_mon_lau_vrfction_pass_flg
,replace(replace(t1.co_sign_unpacker_netw_vrfction_pass_flg,chr(13),''),chr(10),'') as co_sign_unpacker_netw_vrfction_pass_flg
,replace(replace(t1.agent_4_elmnt,chr(13),''),chr(10),'') as agent_4_elmnt
,replace(replace(t1.agent_open_acct_vrfction_pass_flg,chr(13),''),chr(10),'') as agent_open_acct_vrfction_pass_flg
,replace(replace(t1.agent_kyc_pass_flg,chr(13),''),chr(10),'') as agent_kyc_pass_flg
,replace(replace(t1.agent_anti_mon_lau_vrfction_pass_flg,chr(13),''),chr(10),'') as agent_anti_mon_lau_vrfction_pass_flg
,replace(replace(t1.agent_netw_vrfction_pass_flg,chr(13),''),chr(10),'') as agent_netw_vrfction_pass_flg
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.onacct_and_wrtoff_flow_num,chr(13),''),chr(10),'') as onacct_and_wrtoff_flow_num
,replace(replace(t1.trdpty_tran_code,chr(13),''),chr(10),'') as trdpty_tran_code
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,core_dt
,replace(replace(t1.entry_sub_flow_num,chr(13),''),chr(10),'') as entry_sub_flow_num
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.revs_ova_flow_num,chr(13),''),chr(10),'') as revs_ova_flow_num
,revs_cnt
,replace(replace(t1.revs_fail_remark,chr(13),''),chr(10),'') as revs_fail_remark
,replace(replace(t1.reply_cd,chr(13),''),chr(10),'') as reply_cd
,replace(replace(t1.reply_info,chr(13),''),chr(10),'') as reply_info
,final_update_dt
,replace(replace(t1.rent_safebox_status_cd,chr(13),''),chr(10),'') as rent_safebox_status_cd
,rent_safebox_dt
,rent_safebox_exp_dt
,replace(replace(t1.proc_teller_id,chr(13),''),chr(10),'') as proc_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id

from ${iml_schema}.evt_tsafebox_bus_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tsafebox_bus_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
