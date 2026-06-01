/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tir_series
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tir_series
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tir_series purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tir_series(
    i_code varchar2(150) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,dp_close number(31,15) -- 收盘价
    ,dp_high number(31,15) -- 最高价
    ,dp_low number(31,15) -- 最低价
    ,dp_ask number(31,15) -- 卖出价
    ,dp_bid number(31,15) -- 买入价
    ,dp_mid number(31,15) -- 中间价
    ,beg_date varchar2(15) -- 生效日期
    ,end_date varchar2(15) -- 失效日期
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 导入管道
    ,dp_bank varchar2(75) -- 数据来源
    ,imp_time varchar2(29) -- 导入时间
    ,dp_id number(22) -- 主键id
    ,source_time varchar2(29) -- 来源时间
    ,state varchar2(2) -- 行情状态，1或null：已生效，0：未生效
    ,update_user varchar2(45) -- 更新用户id，用于复核时过滤同一人不能复核自己修改的内容
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
grant select on ${iol_schema}.ibms_tir_series to ${iml_schema};
grant select on ${iol_schema}.ibms_tir_series to ${icl_schema};
grant select on ${iol_schema}.ibms_tir_series to ${idl_schema};
grant select on ${iol_schema}.ibms_tir_series to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tir_series is '利率行情表';
comment on column ${iol_schema}.ibms_tir_series.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tir_series.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tir_series.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tir_series.dp_close is '收盘价';
comment on column ${iol_schema}.ibms_tir_series.dp_high is '最高价';
comment on column ${iol_schema}.ibms_tir_series.dp_low is '最低价';
comment on column ${iol_schema}.ibms_tir_series.dp_ask is '卖出价';
comment on column ${iol_schema}.ibms_tir_series.dp_bid is '买入价';
comment on column ${iol_schema}.ibms_tir_series.dp_mid is '中间价';
comment on column ${iol_schema}.ibms_tir_series.beg_date is '生效日期';
comment on column ${iol_schema}.ibms_tir_series.end_date is '失效日期';
comment on column ${iol_schema}.ibms_tir_series.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tir_series.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tir_series.dp_bank is '数据来源';
comment on column ${iol_schema}.ibms_tir_series.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_tir_series.dp_id is '主键id';
comment on column ${iol_schema}.ibms_tir_series.source_time is '来源时间';
comment on column ${iol_schema}.ibms_tir_series.state is '行情状态，1或null：已生效，0：未生效';
comment on column ${iol_schema}.ibms_tir_series.update_user is '更新用户id，用于复核时过滤同一人不能复核自己修改的内容';
comment on column ${iol_schema}.ibms_tir_series.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_tir_series.etl_timestamp is 'ETL处理时间戳';
