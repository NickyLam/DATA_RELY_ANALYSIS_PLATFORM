: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ext_cap_acct_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_ext_cap_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.open_acct_bank_no,chr(13),''),chr(10),'') as open_acct_bank_no
,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'') as open_acct_bank_name
,open_acct_dt
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.intnal_cap_acct_num,chr(13),''),chr(10),'') as intnal_cap_acct_num
,replace(replace(t1.cap_acct_type_cd,chr(13),''),chr(10),'') as cap_acct_type_cd
,replace(replace(t1.intnal_acct_num,chr(13),''),chr(10),'') as intnal_acct_num
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd
,replace(replace(t1.pay_int_ped_corp_cd,chr(13),''),chr(10),'') as pay_int_ped_corp_cd
,replace(replace(t1.pay_int_ped_freq,chr(13),''),chr(10),'') as pay_int_ped_freq
,replace(replace(t1.int_rat_def_id,chr(13),''),chr(10),'') as int_rat_def_id
,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
,pay_mon
,pay_days
,int_rat
,clos_acct_dt
,replace(replace(t1.prod_type_id,chr(13),''),chr(10),'') as prod_type_id
,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.swift_cd,chr(13),''),chr(10),'') as swift_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.acct_char_descb,chr(13),''),chr(10),'') as acct_char_descb
,replace(replace(t1.acct_attr_descb,chr(13),''),chr(10),'') as acct_attr_descb
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.cross_bor_ibank_nostro_acct_id,chr(13),''),chr(10),'') as cross_bor_ibank_nostro_acct_id

from ${iml_schema}.agt_ext_cap_acct t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ext_cap_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
