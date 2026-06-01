/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_customer_supplement_info_pub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_customer_supplement_info_pub
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_customer_supplement_info_pub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_customer_supplement_info_pub(
    custno varchar2(30) -- 
    ,lncdpw varchar2(12) -- 
    ,lncdtg varchar2(2) -- 
    ,lncddt varchar2(12) -- 
    ,lncdst varchar2(3) -- 
    ,lcditg varchar2(2) -- 
    ,lcdidt varchar2(12) -- 
    ,lcdrdt varchar2(12) -- 
    ,upcrna varchar2(90) -- 
    ,uprgcy varchar2(3) -- 
    ,uprgam number(18,2) -- 
    ,upcrps varchar2(30) -- 
    ,upidtp varchar2(30) -- 
    ,upidno varchar2(30) -- 
    ,upopno varchar2(30) -- 
    ,upcpcd varchar2(30) -- 
    ,upcped varchar2(12) -- 
    ,retxtg varchar2(2) -- 
    ,txdpid varchar2(90) -- 
    ,iscuim varchar2(2) -- 
    ,ishtch varchar2(2) -- 
    ,stckam number(18,2) -- 
    ,isgrup varchar2(2) -- 
    ,gropid varchar2(30) -- 
    ,isgrmo varchar2(2) -- 
    ,ctylev varchar2(2) -- 
    ,waylv5 varchar2(15) -- 
    ,etpcht varchar2(15) -- 
    ,cuslv3 varchar2(2) -- 
    ,custp3 varchar2(2) -- 
    ,lmtway varchar2(15) -- 
    ,rpmltp varchar2(3) -- 
    ,retinm number(20) -- 
    ,unvrnm number(20) -- 
    ,isdrec varchar2(2) -- 
    ,provce varchar2(150) -- 
    ,inoutp varchar2(2) -- 
    ,worang varchar2(383) -- 
    ,supeor varchar2(150) -- 
    ,buldmy number(18,2) -- 
    ,budgtp varchar2(150) -- 
    ,orgown varchar2(150) -- 
    ,cdradt varchar2(12) -- 
    ,prfd01 varchar2(90) -- 
    ,prfd02 varchar2(90) -- 
    ,prfd03 varchar2(90) -- 
    ,prfd04 number(18,2) -- 
    ,prfd05 number(18,2) -- 
    ,salmon number(18,2) -- 
    ,sizehy varchar2(12) -- 
    ,isbank varchar2(2) -- 
    ,banksz varchar2(2) -- 
    ,xwqyid varchar2(2) -- 
    ,jjzzxs varchar2(3) -- 
    ,jjbmlx varchar2(12) -- 
    ,caccno varchar2(30) -- 
    ,econtp varchar2(15) -- 
    ,teleno varchar2(150) -- 
    ,vocamx varchar2(30) -- 
    ,psrntg varchar2(3) -- 
    ,lwctna varchar2(150) -- 
    ,lwidno varchar2(150) -- 
    ,cptnnm varchar2(90) -- 
    ,vocatp varchar2(12) -- 
    ,rgstad varchar2(30) -- 
    ,regidt varchar2(12) -- 
    ,regiad varchar2(300) -- 
    ,operar varchar2(383) -- 
    ,custlv varchar2(15) -- 
    ,statlv varchar2(15) -- 
    ,jonttg varchar2(2) -- 
    ,doubtp varchar2(15) -- 
    ,tttrib number(18,2) -- 
    ,ttrema number(18,2) -- 
    ,risklv varchar2(15) -- 
    ,datatp varchar2(15) -- 
    ,roletp varchar2(15) -- 
    ,isincu varchar2(2) -- 
    ,iscred varchar2(2) -- 
    ,credid varchar2(15) -- 
    ,credln number(18,2) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,bankno varchar2(30) -- 
    ,banklv varchar2(12) -- 
    ,bktpid varchar2(30) -- 
    ,jjdl varchar2(30) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_customer_supplement_info_pub to ${iml_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info_pub to ${icl_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info_pub to ${idl_schema};
grant select on ${iol_schema}.eifs_customer_supplement_info_pub to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_customer_supplement_info_pub is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.custno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lncdpw is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lncdtg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lncddt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lncdst is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lcditg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lcdidt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lcdrdt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upcrna is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.uprgcy is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.uprgam is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upcrps is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upidtp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upidno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upopno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upcpcd is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.upcped is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.retxtg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.txdpid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.iscuim is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.ishtch is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.stckam is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.isgrup is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.gropid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.isgrmo is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.ctylev is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.waylv5 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.etpcht is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.cuslv3 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.custp3 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lmtway is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.rpmltp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.retinm is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.unvrnm is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.isdrec is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.provce is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.inoutp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.worang is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.supeor is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.buldmy is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.budgtp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.orgown is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.cdradt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.prfd01 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.prfd02 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.prfd03 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.prfd04 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.prfd05 is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.salmon is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.sizehy is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.isbank is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.banksz is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.xwqyid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.jjzzxs is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.jjbmlx is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.caccno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.econtp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.teleno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.vocamx is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.psrntg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lwctna is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.lwidno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.cptnnm is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.vocatp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.rgstad is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.regidt is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.regiad is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.operar is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.custlv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.statlv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.jonttg is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.doubtp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.tttrib is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.ttrema is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.risklv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.datatp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.roletp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.isincu is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.iscred is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.credid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.credln is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.last_updated_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.last_updated_tx_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.created_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.created_tx_stamp is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.bankno is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.banklv is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.bktpid is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.jjdl is '';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_customer_supplement_info_pub.etl_timestamp is 'ETL处理时间戳';
