/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bdt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bdt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bdt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bdt(
    inr varchar2(12) -- 
    ,docdis varchar2(4000) -- 
    ,docins varchar2(270) -- 
    ,prsdoc varchar2(4000) -- 
    ,disdoc varchar2(162) -- 
    ,aplins varchar2(615) -- 
    ,matper varchar2(198) -- 
    ,comcon varchar2(2970) -- 
    ,setinsbr varchar2(594) -- 
    ,roggod varchar2(2460) -- 
    ,pordis varchar2(60) -- 
    ,delplc varchar2(60) -- 
    ,vesnam varchar2(60) -- 
    ,relstoadr varchar2(216) -- 
    ,chaded varchar2(324) -- 
    ,chaadd varchar2(324) -- 
    ,fldmodblk varchar2(4000) -- 
    ,nartxt77a varchar2(1080) -- 
    ,contag72 varchar2(4000) -- 
    ,contag79 varchar2(4000) -- 
    ,docdisdef varchar2(4000) -- 
    ,docdisflg varchar2(2) -- 
    ,disdocdef varchar2(162) -- 
    ,disdocflg varchar2(2) -- 
    ,porlod varchar2(60) -- 
    ,notpty varchar2(540) -- 
    ,voynum varchar2(45) -- 
    ,carnam varchar2(53) -- 
    ,ctrstm varchar2(4000) -- 
    ,sndrmk varchar2(4000) -- 寄单索款修改备注
    ,accrmk varchar2(1530) -- 到期付款确认备注
    ,dcrrmk varchar2(612) -- 拒付备注
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
grant select on ${iol_schema}.isbs_bdt to ${iml_schema};
grant select on ${iol_schema}.isbs_bdt to ${icl_schema};
grant select on ${iol_schema}.isbs_bdt to ${idl_schema};
grant select on ${iol_schema}.isbs_bdt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bdt is '国内证买方信用证下单据业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_bdt.inr is '';
comment on column ${iol_schema}.isbs_bdt.docdis is '';
comment on column ${iol_schema}.isbs_bdt.docins is '';
comment on column ${iol_schema}.isbs_bdt.prsdoc is '';
comment on column ${iol_schema}.isbs_bdt.disdoc is '';
comment on column ${iol_schema}.isbs_bdt.aplins is '';
comment on column ${iol_schema}.isbs_bdt.matper is '';
comment on column ${iol_schema}.isbs_bdt.comcon is '';
comment on column ${iol_schema}.isbs_bdt.setinsbr is '';
comment on column ${iol_schema}.isbs_bdt.roggod is '';
comment on column ${iol_schema}.isbs_bdt.pordis is '';
comment on column ${iol_schema}.isbs_bdt.delplc is '';
comment on column ${iol_schema}.isbs_bdt.vesnam is '';
comment on column ${iol_schema}.isbs_bdt.relstoadr is '';
comment on column ${iol_schema}.isbs_bdt.chaded is '';
comment on column ${iol_schema}.isbs_bdt.chaadd is '';
comment on column ${iol_schema}.isbs_bdt.fldmodblk is '';
comment on column ${iol_schema}.isbs_bdt.nartxt77a is '';
comment on column ${iol_schema}.isbs_bdt.contag72 is '';
comment on column ${iol_schema}.isbs_bdt.contag79 is '';
comment on column ${iol_schema}.isbs_bdt.docdisdef is '';
comment on column ${iol_schema}.isbs_bdt.docdisflg is '';
comment on column ${iol_schema}.isbs_bdt.disdocdef is '';
comment on column ${iol_schema}.isbs_bdt.disdocflg is '';
comment on column ${iol_schema}.isbs_bdt.porlod is '';
comment on column ${iol_schema}.isbs_bdt.notpty is '';
comment on column ${iol_schema}.isbs_bdt.voynum is '';
comment on column ${iol_schema}.isbs_bdt.carnam is '';
comment on column ${iol_schema}.isbs_bdt.ctrstm is '';
comment on column ${iol_schema}.isbs_bdt.sndrmk is '寄单索款修改备注';
comment on column ${iol_schema}.isbs_bdt.accrmk is '到期付款确认备注';
comment on column ${iol_schema}.isbs_bdt.dcrrmk is '拒付备注';
comment on column ${iol_schema}.isbs_bdt.setrmk is '付款备注';
comment on column ${iol_schema}.isbs_bdt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bdt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bdt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bdt.etl_timestamp is 'ETL处理时间戳';
