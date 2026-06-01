: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sec_trad_position_deal_bok_a
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_sec_trad_position_deal_bok.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select cdate
,seqno
,ptype
,gendate
,upddate
,tradeid
,secid
,account
,investtype
,encashyears
,mayield
,imyield
,option_mayield
,option_imyield
,dailydscyield
,duration
,cnvxty
,msprd_d
,msprd_cnvxty
,myield_d
,myield_cnvxty
,dv01
,tomaccrue
,tdyaccrue
,ystaccrue
,tdycpricebf
,tdycprice
,ystcprice
,tdymarketcprice
,ystmarketcprice
,tdymarketyield
,ystmarketyield
,tdycostamt
,ystcostamt
,tdyprinamt
,ystprinamt
,tdyprinamt_paid
,ystprinamt_paid
,tdymtm
,ystmtm
,tdyfloatingpl
,ystfloatingpl
,tdydscincexp_add
,tdydscincexp_cha
,tdydscincexpchasum
,ystdscincexpchasum
,tdyunpaiddscincexp
,ystunpaiddscincexp
,tdydscincexp
,ystdscincexp
,tdyintincexp_add
,tdyintincexp_adj
,tdyintincexp_cha
,tdyintincexpchasum
,ystintincexpchasum
,tdyregiontintincexp
,ystregiontintincexp
,tdytobepaidintincexp_add
,tdytobepaidintincexp_del
,tdytobepaidintincexp
,ysttobepaidintincexp
,tdyunpaidintincexp
,ystunpaidintincexp
,tdyintincexp
,ystintincexp
,tdyintincexp_un
,ystintincexp_un
,tdyprofitloss
,ystprofitloss
,lstmntdate
,lstmntuser
,cost_1
,profitloss_1
,profitlossbf_1
,tdyprinamt_act
,ystprinamt_act
,tdytobepaidcostamt
,ysttobepaidcostamt
,tdytobepaiddscincexp
,ysttobepaiddscincexp
,tdytobepaiddscincexp_add
,tdytobepaiddscincexp_del
,tdytobepaidcost_1
,facevalue
,tdytobepaidcostamt_add
,tdytobepaidcostamt_del
,ystcost_1
,tdytobepaidcost_1_add
,tdytobepaidcost_1_del
,ysttobepaidcost_1
,tdycostcost_2
,ystcostcost_2
,tdycostint_2
,ystcostint_2
,tdyprofitloss_2
,ystprofitloss_2
,originalseqno
,etl_dt
,etl_timestamp from iol.fams_sec_trad_position_deal_bok where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sec_trad_position_deal_bok.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes