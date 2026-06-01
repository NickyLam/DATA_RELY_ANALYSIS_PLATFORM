: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_int_rat_para_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_int_rat_para_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.int_rat_id,chr(13),''),chr(10),'') as int_rat_id
,replace(replace(t1.int_rat_name,chr(13),''),chr(10),'') as int_rat_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,effect_dt
,replace(replace(t1.int_rat_ped_corp,chr(13),''),chr(10),'') as int_rat_ped_corp
,replace(replace(t1.int_rat_ped_cd,chr(13),''),chr(10),'') as int_rat_ped_cd
,int_rat
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.int_rat_corp_cd,chr(13),''),chr(10),'') as int_rat_corp_cd
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,modif_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id

from ${iml_schema}.agt_loan_int_rat_para_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_int_rat_para_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
