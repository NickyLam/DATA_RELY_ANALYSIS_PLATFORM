: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ref_acct_rgst_mobile_no_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ref_acct_rgst_mobile_no_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select mobile_no
,cert_type_cd
,cert_no
,acct_num
,acct_name
,acct_num_rgst_attr_cd
,onl_bank_sys_open_bank_no
,acct_open_bank_no
,acct_clear_bank_no
,rgst_tm
,mobile_no_status_cd
,job_cd
,etl_dt from idl.rpt_ref_acct_rgst_mobile_no_h where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ref_acct_rgst_mobile_no_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes