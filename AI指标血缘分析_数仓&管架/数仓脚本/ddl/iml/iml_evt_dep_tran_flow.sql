/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,rule_id varchar2(100) -- 规则编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_type_cd varchar2(100) -- 客户类型代码
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,prod_id varchar2(100) -- 产品编号
    ,tran_code varchar2(100) -- 交易码
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_kind_cd varchar2(30) -- 交易种类代码
    ,bal_chg_type_cd varchar2(30) -- 余额变化类型代码
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,pric_amt number(30,2) -- 本金金额
    ,int_amt number(30,2) -- 利息金额
    ,comp_int_amt number(30,2) -- 复利金额
    ,pnlt_amt number(30,2) -- 罚息金额
    ,float_ratio number(18,8) -- 浮动比例
    ,tax number(30,2) -- 税金
    ,cntpty_equvl_amt number(30,2) -- 交易对手等值金额
    ,offset_exch_rat number(18,8) -- 平盘汇率
    ,cross_exch_rat number(18,8) -- 交叉汇率
    ,effect_dt date -- 生效日期
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,debit_crdt_flg_cd varchar2(30) -- 借贷标志代码
    ,post_flg varchar2(10) -- 过账标志
    ,int_accr_flg_cd varchar2(30) -- 计息标志代码
    ,revs_flg varchar2(10) -- 冲正标志
    ,vtual_flg varchar2(10) -- 虚拟标志
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,chn_id varchar2(100) -- 渠道编号
    ,chn_dt date -- 渠道日期
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,modif_bf_org_id varchar2(100) -- 变更前机构编号
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
grant select on ${iml_schema}.evt_dep_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_dep_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_dep_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_tran_flow is '存款交易流水';
comment on column ${iml_schema}.evt_dep_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_dep_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_tran_flow.rule_id is '规则编号';
comment on column ${iml_schema}.evt_dep_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_dep_tran_flow.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_dep_tran_flow.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_dep_tran_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_dep_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_tran_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_dep_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_dep_tran_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_dep_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_kind_cd is '交易种类代码';
comment on column ${iml_schema}.evt_dep_tran_flow.bal_chg_type_cd is '余额变化类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_dep_tran_flow.pric_amt is '本金金额';
comment on column ${iml_schema}.evt_dep_tran_flow.int_amt is '利息金额';
comment on column ${iml_schema}.evt_dep_tran_flow.comp_int_amt is '复利金额';
comment on column ${iml_schema}.evt_dep_tran_flow.pnlt_amt is '罚息金额';
comment on column ${iml_schema}.evt_dep_tran_flow.float_ratio is '浮动比例';
comment on column ${iml_schema}.evt_dep_tran_flow.tax is '税金';
comment on column ${iml_schema}.evt_dep_tran_flow.cntpty_equvl_amt is '交易对手等值金额';
comment on column ${iml_schema}.evt_dep_tran_flow.offset_exch_rat is '平盘汇率';
comment on column ${iml_schema}.evt_dep_tran_flow.cross_exch_rat is '交叉汇率';
comment on column ${iml_schema}.evt_dep_tran_flow.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_tran_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_dep_tran_flow.debit_crdt_flg_cd is '借贷标志代码';
comment on column ${iml_schema}.evt_dep_tran_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_dep_tran_flow.int_accr_flg_cd is '计息标志代码';
comment on column ${iml_schema}.evt_dep_tran_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_dep_tran_flow.vtual_flg is '虚拟标志';
comment on column ${iml_schema}.evt_dep_tran_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_dep_tran_flow.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_dep_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_dep_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_dep_tran_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.evt_dep_tran_flow.modif_bf_org_id is '变更前机构编号';
comment on column ${iml_schema}.evt_dep_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_tran_flow.etl_timestamp is 'ETL处理时间戳';
