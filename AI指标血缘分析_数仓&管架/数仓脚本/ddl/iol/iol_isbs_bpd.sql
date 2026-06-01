/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bpd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bpd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bpd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bpd(
    nam varchar2(60) -- 
    ,sndflg varchar2(2) -- 
    ,rskrat number(3,2) -- 
    ,fincod varchar2(36) -- 
    ,intday number(4,0) -- 
    ,ownusr varchar2(12) -- 
    ,pntnam varchar2(60) -- 
    ,pctfin number(5,2) -- 
    ,actyld number(12,6) -- 
    ,fpdinr varchar2(12) -- 
    ,fintyp varchar2(5) -- 
    ,pntref1 varchar2(24) -- 
    ,fianam varchar2(60) -- 
    ,intrat number(14,6) -- 
    ,liaextid varchar2(24) -- 
    ,syamt number(18,3) -- 
    ,punintrat number(12,6) -- 
    ,yjcur varchar2(5) -- 
    ,intunt date -- 
    ,finblk varchar2(600) -- 
    ,pntinr varchar2(12) -- 
    ,fidinr varchar2(12) -- 
    ,pnttyp varchar2(9) -- 
    ,credat date -- 
    ,huanxiamt number(18,3) -- 
    ,fortyp varchar2(2) -- 
    ,ovddat date -- 
    ,feeamt number(18,3) -- 
    ,kuaday number(4,0) -- 
    ,ownref varchar2(24) -- 
    ,opndat date -- 
    ,othintamt number(18,3) -- 
    ,ywcur varchar2(5) -- 
    ,sta varchar2(2) -- 
    ,grarat number(12,6) -- 
    ,marrat number(12,6) -- 
    ,totamt number(18,3) -- 
    ,fogamt number(18,3) -- 
    ,telamt number(18,3) -- 
    ,tolrat number(12,6) -- 
    ,intirt varchar2(9) -- 
    ,branchinr varchar2(12) -- 
    ,benxiamt number(18,3) -- 
    ,lctyp varchar2(2) -- 
    ,cheamt number(18,3) -- 
    ,bchkeyinr varchar2(12) -- 
    ,feetyp varchar2(2) -- 
    ,etyextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,finact varchar2(32) -- 
    ,fhftyp varchar2(2) -- 
    ,clsdat date -- 
    ,pntref varchar2(24) -- 
    ,inr varchar2(12) -- 
    ,fiaref varchar2(24) -- 
    ,rsktyp varchar2(2) -- 
    ,ovdflg varchar2(2) -- 
    ,matdat date -- 
    ,intamt number(18,3) -- 
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
grant select on ${iol_schema}.isbs_bpd to ${iml_schema};
grant select on ${iol_schema}.isbs_bpd to ${icl_schema};
grant select on ${iol_schema}.isbs_bpd to ${idl_schema};
grant select on ${iol_schema}.isbs_bpd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bpd is '出口融资业务信息(存放短字节内容)';
comment on column ${iol_schema}.isbs_bpd.nam is '';
comment on column ${iol_schema}.isbs_bpd.sndflg is '';
comment on column ${iol_schema}.isbs_bpd.rskrat is '';
comment on column ${iol_schema}.isbs_bpd.fincod is '';
comment on column ${iol_schema}.isbs_bpd.intday is '';
comment on column ${iol_schema}.isbs_bpd.ownusr is '';
comment on column ${iol_schema}.isbs_bpd.pntnam is '';
comment on column ${iol_schema}.isbs_bpd.pctfin is '';
comment on column ${iol_schema}.isbs_bpd.actyld is '';
comment on column ${iol_schema}.isbs_bpd.fpdinr is '';
comment on column ${iol_schema}.isbs_bpd.fintyp is '';
comment on column ${iol_schema}.isbs_bpd.pntref1 is '';
comment on column ${iol_schema}.isbs_bpd.fianam is '';
comment on column ${iol_schema}.isbs_bpd.intrat is '';
comment on column ${iol_schema}.isbs_bpd.liaextid is '';
comment on column ${iol_schema}.isbs_bpd.syamt is '';
comment on column ${iol_schema}.isbs_bpd.punintrat is '';
comment on column ${iol_schema}.isbs_bpd.yjcur is '';
comment on column ${iol_schema}.isbs_bpd.intunt is '';
comment on column ${iol_schema}.isbs_bpd.finblk is '';
comment on column ${iol_schema}.isbs_bpd.pntinr is '';
comment on column ${iol_schema}.isbs_bpd.fidinr is '';
comment on column ${iol_schema}.isbs_bpd.pnttyp is '';
comment on column ${iol_schema}.isbs_bpd.credat is '';
comment on column ${iol_schema}.isbs_bpd.huanxiamt is '';
comment on column ${iol_schema}.isbs_bpd.fortyp is '';
comment on column ${iol_schema}.isbs_bpd.ovddat is '';
comment on column ${iol_schema}.isbs_bpd.feeamt is '';
comment on column ${iol_schema}.isbs_bpd.kuaday is '';
comment on column ${iol_schema}.isbs_bpd.ownref is '';
comment on column ${iol_schema}.isbs_bpd.opndat is '';
comment on column ${iol_schema}.isbs_bpd.othintamt is '';
comment on column ${iol_schema}.isbs_bpd.ywcur is '';
comment on column ${iol_schema}.isbs_bpd.sta is '';
comment on column ${iol_schema}.isbs_bpd.grarat is '';
comment on column ${iol_schema}.isbs_bpd.marrat is '';
comment on column ${iol_schema}.isbs_bpd.totamt is '';
comment on column ${iol_schema}.isbs_bpd.fogamt is '';
comment on column ${iol_schema}.isbs_bpd.telamt is '';
comment on column ${iol_schema}.isbs_bpd.tolrat is '';
comment on column ${iol_schema}.isbs_bpd.intirt is '';
comment on column ${iol_schema}.isbs_bpd.branchinr is '';
comment on column ${iol_schema}.isbs_bpd.benxiamt is '';
comment on column ${iol_schema}.isbs_bpd.lctyp is '';
comment on column ${iol_schema}.isbs_bpd.cheamt is '';
comment on column ${iol_schema}.isbs_bpd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_bpd.feetyp is '';
comment on column ${iol_schema}.isbs_bpd.etyextkey is '';
comment on column ${iol_schema}.isbs_bpd.ver is '';
comment on column ${iol_schema}.isbs_bpd.finact is '';
comment on column ${iol_schema}.isbs_bpd.fhftyp is '';
comment on column ${iol_schema}.isbs_bpd.clsdat is '';
comment on column ${iol_schema}.isbs_bpd.pntref is '';
comment on column ${iol_schema}.isbs_bpd.inr is '';
comment on column ${iol_schema}.isbs_bpd.fiaref is '';
comment on column ${iol_schema}.isbs_bpd.rsktyp is '';
comment on column ${iol_schema}.isbs_bpd.ovdflg is '';
comment on column ${iol_schema}.isbs_bpd.matdat is '';
comment on column ${iol_schema}.isbs_bpd.intamt is '';
comment on column ${iol_schema}.isbs_bpd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bpd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bpd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bpd.etl_timestamp is 'ETL处理时间戳';
