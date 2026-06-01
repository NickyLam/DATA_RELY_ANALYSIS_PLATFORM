: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_cap_cntpty_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_cap_cntpty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select party_id
,lp_id
,dept_id
,cntpty_id
,cntpty_abbr
,cntpty_fname
,cntpty_en_abbr
,cntpty_en_name
,elec_cert_name
,elec_cert_id
,elec_cert_flg
,intnal_rating_level_cd
,cotas_name
,tel_num
,fax_num
,issuer_flg
,issuer_id
,guartor_flg
,guartor_id
,fin_inst_flg
,trust_org_flg
,indus_type_cd
,elec_ibank_no
,pay_bk_bank_no
,swift_id
,cust_id
,etl_dt
,job_cd from idl.icrm_pty_cap_cntpty_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_cap_cntpty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes