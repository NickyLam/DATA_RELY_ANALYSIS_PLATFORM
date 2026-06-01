: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_bank_acct_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_corp_bank_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sorc_sys_cd,chr(13),''),chr(10),'')
,replace(replace(basic_open_bank_no,chr(13),''),chr(10),'')
,replace(replace(basic_open_bank_name,chr(13),''),chr(10),'')
,replace(replace(basic_acct_id,chr(13),''),chr(10),'')
,basic_open_acct_dt
,replace(replace(obank_acct_num,chr(13),''),chr(10),'')
,replace(replace(obank_acct_bank_name,chr(13),''),chr(10),'')
,replace(replace(hxb_acct_num,chr(13),''),chr(10),'')
,replace(replace(hxb_acct_bank_name,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_corp_bank_acct_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_bank_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
