/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_doss_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_doss_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_doss_acct(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_type varchar2(1) -- 账户类型
    ,balance number(17,2) -- 余额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,import_type varchar2(1) -- 导入类型
    ,individual_flag varchar2(1) -- 对公对私标志
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,doss_date date -- 转久悬日期
    ,out_date date -- 出库日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,int_amt number(17,2) -- 利息金额
    ,por_int_tot number(17,2) -- 本息合计
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
grant select on ${iol_schema}.ncbs_rb_batch_doss_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_doss_acct is '久悬户批量导入明细表';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.import_type is '导入类型';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.doss_date is '转久悬日期';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.out_date is '出库日期';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.por_int_tot is '本息合计';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_doss_acct.etl_timestamp is 'ETL处理时间戳';
