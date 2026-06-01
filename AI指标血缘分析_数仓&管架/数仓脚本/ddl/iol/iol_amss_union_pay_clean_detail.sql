/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_union_pay_clean_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_union_pay_clean_detail
whenever sqlerror continue none;
drop table ${iol_schema}.amss_union_pay_clean_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_clean_detail(
    id varchar2(32) -- 主键ID
    ,batch_no varchar2(128) -- 批次号
    ,fund_id varchar2(128) -- 
    ,clean_date timestamp -- 划账日期
    ,clean_result varchar2(128) -- 划账结果 0-未划账 1-划账成功 2-划账失败
    ,payer_acct varchar2(32) -- 付款账户
    ,payer_acct_name varchar2(256) -- 付款账户名
    ,payer_acct_type varchar2(32) -- 付款账户类型
    ,payer_bank_no varchar2(32) -- 付款账户开户行号
    ,payer_bank_name varchar2(256) -- 付款账户开户行名称
    ,payee_acct varchar2(32) -- 收款账户
    ,payee_acct_name varchar2(256) -- 收款账户名
    ,payee_acct_type varchar2(32) -- 收款账户类型
    ,clean_amt number(20,2) -- 应划账金额
    ,actual_amt number(20,2) -- 实际划账金额
    ,resp_msg varchar2(256) -- 失败原因
    ,physics_flag number(1,0) -- 物理标识，默认1正常，2删除
    ,create_time timestamp -- 创建时间
    ,create_emp varchar2(128) -- 创建者
    ,update_time timestamp -- 更新时间
    ,update_emp varchar2(128) -- 更新者
    ,channel_id varchar2(128) -- 所属机构ID
    ,org_id varchar2(128) -- 柜台机构ID
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
grant select on ${iol_schema}.amss_union_pay_clean_detail to ${iml_schema};
grant select on ${iol_schema}.amss_union_pay_clean_detail to ${icl_schema};
grant select on ${iol_schema}.amss_union_pay_clean_detail to ${idl_schema};
grant select on ${iol_schema}.amss_union_pay_clean_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_union_pay_clean_detail is '日终划账结果表';
comment on column ${iol_schema}.amss_union_pay_clean_detail.id is '主键ID';
comment on column ${iol_schema}.amss_union_pay_clean_detail.batch_no is '批次号';
comment on column ${iol_schema}.amss_union_pay_clean_detail.fund_id is '';
comment on column ${iol_schema}.amss_union_pay_clean_detail.clean_date is '划账日期';
comment on column ${iol_schema}.amss_union_pay_clean_detail.clean_result is '划账结果 0-未划账 1-划账成功 2-划账失败';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payer_acct is '付款账户';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payer_acct_name is '付款账户名';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payer_acct_type is '付款账户类型';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payer_bank_no is '付款账户开户行号';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payer_bank_name is '付款账户开户行名称';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payee_acct is '收款账户';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payee_acct_name is '收款账户名';
comment on column ${iol_schema}.amss_union_pay_clean_detail.payee_acct_type is '收款账户类型';
comment on column ${iol_schema}.amss_union_pay_clean_detail.clean_amt is '应划账金额';
comment on column ${iol_schema}.amss_union_pay_clean_detail.actual_amt is '实际划账金额';
comment on column ${iol_schema}.amss_union_pay_clean_detail.resp_msg is '失败原因';
comment on column ${iol_schema}.amss_union_pay_clean_detail.physics_flag is '物理标识，默认1正常，2删除';
comment on column ${iol_schema}.amss_union_pay_clean_detail.create_time is '创建时间';
comment on column ${iol_schema}.amss_union_pay_clean_detail.create_emp is '创建者';
comment on column ${iol_schema}.amss_union_pay_clean_detail.update_time is '更新时间';
comment on column ${iol_schema}.amss_union_pay_clean_detail.update_emp is '更新者';
comment on column ${iol_schema}.amss_union_pay_clean_detail.channel_id is '所属机构ID';
comment on column ${iol_schema}.amss_union_pay_clean_detail.org_id is '柜台机构ID';
comment on column ${iol_schema}.amss_union_pay_clean_detail.start_dt is '开始时间';
comment on column ${iol_schema}.amss_union_pay_clean_detail.end_dt is '结束时间';
comment on column ${iol_schema}.amss_union_pay_clean_detail.id_mark is '增删标志';
comment on column ${iol_schema}.amss_union_pay_clean_detail.etl_timestamp is 'ETL处理时间戳';
