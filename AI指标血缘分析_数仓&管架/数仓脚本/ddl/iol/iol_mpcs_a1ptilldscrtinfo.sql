/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ptilldscrtinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ptilldscrtinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ptilldscrtinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ptilldscrtinfo(
    transdt varchar2(12) -- 交易日期
    ,transeqno varchar2(53) -- 报文标识号
    ,no varchar2(12) -- 序号
    ,illdscrtcause varchar2(600) -- 违法失信列入事由或情形
    ,illabnmldate varchar2(12) -- 违法失信列入日期
    ,illabnmldcsnauth varchar2(384) -- 违法失信列入决定机关
    ,illrmvcause varchar2(600) -- 违法失信移出事由
    ,illrmvdate varchar2(12) -- 违法失信移出日期
    ,illrmvdcsnauth varchar2(384) -- 违法失信移出决定机关
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a1ptilldscrtinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ptilldscrtinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ptilldscrtinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ptilldscrtinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ptilldscrtinfo is '严重违法失信信息登记表';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.transeqno is '报文标识号';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.no is '序号';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illdscrtcause is '违法失信列入事由或情形';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illabnmldate is '违法失信列入日期';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illabnmldcsnauth is '违法失信列入决定机关';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illrmvcause is '违法失信移出事由';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illrmvdate is '违法失信移出日期';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.illrmvdcsnauth is '违法失信移出决定机关';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ptilldscrtinfo.etl_timestamp is 'ETL处理时间戳';
