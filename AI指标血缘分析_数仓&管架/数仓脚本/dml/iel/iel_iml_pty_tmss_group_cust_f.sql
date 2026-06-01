: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_tmss_group_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_tmss_group_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_cate_cd,chr(13),''),chr(10),'') as cert_cate_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.group_type_cd,chr(13),''),chr(10),'') as group_type_cd
,replace(replace(t1.multi_bank_serv_flg,chr(13),''),chr(10),'') as multi_bank_serv_flg
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.belong_bank_no,chr(13),''),chr(10),'') as belong_bank_no
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,t1.create_tm as create_tm
,replace(replace(t1.checker_id,chr(13),''),chr(10),'') as checker_id
,t1.check_tm as check_tm
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,replace(replace(t1.unify_soci_crdt_id,chr(13),''),chr(10),'') as unify_soci_crdt_id
,replace(replace(t1.adres_name,chr(13),''),chr(10),'') as adres_name
,replace(replace(t1.adres_addr,chr(13),''),chr(10),'') as adres_addr
,replace(replace(t1.adres_tel,chr(13),''),chr(10),'') as adres_tel
,replace(replace(t1.adres_remark,chr(13),''),chr(10),'') as adres_remark
,replace(replace(t1.dc_rgst_status_cd,chr(13),''),chr(10),'') as dc_rgst_status_cd
,t1.dc_valid_tm as dc_valid_tm
,t1.ukey_uplmi_cnt as ukey_uplmi_cnt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_tmss_group_cust t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_tmss_group_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes