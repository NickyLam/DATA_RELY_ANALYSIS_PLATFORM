: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareseo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareseo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,t.s_fellow_progress as s_fellow_progress
    ,replace(replace(t.s_fellow_issuetype,chr(13),''),chr(10),'') as s_fellow_issuetype
    ,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
    ,t.s_fellow_price as s_fellow_price
    ,t.s_fellow_amount as s_fellow_amount
    ,t.s_fellow_collection as s_fellow_collection
    ,replace(replace(t.s_fellow_recorddate,chr(13),''),chr(10),'') as s_fellow_recorddate
    ,replace(replace(t.s_fellow_paystartdate,chr(13),''),chr(10),'') as s_fellow_paystartdate
    ,replace(replace(t.s_fellow_payenddate,chr(13),''),chr(10),'') as s_fellow_payenddate
    ,replace(replace(t.s_fellow_subdate,chr(13),''),chr(10),'') as s_fellow_subdate
    ,replace(replace(t.s_fellow_otcdate,chr(13),''),chr(10),'') as s_fellow_otcdate
    ,replace(replace(t.s_fellow_listdate,chr(13),''),chr(10),'') as s_fellow_listdate
    ,replace(replace(t.s_fellow_instlistdate,chr(13),''),chr(10),'') as s_fellow_instlistdate
    ,replace(replace(t.s_fellow_changedate,chr(13),''),chr(10),'') as s_fellow_changedate
    ,replace(replace(t.s_fellow_roadshowdate,chr(13),''),chr(10),'') as s_fellow_roadshowdate
    ,replace(replace(t.s_fellow_refunddate,chr(13),''),chr(10),'') as s_fellow_refunddate
    ,replace(replace(t.s_fellow_unfrozedate,chr(13),''),chr(10),'') as s_fellow_unfrozedate
    ,replace(replace(t.s_fellow_preplandate,chr(13),''),chr(10),'') as s_fellow_preplandate
    ,replace(replace(t.s_fellow_smtganncedate,chr(13),''),chr(10),'') as s_fellow_smtganncedate
    ,replace(replace(t.s_fellow_passdate,chr(13),''),chr(10),'') as s_fellow_passdate
    ,replace(replace(t.s_fellow_approveddate,chr(13),''),chr(10),'') as s_fellow_approveddate
    ,replace(replace(t.s_fellow_anncedate,chr(13),''),chr(10),'') as s_fellow_anncedate
    ,replace(replace(t.s_fellow_ratioanncedate,chr(13),''),chr(10),'') as s_fellow_ratioanncedate
    ,replace(replace(t.s_fellow_offeringdate,chr(13),''),chr(10),'') as s_fellow_offeringdate
    ,replace(replace(t.s_fellow_listanndate,chr(13),''),chr(10),'') as s_fellow_listanndate
    ,replace(replace(t.s_fellow_offeringobject,chr(13),''),chr(10),'') as s_fellow_offeringobject
    ,t.s_fellow_priceuplimit as s_fellow_priceuplimit
    ,t.s_fellow_pricedownlimit as s_fellow_pricedownlimit
    ,replace(replace(t.s_seo_code,chr(13),''),chr(10),'') as s_seo_code
    ,replace(replace(t.s_seo_name,chr(13),''),chr(10),'') as s_seo_name
    ,t.s_seo_pe as s_seo_pe
    ,t.s_seo_amtbyplacing as s_seo_amtbyplacing
    ,t.s_seo_amttojur as s_seo_amttojur
    ,replace(replace(t.s_seo_holdersubsmode,chr(13),''),chr(10),'') as s_seo_holdersubsmode
    ,t.s_seo_holdersubsrate as s_seo_holdersubsrate
    ,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
    ,t.pricingmode as pricingmode
    ,t.s_fellow_orgpricemin as s_fellow_orgpricemin
    ,t.s_fellow_discntratio as s_fellow_discntratio
    ,replace(replace(t.s_fellow_date,chr(13),''),chr(10),'') as s_fellow_date
    ,replace(replace(t.s_fellow_subinvitationdt,chr(13),''),chr(10),'') as s_fellow_subinvitationdt
    ,replace(replace(t.s_fellow_year,chr(13),''),chr(10),'') as s_fellow_year
    ,t.s_fellow_objective_code as s_fellow_objective_code
    ,replace(replace(t.pricingdate,chr(13),''),chr(10),'') as pricingdate
    ,t.is_no_public as is_no_public
    ,t.expense as expense
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_ashareseo t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareseo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes