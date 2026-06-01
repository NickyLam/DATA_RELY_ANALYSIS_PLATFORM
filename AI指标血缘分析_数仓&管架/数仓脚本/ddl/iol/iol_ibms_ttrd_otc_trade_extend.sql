/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_trade_extend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_trade_extend
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_trade_extend(
    extend_id number(16,0) -- 主键id
    ,trd_id number(16,0) -- 交易单id
    ,u_i_code varchar2(45) -- 标的i_code
    ,u_a_type varchar2(30) -- 标的a_type
    ,u_m_type varchar2(30) -- 标的m_type
    ,fst_set_amount number(31,4) -- 首期金额
    ,end_set_amount number(31,4) -- 到期金额
    ,fst_set_aiamount number(31,4) -- 首期总应计利息
    ,end_set_aiamount number(31,4) -- 到期总应计利息
    ,u_secu_acc_id varchar2(45) -- 标的内部证券id
    ,u_grpid varchar2(45) -- 
    ,u_secu_ext_acc_id varchar2(30) -- 外部证券账户
    ,end_set_days number(22) -- 到期交易的清算速度
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
grant select on ${iol_schema}.ibms_ttrd_otc_trade_extend to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_extend to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_extend to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade_extend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_trade_extend is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.extend_id is '主键id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.trd_id is '交易单id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_i_code is '标的i_code';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_a_type is '标的a_type';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_m_type is '标的m_type';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.fst_set_amount is '首期金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.end_set_amount is '到期金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.fst_set_aiamount is '首期总应计利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.end_set_aiamount is '到期总应计利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_secu_acc_id is '标的内部证券id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_grpid is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.u_secu_ext_acc_id is '外部证券账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.end_set_days is '到期交易的清算速度';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_otc_trade_extend.etl_timestamp is 'ETL处理时间戳';
