/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tfudpara
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tfudpara
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tfudpara purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tfudpara(
    totalnum varchar2(15) -- 总笔数
    ,totalshare varchar2(48) -- 总份额
    ,fudcd varchar2(12) -- 基金代码
    ,rate varchar2(27) -- 七日年化收益率
    ,profit varchar2(48) -- 万分收益
    ,dzprofit varchar2(48) -- 垫资方收益
    ,trndt varchar2(12) -- 交易日期
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
grant select on ${iol_schema}.mpcs_a57tfudpara to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tfudpara to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tfudpara to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tfudpara to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tfudpara is '';
comment on column ${iol_schema}.mpcs_a57tfudpara.totalnum is '总笔数';
comment on column ${iol_schema}.mpcs_a57tfudpara.totalshare is '总份额';
comment on column ${iol_schema}.mpcs_a57tfudpara.fudcd is '基金代码';
comment on column ${iol_schema}.mpcs_a57tfudpara.rate is '七日年化收益率';
comment on column ${iol_schema}.mpcs_a57tfudpara.profit is '万分收益';
comment on column ${iol_schema}.mpcs_a57tfudpara.dzprofit is '垫资方收益';
comment on column ${iol_schema}.mpcs_a57tfudpara.trndt is '交易日期';
comment on column ${iol_schema}.mpcs_a57tfudpara.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a57tfudpara.etl_timestamp is 'ETL处理时间戳';
