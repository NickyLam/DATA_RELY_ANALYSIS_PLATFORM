: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_bdms_union_bank_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_bdms_union_bank.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,ubank_no
,ctgy
,clss
,ubank_cat_id
,drct
,ndcd
,sprr_lst
,pbcbk
,ubank_city
,ubank_name
,shrt_nm
,ubank_address
,ubank_zip
,ubank_tel
,email
,fctv_dt
,upd_time
,term_nb
,proc_status
,rmrk
,xpry_dt
,status
,ubank_linkman
,cert_info_cn
,cert_info_sn
,cert_bind_status
,cert_valide_date
,cert_invalide_date
,last_upd_oprid
,last_upd_txn_id
,last_upd_ts
,start_dt
,end_dt
,id_mark
,etl_timestamp from idl.aml_bdms_union_bank where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_bdms_union_bank.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes