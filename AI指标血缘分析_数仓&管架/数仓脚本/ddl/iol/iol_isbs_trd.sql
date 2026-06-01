/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_trd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_trd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_trd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trd(
    grarat number(12,6) -- 
    ,ovddat date -- 
    ,pntref varchar2(24) -- 
    ,spddat date -- 
    ,pctfin number(5,2) -- 
    ,nam varchar2(60) -- 
    ,ownref varchar2(24) -- 
    ,pntnam varchar2(60) -- 
    ,finact varchar2(32) -- 
    ,intrat number(14,6) -- 
    ,inr varchar2(12) -- 
    ,delflg varchar2(2) -- 
    ,actyld number(12,6) -- 
    ,ownusr varchar2(12) -- 
    ,fintyp varchar2(5) -- 
    ,ver varchar2(6) -- 
    ,pnttyp varchar2(9) -- 
    ,stagod varchar2(9) -- 
    ,lstintdat date -- 
    ,stacty varchar2(3) -- 
    ,clsdat date -- 
    ,feetyp varchar2(2) -- 
    ,issdat date -- 
    ,restcur varchar2(5) -- 
    ,actrat number(12,6) -- 
    ,credat date -- 
    ,feeamt number(18,3) -- 
    ,itfblk varchar2(1202) -- 
    ,matdat date -- 
    ,opndat date -- 
    ,finblk varchar2(300) -- 
    ,etyextkey varchar2(12) -- 
    ,dftype varchar2(30) -- 
    ,bchkeyinr varchar2(12) -- 
    ,branchinr varchar2(12) -- 
    ,guaflg varchar2(2) -- 
    ,dfrate number(12,6) -- 
    ,restamt number(18,3) -- 
    ,pntinr varchar2(12) -- 
    ,tenday number(3,0) -- 
    ,stttendat date -- 
    ,marrat number(12,6) -- 
    ,irtcod varchar2(9) -- 
    ,extnmb number(4,0) -- 
    ,ovdflg varchar2(2) -- 
    ,actfinday number(5,0) -- 
    ,fincod varchar2(36) -- 
    ,subtyp varchar2(3) -- 
    ,intsetway varchar2(2) -- 
    ,ratadj varchar2(2) -- 
    ,totalamt number(18,3) -- 
    ,acthkdat date -- 
    ,dfint number(18,3) -- 
    ,dfdelrate number(12,6) -- 
    ,dffee number(18,3) -- 
    ,iflastcol varchar2(2) -- 
    ,irtmic varchar2(5) -- 
    ,hangno varchar2(60) -- 
    ,fkqrref varchar2(24) -- 
    ,conno varchar2(45) -- 
    ,jjpph varchar2(45) -- 
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
grant select on ${iol_schema}.isbs_trd to ${iml_schema};
grant select on ${iol_schema}.isbs_trd to ${icl_schema};
grant select on ${iol_schema}.isbs_trd to ${idl_schema};
grant select on ${iol_schema}.isbs_trd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_trd is '进口融资业务信息(保存短字节)';
comment on column ${iol_schema}.isbs_trd.grarat is '';
comment on column ${iol_schema}.isbs_trd.ovddat is '';
comment on column ${iol_schema}.isbs_trd.pntref is '';
comment on column ${iol_schema}.isbs_trd.spddat is '';
comment on column ${iol_schema}.isbs_trd.pctfin is '';
comment on column ${iol_schema}.isbs_trd.nam is '';
comment on column ${iol_schema}.isbs_trd.ownref is '';
comment on column ${iol_schema}.isbs_trd.pntnam is '';
comment on column ${iol_schema}.isbs_trd.finact is '';
comment on column ${iol_schema}.isbs_trd.intrat is '';
comment on column ${iol_schema}.isbs_trd.inr is '';
comment on column ${iol_schema}.isbs_trd.delflg is '';
comment on column ${iol_schema}.isbs_trd.actyld is '';
comment on column ${iol_schema}.isbs_trd.ownusr is '';
comment on column ${iol_schema}.isbs_trd.fintyp is '';
comment on column ${iol_schema}.isbs_trd.ver is '';
comment on column ${iol_schema}.isbs_trd.pnttyp is '';
comment on column ${iol_schema}.isbs_trd.stagod is '';
comment on column ${iol_schema}.isbs_trd.lstintdat is '';
comment on column ${iol_schema}.isbs_trd.stacty is '';
comment on column ${iol_schema}.isbs_trd.clsdat is '';
comment on column ${iol_schema}.isbs_trd.feetyp is '';
comment on column ${iol_schema}.isbs_trd.issdat is '';
comment on column ${iol_schema}.isbs_trd.restcur is '';
comment on column ${iol_schema}.isbs_trd.actrat is '';
comment on column ${iol_schema}.isbs_trd.credat is '';
comment on column ${iol_schema}.isbs_trd.feeamt is '';
comment on column ${iol_schema}.isbs_trd.itfblk is '';
comment on column ${iol_schema}.isbs_trd.matdat is '';
comment on column ${iol_schema}.isbs_trd.opndat is '';
comment on column ${iol_schema}.isbs_trd.finblk is '';
comment on column ${iol_schema}.isbs_trd.etyextkey is '';
comment on column ${iol_schema}.isbs_trd.dftype is '';
comment on column ${iol_schema}.isbs_trd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_trd.branchinr is '';
comment on column ${iol_schema}.isbs_trd.guaflg is '';
comment on column ${iol_schema}.isbs_trd.dfrate is '';
comment on column ${iol_schema}.isbs_trd.restamt is '';
comment on column ${iol_schema}.isbs_trd.pntinr is '';
comment on column ${iol_schema}.isbs_trd.tenday is '';
comment on column ${iol_schema}.isbs_trd.stttendat is '';
comment on column ${iol_schema}.isbs_trd.marrat is '';
comment on column ${iol_schema}.isbs_trd.irtcod is '';
comment on column ${iol_schema}.isbs_trd.extnmb is '';
comment on column ${iol_schema}.isbs_trd.ovdflg is '';
comment on column ${iol_schema}.isbs_trd.actfinday is '';
comment on column ${iol_schema}.isbs_trd.fincod is '';
comment on column ${iol_schema}.isbs_trd.subtyp is '';
comment on column ${iol_schema}.isbs_trd.intsetway is '';
comment on column ${iol_schema}.isbs_trd.ratadj is '';
comment on column ${iol_schema}.isbs_trd.totalamt is '';
comment on column ${iol_schema}.isbs_trd.acthkdat is '';
comment on column ${iol_schema}.isbs_trd.dfint is '';
comment on column ${iol_schema}.isbs_trd.dfdelrate is '';
comment on column ${iol_schema}.isbs_trd.dffee is '';
comment on column ${iol_schema}.isbs_trd.iflastcol is '';
comment on column ${iol_schema}.isbs_trd.irtmic is '';
comment on column ${iol_schema}.isbs_trd.hangno is '';
comment on column ${iol_schema}.isbs_trd.fkqrref is '';
comment on column ${iol_schema}.isbs_trd.conno is '';
comment on column ${iol_schema}.isbs_trd.jjpph is '';
comment on column ${iol_schema}.isbs_trd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_trd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_trd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_trd.etl_timestamp is 'ETL处理时间戳';
