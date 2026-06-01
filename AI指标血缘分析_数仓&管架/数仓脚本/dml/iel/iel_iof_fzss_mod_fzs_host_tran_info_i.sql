: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_host_tran_info_i
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_host_tran_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.plat_date,chr(13),''),chr(10),'') as plat_date
,replace(replace(t1.plat_time,chr(13),''),chr(10),'') as plat_time
,replace(replace(t1.plat_serial_no,chr(13),''),chr(10),'') as plat_serial_no
,replace(replace(t1.channel_no,chr(13),''),chr(10),'') as channel_no
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.global_serial_no,chr(13),''),chr(10),'') as global_serial_no
,replace(replace(t1.corp_work_date,chr(13),''),chr(10),'') as corp_work_date
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,replace(replace(t1.plat_tran_type,chr(13),''),chr(10),'') as plat_tran_type
,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,tran_amt
,replace(replace(t1.revtranf,chr(13),''),chr(10),'') as revtranf
,replace(replace(t1.dc_flag,chr(13),''),chr(10),'') as dc_flag
,replace(replace(t1.to_acct_no,chr(13),''),chr(10),'') as to_acct_no
,replace(replace(t1.to_acct_name,chr(13),''),chr(10),'') as to_acct_name
,replace(replace(t1.to_final_inst_code,chr(13),''),chr(10),'') as to_final_inst_code
,replace(replace(t1.to_final_inst_name,chr(13),''),chr(10),'') as to_final_inst_name
,replace(replace(t1.cnaps_branch_id,chr(13),''),chr(10),'') as cnaps_branch_id
,replace(replace(t1.bank_flag,chr(13),''),chr(10),'') as bank_flag
,replace(replace(t1.abst_code,chr(13),''),chr(10),'') as abst_code
,replace(replace(t1.abst_desc,chr(13),''),chr(10),'') as abst_desc
,replace(replace(t1.ppp_check_code,chr(13),''),chr(10),'') as ppp_check_code
,replace(replace(t1.ppp_srv_cllpty_trx_seq,chr(13),''),chr(10),'') as ppp_srv_cllpty_trx_seq
,replace(replace(t1.ppp_status,chr(13),''),chr(10),'') as ppp_status
,replace(replace(t1.ppp_code,chr(13),''),chr(10),'') as ppp_code
,replace(replace(t1.ppp_msg,chr(13),''),chr(10),'') as ppp_msg
,replace(replace(t1.ppp_date,chr(13),''),chr(10),'') as ppp_date
,replace(replace(t1.ppp_time,chr(13),''),chr(10),'') as ppp_time
,replace(replace(t1.ppp_serial_no,chr(13),''),chr(10),'') as ppp_serial_no
,replace(replace(t1.ppp_chnl_encd,chr(13),''),chr(10),'') as ppp_chnl_encd
,replace(replace(t1.ppp_seq_no,chr(13),''),chr(10),'') as ppp_seq_no
,replace(replace(t1.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t1.host_time,chr(13),''),chr(10),'') as host_time
,replace(replace(t1.host_serial_no,chr(13),''),chr(10),'') as host_serial_no
,replace(replace(t1.check_status,chr(13),''),chr(10),'') as check_status
,replace(replace(t1.is_check_deal,chr(13),''),chr(10),'') as is_check_deal
,replace(replace(t1.fund_flag,chr(13),''),chr(10),'') as fund_flag
,replace(replace(t1.fund_date,chr(13),''),chr(10),'') as fund_date
,replace(replace(t1.fund_serial_no,chr(13),''),chr(10),'') as fund_serial_no
,replace(replace(t1.fund_reason,chr(13),''),chr(10),'') as fund_reason
,replace(replace(t1.reversal_flag,chr(13),''),chr(10),'') as reversal_flag
,replace(replace(t1.reversal_date,chr(13),''),chr(10),'') as reversal_date
,replace(replace(t1.reversal_serial_no,chr(13),''),chr(10),'') as reversal_serial_no
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.error_code,chr(13),''),chr(10),'') as error_code
,replace(replace(t1.error_msg,chr(13),''),chr(10),'') as error_msg
,create_timestamp
,update_timestamp
,start_dt
,end_dt

from ${iol_schema}.fzss_mod_fzs_host_tran_info t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_host_tran_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
