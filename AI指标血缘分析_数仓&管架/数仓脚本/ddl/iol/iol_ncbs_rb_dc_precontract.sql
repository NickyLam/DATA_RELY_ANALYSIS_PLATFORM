/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_precontract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_precontract
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_precontract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_precontract(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,withdrawal_type varchar2(1) -- 支取方式
    ,acct_nature varchar2(10) -- 存款账户类型
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,company varchar2(20) -- 法人
    ,cycle_freq varchar2(5) -- 结息频率
    ,cycle_int_flag varchar2(1) -- 按频率付息标志
    ,email varchar2(200) -- 电子邮件
    ,int_calc_type varchar2(1) -- 计息类型
    ,issue_year varchar2(5) -- 发行年度
    ,narrative varchar2(800) -- 摘要
    ,precontract_no varchar2(50) -- 预约号
    ,precontract_status varchar2(1) -- 期次产品预约状态
    ,precontract_type varchar2(1) -- 预约登记的账户类型
    ,print_cnt number(5) -- 打印次数
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,channel varchar2(10) -- 渠道
    ,delete_date date -- 删除日期
    ,issue_end_date date -- 发行终止日期
    ,issue_start_date date -- 发行起始日期
    ,next_cycle_date date -- 下一结息日
    ,pledged_flag varchar2(1) -- 质押标志
    ,precontract_date date -- 预约登记日期
    ,precontract_open_date date -- 预约开户日期
    ,redeem_date date -- 资产赎回日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_rate number(15,8) -- 行内利率
    ,auth_user_id varchar2(8) -- 授权柜员
    ,del_auth_user_id varchar2(8) -- 删除授权柜员
    ,del_reason varchar2(200) -- 删除原因
    ,del_user_id varchar2(8) -- 删除柜员
    ,failure_reason varchar2(200) -- 失败原因
    ,float_rate number(15,8) -- 浮动利率
    ,issue_amt number(17,2) -- 期次发行金额
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,precontract_amt number(17,2) -- 预约金额
    ,precontract_branch varchar2(12) -- 预约/认购机构
    ,precontract_ccy varchar2(3) -- 期次产品预约币种
    ,real_rate number(15,8) -- 执行利率
    ,tran_amt number(17,2) -- 交易金额
    ,int_day varchar2(2) -- 存贷结息日期
    ,hang_seq_no varchar2(50) -- 挂账序列号
    ,dep_term_internal_key number(15) -- 定期一本通账户内部键
    ,acct_int_type varchar2(1) -- 计息方法
    ,subs_internal_key number(15) -- 认购账户内部键
    ,comb_prod_no varchar2(200) -- 组合产品编号
    ,charge_int_internal_key number(15) -- 收息账户内部键
    ,sub_hang_seq_no varchar2(50) -- 追加挂账子序号
    ,exp_redeem_int_amt number(17,2) -- 预计赎回利息
    ,cancel_date date -- 撤单日期|撤单日期
    ,deposit_nature varchar2(10) -- 
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
grant select on ${iol_schema}.ncbs_rb_dc_precontract to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_precontract is '大额存单登记表';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.cycle_int_flag is '按频率付息标志';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.email is '电子邮件';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.int_calc_type is '计息类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_no is '预约号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_status is '期次产品预约状态';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_type is '预约登记的账户类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.delete_date is '删除日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.issue_end_date is '发行终止日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.issue_start_date is '发行起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.pledged_flag is '质押标志';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_date is '预约登记日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_open_date is '预约开户日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.redeem_date is '资产赎回日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.del_auth_user_id is '删除授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.del_reason is '删除原因';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.del_user_id is '删除柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.issue_amt is '期次发行金额';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_amt is '预约金额';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_branch is '预约/认购机构';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.precontract_ccy is '期次产品预约币种';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.hang_seq_no is '挂账序列号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.dep_term_internal_key is '定期一本通账户内部键';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.acct_int_type is '计息方法';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.subs_internal_key is '认购账户内部键';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.comb_prod_no is '组合产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.charge_int_internal_key is '收息账户内部键';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.sub_hang_seq_no is '追加挂账子序号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.exp_redeem_int_amt is '预计赎回利息';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.cancel_date is '撤单日期|撤单日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.deposit_nature is '';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_precontract.etl_timestamp is 'ETL处理时间戳';
