: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_guar_cont_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_guar_cont_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t.guar_kind_cd,chr(13),''),chr(10),'') as guar_kind_cd
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,t.sign_dt as sign_dt
,t.effect_dt as effect_dt
,t.exp_dt as exp_dt
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd
,replace(replace(t.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no
,replace(replace(t.brwer_rela_cd,chr(13),''),chr(10),'') as brwer_rela_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.guar_amt as guar_amt
,t.ocup_amt as ocup_amt
,t.guar_start_dt as guar_start_dt
,t.guar_exp_dt as guar_exp_dt
,t.guar_tenor as guar_tenor
,replace(replace(t.pri_contr_id,chr(13),''),chr(10),'') as pri_contr_id
,replace(replace(t.pri_contr_type_cd,chr(13),''),chr(10),'') as pri_contr_type_cd
,replace(replace(t.ocup_guar_lmt_flg,chr(13),''),chr(10),'') as ocup_guar_lmt_flg
,replace(replace(t.guar_range_cd,chr(13),''),chr(10),'') as guar_range_cd
,replace(replace(t.gcust_flg,chr(13),''),chr(10),'') as gcust_flg
,replace(replace(t.obg_id,chr(13),''),chr(10),'') as obg_id
,replace(replace(t.obg_name,chr(13),''),chr(10),'') as obg_name
,replace(replace(t.dir_guar_flg,chr(13),''),chr(10),'') as dir_guar_flg
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.director_org_id,chr(13),''),chr(10),'') as director_org_id
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,t.rgst_dt as rgst_dt
,replace(replace(t.update_person_id,chr(13),''),chr(10),'') as update_person_id
,t.update_dt as update_dt
,replace(replace(t.guar_cont_name,chr(13),''),chr(10),'') as guar_cont_name
from ${icl_schema}.cmm_guar_cont t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_guar_cont_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes