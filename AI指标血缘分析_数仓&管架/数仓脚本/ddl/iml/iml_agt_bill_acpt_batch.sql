/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_acpt_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_acpt_batch
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_acpt_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_acpt_batch(
    batch_id varchar2(60) -- 批次编号
    ,lp_id varchar2(60) -- 法人编号
    ,org_id varchar2(60) -- 机构编号
    ,acpt_agt_id varchar2(100) -- 承兑协议编号
    ,acpt_batch_id varchar2(100) -- 承兑批次协议编号
    ,task_type_cd varchar2(10) -- 任务类型代码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,drawer_cust_id varchar2(60) -- 出票人客户编号
    ,appl_acpt_amt number(30,2) -- 申请承兑金额
    ,appl_draw_dt date -- 申请出票日期
    ,exp_dt date -- 到期日期
    ,margin_ratio number(38,8) -- 保证金比例
    ,comm_fee_ratio number(18,6) -- 手续费比例
    ,tran_amt number(30,2) -- 交易金额
    ,pay_bank_bank_no varchar2(60) -- 付款行行号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,dept_id varchar2(60) -- 部门编号
    ,operr_id varchar2(60) -- 操作员编号
    ,tran_dt date -- 交易日期
    ,bus_logic_check_status_cd varchar2(10) -- 业务逻辑检查状态代码
    ,apv_status_cd varchar2(10) -- 审批状态代码
    ,check_status_cd varchar2(10) -- 审核状态代码
    ,crdt_check_status_cd varchar2(10) -- 授信检查状态代码
    ,final_modif_tm timestamp -- 最后修改时间
    ,drawer_acct_num varchar2(100) -- 出票人账号
    ,drawer_bank_name varchar2(375) -- 出票人行名称
    ,actl_dir_indus_name varchar2(150) -- 实际投向行业名称
    ,enter_acct_org_id varchar2(60) -- 入账机构编号
    ,acpt_fee number(30,2) -- 承兑费
    ,mgmt_fee number(30,2) -- 管理费
    ,agt_exp_dt date -- 协议到期日期
    ,acct_amt number(30,2) -- 账户金额
    ,apprved_use_crdt_open_amt number(30,2) -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt number(30,2) -- 本次放款后累计使用敞口金额
    ,cert_no varchar2(60) -- 证件号码
    ,onl_bank_batch_id varchar2(60) -- 网银批量批次编号
    ,fst_repay_acct_id varchar2(100) -- 第一还款账户编号
    ,margin_tenor_type_cd varchar2(30) -- 保证金期限类型代码
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,margin_type_cd varchar2(30) -- 保证金类型代码
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,margin_int_rat_float_type_cd varchar2(60) -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd varchar2(60) -- 保证金利率浮动方式代码
    ,margin_flo_val number(30,2) -- 保证金浮动值
    ,rela_party_que_rest_cd varchar2(30) -- 关联方查询结果代码
    ,tgls_entry_status_cd varchar2(30) -- 核算中台记账状态代码
    ,ncbs_entry_status_cd varchar2(30) -- 核心记账状态代码
    ,h_data_flg varchar2(500) -- 历史数据标志
    ,open_type_cd varchar2(30) -- 敞口类型代码
    ,open_amt number(30,2) -- 敞口金额
    ,adj_dep_prft_flg varchar2(10) -- 调整存款收益标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_bill_acpt_batch to ${icl_schema};
grant select on ${iml_schema}.agt_bill_acpt_batch to ${idl_schema};
grant select on ${iml_schema}.agt_bill_acpt_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_acpt_batch is '票据承兑批次';
comment on column ${iml_schema}.agt_bill_acpt_batch.batch_id is '批次编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.org_id is '机构编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.acpt_agt_id is '承兑协议编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.acpt_batch_id is '承兑批次协议编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.task_type_cd is '任务类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.drawer_cust_id is '出票人客户编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.appl_acpt_amt is '申请承兑金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.appl_draw_dt is '申请出票日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_bill_acpt_batch.comm_fee_ratio is '手续费比例';
comment on column ${iml_schema}.agt_bill_acpt_batch.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.pay_bank_bank_no is '付款行行号';
comment on column ${iml_schema}.agt_bill_acpt_batch.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.dept_id is '部门编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.operr_id is '操作员编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.bus_logic_check_status_cd is '业务逻辑检查状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.check_status_cd is '审核状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.crdt_check_status_cd is '授信检查状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_bill_acpt_batch.drawer_acct_num is '出票人账号';
comment on column ${iml_schema}.agt_bill_acpt_batch.drawer_bank_name is '出票人行名称';
comment on column ${iml_schema}.agt_bill_acpt_batch.actl_dir_indus_name is '实际投向行业名称';
comment on column ${iml_schema}.agt_bill_acpt_batch.enter_acct_org_id is '入账机构编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.acpt_fee is '承兑费';
comment on column ${iml_schema}.agt_bill_acpt_batch.mgmt_fee is '管理费';
comment on column ${iml_schema}.agt_bill_acpt_batch.agt_exp_dt is '协议到期日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.acct_amt is '账户金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.apprved_use_crdt_open_amt is '已批准使用授信敞口金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.distr_post_acm_use_open_amt is '本次放款后累计使用敞口金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.cert_no is '证件号码';
comment on column ${iml_schema}.agt_bill_acpt_batch.onl_bank_batch_id is '网银批量批次编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.fst_repay_acct_id is '第一还款账户编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_tenor_type_cd is '保证金期限类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_type_cd is '保证金类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_int_rat_float_type_cd is '保证金利率浮动类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_int_rat_float_way_cd is '保证金利率浮动方式代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.margin_flo_val is '保证金浮动值';
comment on column ${iml_schema}.agt_bill_acpt_batch.rela_party_que_rest_cd is '关联方查询结果代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.tgls_entry_status_cd is '核算中台记账状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.ncbs_entry_status_cd is '核心记账状态代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.h_data_flg is '历史数据标志';
comment on column ${iml_schema}.agt_bill_acpt_batch.open_type_cd is '敞口类型代码';
comment on column ${iml_schema}.agt_bill_acpt_batch.open_amt is '敞口金额';
comment on column ${iml_schema}.agt_bill_acpt_batch.adj_dep_prft_flg is '调整存款收益标志';
comment on column ${iml_schema}.agt_bill_acpt_batch.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bill_acpt_batch.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_acpt_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_acpt_batch.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_acpt_batch.etl_timestamp is 'ETL处理时间戳';
