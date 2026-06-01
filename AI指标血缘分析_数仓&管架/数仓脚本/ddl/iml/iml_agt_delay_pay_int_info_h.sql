/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_delay_pay_int_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_delay_pay_int_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_delay_pay_int_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_delay_pay_int_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,apv_form_id varchar2(100) -- 审批单编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,min_init_amt number(30,2) -- 最小起存金额
    ,min_init_tenor number(10) -- 最小起存期限
    ,status_cd varchar2(30) -- 状态代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,tm_type_cd varchar2(30) -- 时间类型代码
    ,pay_int_spec_day number(10) -- 付息指定日
    ,int_accr_days number(10) -- 计息天数
    ,max_int_accr_acct_bal number(30,2) -- 最大计息账户余额
    ,delay_pay_int_int number(25,10) -- 延期付息利息
    ,merge_int_set_flg_cd varchar2(30) -- 合并结息标志代码
    ,acm_amt number(30,2) -- 累计金额
    ,int_paybl number(30,2) -- 应付利息
    ,acm_paid_int number(30,2) -- 累计已付利息
    ,int_float_point number(30,8) -- 利息浮动点数
    ,yd_today_val_bal number(15,10) -- 昨日今日值差额
    ,td_acm_amt number(30,2) -- 当日累计金额
    ,next_int_set_day date -- 下一结息日
    ,last_int_set_day date -- 上一结息日
    ,spec_yld_rat number(30,8) -- 指定收益率
    ,int_enter_acct_id varchar2(100) -- 利息入账账户编号
    ,int_enter_acct_cust_acct_num varchar2(60) -- 利息入账客户账号
    ,int_enter_acct_prod_id varchar2(100) -- 利息入账产品编号
    ,int_enter_acct_sub_acct_num varchar2(60) -- 利息入账子账号
    ,int_enter_acct_curr_cd varchar2(30) -- 利息入账币种代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_delay_pay_int_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_delay_pay_int_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_delay_pay_int_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_delay_pay_int_info_h is '延期付息信息历史';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.apv_form_id is '审批单编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.min_init_amt is '最小起存金额';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.min_init_tenor is '最小起存期限';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.tm_type_cd is '时间类型代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.pay_int_spec_day is '付息指定日';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_accr_days is '计息天数';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.max_int_accr_acct_bal is '最大计息账户余额';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.delay_pay_int_int is '延期付息利息';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.merge_int_set_flg_cd is '合并结息标志代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.acm_amt is '累计金额';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_paybl is '应付利息';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.acm_paid_int is '累计已付利息';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_float_point is '利息浮动点数';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.yd_today_val_bal is '昨日今日值差额';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.td_acm_amt is '当日累计金额';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.next_int_set_day is '下一结息日';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.last_int_set_day is '上一结息日';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.spec_yld_rat is '指定收益率';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_enter_acct_id is '利息入账账户编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_enter_acct_cust_acct_num is '利息入账客户账号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_enter_acct_prod_id is '利息入账产品编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_enter_acct_sub_acct_num is '利息入账子账号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.int_enter_acct_curr_cd is '利息入账币种代码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_delay_pay_int_info_h.etl_timestamp is 'ETL处理时间戳';
