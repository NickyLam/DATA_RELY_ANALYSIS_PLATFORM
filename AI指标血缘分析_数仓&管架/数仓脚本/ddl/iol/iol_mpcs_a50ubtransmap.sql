/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubtransmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubtransmap
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubtransmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubtransmap(
    paraid number(8,0) -- 
    ,msgtype varchar2(8) -- 消息类型
    ,procecode varchar2(9) -- 银联交易处理码
    ,exprocode varchar2(3) -- 服务点条件码
    ,transcode varchar2(9) -- 交易码
    ,transname varchar2(60) -- 交易名称
    ,addrflag varchar2(2) -- 
    ,revflag varchar2(2) -- 
    ,timeout number(8,0) -- 超时时间
    ,resflag nvarchar2(4) -- 
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
grant select on ${iol_schema}.mpcs_a50ubtransmap to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubtransmap to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubtransmap to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubtransmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubtransmap is '银联交易码映射表';
comment on column ${iol_schema}.mpcs_a50ubtransmap.paraid is '';
comment on column ${iol_schema}.mpcs_a50ubtransmap.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a50ubtransmap.procecode is '银联交易处理码';
comment on column ${iol_schema}.mpcs_a50ubtransmap.exprocode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a50ubtransmap.transcode is '交易码';
comment on column ${iol_schema}.mpcs_a50ubtransmap.transname is '交易名称';
comment on column ${iol_schema}.mpcs_a50ubtransmap.addrflag is '';
comment on column ${iol_schema}.mpcs_a50ubtransmap.revflag is '';
comment on column ${iol_schema}.mpcs_a50ubtransmap.timeout is '超时时间';
comment on column ${iol_schema}.mpcs_a50ubtransmap.resflag is '';
comment on column ${iol_schema}.mpcs_a50ubtransmap.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a50ubtransmap.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a50ubtransmap.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a50ubtransmap.etl_timestamp is 'ETL处理时间戳';
