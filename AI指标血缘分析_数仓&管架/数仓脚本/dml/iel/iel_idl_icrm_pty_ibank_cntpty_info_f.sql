: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_ibank_cntpty_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_ibank_cntpty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,party_id
,lp_id
,src_party_id
,org_id
,super_org_id
,party_name
,party_fname
,party_alias
,party_pinyin
,en_name
,en_fname
,status_cd
,found_dt
,bus_lics_num
,party_cd_cert_id
,fin_lics_id
,dc_pay_sys_bank_no
,fcurr_pay_sys_bank_no
,rgst
,party_cls_descb
,party_type_cd
,cust_id
,mar_maker_flg
,spv_flg
,matn_org_id
,matn_org_name
,create_dt
,update_dt
,id_mark
from idl.icrm_pty_ibank_cntpty_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_ibank_cntpty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes