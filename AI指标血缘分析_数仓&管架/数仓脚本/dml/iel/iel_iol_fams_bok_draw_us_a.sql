: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_draw_us_a
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_draw_us.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select drawdate
,accountid
,trustuuid
,ptype
,trustid
,gendate
,updatedate
,cashamt
,assetamt
,oriprinamt
,drawprinamt
,tdyintincexp_add
,tdyintincexp_adj
,tdyintincexp_cha
,tdyintincexpchasum
,ystintincexpchasum
,tdyregiontintincexp
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
,tdyintinc_dr
,lstmntdate
,ystregiontintincexp
,tdycosta
,ystcosta
,tdyprofitlossa
,ystprofitlossa
,tdycostcostb
,ystcostcostb
,tdycostintb
,ystcostintb
,tdyprofitlossb
,ystprofitlossb
,tradeuuid
,tdydscincexp_add
,tdydscincexp_cha
,tdydscincexpchasum
,ystdscincexpchasum
,tdyunpaiddscincexp
,ystunpaiddscincexp
,tdydscincexp
,ystdscincexp
,tdyprofitloss
,ystprofitloss
,tdycpricebf
,tdycprice
,ystcprice
,tdycostamt
,ystcostamt
,mayield
,etl_dt
,etl_timestamp from iol.fams_bok_draw_us where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_draw_us.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes