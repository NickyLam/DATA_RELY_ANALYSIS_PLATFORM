: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_customer_info_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.financialorganizationnumber,chr(13),''),chr(10),'') as financialorganizationnumber
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.customersubtype,chr(13),''),chr(10),'') as customersubtype
,replace(replace(t1.enterprisename,chr(13),''),chr(10),'') as enterprisename
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.certidexpiredate,chr(13),''),chr(10),'') as certidexpiredate
,replace(replace(t1.institutionalcreditcode,chr(13),''),chr(10),'') as institutionalcreditcode
,replace(replace(t1.organizationcertificatenumber,chr(13),''),chr(10),'') as organizationcertificatenumber
,replace(replace(t1.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t1.registeraddr,chr(13),''),chr(10),'') as registeraddr
,replace(replace(t1.registercountry,chr(13),''),chr(10),'') as registercountry
,replace(replace(t1.registerareacode,chr(13),''),chr(10),'') as registerareacode
,replace(replace(t1.registerareaname,chr(13),''),chr(10),'') as registerareaname
,replace(replace(t1.registerdate,chr(13),''),chr(10),'') as registerdate
,replace(replace(t1.operatinglife,chr(13),''),chr(10),'') as operatinglife
,replace(replace(t1.acoperatinglife,chr(13),''),chr(10),'') as acoperatinglife
,replace(replace(t1.mostbusiness,chr(13),''),chr(10),'') as mostbusiness
,replace(replace(t1.rccurrency,chr(13),''),chr(10),'') as rccurrency
,pccurrency
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.economicindustrytype,chr(13),''),chr(10),'') as economicindustrytype
,replace(replace(t1.economictype,chr(13),''),chr(10),'') as economictype
,replace(replace(t1.officetel,chr(13),''),chr(10),'') as officetel
,replace(replace(t1.financedepttel,chr(13),''),chr(10),'') as financedepttel
,replace(replace(t1.owebalancesumbalance,chr(13),''),chr(10),'') as owebalancesumbalance
,replace(replace(t1.badsumbalance,chr(13),''),chr(10),'') as badsumbalance
,replace(replace(t1.riskwarning,chr(13),''),chr(10),'') as riskwarning
,replace(replace(t1.basicaccoutcode,chr(13),''),chr(10),'') as basicaccoutcode
,replace(replace(t1.basicaccoutname,chr(13),''),chr(10),'') as basicaccoutname
,replace(replace(t1.listingflag,chr(13),''),chr(10),'') as listingflag
,replace(replace(t1.zipcode,chr(13),''),chr(10),'') as zipcode
,replace(replace(t1.phonenumber,chr(13),''),chr(10),'') as phonenumber
,staffnumber
,replace(replace(t1.enterpriseholdingtype,chr(13),''),chr(10),'') as enterpriseholdingtype
,replace(replace(t1.opencloseflag,chr(13),''),chr(10),'') as opencloseflag
,replace(replace(t1.organizationscale,chr(13),''),chr(10),'') as organizationscale
,replace(replace(t1.inoutflag,chr(13),''),chr(10),'') as inoutflag
,replace(replace(t1.laborintensiveflag,chr(13),''),chr(10),'') as laborintensiveflag
,replace(replace(t1.taxpayertype,chr(13),''),chr(10),'') as taxpayertype
,replace(replace(t1.recommend,chr(13),''),chr(10),'') as recommend
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,replace(replace(t1.creditrate,chr(13),''),chr(10),'') as creditrate
,replace(replace(t1.portal,chr(13),''),chr(10),'') as portal
,replace(replace(t1.loansplitresult,chr(13),''),chr(10),'') as loansplitresult
,replace(replace(t1.orgminputoutdate,chr(13),''),chr(10),'') as orgminputoutdate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.updatedate1,chr(13),''),chr(10),'') as updatedate1

from ${iol_schema}.icms_wyd_customer_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
