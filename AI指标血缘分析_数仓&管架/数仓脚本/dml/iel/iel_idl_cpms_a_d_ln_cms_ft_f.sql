: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_a_d_ln_cms_ft_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_a_d_ln_cms_ft_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,data_date
,data_time
,duebillno
,cust_id
,paybackaccount
,ratefloat
,mon_avl
,overbal_mon_avl
,overbal_mon_cml
,customerid
,customername
,customertype
,actualbusinessrate
,actualputoutdate
,actualmaturity
,termmonth
,subjectno
,businesscurrency
,balance
,loan_mon_cml
,loan_quar_cml
,loan_year_cml
,loan_mon_avl
,loan_quar_avl
,loan_year_avl
,badbalance
,businesssum
,dullbalance
,finishdate
,finishtype
,interestbalance1
,interestbalance2
,normalbalance
,overduebalance
,overduedays
,loantype
,businessstatus
,saledate
,contractno
,contractsum
,bailsum
,bailratio
,bailcurrency
,baserate
,baseratetype
,businesstype
,classifyresulteleven
,mainreturntype
,ltvvalue
,guarantyhouse
,constructionarea
,corpuspaymethod
,direction
,extendtimes
,housetype
,iccyc
,ictype
,lcno
,lowrisk
,occurtype
,orgid
,originalputoutdate
,oweinterestdays
,rateadjustcyc
,ratefloattype
,reversibility
,safeguardtype
,securitiesregion
,thirdparty1
,userid
,vouchclass
,vouchtype
,certtype
,certid
,corpid
,creditdate
,creditlevel
,economytype
,enterprisebelong
,industrytype
,loancardno
,orgnature
,orgtype
,regioncode
,registeradd
,registercapital
,scope
,belonggroupid
,adjustratetype
,countrycode
,guarantyratio
,paysource
,sfgjxzhy
,listingcorpornot
,fictitiousperson
,fictitiouspersonid
,paymentmode
,isrelative
,purpose
,begindate
,enddate
,holdingtype
,repaycnt
,repayamt
,overbal_quar_cml
,overbal_year_cml
,overbal_quar_avl
,overbal_year_avl
,last_balance
,last_mon_balance
,last_loan_mon_cml
,last_loan_mon_avl
,last_overduebalance
,last_mon_overduebalance
,last_overbal_mon_cml
,last_overbal_mon_avl from idl.cpms_a_d_ln_cms_ft where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_a_d_ln_cms_ft_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes