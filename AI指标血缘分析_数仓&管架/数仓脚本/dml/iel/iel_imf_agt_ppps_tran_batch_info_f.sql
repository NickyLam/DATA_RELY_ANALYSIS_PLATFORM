: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ppps_tran_batch_info_f
CreateDate: 20240826
FileName:   ${iel_data_path}/agt_ppps_tran_batch_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.chn_tran_flow_num,chr(13),''),chr(10),'') as chn_tran_flow_num
,chn_tran_dt
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.chn_sys_cd,chr(13),''),chr(10),'') as chn_sys_cd
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,tran_dt
,replace(replace(t1.tran_batch_status_cd,chr(13),''),chr(10),'') as tran_batch_status_cd
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tot_tran_amt
,tot_tran_cnt
,fail_amt
,fail_cnt
,sucs_amt
,sucs_cnt
,replace(replace(t1.plat_return_code,chr(13),''),chr(10),'') as plat_return_code
,replace(replace(t1.plat_return_descb,chr(13),''),chr(10),'') as plat_return_descb
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.fee_id,chr(13),''),chr(10),'') as fee_id
,replace(replace(t1.fee_descb,chr(13),''),chr(10),'') as fee_descb
,replace(replace(t1.inside_acct_flg,chr(13),''),chr(10),'') as inside_acct_flg
,replace(replace(t1.intnal_acct_id,chr(13),''),chr(10),'') as intnal_acct_id
,replace(replace(t1.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
,replace(replace(t1.corp_acct_id,chr(13),''),chr(10),'') as corp_acct_id
,replace(replace(t1.corp_acct_name,chr(13),''),chr(10),'') as corp_acct_name
,replace(replace(t1.sign_flg,chr(13),''),chr(10),'') as sign_flg
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,final_update_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_ppps_tran_batch_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ppps_tran_batch_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
