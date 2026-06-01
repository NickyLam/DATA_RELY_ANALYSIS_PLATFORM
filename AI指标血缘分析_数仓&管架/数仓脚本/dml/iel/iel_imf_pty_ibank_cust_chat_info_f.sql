: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_ibank_cust_chat_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_ibank_cust_chat_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fin_inst_cate_cd,chr(13),''),chr(10),'') as fin_inst_cate_cd
,replace(replace(t1.open_acct_lics_num,chr(13),''),chr(10),'') as open_acct_lics_num
,replace(replace(t1.fx_mang_lics_num,chr(13),''),chr(10),'') as fx_mang_lics_num
,replace(replace(t1.fin_lics_num,chr(13),''),chr(10),'') as fin_lics_num
,replace(replace(t1.csrc_cd_no,chr(13),''),chr(10),'') as csrc_cd_no
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.swift_id,chr(13),''),chr(10),'') as swift_id
,replace(replace(t1.apv_num,chr(13),''),chr(10),'') as apv_num
,t1.apv_num_valid_dt as apv_num_valid_dt
,replace(replace(t1.corp_fori_exch_cd,chr(13),''),chr(10),'') as corp_fori_exch_cd
,replace(replace(t1.cbrc_oss_code,chr(13),''),chr(10),'') as cbrc_oss_code
,t1.cbrc_oss_code_valid_dt as cbrc_oss_code_valid_dt
,replace(replace(t1.insure_lics_num,chr(13),''),chr(10),'') as insure_lics_num
,t1.insure_lics_valid_dt as insure_lics_valid_dt
,replace(replace(t1.secu_lics_num,chr(13),''),chr(10),'') as secu_lics_num
,t1.secu_lics_valid_dt as secu_lics_valid_dt
,replace(replace(t1.intstl_factor_cert_num,chr(13),''),chr(10),'') as intstl_factor_cert_num
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.fin_inst_code,chr(13),''),chr(10),'') as fin_inst_code
from ${iml_schema}.pty_ibank_cust_chat_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_ibank_cust_chat_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes