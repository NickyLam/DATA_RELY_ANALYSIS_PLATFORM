/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_case_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_case_cust
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_case_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_case_cust(
    case_id varchar2(96) -- 案例编号
    ,stat_dt date -- 数据日期
    ,cust_id varchar2(48) -- 客户编号
    ,fetr_ids varchar2(1500) -- 可疑特征编号
    ,rcv_cny_amt number(30,4) -- 折人民币收款金额
    ,rcv_usd_amt number(30,4) -- 折美元收款金额
    ,rcv_cnt number(22,0) -- 收款笔数
    ,pay_cny_amt number(30,4) -- 折人民币付款金额
    ,pay_usd_amt number(30,4) -- 折美元付款金额
    ,pay_cnt number(22,0) -- 付款笔数
    ,is_del varchar2(2) -- 是否排除
    ,advice varchar2(4000) -- 处理意见
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
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
grant select on ${iol_schema}.amls_t3b_case_cust to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_case_cust to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_case_cust to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_case_cust to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_case_cust is 't3b_可疑案例客户关系表';
comment on column ${iol_schema}.amls_t3b_case_cust.case_id is '案例编号';
comment on column ${iol_schema}.amls_t3b_case_cust.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_case_cust.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t3b_case_cust.fetr_ids is '可疑特征编号';
comment on column ${iol_schema}.amls_t3b_case_cust.rcv_cny_amt is '折人民币收款金额';
comment on column ${iol_schema}.amls_t3b_case_cust.rcv_usd_amt is '折美元收款金额';
comment on column ${iol_schema}.amls_t3b_case_cust.rcv_cnt is '收款笔数';
comment on column ${iol_schema}.amls_t3b_case_cust.pay_cny_amt is '折人民币付款金额';
comment on column ${iol_schema}.amls_t3b_case_cust.pay_usd_amt is '折美元付款金额';
comment on column ${iol_schema}.amls_t3b_case_cust.pay_cnt is '付款笔数';
comment on column ${iol_schema}.amls_t3b_case_cust.is_del is '是否排除';
comment on column ${iol_schema}.amls_t3b_case_cust.advice is '处理意见';
comment on column ${iol_schema}.amls_t3b_case_cust.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t3b_case_cust.modifier is '修改人';
comment on column ${iol_schema}.amls_t3b_case_cust.is_ctrl is '默认控制补录：0否；1是';
comment on column ${iol_schema}.amls_t3b_case_cust.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_case_cust.etl_timestamp is 'ETL处理时间戳';
