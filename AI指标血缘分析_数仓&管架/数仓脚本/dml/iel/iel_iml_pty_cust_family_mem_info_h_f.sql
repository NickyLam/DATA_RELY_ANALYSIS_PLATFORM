: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_family_mem_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_family_mem_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.family_mem_name,chr(13),''),chr(10),'') as family_mem_name
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.local_corp_name,chr(13),''),chr(10),'') as local_corp_name
,replace(replace(t1.local_corp_loan_card_no,chr(13),''),chr(10),'') as local_corp_loan_card_no
,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'') as work_tel_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,mon_inco
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num
,join_work_year
,replace(replace(t1.area_cd,chr(13),''),chr(10),'') as area_cd
,birth_dt
,replace(replace(t1.landine_no,chr(13),''),chr(10),'') as landine_no
,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.pty_cust_family_mem_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_family_mem_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
