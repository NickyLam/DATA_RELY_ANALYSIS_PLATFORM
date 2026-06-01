: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_shard_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_shard_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.invest_curr_cd,chr(13),''),chr(10),'') as invest_curr_cd
,invest_ratio
,invest_amt
,actl_pay_amt
,tot_invest_amt_latest_ready_dt
,replace(replace(t1.share_right_cert_num,chr(13),''),chr(10),'') as share_right_cert_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.corp_actl_ctrler_flg,chr(13),''),chr(10),'') as corp_actl_ctrler_flg
,share_ratio
,contri_latest_ready_dt
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.contrior_type_cd,chr(13),''),chr(10),'') as contrior_type_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,start_hold_stock_dt
,replace(replace(t1.org_crdt_id,chr(13),''),chr(10),'') as org_crdt_id
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
,replace(replace(t1.comer_rgst_and_non_comer_rgst_cert_num,chr(13),''),chr(10),'') as comer_rgst_and_non_comer_rgst_cert_num
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.pty_cust_shard_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_shard_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
