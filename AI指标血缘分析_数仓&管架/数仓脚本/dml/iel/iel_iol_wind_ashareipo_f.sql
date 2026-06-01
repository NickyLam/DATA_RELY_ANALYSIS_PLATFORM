: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareipo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareipo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
    ,t.s_ipo_price as s_ipo_price
    ,t.s_ipo_pre_dilutedpe as s_ipo_pre_dilutedpe
    ,t.s_ipo_dilutedpe as s_ipo_dilutedpe
    ,t.s_ipo_amount as s_ipo_amount
    ,t.s_ipo_amtbyplacing as s_ipo_amtbyplacing
    ,t.s_ipo_amttojur as s_ipo_amttojur
    ,t.s_ipo_collection as s_ipo_collection
    ,t.s_ipo_cashratio as s_ipo_cashratio
    ,replace(replace(t.s_ipo_purchasecode,chr(13),''),chr(10),'') as s_ipo_purchasecode
    ,replace(replace(t.s_ipo_subdate,chr(13),''),chr(10),'') as s_ipo_subdate
    ,replace(replace(t.s_ipo_jurisdate,chr(13),''),chr(10),'') as s_ipo_jurisdate
    ,replace(replace(t.s_ipo_instisdate,chr(13),''),chr(10),'') as s_ipo_instisdate
    ,replace(replace(t.s_ipo_expectlistdate,chr(13),''),chr(10),'') as s_ipo_expectlistdate
    ,replace(replace(t.s_ipo_fundverificationdate,chr(13),''),chr(10),'') as s_ipo_fundverificationdate
    ,replace(replace(t.s_ipo_ratiodate,chr(13),''),chr(10),'') as s_ipo_ratiodate
    ,replace(replace(t.s_fellow_unfrozedate,chr(13),''),chr(10),'') as s_fellow_unfrozedate
    ,replace(replace(t.s_ipo_listdate,chr(13),''),chr(10),'') as s_ipo_listdate
    ,replace(replace(t.s_ipo_puboffrdate,chr(13),''),chr(10),'') as s_ipo_puboffrdate
    ,replace(replace(t.s_ipo_anncedate,chr(13),''),chr(10),'') as s_ipo_anncedate
    ,replace(replace(t.s_ipo_anncelstdate,chr(13),''),chr(10),'') as s_ipo_anncelstdate
    ,replace(replace(t.s_ipo_roadshowstartdate,chr(13),''),chr(10),'') as s_ipo_roadshowstartdate
    ,replace(replace(t.s_ipo_roadshowenddate,chr(13),''),chr(10),'') as s_ipo_roadshowenddate
    ,replace(replace(t.s_ipo_placingdate,chr(13),''),chr(10),'') as s_ipo_placingdate
    ,replace(replace(t.s_ipo_applystartdate,chr(13),''),chr(10),'') as s_ipo_applystartdate
    ,replace(replace(t.s_ipo_applyenddate,chr(13),''),chr(10),'') as s_ipo_applyenddate
    ,replace(replace(t.s_ipo_priceannouncedate,chr(13),''),chr(10),'') as s_ipo_priceannouncedate
    ,replace(replace(t.s_ipo_placingresultdate,chr(13),''),chr(10),'') as s_ipo_placingresultdate
    ,replace(replace(t.s_ipo_fundenddate,chr(13),''),chr(10),'') as s_ipo_fundenddate
    ,replace(replace(t.s_ipo_capverificationdate,chr(13),''),chr(10),'') as s_ipo_capverificationdate
    ,replace(replace(t.s_ipo_refunddate,chr(13),''),chr(10),'') as s_ipo_refunddate
    ,t.s_ipo_expectedcollection as s_ipo_expectedcollection
    ,t.s_ipo_list_fee as s_ipo_list_fee
    ,replace(replace(t.s_ipo_lpurnameonl,chr(13),''),chr(10),'') as s_ipo_lpurnameonl
    ,t.s_ipo_cashamtuplimit as s_ipo_cashamtuplimit
    ,t.s_ipo_cashmoneyuplimit as s_ipo_cashmoneyuplimit
    ,replace(replace(t.s_ipo_namebyplacing,chr(13),''),chr(10),'') as s_ipo_namebyplacing
    ,t.s_ipo_showpricedownlimit as s_ipo_showpricedownlimit
    ,t.s_ipo_par as s_ipo_par
    ,t.s_ipo_purchaseuplimit as s_ipo_purchaseuplimit
    ,t.s_ipo_op_uplimit as s_ipo_op_uplimit
    ,t.s_ipo_op_downlimit as s_ipo_op_downlimit
    ,replace(replace(t.s_ipo_purchasemv_dt,chr(13),''),chr(10),'') as s_ipo_purchasemv_dt
    ,t.s_ipo_pubosdtotisscoll as s_ipo_pubosdtotisscoll
    ,t.s_ipo_osdexpoffamount as s_ipo_osdexpoffamount
    ,t.s_ipo_osdexpoffamountup as s_ipo_osdexpoffamountup
    ,t.s_ipo_osdactoffamount as s_ipo_osdactoffamount
    ,t.s_ipo_osdactoffprice as s_ipo_osdactoffprice
    ,t.s_ipo_osdunderwritingfees as s_ipo_osdunderwritingfees
    ,t.s_ipo_pureffsubratio as s_ipo_pureffsubratio
    ,t.s_ipo_reporate as s_ipo_reporate
    ,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
    ,t.is_failure as is_failure
    ,t.s_ipo_otc_cash_pct as s_ipo_otc_cash_pct
    ,t.min_applyunit as min_applyunit
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_ashareipo t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareipo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes