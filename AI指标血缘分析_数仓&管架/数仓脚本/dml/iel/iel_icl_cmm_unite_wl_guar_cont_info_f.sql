: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_guar_cont_info_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cmm_unite_wl_guar_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_kind_cd,chr(13),''),chr(10),'') as guar_kind_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,sign_dt
,effect_dt
,exp_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.guartor_cust_id,chr(13),''),chr(10),'') as guartor_cust_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd
,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no
,guar_amt
,replace(replace(t1.gover_fin_guar_corp_guar_flg,chr(13),''),chr(10),'') as gover_fin_guar_corp_guar_flg
,replace(replace(t1.rev_guar_flg,chr(13),''),chr(10),'') as rev_guar_flg
,replace(replace(t1.guar_org_name,chr(13),''),chr(10),'') as guar_org_name
,replace(replace(t1.guar_item_promis_id,chr(13),''),chr(10),'') as guar_item_promis_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,rgst_dt

from ${icl_schema}.cmm_unite_wl_guar_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_guar_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
