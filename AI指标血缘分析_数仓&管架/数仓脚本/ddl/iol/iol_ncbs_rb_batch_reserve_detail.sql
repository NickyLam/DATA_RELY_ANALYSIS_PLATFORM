/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_reserve_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_reserve_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_reserve_detail(
    acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,restraint_type varchar2(3) -- 限制类型
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,available_amt number(17,2) -- 可用余额
    ,pledged_amt number(17,2) -- 限制金额
    ,sub_acct_seq_no varchar2(5) -- 子账户序号
    ,ext_ref_no varchar2(50) -- 来单编号
    ,pay_out_amt number(17,2) -- 备款扣划金额
    ,pay_out_status varchar2(3) -- 扣款状态
    ,actual_pay_out_amt number(17,2) -- 实际扣划金额
    ,close_acct_flag varchar2(1) -- 是否可销户
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
grant select on ${iol_schema}.ncbs_rb_batch_reserve_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_reserve_detail is '备款明细信息表';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.available_amt is '可用余额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.pledged_amt is '限制金额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.sub_acct_seq_no is '子账户序号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.ext_ref_no is '来单编号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.pay_out_amt is '备款扣划金额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.pay_out_status is '扣款状态';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.actual_pay_out_amt is '实际扣划金额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.close_acct_flag is '是否可销户';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_detail.etl_timestamp is 'ETL处理时间戳';
