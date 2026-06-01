: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_fin_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(finprod_id,chr(13),''),chr(10),'') as finprod_id
      ,replace(replace(finprod_type,chr(13),''),chr(10),'') as finprod_type
      ,replace(replace(finprod_type2,chr(13),''),chr(10),'') as finprod_type2
      ,replace(replace(finprod_abbr,chr(13),''),chr(10),'') as finprod_abbr
      ,replace(replace(finprod_name,chr(13),''),chr(10),'') as finprod_name
      ,replace(replace(profit_type,chr(13),''),chr(10),'') as profit_type
      ,replace(replace(coupon_species,chr(13),''),chr(10),'') as coupon_species
      ,replace(replace(chl_finprod_id,chr(13),''),chr(10),'') as chl_finprod_id
      ,replace(replace(finprod_market_id,chr(13),''),chr(10),'') as finprod_market_id
      ,replace(replace(issue_id,chr(13),''),chr(10),'') as issue_id
      ,issue_price
      ,issue_amt
      ,replace(replace(ccy,chr(13),''),chr(10),'') as ccy
      ,replace(replace(bln_area,chr(13),''),chr(10),'') as bln_area
      ,replace(replace(trade_market,chr(13),''),chr(10),'') as trade_market
      ,replace(replace(calendar_id,chr(13),''),chr(10),'') as calendar_id
      ,replace(replace(issue_type,chr(13),''),chr(10),'') as issue_type
      ,replace(replace(operation_type,chr(13),''),chr(10),'') as operation_type
      ,replace(replace(entrust_type,chr(13),''),chr(10),'') as entrust_type
      ,replace(replace(entruster,chr(13),''),chr(10),'') as entruster
      ,replace(replace(trustee_id,chr(13),''),chr(10),'') as trustee_id
      ,replace(replace(issuer,chr(13),''),chr(10),'') as issuer
      ,replace(replace(manager,chr(13),''),chr(10),'') as manager
      ,replace(replace(financier,chr(13),''),chr(10),'') as financier
      ,idate
      ,vdate
      ,mdate
      ,term_days
      ,actmdate
      ,liquidation_date
      ,replace(replace(is_chl,chr(13),''),chr(10),'') as is_chl
      ,replace(replace(is_sus,chr(13),''),chr(10),'') as is_sus
      ,replace(replace(sustainable_remark,chr(13),''),chr(10),'') as sustainable_remark
      ,replace(replace(is_right,chr(13),''),chr(10),'') as is_right
      ,replace(replace(capi_income_feature,chr(13),''),chr(10),'') as capi_income_feature
      ,replace(replace(p_finprod_id,chr(13),''),chr(10),'') as p_finprod_id
      ,replace(replace(o_finprod_id,chr(13),''),chr(10),'') as o_finprod_id
      ,replace(replace(regist_org,chr(13),''),chr(10),'') as regist_org
      ,replace(replace(exe_date,chr(13),''),chr(10),'') as exe_date
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(contract_no,chr(13),''),chr(10),'') as contract_no
      ,replace(replace(is_fin_org,chr(13),''),chr(10),'') as is_fin_org
      ,replace(replace(sponsor,chr(13),''),chr(10),'') as sponsor
      ,replace(replace(invest_adviser,chr(13),''),chr(10),'') as invest_adviser
      ,replace(replace(liquidation_yesno,chr(13),''),chr(10),'') as liquidation_yesno
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_fin_product
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes