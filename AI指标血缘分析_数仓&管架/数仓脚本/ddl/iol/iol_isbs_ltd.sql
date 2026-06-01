/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ltd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ltd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ltd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ltd(
    avbwth varchar2(2) -- 
    ,stacty varchar2(3) -- 
    ,spcbenflg varchar2(2) -- 
    ,chato varchar2(2) -- 
    ,nomtop number(2,0) -- 
    ,nomton number(2,0) -- 
    ,expplc varchar2(44) -- 
    ,inr varchar2(12) -- 
    ,shpto varchar2(98) -- 
    ,avbby varchar2(2) -- 
    ,adlflg varchar2(2) -- 
    ,prepers18 number(3,0) -- 
    ,ver varchar2(6) -- 
    ,porloa varchar2(98) -- 
    ,shpfro varchar2(98) -- 
    ,amedat date -- 
    ,shptrs varchar2(53) -- 
    ,credat date -- 
    ,redclsflg varchar2(2) -- 
    ,prepertxts18 varchar2(53) -- 
    ,lcrtyp varchar2(3) -- 
    ,ownref varchar2(24) -- 
    ,clsdat date -- 
    ,nam varchar2(60) -- 
    ,tenmaxday number(3,0) -- 
    ,rmbcha varchar2(5) -- 
    ,shppar varchar2(53) -- 
    ,nomspc varchar2(2) -- 
    ,ledinr varchar2(12) -- 
    ,advnbr number(3,0) -- 
    ,apprul varchar2(45) -- 
    ,shppars18 varchar2(17) -- 
    ,docsubflg varchar2(2) -- 
    ,expdat date -- 
    ,shpdat date -- 
    ,pordis varchar2(98) -- 
    ,spcrcbflg varchar2(2) -- 
    ,rmbflg varchar2(2) -- 
    ,amenbr number(3,0) -- 
    ,apprulrmb varchar2(45) -- 
    ,utlnbr number(3,0) -- 
    ,ownusr varchar2(12) -- 
    ,etyextkey varchar2(12) -- 
    ,opndat date -- 
    ,shptrss18 varchar2(17) -- 
    ,cnfins varchar2(2) -- 
    ,branchinr varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,apprultxt varchar2(53) -- 
    ,autdat date -- 
    ,rmbact varchar2(53) -- 
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
grant select on ${iol_schema}.isbs_ltd to ${iml_schema};
grant select on ${iol_schema}.isbs_ltd to ${icl_schema};
grant select on ${iol_schema}.isbs_ltd to ${idl_schema};
grant select on ${iol_schema}.isbs_ltd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ltd is '转让信用证业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_ltd.avbwth is '';
comment on column ${iol_schema}.isbs_ltd.stacty is '';
comment on column ${iol_schema}.isbs_ltd.spcbenflg is '';
comment on column ${iol_schema}.isbs_ltd.chato is '';
comment on column ${iol_schema}.isbs_ltd.nomtop is '';
comment on column ${iol_schema}.isbs_ltd.nomton is '';
comment on column ${iol_schema}.isbs_ltd.expplc is '';
comment on column ${iol_schema}.isbs_ltd.inr is '';
comment on column ${iol_schema}.isbs_ltd.shpto is '';
comment on column ${iol_schema}.isbs_ltd.avbby is '';
comment on column ${iol_schema}.isbs_ltd.adlflg is '';
comment on column ${iol_schema}.isbs_ltd.prepers18 is '';
comment on column ${iol_schema}.isbs_ltd.ver is '';
comment on column ${iol_schema}.isbs_ltd.porloa is '';
comment on column ${iol_schema}.isbs_ltd.shpfro is '';
comment on column ${iol_schema}.isbs_ltd.amedat is '';
comment on column ${iol_schema}.isbs_ltd.shptrs is '';
comment on column ${iol_schema}.isbs_ltd.credat is '';
comment on column ${iol_schema}.isbs_ltd.redclsflg is '';
comment on column ${iol_schema}.isbs_ltd.prepertxts18 is '';
comment on column ${iol_schema}.isbs_ltd.lcrtyp is '';
comment on column ${iol_schema}.isbs_ltd.ownref is '';
comment on column ${iol_schema}.isbs_ltd.clsdat is '';
comment on column ${iol_schema}.isbs_ltd.nam is '';
comment on column ${iol_schema}.isbs_ltd.tenmaxday is '';
comment on column ${iol_schema}.isbs_ltd.rmbcha is '';
comment on column ${iol_schema}.isbs_ltd.shppar is '';
comment on column ${iol_schema}.isbs_ltd.nomspc is '';
comment on column ${iol_schema}.isbs_ltd.ledinr is '';
comment on column ${iol_schema}.isbs_ltd.advnbr is '';
comment on column ${iol_schema}.isbs_ltd.apprul is '';
comment on column ${iol_schema}.isbs_ltd.shppars18 is '';
comment on column ${iol_schema}.isbs_ltd.docsubflg is '';
comment on column ${iol_schema}.isbs_ltd.expdat is '';
comment on column ${iol_schema}.isbs_ltd.shpdat is '';
comment on column ${iol_schema}.isbs_ltd.pordis is '';
comment on column ${iol_schema}.isbs_ltd.spcrcbflg is '';
comment on column ${iol_schema}.isbs_ltd.rmbflg is '';
comment on column ${iol_schema}.isbs_ltd.amenbr is '';
comment on column ${iol_schema}.isbs_ltd.apprulrmb is '';
comment on column ${iol_schema}.isbs_ltd.utlnbr is '';
comment on column ${iol_schema}.isbs_ltd.ownusr is '';
comment on column ${iol_schema}.isbs_ltd.etyextkey is '';
comment on column ${iol_schema}.isbs_ltd.opndat is '';
comment on column ${iol_schema}.isbs_ltd.shptrss18 is '';
comment on column ${iol_schema}.isbs_ltd.cnfins is '';
comment on column ${iol_schema}.isbs_ltd.branchinr is '';
comment on column ${iol_schema}.isbs_ltd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_ltd.apprultxt is '';
comment on column ${iol_schema}.isbs_ltd.autdat is '';
comment on column ${iol_schema}.isbs_ltd.rmbact is '';
comment on column ${iol_schema}.isbs_ltd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ltd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ltd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ltd.etl_timestamp is 'ETL处理时间戳';
