/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_financial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_financial
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_financial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_financial(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_exec_name varchar2(200) -- 客户经理姓名
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,auto_extend varchar2(1) -- 是否自动延期
    ,auto_renew_rollover varchar2(1) -- 自动转存方式
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,company varchar2(20) -- 法人
    ,failure_times number(5) -- 累积失败次数
    ,fin_prod_desc varchar2(50) -- 理财产品类型描述
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,last_transfer_date date -- 上次划转日期
    ,next_transfer_date date -- 下次划转日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,failure_reason varchar2(200) -- 失败原因
    ,fin_prod_type varchar2(12) -- 理财产品编号
    ,financial_amount number(17,2) -- 理财产品金额
    ,int_min_amt number(17,2) -- 最小起存金额
    ,out_sign_branch varchar2(12) -- 解约机构
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,remain_amt number(17,2) -- 协议留存金额
    ,sign_branch varchar2(12) -- 签约机构
    ,sign_user_id varchar2(8) -- 签约柜员
    ,tda_acct_ccy varchar2(3) -- 定期账户币种
    ,tda_acct_prod_type varchar2(12) -- 定期账户产品类型
    ,tda_acct_seq_no varchar2(5) -- 定期账户序列号
    ,tda_base_acct_no varchar2(50) -- 定期账号
    ,transfer_day varchar2(2) -- 划转日
    ,transfer_freq varchar2(5) -- 划转频率
    ,deposit_nature varchar2(10) -- 核心存款性质
    ,failure_total_times number(5) -- 失败总次数
    ,unsign_reference varchar2(50) -- 解约流水
    ,fin_fixed_amt number(17,2) -- 理财固定金额
    ,sign_reference varchar2(50) -- 签约流水
    ,transfer_start_date date -- 转存起始日期
    ,transfer_freq_type varchar2(1) -- 划转频率类型
    ,last_transfer_reference varchar2(50) -- 上一转存流水
    ,transfer_end_date date -- 转存结束日期或终止日期
    ,success_times number(5) -- 累积成功次数
    ,success_total_times number(5) -- 成功总次数
    ,unsign_operate_date date -- 解约操作日期|解约操作日期
    ,retry_transfer_date date -- 重新尝试转存日重新尝试转存日
    ,limit_period_freq varchar2(5) -- 限额周期限额周期
    ,limit_max_amt number(17,2) -- 最大限额最大限额
    ,next_calc_date date -- 下一计算日期下一计算日期
    ,holding_limit number(17,2) -- 已占用额度已占用额度
    ,backup_date date -- 
    ,month_total_amount number(17,2) -- 
    ,is_auto_sign varchar2(1) -- 
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
grant select on ${iol_schema}.ncbs_rb_agreement_financial to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_financial to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_financial to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_financial to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_financial is '理财协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.term is '存期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.acct_exec_name is '客户经理姓名';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.auto_extend is '是否自动延期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.auto_renew_rollover is '自动转存方式';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.failure_times is '累积失败次数';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.fin_prod_desc is '理财产品类型描述';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.last_transfer_date is '上次划转日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.next_transfer_date is '下次划转日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.fin_prod_type is '理财产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.financial_amount is '理财产品金额';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.int_min_amt is '最小起存金额';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.out_sign_branch is '解约机构';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.remain_amt is '协议留存金额';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.sign_branch is '签约机构';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.tda_acct_ccy is '定期账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.tda_acct_prod_type is '定期账户产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.tda_acct_seq_no is '定期账户序列号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.tda_base_acct_no is '定期账号';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.transfer_day is '划转日';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.transfer_freq is '划转频率';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.deposit_nature is '核心存款性质';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.failure_total_times is '失败总次数';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.unsign_reference is '解约流水';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.fin_fixed_amt is '理财固定金额';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.sign_reference is '签约流水';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.transfer_start_date is '转存起始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.transfer_freq_type is '划转频率类型';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.last_transfer_reference is '上一转存流水';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.transfer_end_date is '转存结束日期或终止日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.success_times is '累积成功次数';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.success_total_times is '成功总次数';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.unsign_operate_date is '解约操作日期|解约操作日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.retry_transfer_date is '重新尝试转存日重新尝试转存日';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.limit_period_freq is '限额周期限额周期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.limit_max_amt is '最大限额最大限额';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.next_calc_date is '下一计算日期下一计算日期';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.holding_limit is '已占用额度已占用额度';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.backup_date is '';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.month_total_amount is '';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.is_auto_sign is '';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_financial.etl_timestamp is 'ETL处理时间戳';
