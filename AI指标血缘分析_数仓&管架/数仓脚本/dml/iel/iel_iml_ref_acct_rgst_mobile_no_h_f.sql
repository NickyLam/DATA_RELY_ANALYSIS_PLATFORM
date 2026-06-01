: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_acct_rgst_mobile_no_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_acct_rgst_mobile_no_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_num_rgst_attr_cd,chr(13),''),chr(10),'') as acct_num_rgst_attr_cd
,replace(replace(t1.onl_bank_sys_open_bank_no,chr(13),''),chr(10),'') as onl_bank_sys_open_bank_no
,replace(replace(t1.acct_open_bank_no,chr(13),''),chr(10),'') as acct_open_bank_no
,replace(replace(t1.acct_clear_bank_no,chr(13),''),chr(10),'') as acct_clear_bank_no
,t1.rgst_tm as rgst_tm
,replace(replace(t1.mobile_no_status_cd,chr(13),''),chr(10),'') as mobile_no_status_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_acct_rgst_mobile_no_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_acct_rgst_mobile_no_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes