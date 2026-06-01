/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_auto_redt_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_auto_redt_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_auto_redt_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_auto_redt_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dep_agt_id varchar2(100) -- 存款协议编号
    ,seq_num varchar2(60) -- 序号
    ,plan_id varchar2(100) -- 计划编号
    ,sign_agt_type_cd varchar2(30) -- 签约协议类型代码
    ,sign_agt_status_cd varchar2(30) -- 签约协议状态代码
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,acct_sub_acct_num varchar2(60) -- 账户子账号
    ,acct_name varchar2(500) -- 账户名称
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,dep_term_tenor varchar2(10) -- 存期期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,lowt_redt_amt number(30,2) -- 最低转存金额
    ,redt_by_agt_way_cd varchar2(30) -- 约定转存方式代码
    ,redt_mode_cd varchar2(30) -- 转存方式代码
    ,tran_acct_mult number(10) -- 转账倍数
    ,tran_amt number(30,2) -- 交易金额
    ,bal_ratio number(18,6) -- 余额比例
    ,acm_tran_acct_amt number(30,2) -- 累计转账金额
    ,tran_acct_base number(30,2) -- 转账基数
    ,mini_guart_amt number(30,2) -- 保底金额
    ,redt_acct_type_cd varchar2(30) -- 转存账户类型代码
    ,finc_fix_amt number(30,2) -- 理财固定金额
    ,cntpty_acct_id varchar2(100) -- 对手账户编号
    ,cntpty_cust_acct_num varchar2(60) -- 对手客户账号
    ,cntpty_acct_prod_id varchar2(100) -- 对手账户产品编号
    ,cntpty_acct_curr_cd varchar2(30) -- 对手账户币种代码
    ,cntpty_acct_sub_acct_num varchar2(60) -- 对手账户子账号
    ,cntpty_bank_no varchar2(30) -- 对手银行行号
    ,cntpty_acct_name varchar2(1000) -- 对手账户名称
    ,cntpty_acct_type_cd varchar2(30) -- 对手账户类型代码
    ,pric_int_enter_sub_acct_num varchar2(60) -- 本息入账账户子账号
    ,pric_int_enter_acct_cust_acct_num varchar2(60) -- 本息入账客户账号
    ,pric_int_enter_curr_cd varchar2(30) -- 本息入账账户币种代码
    ,pric_int_enter_prod_id varchar2(100) -- 本息入账账户产品编号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,stl_cust_acct_num varchar2(60) -- 结算客户账号
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,loan_rs_cd varchar2(30) -- 贷款原因代码
    ,prior_level varchar2(30) -- 优先等级
    ,acm_track_cnt number(10) -- 累计追踪次数
    ,acm_tran_acct_cnt number(10) -- 累计转账次数
    ,subtn_tran_cnt number(10) -- 持续划款次数
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,sign_dt date -- 签约日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,auto_payoff_flg varchar2(10) -- 自动结清标志
    ,open_cnt_type_cd varchar2(30) -- 开立笔数类型代码
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
grant select on ${iml_schema}.agt_dep_acct_auto_redt_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_auto_redt_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_auto_redt_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_auto_redt_agt_h is '存款账户自动转存协议历史';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.seq_num is '序号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.plan_id is '计划编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sign_agt_type_cd is '签约协议类型代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sign_agt_status_cd is '签约协议状态代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acct_sub_acct_num is '账户子账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.dep_term_tenor is '存期期限';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.lowt_redt_amt is '最低转存金额';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.redt_by_agt_way_cd is '约定转存方式代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.redt_mode_cd is '转存方式代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.tran_acct_mult is '转账倍数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.bal_ratio is '余额比例';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acm_tran_acct_amt is '累计转账金额';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.tran_acct_base is '转账基数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.mini_guart_amt is '保底金额';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.redt_acct_type_cd is '转存账户类型代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.finc_fix_amt is '理财固定金额';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_id is '对手账户编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_cust_acct_num is '对手客户账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_prod_id is '对手账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_curr_cd is '对手账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_sub_acct_num is '对手账户子账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_bank_no is '对手银行行号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_name is '对手账户名称';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.cntpty_acct_type_cd is '对手账户类型代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.pric_int_enter_sub_acct_num is '本息入账账户子账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.pric_int_enter_acct_cust_acct_num is '本息入账客户账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.pric_int_enter_curr_cd is '本息入账账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.pric_int_enter_prod_id is '本息入账账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.stl_cust_acct_num is '结算客户账号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.loan_rs_cd is '贷款原因代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.prior_level is '优先等级';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acm_track_cnt is '累计追踪次数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.acm_tran_acct_cnt is '累计转账次数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.subtn_tran_cnt is '持续划款次数';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.auto_payoff_flg is '自动结清标志';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.open_cnt_type_cd is '开立笔数类型代码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_auto_redt_agt_h.etl_timestamp is 'ETL处理时间戳';
