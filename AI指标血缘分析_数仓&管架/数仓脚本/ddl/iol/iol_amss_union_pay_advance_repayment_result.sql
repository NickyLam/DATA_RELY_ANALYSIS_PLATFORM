/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_union_pay_advance_repayment_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_union_pay_advance_repayment_result
whenever sqlerror continue none;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_advance_repayment_result(
    id varchar2(32) -- 主键
    ,trade_date timestamp -- 交易日期
    ,fund_id varchar2(32) -- 商户编号
    ,fund_name varchar2(256) -- 商户名称
    ,org_id varchar2(32) -- 所属分行机构号
    ,org_name varchar2(64) -- 所属分行机构名称
    ,mer_limit number(20,2) -- 商户额度
    ,sucess_amt number(20,2) -- 当天成功金额
    ,un_amt number(20,2) -- 当天未明金额
    ,balance_limt number(20,2) -- 剩余额度
    ,repayment_amt number(20,2) -- 已还款金额
    ,physics_flag number(1,0) -- 物理标识 1-正常 2-删除
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,create_emp varchar2(32) -- 创建人
    ,update_emp varchar2(32) -- 更新人
    ,clean_state number(1,0) -- 清分状态：0-未清分 1-清分中 2-已清分
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
grant select on ${iol_schema}.amss_union_pay_advance_repayment_result to ${iml_schema};
grant select on ${iol_schema}.amss_union_pay_advance_repayment_result to ${icl_schema};
grant select on ${iol_schema}.amss_union_pay_advance_repayment_result to ${idl_schema};
grant select on ${iol_schema}.amss_union_pay_advance_repayment_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_union_pay_advance_repayment_result is '垫资还款表';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.id is '主键';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.trade_date is '交易日期';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.fund_id is '商户编号';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.fund_name is '商户名称';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.org_id is '所属分行机构号';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.org_name is '所属分行机构名称';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.mer_limit is '商户额度';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.sucess_amt is '当天成功金额';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.un_amt is '当天未明金额';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.balance_limt is '剩余额度';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.repayment_amt is '已还款金额';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.physics_flag is '物理标识 1-正常 2-删除';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.create_time is '创建时间';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.update_time is '更新时间';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.create_emp is '创建人';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.update_emp is '更新人';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.clean_state is '清分状态：0-未清分 1-清分中 2-已清分';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.start_dt is '开始时间';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.end_dt is '结束时间';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.id_mark is '增删标志';
comment on column ${iol_schema}.amss_union_pay_advance_repayment_result.etl_timestamp is 'ETL处理时间戳';
