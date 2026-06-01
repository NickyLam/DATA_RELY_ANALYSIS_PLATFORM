: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_finc_prod_yld_rat_set_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_finc_prod_yld_rat_set.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,vp
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd
,replace(replace(t1.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.sell_type_cd,chr(13),''),chr(10),'') as sell_type_cd
,hold_days
,hold_min_days
,hold_max_days
,hold_min_amt
,hold_max_amt
,cust_yld_rat
,bank_yld_rat
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_finc_prod_yld_rat_set t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_finc_prod_yld_rat_set.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
