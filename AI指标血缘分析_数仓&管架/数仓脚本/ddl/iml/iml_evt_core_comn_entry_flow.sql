/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_core_comn_entry_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_core_comn_entry_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_core_comn_entry_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_core_comn_entry_flow(
    evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,revs_tran_type_code varchar2(30) -- 冲正交易类型码
    ,revs_tran_dt date -- 冲正交易日期
    ,check_entry_cd varchar2(30) -- 对账码
    ,fee_prod_id varchar2(100) -- 费用产品编号
    ,float_ratio number(18,6) -- 浮动比例
    ,follow_id varchar2(100) -- 跟踪编号
    ,post_flg varchar2(10) -- 过账标志
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,core_flow_num varchar2(100) -- 核心流水号
    ,core_tran_teller_id varchar2(100) -- 核心交易柜员编号
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,org_id varchar2(100) -- 机构编号
    ,tran_id varchar2(100) -- 交易编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,cntpty_curr_cd varchar2(30) -- 交易对手币种代码
    ,cntpty_prod_id varchar2(100) -- 交易对手产品编号
    ,cntpty_org_dist_cd varchar2(30) -- 交易对手机构行政区划代码
    ,cntpty_tran_ref_no varchar2(60) -- 交易对手交易参考号
    ,cntpty_tran_flow_num varchar2(100) -- 交易对手交易流水号
    ,cntpty_type_cd varchar2(30) -- 交易对手客户类型代码
    ,cntpty_cust_acct_num varchar2(60) -- 交易对手客户账号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,cntpty_bank_name varchar2(500) -- 交易对手银行名称
    ,cntpty_unionpay_num varchar2(60) -- 交易对手银联号
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_open_acct_org_id varchar2(100) -- 交易对手账户开户机构编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_acct_sub_acct_num varchar2(60) -- 交易对手账户子账号
    ,cntpty_cert_no varchar2(60) -- 交易对手证件号码
    ,cntpty_cert_type_cd varchar2(30) -- 交易对手证件类型代码
    ,tran_happ_site varchar2(500) -- 交易发生地点
    ,tran_postsc varchar2(500) -- 交易附言
    ,tran_amt number(30,2) -- 交易金额
    ,tran_code varchar2(30) -- 交易码
    ,tran_descb varchar2(500) -- 交易描述
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,tran_tm varchar2(500) -- 交易时间
    ,tran_revd_flg varchar2(10) -- 交易已冲正标志
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,med_type_cd varchar2(30) -- 介质类型代码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,subj_id varchar2(100) -- 科目编号
    ,subj_entry_cust_name varchar2(500) -- 科目记账客户名称
    ,subj_entry_cust_acct_num varchar2(250) -- 科目记账客户账号
    ,subj_entry_sub_acct_num varchar2(30) -- 科目记账子账号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,src_sys_id varchar2(100) -- 来源系统编号
    ,fe_flow_num varchar2(100) -- 前端流水号
    ,clear_dt date -- 清算日期
    ,chn_tran_dt date -- 渠道交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,effect_dt date -- 生效日期
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,sys_id varchar2(100) -- 系统编号
    ,cash_proj_cd varchar2(30) -- 现金项目代码
    ,crdt_card_num varchar2(60) -- 信用卡号
    ,bus_proc_status_cd varchar2(30) -- 业务处理状态代码
    ,bus_tran_flow_num varchar2(100) -- 业务交易流水号
    ,bus_tran_dt date -- 业务交易日期
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,have_med_flg varchar2(10) -- 有介质标志
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,sob_cate_cd varchar2(30) -- 账套类别代码
    ,real_cntpty_prod_id varchar2(100) -- 真实交易对手产品编号
    ,real_cntpty_org_id varchar2(100) -- 真实交易对手机构编号
    ,real_cntpty_org_dist_cd varchar2(30) -- 真实交易对手机构行政区划代码
    ,real_cntpty_org_name varchar2(500) -- 真实交易对手机构名称
    ,real_cntpty_cust_acct_num varchar2(60) -- 真实交易对手客户账号
    ,real_cntpty_name varchar2(500) -- 真实交易对手名称
    ,real_cntpty_cert_no varchar2(60) -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd varchar2(30) -- 真实交易对手证件类型代码
    ,real_tran_happ_site varchar2(500) -- 真实交易发生地点
    ,main_tran_seq_num varchar2(60) -- 主交易序号
    ,main_evt_cls_cd varchar2(30) -- 主事件分类代码
    ,auto_revs_flg varchar2(10) -- 自动冲正标志
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
grant select on ${iml_schema}.evt_core_comn_entry_flow to ${icl_schema};
grant select on ${iml_schema}.evt_core_comn_entry_flow to ${idl_schema};
grant select on ${iml_schema}.evt_core_comn_entry_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_core_comn_entry_flow is '核心通用记账流水';
comment on column ${iml_schema}.evt_core_comn_entry_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.revs_tran_type_code is '冲正交易类型码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.revs_tran_dt is '冲正交易日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.check_entry_cd is '对账码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.fee_prod_id is '费用产品编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.float_ratio is '浮动比例';
comment on column ${iml_schema}.evt_core_comn_entry_flow.follow_id is '跟踪编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_core_comn_entry_flow.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.core_tran_teller_id is '核心交易柜员编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_id is '交易编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_curr_cd is '交易对手币种代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_prod_id is '交易对手产品编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_org_dist_cd is '交易对手机构行政区划代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_tran_ref_no is '交易对手交易参考号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_tran_flow_num is '交易对手交易流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_type_cd is '交易对手客户类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_cust_acct_num is '交易对手客户账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_bank_name is '交易对手银行名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_unionpay_num is '交易对手银联号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_acct_open_acct_org_id is '交易对手账户开户机构编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_acct_sub_acct_num is '交易对手账户子账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_cert_no is '交易对手证件号码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cntpty_cert_type_cd is '交易对手证件类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_happ_site is '交易发生地点';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_postsc is '交易附言';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_revd_flg is '交易已冲正标志';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_core_comn_entry_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.med_type_cd is '介质类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_core_comn_entry_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.subj_id is '科目编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.subj_entry_cust_name is '科目记账客户名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.subj_entry_cust_acct_num is '科目记账客户账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.subj_entry_sub_acct_num is '科目记账子账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.src_sys_id is '来源系统编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.fe_flow_num is '前端流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.chn_tran_dt is '渠道交易日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.cash_proj_cd is '现金项目代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.crdt_card_num is '信用卡号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.bus_proc_status_cd is '业务处理状态代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.bus_tran_flow_num is '业务交易流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.have_med_flg is '有介质标志';
comment on column ${iml_schema}.evt_core_comn_entry_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.sob_cate_cd is '账套类别代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_prod_id is '真实交易对手产品编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_org_id is '真实交易对手机构编号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_org_dist_cd is '真实交易对手机构行政区划代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_org_name is '真实交易对手机构名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_cust_acct_num is '真实交易对手客户账号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_name is '真实交易对手名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_cert_no is '真实交易对手证件号码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_cntpty_cert_type_cd is '真实交易对手证件类型代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.real_tran_happ_site is '真实交易发生地点';
comment on column ${iml_schema}.evt_core_comn_entry_flow.main_tran_seq_num is '主交易序号';
comment on column ${iml_schema}.evt_core_comn_entry_flow.main_evt_cls_cd is '主事件分类代码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.auto_revs_flg is '自动冲正标志';
comment on column ${iml_schema}.evt_core_comn_entry_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_core_comn_entry_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_core_comn_entry_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_core_comn_entry_flow.etl_timestamp is 'ETL处理时间戳';
