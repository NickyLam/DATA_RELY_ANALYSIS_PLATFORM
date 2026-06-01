/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_plan
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_plan(
    org varchar2(18) -- 机构号
    ,plan_id number(20,0) -- 流水号
    ,acct_no number(20,0) -- 账户编号
    ,acct_type varchar2(2) -- 账户类型
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,plan_nbr varchar2(9) -- 信用计划号
    ,plan_type varchar2(2) -- 信用计划类型
    ,product_cd varchar2(9) -- 产品代码
    ,ref_nbr varchar2(35) -- 交易参考号
    ,curr_bal number(15,2) -- 当前余额
    ,begin_bal number(15,2) -- 期初余额
    ,dispute_amt number(15,2) -- 争议金额
    ,tot_due_amt number(15,2) -- 最小还款额
    ,plan_add_date date -- 记录建立日期
    ,paid_out_date date -- 还清日期
    ,past_principal number(15,2) -- 上期本金
    ,past_interest number(15,2) -- 上期利息
    ,past_card_fee number(15,2) -- 上期年费
    ,past_ovrlmt_fee number(15,2) -- 上期超限费
    ,past_lpc number(15,2) -- 上期滞纳金
    ,past_nsf_fee number(15,2) -- 上期资金不足费
    ,past_txn_fee number(15,2) -- 上期交易费
    ,past_svc_fee number(15,2) -- 上期服务费
    ,past_ins number(15,2) -- 上期保险金额
    ,past_user_fee1 number(19,6) -- 上期自定义费用1
    ,past_user_fee2 number(19,6) -- 上期自定义费用2
    ,past_user_fee3 number(19,6) -- 上期自定义费用3
    ,past_user_fee4 number(19,6) -- 上期自定义费用4
    ,past_user_fee5 number(19,6) -- 上期自定义费用5
    ,past_user_fee6 number(19,6) -- 上期自定义费用6
    ,ctd_principal number(15,2) -- 当期本金
    ,ctd_interest number(15,2) -- 当期利息
    ,ctd_card_fee number(15,2) -- 当期年费
    ,ctd_ovrlmt_fee number(15,2) -- 当期超限费
    ,ctd_lpc number(15,2) -- 当期滞纳金
    ,ctd_nsf_fee number(15,2) -- 当期资金不足费
    ,ctd_svc_fee number(15,2) -- 当期服务费
    ,ctd_txn_fee number(15,2) -- 当期交易费
    ,ctd_ins number(15,2) -- 当期保险金额
    ,ctd_user_fee1 number(19,6) -- 当期新增自定义费用1
    ,ctd_user_fee2 number(19,6) -- 当期新增自定义费用2
    ,ctd_user_fee3 number(19,6) -- 当期新增自定义费用3
    ,ctd_user_fee4 number(19,6) -- 当期新增自定义费用4
    ,ctd_user_fee5 number(19,6) -- 当期新增自定义费用5
    ,ctd_user_fee6 number(19,6) -- 当期新增自定义费用6
    ,ctd_amt_db number(15,2) -- 当期借记金额
    ,ctd_amt_cr number(15,2) -- 当期贷记金额
    ,ctd_nbr_db number(22) -- 当期借记交易笔数
    ,ctd_nbr_cr number(22) -- 当期贷记交易笔数
    ,nodefbnp_int_acru number(19,6) -- 非延迟利息
    ,beg_defbnp_int_acru number(19,6) -- 往期累积延时利息
    ,ctd_defbnp_int_acru number(19,6) -- 当期累积延时利息
    ,user_code1 varchar2(90) -- 用户自定义代码1
    ,user_code2 varchar2(90) -- 用户自定义代码2
    ,user_code3 varchar2(90) -- 用户自定义代码3
    ,user_code4 varchar2(90) -- 用户自定义代码4
    ,user_code5 varchar2(90) -- 用户自定义代码5
    ,user_code6 varchar2(90) -- 用户自定义代码6
    ,user_number1 number(22) -- 用户自定义笔数1
    ,user_number2 number(22) -- 用户自定义笔数2
    ,user_number3 number(22) -- 用户自定义笔数3
    ,user_number4 number(22) -- 用户自定义笔数4
    ,user_number5 number(22) -- 用户自定义笔数5
    ,user_number6 number(22) -- 用户自定义笔数6
    ,user_field1 varchar2(90) -- 用户自定义域1
    ,user_field2 varchar2(90) -- 用户自定义域2
    ,user_field3 varchar2(90) -- 用户自定义域3
    ,user_field4 varchar2(90) -- 用户自定义域4
    ,user_field5 varchar2(90) -- 用户自定义域5
    ,user_field6 varchar2(90) -- 用户自定义域6
    ,user_date1 date -- 用户自定义日期1
    ,user_date2 date -- 用户自定义日期2
    ,user_date3 date -- 用户自定义日期3
    ,user_date4 date -- 用户自定义日期4
    ,user_date5 date -- 用户自定义日期5
    ,user_date6 date -- 用户自定义日期6
    ,user_amt1 number(19,6) -- 用户自定义金额1
    ,user_amt2 number(19,6) -- 用户自定义金额2
    ,user_amt3 number(19,6) -- 用户自定义金额3
    ,user_amt4 number(19,6) -- 用户自定义金额4
    ,user_amt5 number(19,6) -- 用户自定义金额5
    ,user_amt6 number(19,6) -- 昨日贷记卡承诺余额
    ,jpa_version number(22) -- 乐观锁版本号
    ,past_penalty number(15,2) -- 往期罚息
    ,ctd_penalty number(15,2) -- 当期罚息
    ,past_compound number(15,2) -- 往期复利
    ,ctd_compound number(15,2) -- 当期复利
    ,penalty_acru number(19,6) -- 罚息累计
    ,compound_acru number(19,6) -- 复利累计
    ,interest_rate number(19,6) -- 基础利率
    ,penalty_rate number(19,6) -- 罚息利率
    ,compound_rate number(19,6) -- 复利利率
    ,use_plan_rate varchar2(2) -- 是否使用plan的利率
    ,last_pmt_date date -- 上一还款日期
    ,term number(22) -- 所在贷款期数
    ,calc_type varchar2(2) -- 计费类型
    ,calc_cycle number(22) -- 计费周期
    ,fee_rate number(19,6) -- 费率
    ,last_fee_date date -- 上一收费日
    ,next_fee_date date -- 下一收费日
    ,txn_seq number(20,0) -- 交易流水号
    ,first_dd_date date -- 首次约定还款日期
    ,consumer_trans_id varchar2(48) -- 业务流水号
    ,sys_trans_id varchar2(48) -- 系统调用流水号
    ,buser_field21 varchar2(23) -- 系统备用域21
    ,sub_terminal_type varchar2(23) -- 终端类型
    ,sub_merch_id varchar2(60) -- 二级商户编码
    ,sub_merch_name varchar2(90) -- 二级商户名称
    ,wares_desc varchar2(90) -- 商品信息
    ,last_modified_datetime date -- 修改时间
    ,original_amt number(19,6) -- 原始交易本金
    ,interest_calc_base varchar2(2) -- 计息基数
    ,created_datetime date -- 创建时间
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0ntm_plan to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_plan to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_plan to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_plan is '信用计划表';
comment on column ${iol_schema}.mpcs_a0ntm_plan.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.plan_id is '流水号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.acct_no is '账户编号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.acct_type is '账户类型';
comment on column ${iol_schema}.mpcs_a0ntm_plan.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.plan_nbr is '信用计划号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.plan_type is '信用计划类型';
comment on column ${iol_schema}.mpcs_a0ntm_plan.product_cd is '产品代码';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ref_nbr is '交易参考号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.curr_bal is '当前余额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.begin_bal is '期初余额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.dispute_amt is '争议金额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.tot_due_amt is '最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.plan_add_date is '记录建立日期';
comment on column ${iol_schema}.mpcs_a0ntm_plan.paid_out_date is '还清日期';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_principal is '上期本金';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_interest is '上期利息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_card_fee is '上期年费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_ovrlmt_fee is '上期超限费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_lpc is '上期滞纳金';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_nsf_fee is '上期资金不足费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_txn_fee is '上期交易费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_svc_fee is '上期服务费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_ins is '上期保险金额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee1 is '上期自定义费用1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee2 is '上期自定义费用2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee3 is '上期自定义费用3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee4 is '上期自定义费用4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee5 is '上期自定义费用5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_user_fee6 is '上期自定义费用6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_principal is '当期本金';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_interest is '当期利息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_card_fee is '当期年费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_ovrlmt_fee is '当期超限费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_lpc is '当期滞纳金';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_nsf_fee is '当期资金不足费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_svc_fee is '当期服务费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_txn_fee is '当期交易费';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_ins is '当期保险金额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee1 is '当期新增自定义费用1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee2 is '当期新增自定义费用2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee3 is '当期新增自定义费用3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee4 is '当期新增自定义费用4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee5 is '当期新增自定义费用5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_user_fee6 is '当期新增自定义费用6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_amt_db is '当期借记金额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_amt_cr is '当期贷记金额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_nbr_db is '当期借记交易笔数';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_nbr_cr is '当期贷记交易笔数';
comment on column ${iol_schema}.mpcs_a0ntm_plan.nodefbnp_int_acru is '非延迟利息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.beg_defbnp_int_acru is '往期累积延时利息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_defbnp_int_acru is '当期累积延时利息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code1 is '用户自定义代码1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code2 is '用户自定义代码2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code3 is '用户自定义代码3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code4 is '用户自定义代码4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code5 is '用户自定义代码5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_code6 is '用户自定义代码6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number1 is '用户自定义笔数1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number2 is '用户自定义笔数2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number3 is '用户自定义笔数3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number4 is '用户自定义笔数4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number5 is '用户自定义笔数5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_number6 is '用户自定义笔数6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field1 is '用户自定义域1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field2 is '用户自定义域2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field3 is '用户自定义域3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field4 is '用户自定义域4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field5 is '用户自定义域5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_field6 is '用户自定义域6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date1 is '用户自定义日期1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date2 is '用户自定义日期2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date3 is '用户自定义日期3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date4 is '用户自定义日期4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date5 is '用户自定义日期5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_date6 is '用户自定义日期6';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt1 is '用户自定义金额1';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt2 is '用户自定义金额2';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt3 is '用户自定义金额3';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt4 is '用户自定义金额4';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt5 is '用户自定义金额5';
comment on column ${iol_schema}.mpcs_a0ntm_plan.user_amt6 is '昨日贷记卡承诺余额';
comment on column ${iol_schema}.mpcs_a0ntm_plan.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_penalty is '往期罚息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_penalty is '当期罚息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.past_compound is '往期复利';
comment on column ${iol_schema}.mpcs_a0ntm_plan.ctd_compound is '当期复利';
comment on column ${iol_schema}.mpcs_a0ntm_plan.penalty_acru is '罚息累计';
comment on column ${iol_schema}.mpcs_a0ntm_plan.compound_acru is '复利累计';
comment on column ${iol_schema}.mpcs_a0ntm_plan.interest_rate is '基础利率';
comment on column ${iol_schema}.mpcs_a0ntm_plan.penalty_rate is '罚息利率';
comment on column ${iol_schema}.mpcs_a0ntm_plan.compound_rate is '复利利率';
comment on column ${iol_schema}.mpcs_a0ntm_plan.use_plan_rate is '是否使用plan的利率';
comment on column ${iol_schema}.mpcs_a0ntm_plan.last_pmt_date is '上一还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_plan.term is '所在贷款期数';
comment on column ${iol_schema}.mpcs_a0ntm_plan.calc_type is '计费类型';
comment on column ${iol_schema}.mpcs_a0ntm_plan.calc_cycle is '计费周期';
comment on column ${iol_schema}.mpcs_a0ntm_plan.fee_rate is '费率';
comment on column ${iol_schema}.mpcs_a0ntm_plan.last_fee_date is '上一收费日';
comment on column ${iol_schema}.mpcs_a0ntm_plan.next_fee_date is '下一收费日';
comment on column ${iol_schema}.mpcs_a0ntm_plan.txn_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.first_dd_date is '首次约定还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_plan.consumer_trans_id is '业务流水号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.sys_trans_id is '系统调用流水号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.buser_field21 is '系统备用域21';
comment on column ${iol_schema}.mpcs_a0ntm_plan.sub_terminal_type is '终端类型';
comment on column ${iol_schema}.mpcs_a0ntm_plan.sub_merch_id is '二级商户编码';
comment on column ${iol_schema}.mpcs_a0ntm_plan.sub_merch_name is '二级商户名称';
comment on column ${iol_schema}.mpcs_a0ntm_plan.wares_desc is '商品信息';
comment on column ${iol_schema}.mpcs_a0ntm_plan.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_plan.original_amt is '原始交易本金';
comment on column ${iol_schema}.mpcs_a0ntm_plan.interest_calc_base is '计息基数';
comment on column ${iol_schema}.mpcs_a0ntm_plan.created_datetime is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_plan.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_plan.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_plan.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_plan.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_plan.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_plan.etl_timestamp is 'ETL处理时间戳';
