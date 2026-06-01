: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_marg_contr_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_marg_contr_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.contr_id,chr(13),''),chr(10),'') as contr_id
,replace(replace(t1.contr_typ_cd,chr(13),''),chr(10),'') as contr_typ_cd
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.sub_num,chr(13),''),chr(10),'') as sub_num
,replace(replace(t1.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
,t1.margin_amt as margin_amt
from ${idl_schema}.hdws_dul_d_mims_coll_marg_contr_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_marg_contr_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes