/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vi_security_profit_loss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vi_security_profit_loss
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vi_security_profit_loss purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vi_security_profit_loss(
    keepfolder_id number(22,0) -- 账户id
    ,keepfolder_name varchar2(75) -- 账户名字
    ,settledate varchar2(12) -- 评估日期
    ,security_id varchar2(24) -- 债券代码
    ,security_name varchar2(192) -- 债券名称
    ,security_type varchar2(5) -- 债券类别
    ,currency varchar2(5) -- 币种
    ,last_qty number -- 券面总额
    ,cdc_price number -- 市场净价
    ,market_price_type varchar2(150) -- 市场净价类型
    ,market_value number -- 净价市值
    ,dirty_price number -- 市场全价
    ,dirty_market_value number -- 全价市值
    ,convexity number -- 凸性
    ,duration number -- 久期
    ,m_duration number -- 修正久期
    ,pvbp number -- pvbp
    ,term_to_maturity number -- 待偿期
    ,var number -- var值
    ,last_modified timestamp -- 最后修改时间
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
grant select on ${iol_schema}.ctms_tbs_vi_security_profit_loss to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vi_security_profit_loss to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vi_security_profit_loss to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vi_security_profit_loss to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vi_security_profit_loss is '债券收益风险评估数据视图';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.keepfolder_id is '账户id';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.keepfolder_name is '账户名字';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.settledate is '评估日期';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.security_id is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.security_name is '债券名称';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.security_type is '债券类别';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.currency is '币种';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.last_qty is '券面总额';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.cdc_price is '市场净价';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.market_price_type is '市场净价类型';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.market_value is '净价市值';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.dirty_price is '市场全价';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.dirty_market_value is '全价市值';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.convexity is '凸性';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.duration is '久期';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.m_duration is '修正久期';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.pvbp is 'pvbp';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.term_to_maturity is '待偿期';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.var is 'var值';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.last_modified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_vi_security_profit_loss.etl_timestamp is 'ETL处理时间戳';
