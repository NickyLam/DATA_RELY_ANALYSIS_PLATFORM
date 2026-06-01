: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_interf_payhsrcsecinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_interf_payhsrcsecinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(secid,chr(13),''),chr(10),'') as secid
      ,replace(replace(secname,chr(13),''),chr(10),'') as secname
      ,replace(replace(seccode,chr(13),''),chr(10),'') as seccode
      ,replace(replace(market,chr(13),''),chr(10),'') as market
      ,replace(replace(secfullname,chr(13),''),chr(10),'') as secfullname
      ,replace(replace(ratebasic,chr(13),''),chr(10),'') as ratebasic
      ,replace(replace(couponspecies,chr(13),''),chr(10),'') as couponspecies
      ,replace(replace(interestrate,chr(13),''),chr(10),'') as interestrate
      ,vdate
      ,mdate
      ,replace(replace(paycycle,chr(13),''),chr(10),'') as paycycle
      ,facevalue
      ,issueprice
      ,paperir
      ,replace(replace(schecalrule,chr(13),''),chr(10),'') as schecalrule
      ,firstrateday
      ,replace(replace(workdayrule,chr(13),''),chr(10),'') as workdayrule
      ,replace(replace(issuershort,chr(13),''),chr(10),'') as issuershort
      ,replace(replace(resettype,chr(13),''),chr(10),'') as resettype
      ,observebefday
      ,replace(replace(observebefunit,chr(13),''),chr(10),'') as observebefunit
      ,toprate
      ,bottomrate
      ,issueamt
      ,replace(replace(ratecode,chr(13),''),chr(10),'') as ratecode
      ,spreadrate_8
      ,coefficient
      ,replace(replace(sectype,chr(13),''),chr(10),'') as sectype
      ,replace(replace(sectype2,chr(13),''),chr(10),'') as sectype2
      ,replace(replace(chbsectype,chr(13),''),chr(10),'') as chbsectype
      ,replace(replace(chbsectype2,chr(13),''),chr(10),'') as chbsectype2
      ,replace(replace(pbocsectype,chr(13),''),chr(10),'') as pbocsectype
      ,replace(replace(pbocsectype2,chr(13),''),chr(10),'') as pbocsectype2
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(issecbond,chr(13),''),chr(10),'') as issecbond
      ,replace(replace(issus,chr(13),''),chr(10),'') as issus
      ,replace(replace(calloption,chr(13),''),chr(10),'') as calloption
      ,replace(replace(putoption,chr(13),''),chr(10),'') as putoption
      ,replace(replace(institution,chr(13),''),chr(10),'') as institution
      ,replace(replace(institutiontext,chr(13),''),chr(10),'') as institutiontext
      ,replace(replace(markettext,chr(13),''),chr(10),'') as markettext
      ,replace(replace(market2,chr(13),''),chr(10),'') as market2
      ,replace(replace(ccy,chr(13),''),chr(10),'') as ccy
      ,replace(replace(issuetype,chr(13),''),chr(10),'') as issuetype
      ,replace(replace(blnarea,chr(13),''),chr(10),'') as blnarea
      ,replace(replace(guarantor,chr(13),''),chr(10),'') as guarantor
      ,replace(replace(guartype,chr(13),''),chr(10),'') as guartype
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(source,chr(13),''),chr(10),'') as source
      ,pubenddate
      ,replace(replace(asset_class,chr(13),''),chr(10),'') as asset_class
      ,replace(replace(concrete_class,chr(13),''),chr(10),'') as concrete_class
      ,replace(replace(concrete_class_sm,chr(13),''),chr(10),'') as concrete_class_sm
      ,replace(replace(issuer_scale_type,chr(13),''),chr(10),'') as issuer_scale_type
      ,replace(replace(issuer_technology_type,chr(13),''),chr(10),'') as issuer_technology_type
      ,replace(replace(issuer_economic_type,chr(13),''),chr(10),'') as issuer_economic_type
      ,replace(replace(issuer_desc,chr(13),''),chr(10),'') as issuer_desc
      ,replace(replace(issuer_institutions,chr(13),''),chr(10),'') as issuer_institutions
      ,replace(replace(city_invest_sec_chb,chr(13),''),chr(10),'') as city_invest_sec_chb
      ,replace(replace(city_invest_sec_provinces,chr(13),''),chr(10),'') as city_invest_sec_provinces
      ,replace(replace(city_invest_sec_cities,chr(13),''),chr(10),'') as city_invest_sec_cities
      ,replace(replace(city_invest_sec_county,chr(13),''),chr(10),'') as city_invest_sec_county
      ,replace(replace(city_invest_sec_wind,chr(13),''),chr(10),'') as city_invest_sec_wind
      ,replace(replace(city_invest_sec_cbrc,chr(13),''),chr(10),'') as city_invest_sec_cbrc
      ,replace(replace(issuer_institutions_second,chr(13),''),chr(10),'') as issuer_institutions_second
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_interf_payhsrcsecinfo
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_interf_payhsrcsecinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes