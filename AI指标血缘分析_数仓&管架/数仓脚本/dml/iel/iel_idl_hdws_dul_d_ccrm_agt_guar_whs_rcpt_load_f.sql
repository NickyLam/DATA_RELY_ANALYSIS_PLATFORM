: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_whs_rcpt_load_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_whs_rcpt_load.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as etl_dt
,replace(replace(t1.whs_rcpt_load_typ_cd,chr(13),''),chr(10),'') as whs_rcpt_load_typ_cd
,replace(replace(t1.whs_rcpt_or_load_num,chr(13),''),chr(10),'') as whs_rcpt_or_load_num
,replace(replace(t1.issue_corp,chr(13),''),chr(10),'') as issue_corp
,t1.issue_dt as issue_dt
,replace(replace(t1.cons_pers_name,chr(13),''),chr(10),'') as cons_pers_name
,replace(replace(t1.store_term_corp_cd,chr(13),''),chr(10),'') as store_term_corp_cd
,t1.store_term as store_term
,replace(replace(t1.store_site,chr(13),''),chr(10),'') as store_site
,replace(replace(t1.goods_name,chr(13),''),chr(10),'') as goods_name
,replace(replace(t1.goods_spec_model,chr(13),''),chr(10),'') as goods_spec_model
,replace(replace(t1.lna_corp,chr(13),''),chr(10),'') as lna_corp
,t1.qty as qty
,replace(replace(t1.invo_num,chr(13),''),chr(10),'') as invo_num
,replace(replace(t1.elig_proof,chr(13),''),chr(10),'') as elig_proof
,replace(replace(t1.store_goods_prod_maker,chr(13),''),chr(10),'') as store_goods_prod_maker
,t1.store_goods_purc_prc_total_amt as store_goods_purc_prc_total_amt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_whs_rcpt_load t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_whs_rcpt_load.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes