: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_invest_info_h_f
CreateDate: 20230525
FileName:   ${iel_data_path}/pty_cust_invest_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dir_corp_cert_type_cd,chr(13),''),chr(10),'') as dir_corp_cert_type_cd
,replace(replace(t1.dir_corp_cert_no,chr(13),''),chr(10),'') as dir_corp_cert_no
,replace(replace(t1.dir_corp_name,chr(13),''),chr(10),'') as dir_corp_name
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.dir_corp_legal_rep_name,chr(13),''),chr(10),'') as dir_corp_legal_rep_name
,replace(replace(t1.dir_corp_loan_card_no,chr(13),''),chr(10),'') as dir_corp_loan_card_no
,replace(replace(t1.contri_curr_cd,chr(13),''),chr(10),'') as contri_curr_cd
,contri_ratio
,contri_amt
,actl_invest_amt
,invest_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd
,fst_year_invest_prft
,replace(replace(t1.org_crdt_id,chr(13),''),chr(10),'') as org_crdt_id
,replace(replace(t1.invest_type_cd,chr(13),''),chr(10),'') as invest_type_cd
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,to_date('${batch_date}','yyyymmdd') as etl_dt

from ${iml_schema}.pty_cust_invest_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_invest_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
