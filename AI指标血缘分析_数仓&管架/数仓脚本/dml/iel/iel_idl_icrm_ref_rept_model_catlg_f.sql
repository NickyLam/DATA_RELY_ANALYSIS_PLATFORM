: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_rept_model_catlg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_rept_model_catlg.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select model_id
,model_name
,model_type
,model_descb
,model_abb
,model_cls
,model_attr_1
,model_attr_2
,dsply_method
,tab_head_descb
,del_flg
,remark
,etl_dt
,job_cd from idl.icrm_ref_rept_model_catlg where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_rept_model_catlg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes