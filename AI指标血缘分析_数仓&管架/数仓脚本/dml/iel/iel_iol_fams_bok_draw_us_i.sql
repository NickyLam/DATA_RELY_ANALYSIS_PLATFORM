: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_draw_us_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_draw_us.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.drawdate as drawdate
,replace(replace(t1.accountid,chr(13),''),chr(10),'') as accountid
,replace(replace(t1.trustuuid,chr(13),''),chr(10),'') as trustuuid
,replace(replace(t1.ptype,chr(13),''),chr(10),'') as ptype
,replace(replace(t1.trustid,chr(13),''),chr(10),'') as trustid
,t1.gendate as gendate
,t1.updatedate as updatedate
,t1.cashamt as cashamt
,t1.assetamt as assetamt
,t1.oriprinamt as oriprinamt
,t1.drawprinamt as drawprinamt
,t1.tdyintincexp_add as tdyintincexp_add
,t1.tdyintincexp_adj as tdyintincexp_adj
,t1.tdyintincexp_cha as tdyintincexp_cha
,t1.tdyintincexpchasum as tdyintincexpchasum
,t1.ystintincexpchasum as ystintincexpchasum
,t1.tdyregiontintincexp as tdyregiontintincexp
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
,t1.tdyintinc_dr as tdyintinc_dr
,t1.lstmntdate as lstmntdate
,t1.ystregiontintincexp as ystregiontintincexp
,t1.tdycosta as tdycosta
,t1.ystcosta as ystcosta
,t1.tdyprofitlossa as tdyprofitlossa
,t1.ystprofitlossa as ystprofitlossa
,t1.tdycostcostb as tdycostcostb
,t1.ystcostcostb as ystcostcostb
,t1.tdycostintb as tdycostintb
,t1.ystcostintb as ystcostintb
,t1.tdyprofitlossb as tdyprofitlossb
,t1.ystprofitlossb as ystprofitlossb
,replace(replace(t1.tradeuuid,chr(13),''),chr(10),'') as tradeuuid
,t1.tdydscincexp_add as tdydscincexp_add
,t1.tdydscincexp_cha as tdydscincexp_cha
,t1.tdydscincexpchasum as tdydscincexpchasum
,t1.ystdscincexpchasum as ystdscincexpchasum
,t1.tdyunpaiddscincexp as tdyunpaiddscincexp
,t1.ystunpaiddscincexp as ystunpaiddscincexp
,t1.tdydscincexp as tdydscincexp
,t1.ystdscincexp as ystdscincexp
,t1.tdyprofitloss as tdyprofitloss
,t1.ystprofitloss as ystprofitloss
,t1.tdycpricebf as tdycpricebf
,t1.tdycprice as tdycprice
,t1.ystcprice as ystcprice
,t1.tdycostamt as tdycostamt
,t1.ystcostamt as ystcostamt
,t1.mayield as mayield
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_bok_draw_us t1
where t1.drawdate = TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_draw_us.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes