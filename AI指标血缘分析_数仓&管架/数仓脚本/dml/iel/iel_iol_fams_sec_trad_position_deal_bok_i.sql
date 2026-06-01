: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sec_trad_position_deal_bok_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_sec_trad_position_deal_bok.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.cdate as cdate
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.ptype,chr(13),''),chr(10),'') as ptype
,t1.gendate as gendate
,t1.upddate as upddate
,replace(replace(t1.tradeid,chr(13),''),chr(10),'') as tradeid
,replace(replace(t1.secid,chr(13),''),chr(10),'') as secid
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.investtype,chr(13),''),chr(10),'') as investtype
,t1.encashyears as encashyears
,t1.mayield as mayield
,t1.imyield as imyield
,t1.option_mayield as option_mayield
,t1.option_imyield as option_imyield
,t1.dailydscyield as dailydscyield
,t1.duration as duration
,t1.cnvxty as cnvxty
,t1.msprd_d as msprd_d
,t1.msprd_cnvxty as msprd_cnvxty
,t1.myield_d as myield_d
,t1.myield_cnvxty as myield_cnvxty
,t1.dv01 as dv01
,t1.tomaccrue as tomaccrue
,t1.tdyaccrue as tdyaccrue
,t1.ystaccrue as ystaccrue
,t1.tdycpricebf as tdycpricebf
,t1.tdycprice as tdycprice
,t1.ystcprice as ystcprice
,t1.tdymarketcprice as tdymarketcprice
,t1.ystmarketcprice as ystmarketcprice
,t1.tdymarketyield as tdymarketyield
,t1.ystmarketyield as ystmarketyield
,t1.tdycostamt as tdycostamt
,t1.ystcostamt as ystcostamt
,t1.tdyprinamt as tdyprinamt
,t1.ystprinamt as ystprinamt
,t1.tdyprinamt_paid as tdyprinamt_paid
,t1.ystprinamt_paid as ystprinamt_paid
,t1.tdymtm as tdymtm
,t1.ystmtm as ystmtm
,t1.tdyfloatingpl as tdyfloatingpl
,t1.ystfloatingpl as ystfloatingpl
,t1.tdydscincexp_add as tdydscincexp_add
,t1.tdydscincexp_cha as tdydscincexp_cha
,t1.tdydscincexpchasum as tdydscincexpchasum
,t1.ystdscincexpchasum as ystdscincexpchasum
,t1.tdyunpaiddscincexp as tdyunpaiddscincexp
,t1.ystunpaiddscincexp as ystunpaiddscincexp
,t1.tdydscincexp as tdydscincexp
,t1.ystdscincexp as ystdscincexp
,t1.tdyintincexp_add as tdyintincexp_add
,t1.tdyintincexp_adj as tdyintincexp_adj
,t1.tdyintincexp_cha as tdyintincexp_cha
,t1.tdyintincexpchasum as tdyintincexpchasum
,t1.ystintincexpchasum as ystintincexpchasum
,t1.tdyregiontintincexp as tdyregiontintincexp
,t1.ystregiontintincexp as ystregiontintincexp
,t1.tdytobepaidintincexp_add as tdytobepaidintincexp_add
,t1.tdytobepaidintincexp_del as tdytobepaidintincexp_del
,t1.tdytobepaidintincexp as tdytobepaidintincexp
,t1.ysttobepaidintincexp as ysttobepaidintincexp
,t1.tdyunpaidintincexp as tdyunpaidintincexp
,t1.ystunpaidintincexp as ystunpaidintincexp
,t1.tdyintincexp as tdyintincexp
,t1.ystintincexp as ystintincexp
,t1.tdyintincexp_un as tdyintincexp_un
,t1.ystintincexp_un as ystintincexp_un
,t1.tdyprofitloss as tdyprofitloss
,t1.ystprofitloss as ystprofitloss
,t1.lstmntdate as lstmntdate
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,t1.cost_1 as cost_1
,t1.profitloss_1 as profitloss_1
,t1.profitlossbf_1 as profitlossbf_1
,t1.tdyprinamt_act as tdyprinamt_act
,t1.ystprinamt_act as ystprinamt_act
,t1.tdytobepaidcostamt as tdytobepaidcostamt
,t1.ysttobepaidcostamt as ysttobepaidcostamt
,t1.tdytobepaiddscincexp as tdytobepaiddscincexp
,t1.ysttobepaiddscincexp as ysttobepaiddscincexp
,t1.tdytobepaiddscincexp_add as tdytobepaiddscincexp_add
,t1.tdytobepaiddscincexp_del as tdytobepaiddscincexp_del
,t1.tdytobepaidcost_1 as tdytobepaidcost_1
,t1.facevalue as facevalue
,t1.tdytobepaidcostamt_add as tdytobepaidcostamt_add
,t1.tdytobepaidcostamt_del as tdytobepaidcostamt_del
,t1.ystcost_1 as ystcost_1
,t1.tdytobepaidcost_1_add as tdytobepaidcost_1_add
,t1.tdytobepaidcost_1_del as tdytobepaidcost_1_del
,t1.ysttobepaidcost_1 as ysttobepaidcost_1
,t1.tdycostcost_2 as tdycostcost_2
,t1.ystcostcost_2 as ystcostcost_2
,t1.tdycostint_2 as tdycostint_2
,t1.ystcostint_2 as ystcostint_2
,t1.tdyprofitloss_2 as tdyprofitloss_2
,t1.ystprofitloss_2 as ystprofitloss_2
,replace(replace(t1.originalseqno,chr(13),''),chr(10),'') as originalseqno
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_sec_trad_position_deal_bok t1
where t1.cdate = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sec_trad_position_deal_bok.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes