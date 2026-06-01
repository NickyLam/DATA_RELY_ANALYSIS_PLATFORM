: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kdb_slep_perp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kdb_slep_perp_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select     
    replace(replace(t1.regsno,chr(13),''),chr(10),'') as  regsno
    ,replace(replace(t1.acctno,chr(13),''),chr(10),'')  as acctno
    ,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  as status
    ,replace(replace(t1.regsdt,chr(13),''),chr(10),'')  as regsdt
    ,replace(replace(rtrim(t1.perpdt),chr(13),''),chr(10),'')  as perpdt
    ,replace(replace(t1.passtg,chr(13),''),chr(10),'')  as passtg
    ,replace(replace(rtrim(t1.passdt),chr(13),''),chr(10),'')  as passdt
    ,replace(replace(rtrim(t1.passsq),chr(13),''),chr(10),'')  as passsq
    ,replace(replace(rtrim(t1.passus),chr(13),''),chr(10),'')  as passus
    ,replace(replace(rtrim(t1.unsldt),chr(13),''),chr(10),'')  as unsldt
    ,replace(replace(rtrim(t1.unslsq),chr(13),''),chr(10),'')  as unslsq
    ,replace(replace(rtrim(t1.unsltp),chr(13),''),chr(10),'') as unsltp from IoL.cbss_kdb_slep_perp t1 
where t1.start_dt <= to_date('20210101','yyyymmdd') and t1.end_dt > to_date('20210101','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kdb_slep_perp_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes