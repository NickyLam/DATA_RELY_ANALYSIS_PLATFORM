: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_fin_stat_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_fin_stat_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.rec_id,chr(13),''),chr(10),'') as rec_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.rept_curr_cd,chr(13),''),chr(10),'') as rept_curr_cd 
,replace(replace(t1.rept_corp_cd,chr(13),''),chr(10),'') as rept_corp_cd 
,replace(replace(t1.rept_cali_type_cd,chr(13),''),chr(10),'') as rept_cali_type_cd 
,t1.rept_dt as rept_dt 
,replace(replace(t1.rept_ped_cd,chr(13),''),chr(10),'') as rept_ped_cd 
,replace(replace(t1.rept_note,chr(13),''),chr(10),'') as rept_note 
,replace(replace(t1.rept_status_cd,chr(13),''),chr(10),'') as rept_status_cd 
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id 
,t1.rgst_dt as rgst_dt 
,replace(replace(t1.rgst_user_id,chr(13),''),chr(10),'') as rgst_user_id 
,replace(replace(t1.audit_flg,chr(13),''),chr(10),'') as audit_flg 
,replace(replace(t1.audit_corp,chr(13),''),chr(10),'') as audit_corp 
,replace(replace(t1.audit_opinion,chr(13),''),chr(10),'') as audit_opinion 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_fin_stat_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_fin_stat_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes