: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_new_balance_f
CreateDate: 20230804
FileName:   ${iel_data_path}/ctms_tbs_v_new_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,baretrade_id
,replace(replace(t1.baretradename,chr(13),''),chr(10),'') as baretradename
,balance_id
,alterbalance_id
,aspclient_id
,keepfolder_id
,settledate
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.buztype,chr(13),''),chr(10),'') as buztype
,replace(replace(t1.majorassetcode,chr(13),''),chr(10),'') as majorassetcode
,replace(replace(t1.minorassetcode,chr(13),''),chr(10),'') as minorassetcode
,holdposition
,holdfaceamount
,cleanpricecost
,interestadjust
,fairvaluealter
,interestcost
,dirtypricecost
,impairment
,priceearning
,amortizeearning
,interestearning
,fairvalueincome
,impairmentlost
,tradeexpense
,realrate
,valuedate
,maturitydate
,lastmodified
,occuramount
,balance_id_prev
,replace(replace(t1.rev_flag,chr(13),''),chr(10),'') as rev_flag
,reservevalue1
,reservevalue2
,replace(replace(t1.product_code,chr(13),''),chr(10),'') as product_code
,chargeincome
,chargeexpense
,replace(replace(t1.capital_subjectid,chr(13),''),chr(10),'') as capital_subjectid
,replace(replace(t1.interestcost_subjectid,chr(13),''),chr(10),'') as interestcost_subjectid
,replace(replace(t1.interestadjust_subjectid,chr(13),''),chr(10),'') as interestadjust_subjectid
,replace(replace(t1.fairvaluealter_subjectid,chr(13),''),chr(10),'') as fairvaluealter_subjectid
,replace(replace(t1.interestearning_subjectid,chr(13),''),chr(10),'') as interestearning_subjectid
,replace(replace(t1.amortizeearning_subjectid,chr(13),''),chr(10),'') as amortizeearning_subjectid
,replace(replace(t1.fairvalueincome_subjectid,chr(13),''),chr(10),'') as fairvalueincome_subjectid
,replace(replace(t1.priceearning_subjectid,chr(13),''),chr(10),'') as priceearning_subjectid

from ${iol_schema}.ctms_tbs_v_new_balance t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_new_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
