: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_htes_draft_his_info_f
CreateDate: 20241023
FileName:   ${iel_data_path}/bdms_htes_draft_his_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msg_type,chr(13),''),chr(10),'') as msg_type
,replace(replace(t1.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t1.req_type,chr(13),''),chr(10),'') as req_type
,replace(replace(t1.req_name,chr(13),''),chr(10),'') as req_name
,replace(replace(t1.req_cert_no,chr(13),''),chr(10),'') as req_cert_no
,replace(replace(t1.req_account,chr(13),''),chr(10),'') as req_account
,replace(replace(t1.req_mem_no,chr(13),''),chr(10),'') as req_mem_no
,replace(replace(t1.req_brh_no,chr(13),''),chr(10),'') as req_brh_no
,replace(replace(t1.req_bank_no,chr(13),''),chr(10),'') as req_bank_no
,replace(replace(t1.req_industry,chr(13),''),chr(10),'') as req_industry
,replace(replace(t1.req_corp_scale,chr(13),''),chr(10),'') as req_corp_scale
,replace(replace(t1.req_dr_act,chr(13),''),chr(10),'') as req_dr_act
,replace(replace(t1.req_area,chr(13),''),chr(10),'') as req_area
,replace(replace(t1.req_is_grn,chr(13),''),chr(10),'') as req_is_grn
,replace(replace(t1.req_misc,chr(13),''),chr(10),'') as req_misc
,replace(replace(t1.rcv_type,chr(13),''),chr(10),'') as rcv_type
,replace(replace(t1.rcv_name,chr(13),''),chr(10),'') as rcv_name
,replace(replace(t1.rcv_cert_no,chr(13),''),chr(10),'') as rcv_cert_no
,replace(replace(t1.rcv_account,chr(13),''),chr(10),'') as rcv_account
,replace(replace(t1.rcv_mem_no,chr(13),''),chr(10),'') as rcv_mem_no
,replace(replace(t1.rcv_brh_no,chr(13),''),chr(10),'') as rcv_brh_no
,replace(replace(t1.rcv_bank_no,chr(13),''),chr(10),'') as rcv_bank_no
,replace(replace(t1.rcv_misc,chr(13),''),chr(10),'') as rcv_misc
,replace(replace(t1.buss_occ_dt,chr(13),''),chr(10),'') as buss_occ_dt
,replace(replace(t1.buss_occ_tm,chr(13),''),chr(10),'') as buss_occ_tm
,replace(replace(t1.buss_fns_dt,chr(13),''),chr(10),'') as buss_fns_dt
,replace(replace(t1.buss_fns_tm,chr(13),''),chr(10),'') as buss_fns_tm
,replace(replace(t1.grnt_address,chr(13),''),chr(10),'') as grnt_address
,replace(replace(t1.move_trs_type,chr(13),''),chr(10),'') as move_trs_type
,replace(replace(t1.conf_pay_type,chr(13),''),chr(10),'') as conf_pay_type
,replace(replace(t1.conf_pay_add_type,chr(13),''),chr(10),'') as conf_pay_add_type
,replace(replace(t1.conf_pay_rst,chr(13),''),chr(10),'') as conf_pay_rst
,replace(replace(t1.conf_status,chr(13),''),chr(10),'') as conf_status
,replace(replace(t1.stop_pay_type,chr(13),''),chr(10),'') as stop_pay_type
,replace(replace(t1.stop_pay_rsn,chr(13),''),chr(10),'') as stop_pay_rsn
,replace(replace(t1.relieve_stp_type,chr(13),''),chr(10),'') as relieve_stp_type
,replace(replace(t1.relieve_stp_rsn,chr(13),''),chr(10),'') as relieve_stp_rsn
,replace(replace(t1.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t1.buy_back_date,chr(13),''),chr(10),'') as buy_back_date
,replace(replace(t1.real_back_date,chr(13),''),chr(10),'') as real_back_date
,replace(replace(t1.buy_back_status,chr(13),''),chr(10),'') as buy_back_status
,replace(replace(t1.exchge_status,chr(13),''),chr(10),'') as exchge_status
,replace(replace(t1.prmt_result,chr(13),''),chr(10),'') as prmt_result
,replace(replace(t1.prmt_refuse_rsn,chr(13),''),chr(10),'') as prmt_refuse_rsn
,replace(replace(t1.prmt_stl_rst,chr(13),''),chr(10),'') as prmt_stl_rst
,replace(replace(t1.reserver1,chr(13),''),chr(10),'') as reserver1
,replace(replace(t1.reserver2,chr(13),''),chr(10),'') as reserver2
,replace(replace(t1.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.bp_no,chr(13),''),chr(10),'') as bp_no
,replace(replace(t1.cd_range,chr(13),''),chr(10),'') as cd_range
,replace(replace(t1.discount_range,chr(13),''),chr(10),'') as discount_range
,replace(replace(t1.transfer_flag,chr(13),''),chr(10),'') as transfer_flag
,replace(replace(t1.req_dist_tp,chr(13),''),chr(10),'') as req_dist_tp
,replace(replace(t1.rcv_dist_tp,chr(13),''),chr(10),'') as rcv_dist_tp
,replace(replace(t1.prmt_refuse_other_inf,chr(13),''),chr(10),'') as prmt_refuse_other_inf
,replace(replace(t1.buy_back_other_inf,chr(13),''),chr(10),'') as buy_back_other_inf
,replace(replace(t1.bill_beh_seq,chr(13),''),chr(10),'') as bill_beh_seq
,replace(replace(t1.left_cd_range,chr(13),''),chr(10),'') as left_cd_range
,replace(replace(t1.right_cd_range,chr(13),''),chr(10),'') as right_cd_range
,replace(replace(t1.req_buss_type,chr(13),''),chr(10),'') as req_buss_type
,replace(replace(t1.rcv_buss_type,chr(13),''),chr(10),'') as rcv_buss_type
,replace(replace(t1.req_account_name,chr(13),''),chr(10),'') as req_account_name
,replace(replace(t1.rcv_account_name,chr(13),''),chr(10),'') as rcv_account_name
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by

from ${iol_schema}.bdms_htes_draft_his_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_htes_draft_his_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
