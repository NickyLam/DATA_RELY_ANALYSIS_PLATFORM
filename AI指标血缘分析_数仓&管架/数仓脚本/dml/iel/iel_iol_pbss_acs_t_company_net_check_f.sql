: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_acs_t_company_net_check_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_acs_t_company_net_check.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.id,chr(13),''),chr(10),'') as id 
,replace(replace(t1.accept_no,chr(13),''),chr(10),'') as accept_no 
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name 
,replace(replace(t1.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd 
,replace(replace(t1.reside_addr,chr(13),''),chr(10),'') as reside_addr 
,t1.reg_cap as reg_cap 
,replace(replace(t1.estab_dt,chr(13),''),chr(10),'') as estab_dt 
,replace(replace(t1.oper_start_day,chr(13),''),chr(10),'') as oper_start_day 
,replace(replace(t1.oper_end_day,chr(13),''),chr(10),'') as oper_end_day 
,replace(replace(t1.legal_reps_name,chr(13),''),chr(10),'') as legal_reps_name 
,replace(replace(t1.reg_org,chr(13),''),chr(10),'') as reg_org 
,replace(replace(t1.oper_scope,chr(13),''),chr(10),'') as oper_scope 
,replace(replace(t1.check_dt,chr(13),''),chr(10),'') as check_dt 
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name 
,replace(replace(t1.corp_manage_status,chr(13),''),chr(10),'') as corp_manage_status 
,replace(replace(t1.corp_manage_content,chr(13),''),chr(10),'') as corp_manage_content 
,replace(replace(t1.ilegal_dishonesty_status,chr(13),''),chr(10),'') as ilegal_dishonesty_status 
,replace(replace(t1.ilegal_dishonesty_content,chr(13),''),chr(10),'') as ilegal_dishonesty_content 
,replace(replace(t1.corp_taxpayer_status,chr(13),''),chr(10),'') as corp_taxpayer_status 
,replace(replace(t1.corp_tax_content,chr(13),''),chr(10),'') as corp_tax_content 
,replace(replace(t1.reg_info_examine_resu,chr(13),''),chr(10),'') as reg_info_examine_resu 
,t1.tran_dt as tran_dt 
,replace(replace(t1.auth_flag,chr(13),''),chr(10),'') as auth_flag 
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id 
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id 
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark 
,replace(replace(t1.error_status,chr(13),''),chr(10),'') as error_status 
,replace(replace(t1.fictitiouspersonid,chr(13),''),chr(10),'') as fictitiouspersonid 
,replace(replace(t1.iden_typ_cd,chr(13),''),chr(10),'') as iden_typ_cd 
,replace(replace(t1.old_open_licen,chr(13),''),chr(10),'') as old_open_licen 
,replace(replace(t1.reg_status,chr(13),''),chr(10),'') as reg_status 
,replace(replace(t1.idtftp,chr(13),''),chr(10),'') as idtftp 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pbss_acs_t_company_net_check t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_acs_t_company_net_check.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes