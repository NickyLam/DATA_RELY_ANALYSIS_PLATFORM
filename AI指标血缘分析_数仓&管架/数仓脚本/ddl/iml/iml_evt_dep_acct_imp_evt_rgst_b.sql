/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_acct_imp_evt_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,seq_num varchar2(60) -- 序号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,open_acct_dt date -- 开户日期
    ,cust_id varchar2(100) -- 客户编号
    ,dep_redt_type_cd varchar2(30) -- 存款转存类型代码
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,float_point number(18,8) -- 浮动点数
    ,exec_int_rat number(18,8) -- 执行利率
    ,acm_int_adj_amt number(30,2) -- 累计利息调整金额
    ,provi_day_int_adj_amt number(30,2) -- 计提日利息调整金额
    ,base_int_rat number(18,8) -- 基础利率
    ,tot_int_amt number(30,2) -- 总利息金额
    ,int_accr_amt number(30,2) -- 计息金额
    ,last_int_set_dt date -- 上一结息日期
    ,cap_flg varchar2(10) -- 资本化标志
    ,dep_term_tenor number(10) -- 存期期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,exp_dt date -- 到期日期
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_happ_pric number(30,2) -- 交易发生本金
    ,tran_amt number(30,2) -- 交易金额
    ,wdraw_int_rat number(18,8) -- 支取利率
    ,net_int number(30,2) -- 净利息
    ,int_accr_days number(10) -- 计息天数
    ,tax_rat number(18,6) -- 税率
    ,tax_category_cd varchar2(30) -- 税种代码
    ,tax_amt number(30,2) -- 税金
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,redt_seq_num varchar2(60) -- 转存序号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,post_flg varchar2(10) -- 过账标志
    ,tran_revs_dt date -- 交易冲正日期
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,sob_cate_cd varchar2(30) -- 账套类别代码
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,bus_proc_status_cd varchar2(30) -- 业务处理状态代码
    ,check_entry_cd varchar2(30) -- 对账码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,int_calc_begin_dt date -- 利息计算起始日期
    ,year_base_days varchar2(30) -- 年计息基准代码
    ,mon_base_cd varchar2(30) -- 月基准代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_dep_acct_imp_evt_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_dep_acct_imp_evt_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_dep_acct_imp_evt_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b is '存款账户重要事件登记簿';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.seq_num is '序号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.acct_id is '账户编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.open_acct_dt is '开户日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.dep_redt_type_cd is '存款转存类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.float_int_rat is '浮动利率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.float_point is '浮动点数';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.exec_int_rat is '执行利率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.acm_int_adj_amt is '累计利息调整金额';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.provi_day_int_adj_amt is '计提日利息调整金额';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.base_int_rat is '基础利率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tot_int_amt is '总利息金额';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.int_accr_amt is '计息金额';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.last_int_set_dt is '上一结息日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.cap_flg is '资本化标志';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.dep_term_tenor is '存期期限';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_happ_pric is '交易发生本金';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.wdraw_int_rat is '支取利率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.net_int is '净利息';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.int_accr_days is '计息天数';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tax_rat is '税率';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tax_category_cd is '税种代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tax_amt is '税金';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.redt_seq_num is '转存序号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.post_flg is '过账标志';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_revs_dt is '交易冲正日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.sob_cate_cd is '账套类别代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.bus_proc_status_cd is '业务处理状态代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.check_entry_cd is '对账码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.int_calc_begin_dt is '利息计算起始日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.year_base_days is '年计息基准代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.mon_base_cd is '月基准代码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_acct_imp_evt_rgst_b.etl_timestamp is 'ETL处理时间戳';
