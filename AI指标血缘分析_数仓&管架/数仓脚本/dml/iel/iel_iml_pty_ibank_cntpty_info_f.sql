: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_ibank_cntpty_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_ibank_cntpty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_party_id,chr(13),''),chr(10),'') as src_party_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.super_org_id,chr(13),''),chr(10),'') as super_org_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.party_fname,chr(13),''),chr(10),'') as party_fname
,replace(replace(t1.party_alias,chr(13),''),chr(10),'') as party_alias
,replace(replace(t1.party_pinyin,chr(13),''),chr(10),'') as party_pinyin
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name
,replace(replace(t1.en_fname,chr(13),''),chr(10),'') as en_fname
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,t1.found_dt as found_dt
,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'') as bus_lics_num
,replace(replace(t1.party_cd_cert_id,chr(13),''),chr(10),'') as party_cd_cert_id
,replace(replace(t1.fin_lics_id,chr(13),''),chr(10),'') as fin_lics_id
,replace(replace(t1.dc_pay_sys_bank_no,chr(13),''),chr(10),'') as dc_pay_sys_bank_no
,replace(replace(t1.fcurr_pay_sys_bank_no,chr(13),''),chr(10),'') as fcurr_pay_sys_bank_no
,replace(replace(t1.rgst,chr(13),''),chr(10),'') as rgst
,replace(replace(t1.party_cls_descb,chr(13),''),chr(10),'') as party_cls_descb
,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'') as party_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.mar_maker_flg,chr(13),''),chr(10),'') as mar_maker_flg
,replace(replace(t1.spv_flg,chr(13),''),chr(10),'') as spv_flg
,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,replace(replace(t1.matn_org_name,chr(13),''),chr(10),'') as matn_org_name
,replace(replace(t1.rwa_cust_cls_name,chr(13),''),chr(10),'') as rwa_cust_cls_name
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.org_cls_cd,chr(13),''),chr(10),'') as org_cls_cd
,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'') as org_lev_cd
from ${iml_schema}.pty_ibank_cntpty_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_ibank_cntpty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes