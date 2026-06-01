: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_rela_party_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_rela_party_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.rela_party_loan_card_no,chr(13),''),chr(10),'') as rela_party_loan_card_no
,rela_setup_dt
,replace(replace(t1.sup_prod_name,chr(13),''),chr(10),'') as sup_prod_name
,replace(replace(t1.sup_curr_cd,chr(13),''),chr(10),'') as sup_curr_cd
,sup_amt
,sup_ratio
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.belong_sup_chain_client_bs_id,chr(13),''),chr(10),'') as belong_sup_chain_client_bs_id
,co_years
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.org_crdt_id,chr(13),''),chr(10),'') as org_crdt_id
,replace(replace(t1.stru_rela_party_reason_descb,chr(13),''),chr(10),'') as stru_rela_party_reason_descb
,replace(replace(t1.hxb_rela_corp_flg,chr(13),''),chr(10),'') as hxb_rela_corp_flg
,replace(replace(t1.can_sup_prod_descb,chr(13),''),chr(10),'') as can_sup_prod_descb
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.pty_cust_rela_party_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_rela_party_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
