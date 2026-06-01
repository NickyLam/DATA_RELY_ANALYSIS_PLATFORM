/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_trade_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_trade_type
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_trade_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_trade_type(
    trd_type varchar2(15) -- 交易类型
    ,description varchar2(150) -- 交易类型描述
    ,isperiod_inst varchar2(2) -- 是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令
    ,ordernum number(31,6) -- 排序序号
    ,word_template_code varchar2(75) -- word打印模板要素(选填)(审批单)
    ,batch_word_template_code varchar2(75) -- 批量word打印模板要素(选填)(审批单)
    ,word_template_code_trade varchar2(75) -- word打印模板要素(选填)(交易单)
    ,batch_word_template_code_trade varchar2(75) -- 批量word打印模板要素(选填)(交易单)
    ,need_access number(22) -- 是否需要准入 0：不需要（默认）1：需要
    ,need_credit_risk number(22) -- 是否需要信用风险审查 0：不需要（默认）1：需要
    ,need_bond_access varchar2(2) -- 是否需要校验准入库 0-否；1-是；
    ,parent_id varchar2(24) -- 父id
    ,leaf number(1,0) -- 是否叶子节点
    ,need_sppi_check varchar2(2) -- 是否允许sppi测试 0不允许1允许
    ,need_bw_list varchar2(2) -- 是否黑白名单控制 1:是 0:否
    ,def_transfer_type number(22,0) -- 
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
grant select on ${iol_schema}.ibms_ttrd_trade_type to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_trade_type to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_trade_type to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_trade_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_trade_type is '交易类型表';
comment on column ${iol_schema}.ibms_ttrd_trade_type.trd_type is '交易类型';
comment on column ${iol_schema}.ibms_ttrd_trade_type.description is '交易类型描述';
comment on column ${iol_schema}.ibms_ttrd_trade_type.isperiod_inst is '是否是周期指令 0：首期指令 1 :周期指令 2:存续期交易指令 3:存续期非交易指令';
comment on column ${iol_schema}.ibms_ttrd_trade_type.ordernum is '排序序号';
comment on column ${iol_schema}.ibms_ttrd_trade_type.word_template_code is 'word打印模板要素(选填)(审批单)';
comment on column ${iol_schema}.ibms_ttrd_trade_type.batch_word_template_code is '批量word打印模板要素(选填)(审批单)';
comment on column ${iol_schema}.ibms_ttrd_trade_type.word_template_code_trade is 'word打印模板要素(选填)(交易单)';
comment on column ${iol_schema}.ibms_ttrd_trade_type.batch_word_template_code_trade is '批量word打印模板要素(选填)(交易单)';
comment on column ${iol_schema}.ibms_ttrd_trade_type.need_access is '是否需要准入 0：不需要（默认）1：需要';
comment on column ${iol_schema}.ibms_ttrd_trade_type.need_credit_risk is '是否需要信用风险审查 0：不需要（默认）1：需要';
comment on column ${iol_schema}.ibms_ttrd_trade_type.need_bond_access is '是否需要校验准入库 0-否；1-是；';
comment on column ${iol_schema}.ibms_ttrd_trade_type.parent_id is '父id';
comment on column ${iol_schema}.ibms_ttrd_trade_type.leaf is '是否叶子节点';
comment on column ${iol_schema}.ibms_ttrd_trade_type.need_sppi_check is '是否允许sppi测试 0不允许1允许';
comment on column ${iol_schema}.ibms_ttrd_trade_type.need_bw_list is '是否黑白名单控制 1:是 0:否';
comment on column ${iol_schema}.ibms_ttrd_trade_type.def_transfer_type is '';
comment on column ${iol_schema}.ibms_ttrd_trade_type.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_trade_type.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_trade_type.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_trade_type.etl_timestamp is 'ETL处理时间戳';
