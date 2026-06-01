/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_provi_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_provi_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_provi_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_provi_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,provi_flow_num varchar2(100) -- 计提流水号
    ,provi_dt date -- 计提日期
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,loan_num varchar2(60) -- 贷款号
    ,prod_id varchar2(100) -- 产品编号
    ,org_id varchar2(100) -- 机构编号
    ,chn_id varchar2(100) -- 渠道编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acm_provi_amt number(30,2) -- 累计计提金额
    ,td_provi_int number(30,2) -- 本日计提利息
    ,td_provi_actl_amt number(30,2) -- 本日计提实际金额
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,int_tax_acm_amt number(30,2) -- 利息税累计金额
    ,td_int_tax number(30,2) -- 本日利息税
    ,td_int_tax_init_amt number(30,2) -- 本日利息税原金额
    ,int_tax_bal number(30,8) -- 利息税差额
    ,tax_category_cd varchar2(30) -- 税种代码
    ,provi_tax_rat number(18,6) -- 计提税率
    ,cust_id varchar2(100) -- 客户编号
    ,tran_intior_type_cd varchar2(30) -- 交易发起方类型代码
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,sob_cate_cd varchar2(30) -- 账套类别代码
    ,provi_accum number(30,2) -- 计提积数
    ,int_amt number(30,2) -- 利息金额
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,remark varchar2(500) -- 备注
    ,revs_flg varchar2(10) -- 冲正标志
    ,dubil_id varchar2(100) -- 借据编号
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,post_flg varchar2(10) -- 过账标志
    ,cntpty_tran_ref_no varchar2(60) -- 对方交易参考号
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
    ,agt_fix_int_rat number(18,8) -- 协议固定利率
    ,agt_float_ratio number(18,6) -- 协议浮动比例
    ,agt_float_point number(18,8) -- 协议浮动点数
    ,merge_flg varchar2(10) -- 合并标志
    ,tran_tm timestamp -- 交易时间
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,accti_status_cd varchar2(30) -- 核算状态代码
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
grant select on ${iml_schema}.evt_loan_provi_flow to ${icl_schema};
grant select on ${iml_schema}.evt_loan_provi_flow to ${idl_schema};
grant select on ${iml_schema}.evt_loan_provi_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_provi_flow is '贷款计提流水';
comment on column ${iml_schema}.evt_loan_provi_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_provi_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_provi_flow.provi_flow_num is '计提流水号';
comment on column ${iml_schema}.evt_loan_provi_flow.provi_dt is '计提日期';
comment on column ${iml_schema}.evt_loan_provi_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_provi_flow.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.evt_loan_provi_flow.loan_num is '贷款号';
comment on column ${iml_schema}.evt_loan_provi_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_loan_provi_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_loan_provi_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_loan_provi_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_loan_provi_flow.acm_provi_amt is '累计计提金额';
comment on column ${iml_schema}.evt_loan_provi_flow.td_provi_int is '本日计提利息';
comment on column ${iml_schema}.evt_loan_provi_flow.td_provi_actl_amt is '本日计提实际金额';
comment on column ${iml_schema}.evt_loan_provi_flow.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.evt_loan_provi_flow.int_tax_acm_amt is '利息税累计金额';
comment on column ${iml_schema}.evt_loan_provi_flow.td_int_tax is '本日利息税';
comment on column ${iml_schema}.evt_loan_provi_flow.td_int_tax_init_amt is '本日利息税原金额';
comment on column ${iml_schema}.evt_loan_provi_flow.int_tax_bal is '利息税差额';
comment on column ${iml_schema}.evt_loan_provi_flow.tax_category_cd is '税种代码';
comment on column ${iml_schema}.evt_loan_provi_flow.provi_tax_rat is '计提税率';
comment on column ${iml_schema}.evt_loan_provi_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_provi_flow.tran_intior_type_cd is '交易发起方类型代码';
comment on column ${iml_schema}.evt_loan_provi_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_loan_provi_flow.sob_cate_cd is '账套类别代码';
comment on column ${iml_schema}.evt_loan_provi_flow.provi_accum is '计提积数';
comment on column ${iml_schema}.evt_loan_provi_flow.int_amt is '利息金额';
comment on column ${iml_schema}.evt_loan_provi_flow.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.evt_loan_provi_flow.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.evt_loan_provi_flow.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.evt_loan_provi_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_loan_provi_flow.remark is '备注';
comment on column ${iml_schema}.evt_loan_provi_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_loan_provi_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_loan_provi_flow.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.evt_loan_provi_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_loan_provi_flow.cntpty_tran_ref_no is '对方交易参考号';
comment on column ${iml_schema}.evt_loan_provi_flow.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.evt_loan_provi_flow.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.evt_loan_provi_flow.float_int_rat is '浮动利率';
comment on column ${iml_schema}.evt_loan_provi_flow.exec_int_rat is '执行利率';
comment on column ${iml_schema}.evt_loan_provi_flow.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.evt_loan_provi_flow.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.evt_loan_provi_flow.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.evt_loan_provi_flow.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.evt_loan_provi_flow.agt_fix_int_rat is '协议固定利率';
comment on column ${iml_schema}.evt_loan_provi_flow.agt_float_ratio is '协议浮动比例';
comment on column ${iml_schema}.evt_loan_provi_flow.agt_float_point is '协议浮动点数';
comment on column ${iml_schema}.evt_loan_provi_flow.merge_flg is '合并标志';
comment on column ${iml_schema}.evt_loan_provi_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_provi_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_loan_provi_flow.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.evt_loan_provi_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_provi_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_provi_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_provi_flow.etl_timestamp is 'ETL处理时间戳';
