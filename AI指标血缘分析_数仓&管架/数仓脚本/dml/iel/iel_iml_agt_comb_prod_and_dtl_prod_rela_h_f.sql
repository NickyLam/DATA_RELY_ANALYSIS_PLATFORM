: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_comb_prod_and_dtl_prod_rela_h_f
CreateDate: 20230817
FileName:   ${iel_data_path}/agt_comb_prod_and_dtl_prod_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.dtl_prod_id,chr(13),''),chr(10),'') as dtl_prod_id
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,tran_out_prior_level
,prod_prior_level
,diplay_prior_level

from ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_comb_prod_and_dtl_prod_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
