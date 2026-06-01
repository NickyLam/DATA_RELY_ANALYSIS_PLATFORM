: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_obank_dep_rcpt_inpwn_info_f
CreateDate: 20221226
FileName:   ${iel_data_path}/ast_obank_dep_rcpt_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,aval_amt
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.bank_rgst_cd,chr(13),''),chr(10),'') as bank_rgst_cd
,ext_rating_dt
,replace(replace(t1.ext_rating_rest_cd,chr(13),''),chr(10),'') as ext_rating_rest_cd
,effect_dt
,exp_dt
,dep_term
,int_rat
,pric_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_obank_dep_rcpt_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
