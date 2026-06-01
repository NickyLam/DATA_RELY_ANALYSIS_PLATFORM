: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_info_h_f
CreateDate: 20231101
FileName:   ${iel_data_path}/agt_corp_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_corp_id,chr(13),''),chr(10),'') as agt_corp_id
,replace(replace(t1.agt_corp_name,chr(13),''),chr(10),'') as agt_corp_name
,replace(replace(t1.agt_corp_abbr,chr(13),''),chr(10),'') as agt_corp_abbr
,replace(replace(t1.payfan_chn_id,chr(13),''),chr(10),'') as payfan_chn_id
,replace(replace(t1.agency_id,chr(13),''),chr(10),'') as agency_id
,replace(replace(t1.agt_corp_type_cd,chr(13),''),chr(10),'') as agt_corp_type_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.bus_lics_id,chr(13),''),chr(10),'') as bus_lics_id
,bus_lics_stop_valid_dt
,replace(replace(t1.lp_name,chr(13),''),chr(10),'') as lp_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cotas_cert_type_cd,chr(13),''),chr(10),'') as cotas_cert_type_cd
,replace(replace(t1.cotas_cert_no,chr(13),''),chr(10),'') as cotas_cert_no
,replace(replace(t1.cotas_tel_num,chr(13),''),chr(10),'') as cotas_tel_num
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.cotas_addr,chr(13),''),chr(10),'') as cotas_addr
,replace(replace(t1.stl_acct_type_cd,chr(13),''),chr(10),'') as stl_acct_type_cd
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,replace(replace(t1.ghb_enter_acct_flg,chr(13),''),chr(10),'') as ghb_enter_acct_flg
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.open_bank_bank_name,chr(13),''),chr(10),'') as open_bank_bank_name
,replace(replace(t1.open_acct_addr,chr(13),''),chr(10),'') as open_acct_addr
,replace(replace(t1.agt_corp_status_cd,chr(13),''),chr(10),'') as agt_corp_status_cd
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,add_dt
,final_modif_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.sys_idf,chr(13),''),chr(10),'') as sys_idf
,replace(replace(t1.adv_acct_type_cd,chr(13),''),chr(10),'') as adv_acct_type_cd
,replace(replace(t1.adv_acct_id,chr(13),''),chr(10),'') as adv_acct_id
,replace(replace(t1.adv_acct_name,chr(13),''),chr(10),'') as adv_acct_name
,agt_corp_lmt
,sig_lmt
,used_lmt
,payfan_second_lmt
,adv_amt
,last_use_lmt
,replace(replace(t1.st_msg_advise_mobile_no,chr(13),''),chr(10),'') as st_msg_advise_mobile_no
,replace(replace(t1.st_msg_advise_name,chr(13),''),chr(10),'') as st_msg_advise_name

from ${iml_schema}.agt_corp_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
