: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_rept_rec_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_rept_rec.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select rept_id
,rela_obj_type
,rela_obj_id
,rept_cali
,model_id
,rept_name
,rept_dt
,create_tm
,create_org_id
,creator_id
,update_tm
,etl_dt
,job_cd from idl.icrm_ref_rept_rec where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_rept_rec.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes