: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_inv_port_acct_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_inv_port_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.subor_inv_port_id,chr(13),''),chr(10),'') as subor_inv_port_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.haver_id,chr(13),''),chr(10),'') as haver_id
,replace(replace(t1.haver_cd,chr(13),''),chr(10),'') as haver_cd
,replace(replace(t1.haver_name,chr(13),''),chr(10),'') as haver_name
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.deflt_acct_id,chr(13),''),chr(10),'') as deflt_acct_id
,replace(replace(t1.deflt_asset_type_id,chr(13),''),chr(10),'') as deflt_asset_type_id
,final_modif_tm
,replace(replace(t1.data_src_app_set_id,chr(13),''),chr(10),'') as data_src_app_set_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.non_st_at_cate_cd,chr(13),''),chr(10),'') as non_st_at_cate_cd
,create_dt
,update_dt

from ${iml_schema}.agt_inv_port_acct t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_inv_port_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
