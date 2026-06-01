/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_fin_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_fin_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_fin_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_fin_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,cap_froz_flow_num varchar2(100) -- 资金冻结流水号
    ,main_evt_cls_cd varchar2(30) -- 主事件分类代码
    ,main_tran_seq_num varchar2(60) -- 主交易序号
    ,inter_bus_type_cd varchar2(30) -- 中间业务类型代码
    ,exch_rat_type_cd varchar2(30) -- 汇率类型代码
    ,wdraw_way_cd varchar2(30) -- 支取方式代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,sob_cate_cd varchar2(30) -- 账套类别代码
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,acct_name varchar2(500) -- 账户名称
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,prior_level varchar2(30) -- 优先等级
    ,camp_prod_name varchar2(500) -- 营销产品名称
    ,camp_prod_id varchar2(100) -- 营销产品编号
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,bus_tran_batch_no varchar2(60) -- 业务交易批次号
    ,bus_proc_status_cd varchar2(30) -- 业务处理状态代码
    ,vtual_acct_flg varchar2(10) -- 虚户标志
    ,lmt_code varchar2(60) -- 限额编码
    ,cash_proj_cd varchar2(30) -- 现金项目代码
    ,cash_tran_flg varchar2(10) -- 现金交易标志
    ,cross_amt number(30,2) -- 套算金额
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,actl_bal number(30,2) -- 实际余额
    ,actl_cross_exch_rat number(18,8) -- 实际交叉汇率
    ,effect_dt date -- 生效日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_sub_flow_num varchar2(100) -- 渠道子流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,clear_dt date -- 清算日期
    ,begin_curr_cd varchar2(30) -- 起始币种代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,seller_quot_type_cd varchar2(30) -- 卖方牌价类型代码
    ,seller_exch_rat_val number(18,8) -- 卖方汇率值
    ,seller_exch_rat_cls_cd varchar2(30) -- 卖方汇率分类代码
    ,sell_amt number(30,2) -- 卖出金额
    ,sell_curr_cd varchar2(30) -- 卖出币种代码
    ,buy_amt number(30,2) -- 买入金额
    ,buyer_quot_type_cd varchar2(30) -- 买方牌价类型代码
    ,buyer_exch_rat_val number(18,8) -- 买方汇率值
    ,buyer_exch_rat_cls_cd varchar2(30) -- 买方汇率分类代码
    ,cust_name varchar2(500) -- 客户名称
    ,cust_econ_type_cd varchar2(30) -- 客户经济类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,amt_calc_type_cd varchar2(30) -- 金额计算类型代码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,tran_kind_cd varchar2(30) -- 交易种类代码
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_comnt varchar2(500) -- 交易说明
    ,tran_tm timestamp -- 交易时间
    ,tran_dt date -- 交易日期
    ,bef_tran_bal number(30,2) -- 交易前余额
    ,tran_cd varchar2(30) -- 交易码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_postsc varchar2(500) -- 交易附言
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,payment_corp_name varchar2(500) -- 交款单位名称
    ,cross_exch_rat number(18,8) -- 交叉汇率
    ,base_equvl_amt number(30,2) -- 基础等值金额
    ,exch_rat_cls_cd varchar2(30) -- 汇率分类代码
    ,callbk_id varchar2(100) -- 回收编号
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,post_flg varchar2(10) -- 过账标志
    ,follow_id varchar2(100) -- 跟踪编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,serv_fee_flg varchar2(10) -- 服务费标志
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,cntpty_acct_sub_acct_num varchar2(60) -- 对手账户子账号
    ,cntpty_acct_name varchar2(1000) -- 对手账户名称
    ,cntpty_acct_prod_id varchar2(100) -- 对手账户产品编号
    ,cntpty_acct_id varchar2(100) -- 对手账户编号
    ,cntpty_acct_curr_cd varchar2(30) -- 对手账户币种代码
    ,cntpty_bank_name varchar2(500) -- 对手银行名称
    ,cntpty_bank_no varchar2(30) -- 对手银行行号
    ,cntpty_cust_acct_num varchar2(60) -- 对手客户账号
    ,cntpty_open_acct_org_id varchar2(100) -- 对手开户机构编号
    ,cntpty_tran_flow_num varchar2(100) -- 对手交易流水号
    ,cntpty_equvl_amt number(30,2) -- 对手等值金额
    ,cntpty_curr_cd varchar2(30) -- 对手币种代码
    ,cntpty_tran_ref_no varchar2(60) -- 对方交易参考号
    ,avl_way_cd varchar2(30) -- 到账方式代码
    ,loan_num varchar2(60) -- 贷款号
    ,public_agent_name varchar2(500) -- 代办人名称
    ,public_agent_tel_num varchar2(60) -- 代办人电话号码
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,revs_dt date -- 冲正日期
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,revs_tran_cd varchar2(30) -- 冲正交易码
    ,revs_flg varchar2(10) -- 冲正标志
    ,bal_type_cd varchar2(30) -- 钞汇余额代码
    ,attach_rgst_dep_flg varchar2(10) -- 补登存标志
    ,curr_cd varchar2(30) -- 币种代码
    ,check_entry_code varchar2(60) -- 对账编码
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,fxq_tran_dt date -- 反洗钱交易日期
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,core_flow_num varchar2(200) -- 核心流水号
    ,belong_module varchar2(30) -- 所属模块
    ,src_sys_cd varchar2(30) -- 来源系统代码
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
grant select on ${iml_schema}.evt_loan_fin_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_loan_fin_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_loan_fin_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_fin_tran_flow is '贷款金融交易流水';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cap_froz_flow_num is '资金冻结流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.main_evt_cls_cd is '主事件分类代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.main_tran_seq_num is '主交易序号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.inter_bus_type_cd is '中间业务类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.exch_rat_type_cd is '汇率类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.wdraw_way_cd is '支取方式代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.sob_cate_cd is '账套类别代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.acct_name is '账户名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.prior_level is '优先等级';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.camp_prod_name is '营销产品名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.camp_prod_id is '营销产品编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bus_tran_batch_no is '业务交易批次号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bus_proc_status_cd is '业务处理状态代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.vtual_acct_flg is '虚户标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.lmt_code is '限额编码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cash_proj_cd is '现金项目代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cash_tran_flg is '现金交易标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cross_amt is '套算金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.actl_bal is '实际余额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.actl_cross_exch_rat is '实际交叉汇率';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.chn_sub_flow_num is '渠道子流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.begin_curr_cd is '起始币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.seller_quot_type_cd is '卖方牌价类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.seller_exch_rat_val is '卖方汇率值';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.seller_exch_rat_cls_cd is '卖方汇率分类代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.sell_amt is '卖出金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.sell_curr_cd is '卖出币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.buy_amt is '买入金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.buyer_quot_type_cd is '买方牌价类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.buyer_exch_rat_val is '买方汇率值';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.buyer_exch_rat_cls_cd is '买方汇率分类代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cust_econ_type_cd is '客户经济类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.amt_calc_type_cd is '金额计算类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_kind_cd is '交易种类代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_comnt is '交易说明';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bef_tran_bal is '交易前余额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_cd is '交易码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_postsc is '交易附言';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.payment_corp_name is '交款单位名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cross_exch_rat is '交叉汇率';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.base_equvl_amt is '基础等值金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.exch_rat_cls_cd is '汇率分类代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.callbk_id is '回收编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.follow_id is '跟踪编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.serv_fee_flg is '服务费标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_acct_sub_acct_num is '对手账户子账号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_acct_name is '对手账户名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_acct_prod_id is '对手账户产品编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_acct_id is '对手账户编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_acct_curr_cd is '对手账户币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_bank_name is '对手银行名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_bank_no is '对手银行行号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_cust_acct_num is '对手客户账号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_open_acct_org_id is '对手开户机构编号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_tran_flow_num is '对手交易流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_equvl_amt is '对手等值金额';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_curr_cd is '对手币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cntpty_tran_ref_no is '对方交易参考号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.avl_way_cd is '到账方式代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.loan_num is '贷款号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.public_agent_name is '代办人名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.public_agent_tel_num is '代办人电话号码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.revs_dt is '冲正日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.revs_flow_num is '冲正流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.revs_tran_cd is '冲正交易码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bal_type_cd is '钞汇余额代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.attach_rgst_dep_flg is '补登存标志';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.check_entry_code is '对账编码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.fxq_tran_dt is '反洗钱交易日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.belong_module is '所属模块';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.src_sys_cd is '来源系统代码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_fin_tran_flow.etl_timestamp is 'ETL处理时间戳';
