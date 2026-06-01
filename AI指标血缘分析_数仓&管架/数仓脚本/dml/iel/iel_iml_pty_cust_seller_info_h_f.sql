: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_seller_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cust_seller_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t.sys_src_abbr,chr(13),''),chr(10),'') as sys_src_abbr
,replace(replace(t.bank_cust_id,chr(13),''),chr(10),'') as bank_cust_id
,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,t.sign_dt as sign_dt
,t.rels_dt as rels_dt
,replace(replace(t.ta_cust_tran_acct_num,chr(13),''),chr(10),'') as ta_cust_tran_acct_num
,replace(replace(t.rels_flg,chr(13),''),chr(10),'') as rels_flg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_cust_seller_info_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_seller_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes