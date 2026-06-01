: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_finc_prod_clear_acct_info_f
CreateDate: 20260415
FileName:   ${iel_data_path}/agt_finc_prod_clear_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id
,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id
,replace(replace(t1.realred_acct_id,chr(13),''),chr(10),'') as realred_acct_id
,replace(replace(t1.rgst_rgst_acct_bank_id,chr(13),''),chr(10),'') as rgst_rgst_acct_bank_id
,replace(replace(t1.coll_cap_vrfction_acct_id,chr(13),''),chr(10),'') as coll_cap_vrfction_acct_id
,replace(replace(t1.coll_cap_veri_acct_acct_name,chr(13),''),chr(10),'') as coll_cap_veri_acct_acct_name
,replace(replace(t1.cap_vrfction_acct_bank_id,chr(13),''),chr(10),'') as cap_vrfction_acct_bank_id
,replace(replace(t1.make_acct_bank_acct_id,chr(13),''),chr(10),'') as make_acct_bank_acct_id
,replace(replace(t1.make_acct_bank_acct_num_name,chr(13),''),chr(10),'') as make_acct_bank_acct_num_name
,replace(replace(t1.keep_acct_bank_acct_id,chr(13),''),chr(10),'') as keep_acct_bank_acct_id
,replace(replace(t1.keep_acct_bank_acct_num_name,chr(13),''),chr(10),'') as keep_acct_bank_acct_num_name
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.trust_org_open_bank_name,chr(13),''),chr(10),'') as trust_org_open_bank_name
,replace(replace(t1.trust_org_name,chr(13),''),chr(10),'') as trust_org_name
,replace(replace(t1.remark_1,chr(13),''),chr(10),'') as remark_1

from ${iml_schema}.agt_finc_prod_clear_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_prod_clear_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
