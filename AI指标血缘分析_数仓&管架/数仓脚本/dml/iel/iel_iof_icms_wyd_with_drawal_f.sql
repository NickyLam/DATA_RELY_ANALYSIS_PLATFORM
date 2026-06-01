: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_with_drawal_f
CreateDate: 20251110
FileName:   ${iel_data_path}/icms_wyd_with_drawal.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.coorgnum,chr(13),''),chr(10),'') as coorgnum
,replace(replace(t1.applseqnum,chr(13),''),chr(10),'') as applseqnum
,replace(replace(t1.lrrserialno,chr(13),''),chr(10),'') as lrrserialno
,replace(replace(t1.intfccalltm,chr(13),''),chr(10),'') as intfccalltm
,replace(replace(t1.stlprdcd,chr(13),''),chr(10),'') as stlprdcd
,replace(replace(t1.ddtyp,chr(13),''),chr(10),'') as ddtyp
,replace(replace(t1.refe,chr(13),''),chr(10),'') as refe
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,contramt
,replace(replace(t1.precdddate,chr(13),''),chr(10),'') as precdddate
,replace(replace(t1.applsiteregion,chr(13),''),chr(10),'') as applsiteregion
,replace(replace(t1.applusage,chr(13),''),chr(10),'') as applusage
,replace(replace(t1.wzguarmode,chr(13),''),chr(10),'') as wzguarmode
,replace(replace(t1.dedudate,chr(13),''),chr(10),'') as dedudate
,replace(replace(t1.taxpidennum,chr(13),''),chr(10),'') as taxpidennum
,replace(replace(t1.corpfname,chr(13),''),chr(10),'') as corpfname
,replace(replace(t1.ptyecif,chr(13),''),chr(10),'') as ptyecif
,replace(replace(t1.regctyzone,chr(13),''),chr(10),'') as regctyzone
,replace(replace(t1.natnregion,chr(13),''),chr(10),'') as natnregion
,replace(replace(t1.regloc,chr(13),''),chr(10),'') as regloc
,replace(replace(t1.prov,chr(13),''),chr(10),'') as prov
,replace(replace(t1.orgcd,chr(13),''),chr(10),'') as orgcd
,replace(replace(t1.csldsocicrdtid,chr(13),''),chr(10),'') as csldsocicrdtid
,replace(replace(t1.inducomregnum,chr(13),''),chr(10),'') as inducomregnum
,replace(replace(t1.operlicencevalidenddt,chr(13),''),chr(10),'') as operlicencevalidenddt
,replace(replace(t1.gbinduclass,chr(13),''),chr(10),'') as gbinduclass
,replace(replace(t1.wzcorpsize,chr(13),''),chr(10),'') as wzcorpsize
,replace(replace(t1.cbrcsmallcorpind,chr(13),''),chr(10),'') as cbrcsmallcorpind
,replace(replace(t1.estabdt,chr(13),''),chr(10),'') as estabdt
,replace(replace(t1.operyears,chr(13),''),chr(10),'') as operyears
,replace(replace(t1.empcnt,chr(13),''),chr(10),'') as empcnt
,replace(replace(t1.lpname,chr(13),''),chr(10),'') as lpname
,replace(replace(t1.lpecif,chr(13),''),chr(10),'') as lpecif
,replace(replace(t1.lpcerttyp,chr(13),''),chr(10),'') as lpcerttyp
,replace(replace(t1.lpcertnum,chr(13),''),chr(10),'') as lpcertnum
,replace(replace(t1.lpcertexpidate,chr(13),''),chr(10),'') as lpcertexpidate
,replace(replace(t1.lpgend,chr(13),''),chr(10),'') as lpgend
,replace(replace(t1.lpethnic,chr(13),''),chr(10),'') as lpethnic
,replace(replace(t1.lpcertadr,chr(13),''),chr(10),'') as lpcertadr
,replace(replace(t1.lpnation,chr(13),''),chr(10),'') as lpnation
,replace(replace(t1.lpcareer,chr(13),''),chr(10),'') as lpcareer
,replace(replace(t1.lpbirthdt,chr(13),''),chr(10),'') as lpbirthdt
,replace(replace(t1.lpcephnum,chr(13),''),chr(10),'') as lpcephnum
,replace(replace(t1.certbankcardnum,chr(13),''),chr(10),'') as certbankcardnum
,replace(replace(t1.certcephnum,chr(13),''),chr(10),'') as certcephnum
,replace(replace(t1.corpcitauthsigntm,chr(13),''),chr(10),'') as corpcitauthsigntm
,replace(replace(t1.indvcitauthsigntm,chr(13),''),chr(10),'') as indvcitauthsigntm
,replace(replace(t1.corpcitauthsignseq,chr(13),''),chr(10),'') as corpcitauthsignseq
,replace(replace(t1.indvcitauthsignseq,chr(13),''),chr(10),'') as indvcitauthsignseq
,replace(replace(t1.facecertresu,chr(13),''),chr(10),'') as facecertresu
,finalcfmlmt
,modelquotalmt
,coopupdalmt
,replace(replace(t1.lastchklmtdate,chr(13),''),chr(10),'') as lastchklmtdate
,replace(replace(t1.interrat,chr(13),''),chr(10),'') as interrat
,replace(replace(t1.loancnt,chr(13),''),chr(10),'') as loancnt
,replace(replace(t1.loanform,chr(13),''),chr(10),'') as loanform
,replace(replace(t1.origdbillnum,chr(13),''),chr(10),'') as origdbillnum
,replace(replace(t1.wthrguarbiz,chr(13),''),chr(10),'') as wthrguarbiz
,replace(replace(t1.guartcompanyname,chr(13),''),chr(10),'') as guartcompanyname
,replace(replace(t1.guarcorpcerttyp,chr(13),''),chr(10),'') as guarcorpcerttyp
,replace(replace(t1.guarcorpcertnum,chr(13),''),chr(10),'') as guarcorpcertnum
,guarratio
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.riskresult,chr(13),''),chr(10),'') as riskresult
,replace(replace(t1.isfirstloan,chr(13),''),chr(10),'') as isfirstloan
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_wyd_with_drawal t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_with_drawal.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
