/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bmt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bmt(
    inr varchar2(12) -- 
    ,docdis varchar2(4000) -- 
    ,docins varchar2(270) -- 
    ,prsdoc varchar2(4000) -- 
    ,disdoc varchar2(162) -- 
    ,benins varchar2(990) -- 
    ,matper varchar2(198) -- 
    ,intdis varchar2(1980) -- 
    ,comcon varchar2(1980) -- 
    ,fldmodblk varchar2(4000) -- 
    ,chaadd varchar2(324) -- 
    ,chaded varchar2(324) -- 
    ,nartxt77a varchar2(1080) -- 
    ,contag72 varchar2(4000) -- 
    ,contag79 varchar2(4000) -- 
    ,docdisflg varchar2(2) -- 
    ,docdisdef varchar2(4000) -- 
    ,setinsbe varchar2(1980) -- 
    ,benref varchar2(255) -- 
    ,ctrstm varchar2(4000) -- 
    ,sndrmk varchar2(4000) -- 寄单索款修改备注
    ,accrmk varchar2(1530) -- 到期付款确认备注
    ,dcrrmk varchar2(615) -- 拒付备注
    ,setrmk varchar2(612) -- 付款备注
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
grant select on ${iol_schema}.isbs_bmt to ${iml_schema};
grant select on ${iol_schema}.isbs_bmt to ${icl_schema};
grant select on ${iol_schema}.isbs_bmt to ${idl_schema};
grant select on ${iol_schema}.isbs_bmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bmt is '国内证卖方信用证下单据业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_bmt.inr is '';
comment on column ${iol_schema}.isbs_bmt.docdis is '';
comment on column ${iol_schema}.isbs_bmt.docins is '';
comment on column ${iol_schema}.isbs_bmt.prsdoc is '';
comment on column ${iol_schema}.isbs_bmt.disdoc is '';
comment on column ${iol_schema}.isbs_bmt.benins is '';
comment on column ${iol_schema}.isbs_bmt.matper is '';
comment on column ${iol_schema}.isbs_bmt.intdis is '';
comment on column ${iol_schema}.isbs_bmt.comcon is '';
comment on column ${iol_schema}.isbs_bmt.fldmodblk is '';
comment on column ${iol_schema}.isbs_bmt.chaadd is '';
comment on column ${iol_schema}.isbs_bmt.chaded is '';
comment on column ${iol_schema}.isbs_bmt.nartxt77a is '';
comment on column ${iol_schema}.isbs_bmt.contag72 is '';
comment on column ${iol_schema}.isbs_bmt.contag79 is '';
comment on column ${iol_schema}.isbs_bmt.docdisflg is '';
comment on column ${iol_schema}.isbs_bmt.docdisdef is '';
comment on column ${iol_schema}.isbs_bmt.setinsbe is '';
comment on column ${iol_schema}.isbs_bmt.benref is '';
comment on column ${iol_schema}.isbs_bmt.ctrstm is '';
comment on column ${iol_schema}.isbs_bmt.sndrmk is '寄单索款修改备注';
comment on column ${iol_schema}.isbs_bmt.accrmk is '到期付款确认备注';
comment on column ${iol_schema}.isbs_bmt.dcrrmk is '拒付备注';
comment on column ${iol_schema}.isbs_bmt.setrmk is '付款备注';
comment on column ${iol_schema}.isbs_bmt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bmt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bmt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bmt.etl_timestamp is 'ETL处理时间戳';
