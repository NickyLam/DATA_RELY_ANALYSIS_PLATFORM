: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_pbs_eaccount_op_data_f
CreateDate: 20220819
FileName:   ${iel_data_path}/osbs_pbs_eaccount_op_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.peod_accesstoken,chr(13),''),chr(10),'') as peod_accesstoken
    ,replace(replace(t.peod_custno,chr(13),''),chr(10),'') as peod_custno
    ,replace(replace(t.peod_customername,chr(13),''),chr(10),'') as peod_customername
    ,replace(replace(t.peod_userno,chr(13),''),chr(10),'') as peod_userno
    ,replace(replace(t.peod_contactcertificatetypeid,chr(13),''),chr(10),'') as peod_contactcertificatetypeid
    ,replace(replace(t.peod_infostring,chr(13),''),chr(10),'') as peod_infostring
    ,replace(replace(t.peod_birthdate,chr(13),''),chr(10),'') as peod_birthdate
    ,replace(replace(t.peod_fromdate,chr(13),''),chr(10),'') as peod_fromdate
    ,replace(replace(t.peod_thrudate,chr(13),''),chr(10),'') as peod_thrudate
    ,replace(replace(t.peod_authaddrcode,chr(13),''),chr(10),'') as peod_authaddrcode
    ,replace(replace(t.peod_authaddrname,chr(13),''),chr(10),'') as peod_authaddrname
    ,replace(replace(t.peod_contactnum,chr(13),''),chr(10),'') as peod_contactnum
    ,replace(replace(t.peod_gender,chr(13),''),chr(10),'') as peod_gender
    ,replace(replace(t.peod_industry,chr(13),''),chr(10),'') as peod_industry
    ,replace(replace(t.peod_detailaddress,chr(13),''),chr(10),'') as peod_detailaddress
    ,replace(replace(t.peod_taxresident,chr(13),''),chr(10),'') as peod_taxresident
    ,replace(replace(t.peod_taxstatement,chr(13),''),chr(10),'') as peod_taxstatement
    ,replace(replace(t.peod_eaccountno,chr(13),''),chr(10),'') as peod_eaccountno
    ,replace(replace(t.peod_quickbind,chr(13),''),chr(10),'') as peod_quickbind
    ,replace(replace(t.peod_quickbindflag,chr(13),''),chr(10),'') as peod_quickbindflag
    ,replace(replace(t.peod_custflag,chr(13),''),chr(10),'') as peod_custflag
    ,replace(replace(t.peod_ebankcifisexist,chr(13),''),chr(10),'') as peod_ebankcifisexist
    ,replace(replace(t.peod_accountflag,chr(13),''),chr(10),'') as peod_accountflag
    ,replace(replace(t.peod_eaccountstatus,chr(13),''),chr(10),'') as peod_eaccountstatus
    ,replace(replace(t.peod_tranpassword,chr(13),''),chr(10),'') as peod_tranpassword
    ,replace(replace(t.peod_newlogonpassword,chr(13),''),chr(10),'') as peod_newlogonpassword
    ,replace(replace(t.peod_cardno,chr(13),''),chr(10),'') as peod_cardno
    ,replace(replace(t.peod_otherbankflag,chr(13),''),chr(10),'') as peod_otherbankflag
    ,replace(replace(t.peod_bankname,chr(13),''),chr(10),'') as peod_bankname
    ,replace(replace(t.peod_banknumber,chr(13),''),chr(10),'') as peod_banknumber
    ,replace(replace(t.peod_financialinstitutioncode,chr(13),''),chr(10),'') as peod_financialinstitutioncode
    ,replace(replace(t.peod_openbranch,chr(13),''),chr(10),'') as peod_openbranch
    ,replace(replace(t.peod_openbranchname,chr(13),''),chr(10),'') as peod_openbranchname
    ,replace(replace(t.peod_recommendationtype,chr(13),''),chr(10),'') as peod_recommendationtype
    ,replace(replace(t.peod_recommendationnum,chr(13),''),chr(10),'') as peod_recommendationnum
    ,replace(replace(t.peod_srcsystemid,chr(13),''),chr(10),'') as peod_srcsystemid
    ,replace(replace(t.peod_channelcode,chr(13),''),chr(10),'') as peod_channelcode
    ,replace(replace(t.peod_eaccounttype,chr(13),''),chr(10),'') as peod_eaccounttype
    ,replace(replace(t.peod_supplyerno,chr(13),''),chr(10),'') as peod_supplyerno
    ,replace(replace(t.peod_supplyername,chr(13),''),chr(10),'') as peod_supplyername
    ,replace(replace(t.peod_ebankbindflag,chr(13),''),chr(10),'') as peod_ebankbindflag
    ,replace(replace(t.peod_threepicverifyflag,chr(13),''),chr(10),'') as peod_threepicverifyflag
    ,replace(replace(t.peod_channeltype,chr(13),''),chr(10),'') as peod_channeltype
    ,replace(replace(t.peod_operatetype,chr(13),''),chr(10),'') as peod_operatetype
    ,replace(replace(t.peod_accopendate,chr(13),''),chr(10),'') as peod_accopendate
    ,replace(replace(t.peod_verifychannel,chr(13),''),chr(10),'') as peod_verifychannel
    ,replace(replace(t.peod_eaccountlevel,chr(13),''),chr(10),'') as peod_eaccountlevel
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.osbs_pbs_eaccount_op_data t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_eaccount_op_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes