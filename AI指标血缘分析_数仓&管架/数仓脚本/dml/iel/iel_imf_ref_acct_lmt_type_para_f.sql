: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_acct_lmt_type_para_f
CreateDate: 20240822
FileName:   ${iel_data_path}/ref_acct_lmt_type_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_type_cd,chr(13),''),chr(10),'') as lmt_type_cd
,replace(replace(t1.lmt_type_descb,chr(13),''),chr(10),'') as lmt_type_descb
,replace(replace(t1.lmt_type_cate_cd,chr(13),''),chr(10),'') as lmt_type_cate_cd
,replace(replace(t1.froz_lev,chr(13),''),chr(10),'') as froz_lev
,replace(replace(t1.manual_froz_flg,chr(13),''),chr(10),'') as manual_froz_flg
,replace(replace(t1.manual_unfrz_flg,chr(13),''),chr(10),'') as manual_unfrz_flg
,replace(replace(t1.full_amt_stop_pay_flg,chr(13),''),chr(10),'') as full_amt_stop_pay_flg
,replace(replace(t1.sys_spec_flg,chr(13),''),chr(10),'') as sys_spec_flg
,replace(replace(t1.auth_org_froz_flg,chr(13),''),chr(10),'') as auth_org_froz_flg
,replace(replace(t1.eod_deduct_flg,chr(13),''),chr(10),'') as eod_deduct_flg
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_acct_lmt_type_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_acct_lmt_type_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
