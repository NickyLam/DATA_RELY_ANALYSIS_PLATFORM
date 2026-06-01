: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_t_dcam_crnk_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_t_dcam_crnk_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(acctdt,chr(10),''),chr(13),'') as acctdt
,replace(replace(custid,chr(10),''),chr(13),'') as custid
,replace(replace(orover,chr(10),''),chr(13),'') as orover
,replace(replace(lncfno,chr(10),''),chr(13),'') as lncfno
,replace(replace(jzumji,chr(10),''),chr(13),'') as jzumji
,replace(replace(orprho,chr(10),''),chr(13),'') as orprho
,replace(replace(orprdy,chr(10),''),chr(13),'') as orprdy
,replace(replace(normmn,chr(10),''),chr(13),'') as normmn
,replace(replace(atntmn,chr(10),''),chr(13),'') as atntmn
,replace(replace(lessmn,chr(10),''),chr(13),'') as lessmn
,replace(replace(dobtmn,chr(10),''),chr(13),'') as dobtmn
,replace(replace(lostmn,chr(10),''),chr(13),'') as lostmn
,replace(replace(vocatp,chr(10),''),chr(13),'') as vocatp
,replace(replace(loantp,chr(10),''),chr(13),'') as loantp
,replace(replace(floamd,chr(10),''),chr(13),'') as floamd
,replace(replace(irflip,chr(10),''),chr(13),'') as irflip
,replace(replace(assure,chr(10),''),chr(13),'') as assure
,replace(replace(vocatp1,chr(10),''),chr(13),'') as vocatp1
,replace(replace(isrefm,chr(10),''),chr(13),'') as isrefm
,replace(replace(loantp1,chr(10),''),chr(13),'') as loantp1
,replace(replace(autofg,chr(10),''),chr(13),'') as autofg
,replace(replace(chgedt,chr(10),''),chr(13),'') as chgedt
,replace(replace(asselv,chr(10),''),chr(13),'') as asselv
,replace(replace(asseam,chr(10),''),chr(13),'') as asseam
,replace(replace(rlsttp,chr(10),''),chr(13),'') as rlsttp
,replace(replace(collvl,chr(10),''),chr(13),'') as collvl
,replace(replace(iscrdt,chr(10),''),chr(13),'') as iscrdt
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_t_dcam_crnk 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_t_dcam_crnk_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes