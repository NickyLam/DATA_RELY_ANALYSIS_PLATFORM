/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fxq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fxq
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fxq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fxq(
    opidtp varchar2(48) -- 
    ,agidno varchar2(30) -- 
    ,opbrtp varchar2(3) -- 
    ,tranad varchar2(14) -- 
    ,tranrc varchar2(14) -- 
    ,itstsq varchar2(96) -- 
    ,trninr varchar2(12) -- 
    ,pscrtx varchar2(192) -- 
    ,trandt varchar2(12) -- 
    ,opcuna varchar2(96) -- 
    ,relatp varchar2(3) -- 
    ,crcycd varchar2(5) -- 
    ,tranbr varchar2(48) -- 
    ,opcnty varchar2(48) -- 
    ,tranct varchar2(9) -- 
    ,frtran varchar2(2) -- 
    ,opbrar varchar2(14) -- 
    ,opidno varchar2(30) -- 
    ,opactp varchar2(6) -- 
    ,tranti varchar2(21) -- 
    ,opbrna varchar2(96) -- 
    ,opbrno varchar2(21) -- 
    ,tranam varchar2(38) -- 
    ,opacno varchar2(96) -- 
    ,agenna varchar2(48) -- 
    ,accttp varchar2(6) -- 
    ,acctbr varchar2(48) -- 
    ,agidtp varchar2(48) -- 
    ,custno varchar2(48) -- 
    ,agennt varchar2(5) -- 
    ,transq varchar2(96) -- 
    ,tranmt varchar2(9) -- 
    ,amntcd varchar2(3) -- 
    ,acctno varchar2(96) -- 
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
grant select on ${iol_schema}.isbs_fxq to ${iml_schema};
grant select on ${iol_schema}.isbs_fxq to ${icl_schema};
grant select on ${iol_schema}.isbs_fxq to ${idl_schema};
grant select on ${iol_schema}.isbs_fxq to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fxq is 'V_FXQ反洗钱国结接口';
comment on column ${iol_schema}.isbs_fxq.opidtp is '';
comment on column ${iol_schema}.isbs_fxq.agidno is '';
comment on column ${iol_schema}.isbs_fxq.opbrtp is '';
comment on column ${iol_schema}.isbs_fxq.tranad is '';
comment on column ${iol_schema}.isbs_fxq.tranrc is '';
comment on column ${iol_schema}.isbs_fxq.itstsq is '';
comment on column ${iol_schema}.isbs_fxq.trninr is '';
comment on column ${iol_schema}.isbs_fxq.pscrtx is '';
comment on column ${iol_schema}.isbs_fxq.trandt is '';
comment on column ${iol_schema}.isbs_fxq.opcuna is '';
comment on column ${iol_schema}.isbs_fxq.relatp is '';
comment on column ${iol_schema}.isbs_fxq.crcycd is '';
comment on column ${iol_schema}.isbs_fxq.tranbr is '';
comment on column ${iol_schema}.isbs_fxq.opcnty is '';
comment on column ${iol_schema}.isbs_fxq.tranct is '';
comment on column ${iol_schema}.isbs_fxq.frtran is '';
comment on column ${iol_schema}.isbs_fxq.opbrar is '';
comment on column ${iol_schema}.isbs_fxq.opidno is '';
comment on column ${iol_schema}.isbs_fxq.opactp is '';
comment on column ${iol_schema}.isbs_fxq.tranti is '';
comment on column ${iol_schema}.isbs_fxq.opbrna is '';
comment on column ${iol_schema}.isbs_fxq.opbrno is '';
comment on column ${iol_schema}.isbs_fxq.tranam is '';
comment on column ${iol_schema}.isbs_fxq.opacno is '';
comment on column ${iol_schema}.isbs_fxq.agenna is '';
comment on column ${iol_schema}.isbs_fxq.accttp is '';
comment on column ${iol_schema}.isbs_fxq.acctbr is '';
comment on column ${iol_schema}.isbs_fxq.agidtp is '';
comment on column ${iol_schema}.isbs_fxq.custno is '';
comment on column ${iol_schema}.isbs_fxq.agennt is '';
comment on column ${iol_schema}.isbs_fxq.transq is '';
comment on column ${iol_schema}.isbs_fxq.tranmt is '';
comment on column ${iol_schema}.isbs_fxq.amntcd is '';
comment on column ${iol_schema}.isbs_fxq.acctno is '';
comment on column ${iol_schema}.isbs_fxq.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fxq.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fxq.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fxq.etl_timestamp is 'ETL处理时间戳';
