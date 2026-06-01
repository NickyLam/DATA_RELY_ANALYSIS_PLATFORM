/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_int_set_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_int_set_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_int_set_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_int_set_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,seq_num varchar2(60) -- 序号
    ,acct_id varchar2(100) -- 账户编号
    ,int_set_dt date -- 结息日期
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,loan_num varchar2(60) -- 贷款号
    ,prod_id varchar2(100) -- 产品编号
    ,org_id varchar2(100) -- 机构编号
    ,chn_id varchar2(100) -- 渠道编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,int_set_amt number(30,2) -- 结息金额
    ,int_set_day_int_amt number(30,2) -- 结息日利息金额
    ,acm_int_adj_amt number(30,2) -- 累计利息调整金额
    ,acm_provi_int number(30,2) -- 累计计提利息
    ,int_set_day_int_tax number(30,2) -- 结息日利息税
    ,int_tax_acm_amt number(30,2) -- 利息税累计金额
    ,tran_intior_type_cd varchar2(30) -- 交易发起方类型代码
    ,tax_category_cd varchar2(30) -- 税种代码
    ,tax_rat number(18,6) -- 税率
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,sob_type_cd varchar2(30) -- 账套类型代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,revs_flg varchar2(10) -- 冲正标志
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,post_flg varchar2(10) -- 过账标志
    ,bus_proc_status_cd varchar2(30) -- 业务处理状态代码
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
    ,agt_fix_int_rat number(18,8) -- 协议固定利率
    ,agt_float_ratio number(18,6) -- 协议浮动比例
    ,agt_float_point number(18,8) -- 协议浮动点数
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,value_dt date -- 起息日期
    ,int_amt number(30,2) -- 利息金额
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,remark varchar2(750) -- 备注
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
grant select on ${iml_schema}.agt_loan_int_set_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_int_set_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_int_set_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_int_set_h is '贷款结息历史';
comment on column ${iml_schema}.agt_loan_int_set_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_int_set_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_int_set_h.seq_num is '序号';
comment on column ${iml_schema}.agt_loan_int_set_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_int_set_h.int_set_dt is '结息日期';
comment on column ${iml_schema}.agt_loan_int_set_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_loan_int_set_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_loan_int_set_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_int_set_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_loan_int_set_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_loan_int_set_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_int_set_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_int_set_h.int_set_amt is '结息金额';
comment on column ${iml_schema}.agt_loan_int_set_h.int_set_day_int_amt is '结息日利息金额';
comment on column ${iml_schema}.agt_loan_int_set_h.acm_int_adj_amt is '累计利息调整金额';
comment on column ${iml_schema}.agt_loan_int_set_h.acm_provi_int is '累计计提利息';
comment on column ${iml_schema}.agt_loan_int_set_h.int_set_day_int_tax is '结息日利息税';
comment on column ${iml_schema}.agt_loan_int_set_h.int_tax_acm_amt is '利息税累计金额';
comment on column ${iml_schema}.agt_loan_int_set_h.tran_intior_type_cd is '交易发起方类型代码';
comment on column ${iml_schema}.agt_loan_int_set_h.tax_category_cd is '税种代码';
comment on column ${iml_schema}.agt_loan_int_set_h.tax_rat is '税率';
comment on column ${iml_schema}.agt_loan_int_set_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_loan_int_set_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_loan_int_set_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_loan_int_set_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_loan_int_set_h.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.agt_loan_int_set_h.sob_type_cd is '账套类型代码';
comment on column ${iml_schema}.agt_loan_int_set_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_loan_int_set_h.revs_flg is '冲正标志';
comment on column ${iml_schema}.agt_loan_int_set_h.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.agt_loan_int_set_h.post_flg is '过账标志';
comment on column ${iml_schema}.agt_loan_int_set_h.bus_proc_status_cd is '业务处理状态代码';
comment on column ${iml_schema}.agt_loan_int_set_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_loan_int_set_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_loan_int_set_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_loan_int_set_h.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.agt_loan_int_set_h.agt_fix_int_rat is '协议固定利率';
comment on column ${iml_schema}.agt_loan_int_set_h.agt_float_ratio is '协议浮动比例';
comment on column ${iml_schema}.agt_loan_int_set_h.agt_float_point is '协议浮动点数';
comment on column ${iml_schema}.agt_loan_int_set_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_loan_int_set_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_loan_int_set_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_loan_int_set_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_loan_int_set_h.remark is '备注';
comment on column ${iml_schema}.agt_loan_int_set_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_int_set_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_int_set_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_int_set_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_int_set_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_int_set_h.etl_timestamp is 'ETL处理时间戳';
