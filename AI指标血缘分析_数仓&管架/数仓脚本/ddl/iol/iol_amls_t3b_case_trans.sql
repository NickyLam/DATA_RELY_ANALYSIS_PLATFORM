/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_case_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_case_trans
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_case_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_case_trans(
    case_id varchar2(96) -- 案例编号
    ,stat_dt date -- 数据日期
    ,tr_id varchar2(96) -- 业务标识号
    ,fetr_id varchar2(450) -- 可疑特征编号
    ,cust_id varchar2(48) -- 客户编号
    ,acct_id varchar2(96) -- 账户编号
    ,tr_dt date -- 交易日期
    ,is_del varchar2(2) -- 是否排除
    ,advice varchar2(4000) -- 处理意见
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,is_rpt varchar2(2) -- 周期内是否上包过人行：0否；1是
    ,is_ctrl varchar2(2) -- 默认控制补录：0否；1是
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
grant select on ${iol_schema}.amls_t3b_case_trans to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_case_trans to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_case_trans to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_case_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_case_trans is 't3b_可疑历史案例交易关系表';
comment on column ${iol_schema}.amls_t3b_case_trans.case_id is '案例编号';
comment on column ${iol_schema}.amls_t3b_case_trans.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_case_trans.tr_id is '业务标识号';
comment on column ${iol_schema}.amls_t3b_case_trans.fetr_id is '可疑特征编号';
comment on column ${iol_schema}.amls_t3b_case_trans.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t3b_case_trans.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t3b_case_trans.tr_dt is '交易日期';
comment on column ${iol_schema}.amls_t3b_case_trans.is_del is '是否排除';
comment on column ${iol_schema}.amls_t3b_case_trans.advice is '处理意见';
comment on column ${iol_schema}.amls_t3b_case_trans.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t3b_case_trans.modifier is '修改人';
comment on column ${iol_schema}.amls_t3b_case_trans.is_rpt is '周期内是否上包过人行：0否；1是';
comment on column ${iol_schema}.amls_t3b_case_trans.is_ctrl is '默认控制补录：0否；1是';
comment on column ${iol_schema}.amls_t3b_case_trans.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_case_trans.etl_timestamp is 'ETL处理时间戳';
