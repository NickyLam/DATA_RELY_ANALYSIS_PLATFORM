/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl evt_dep_fin_tran_flow
CreateDate: 20221107
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.evt_dep_fin_tran_flow purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.evt_dep_fin_tran_flow(
etl_dt date --ETL处理日期
,evt_id varchar2(250) --事件编号
,lp_id varchar2(100) --法人编号
,tran_flow_num varchar2(100) --交易流水号
,ova_flow_num varchar2(100) --全局流水号
,core_flow_num varchar2(100) --核心流水号
,tran_ref_no varchar2(60) --交易参考号
,acct_id varchar2(100) --账户编号
,cust_acct_num varchar2(60) --客户账号
,bus_prod_id varchar2(100) --业务产品编号
,acct_curr_cd varchar2(30) --账户币种代码
,sub_acct_num varchar2(60) --子账号
,sub_acct_id varchar2(100) --子账户编号
,acct_type_cd varchar2(30) --账户类型代码
,acct_status_cd varchar2(30) --账户状态代码
,vtual_acct_flg varchar2(10) --虚户标志
,cash_tran_flg varchar2(10) --现金交易标志
,acct_name varchar2(500) --账户名称
,open_acct_org_id varchar2(100) --开户机构编号
,evt_cate_id varchar2(100) --事件类别编号
,tran_dt date --交易日期
,tran_org_id varchar2(100) --交易机构编号
,debit_crdt_flg varchar2(10) --借贷标志
,tran_curr_cd varchar2(30) --交易币种代码
,tran_cd varchar2(30) --交易码
,tran_descb varchar2(500) --交易描述
,bef_tran_bal number(30,2) --交易前余额
,tran_amt number(30,2) --交易金额
,actl_bal number(30,2) --实际余额
,tran_kind_cd varchar2(30) --交易种类代码
,cntpty_tran_ref_no varchar2(60) --交易对手交易参考号
,cntpty_acct_id varchar2(100) --交易对手账户编号
,cntpty_cust_acct_num varchar2(60) --交易对手客户账号
,cntpty_acct_curr_cd varchar2(30) --交易对手账户币种代码
,cntpty_sub_acct_num varchar2(60) --交易对手子账号
,cap_froz_flow_num varchar2(100) --资金冻结流水号
,cntpty_acct_prod_id varchar2(100) --交易对手账户产品编号
,cntpty_acct_name varchar2(1000) --交易对手账户名称
,cntpty_unionpay_num varchar2(60) --交易对手银联号
,cntpty_bank_name varchar2(500) --交易对手银行名称
,cntpty_open_acct_org_id varchar2(100) --交易对手开户机构编号
,real_cntpty_fin_inst_id varchar2(100) --真实交易对手金融机构编号
,real_cntpty_fin_inst_name varchar2(500) --交易对手行名
,real_cntpty_acct_type_cd varchar2(30) --真实交易对手账户类型代码
,real_cntpty_acct_id varchar2(100) --真实交易对手账户编号
,cntpty_curr_cd varchar2(30) --交易对手币种代码
,begin_curr_cd varchar2(30) --起始币种代码
,cntpty_tran_flow_num varchar2(100) --交易对手交易流水号
,aim_curr_cd varchar2(30) --目的币种代码
,buy_amt number(30,2) --买入金额
,sell_amt number(30,2) --卖出金额
,vouch_type_cd varchar2(30) --凭证类型代码
,vouch_no varchar2(60) --凭证号码
,cash_proj_cd varchar2(30) --现金项目代码
,amt_calc_type_cd varchar2(30) --金额计算类型代码
,chn_id varchar2(100) --渠道编号
,amt_type_cd varchar2(30) --金额类型代码
,bal_type_cd varchar2(30) --钞汇余额代码
,base_equvl_amt number(30,2) --基础等值金额
,offset_exch_rat number(18,8) --平盘汇率
,cross_exch_rat number(18,8) --交叉汇率
,buyer_exch_rat_cls_cd varchar2(30) --买方汇率分类代码
,buyer_exch_rat_val number(18,8) --买方汇率值
,actl_cross_exch_rat number(18,8) --实际交叉汇率
,seller_exch_rat_cls_cd varchar2(30) --卖方汇率分类代码
,seller_exch_rat_val number(18,8) --卖方汇率值
,inter_bus_type_cd varchar2(30) --中间业务类型代码
,finc_type_cd varchar2(30) --理财类型代码
,quot_type_cd varchar2(30) --牌价类型代码
,med_flg varchar2(10) --介质标志
,med_type_cd varchar2(30) --介质类型代码
,bus_cls_cd varchar2(30) --业务分类代码
,cntpty_cert_type_cd varchar2(30) --交易对手证件类型代码
,attach_rgst_dep_flg varchar2(10) --补登存标志
,main_evt_cls_cd varchar2(30) --主事件分类代码
,exch_rat_type_cd varchar2(30) --汇率类型代码
,avl_way_cd varchar2(30) --到账方式代码
,wdraw_way_cd varchar2(30) --支取方式代码
,bus_tran_batch_no varchar2(60) --业务交易批次号
,bank_tran_seq_num varchar2(60) --银行交易序号
,agent_tel_num varchar2(60) --代理人电话号码
,cust_name varchar2(500) --客户名称
,lmt_code varchar2(500) --限额编码
,cntpty_fin_inst_dist_cd varchar2(30) --交易对手金融机构行政区划代码
,cntpty_cert_no varchar2(60) --交易对手证件号码
,real_cntpty_fin_inst_dist_cd varchar2(30) --真实交易对手金融机构行政区划代码
,real_cntpty_cert_no varchar2(60) --真实交易对手证件号码
,real_cntpty_cert_type_cd varchar2(30) --真实交易对手证件类型代码
,tran_happ_site varchar2(500) --交易发生地点
,real_tran_happ_site varchar2(500) --真实交易发生地点
,cntpty_name varchar2(500) --交易对手名称
,real_cntpty_name varchar2(500) --真实交易对手名称
,payment_corp_name varchar2(500) --交款单位名称
,prior_level varchar2(30) --优先等级
,seller_quot_type_cd varchar2(30) --卖方牌价类型代码
,chn_dt date --渠道日期
,cust_id varchar2(100) --客户编号
,cert_no varchar2(60) --证件号码
,cert_type_cd varchar2(30) --证件类型代码
,bill_num varchar2(60) --票据号码
,sob_cate_cd varchar2(30) --账套类别代码
,tran_postsc varchar2(500) --交易附言
,bus_proc_status_cd varchar2(30) --业务处理状态代码
,auto_revs_flg varchar2(10) --自动冲正标志
,cntpty_equvl_amt number(30,2) --交易对手等值金额
,tran_post_bal_add_finc number(30,2) --交易后余额加理财
,free_serv_fee_flg varchar2(10) --免服务费标志
,tran_public_agent_name varchar2(500) --交易代办人名称
,src_module_type_cd varchar2(30) --源模块类型代码
,effect_dt date --生效日期
,revs_flow_num varchar2(100) --冲正流水号
,tran_termn_id varchar2(100) --交易终端编号
,follow_id varchar2(100) --跟踪编号
,revs_tran_cd varchar2(30) --冲正交易码
,revs_flg varchar2(10) --冲正标志
,revs_dt date --冲正日期
,clear_dt date --清算日期
,post_flg varchar2(10) --过账标志
,memo_code varchar2(60) --摘要码
,tran_memo_descb varchar2(500) --交易摘要描述
,check_teller_id varchar2(100) --复核柜员编号
,auth_teller_id varchar2(100) --授权柜员编号
,init_tran_tm timestamp(6) --原交易时间
,tran_tm timestamp(6) --交易时间
,tran_teller_id varchar2(100) --交易柜员编号
,beps_unpasew_flg varchar2(10) --小额免密标志
,bus_flow_num varchar2(100) --业务流水号
,check_entry_cd varchar2(30) --对账代码
,tran_id varchar2(100) --交易编号
,prpery_sys_code varchar2(250) --来源系统编号
,src_table_name varchar2(100) --源表名称

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.evt_dep_fin_tran_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.evt_dep_fin_tran_flow is '存款金融交易流水';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.evt_id is '事件编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.lp_id is '法人编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.ova_flow_num is '全局流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.core_flow_num is '核心流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_ref_no is '交易参考号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.acct_id is '账户编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cust_acct_num is '客户账号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bus_prod_id is '业务产品编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.acct_curr_cd is '账户币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.sub_acct_num is '子账号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.sub_acct_id is '子账户编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.vtual_acct_flg is '虚户标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cash_tran_flg is '现金交易标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.acct_name is '账户名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.evt_cate_id is '事件类别编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_dt is '交易日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.debit_crdt_flg is '借贷标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_cd is '交易码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_descb is '交易描述';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bef_tran_bal is '交易前余额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_amt is '交易金额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.actl_bal is '实际余额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_kind_cd is '交易种类代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_tran_ref_no is '交易对手交易参考号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_cust_acct_num is '交易对手客户账号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_acct_curr_cd is '交易对手账户币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_sub_acct_num is '交易对手子账号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cap_froz_flow_num is '资金冻结流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_acct_prod_id is '交易对手账户产品编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_acct_name is '交易对手账户名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_unionpay_num is '交易对手银联号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_bank_name is '交易对手银行名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_open_acct_org_id is '交易对手开户机构编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_fin_inst_id is '真实交易对手金融机构编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_fin_inst_name is '交易对手行名';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_acct_type_cd is '真实交易对手账户类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_acct_id is '真实交易对手账户编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_curr_cd is '交易对手币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.begin_curr_cd is '起始币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_tran_flow_num is '交易对手交易流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.aim_curr_cd is '目的币种代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.buy_amt is '买入金额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.sell_amt is '卖出金额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.vouch_no is '凭证号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cash_proj_cd is '现金项目代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.amt_calc_type_cd is '金额计算类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.chn_id is '渠道编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.amt_type_cd is '金额类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bal_type_cd is '钞汇余额代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.base_equvl_amt is '基础等值金额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.offset_exch_rat is '平盘汇率';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cross_exch_rat is '交叉汇率';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.buyer_exch_rat_cls_cd is '买方汇率分类代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.buyer_exch_rat_val is '买方汇率值';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.actl_cross_exch_rat is '实际交叉汇率';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.seller_exch_rat_cls_cd is '卖方汇率分类代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.seller_exch_rat_val is '卖方汇率值';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.inter_bus_type_cd is '中间业务类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.finc_type_cd is '理财类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.quot_type_cd is '牌价类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.med_flg is '介质标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.med_type_cd is '介质类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bus_cls_cd is '业务分类代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_cert_type_cd is '交易对手证件类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.attach_rgst_dep_flg is '补登存标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.main_evt_cls_cd is '主事件分类代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.exch_rat_type_cd is '汇率类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.avl_way_cd is '到账方式代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.wdraw_way_cd is '支取方式代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bus_tran_batch_no is '业务交易批次号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.agent_tel_num is '代理人电话号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cust_name is '客户名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.lmt_code is '限额编码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_fin_inst_dist_cd is '交易对手金融机构行政区划代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_cert_no is '交易对手证件号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_fin_inst_dist_cd is '真实交易对手金融机构行政区划代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_cert_no is '真实交易对手证件号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_cert_type_cd is '真实交易对手证件类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_happ_site is '交易发生地点';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_tran_happ_site is '真实交易发生地点';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_name is '交易对手名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.real_cntpty_name is '真实交易对手名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.payment_corp_name is '交款单位名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.prior_level is '优先等级';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.seller_quot_type_cd is '卖方牌价类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.chn_dt is '渠道日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cust_id is '客户编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cert_no is '证件号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bill_num is '票据号码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.sob_cate_cd is '账套类别代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_postsc is '交易附言';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bus_proc_status_cd is '业务处理状态代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.auto_revs_flg is '自动冲正标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.cntpty_equvl_amt is '交易对手等值金额';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_post_bal_add_finc is '交易后余额加理财';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.free_serv_fee_flg is '免服务费标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_public_agent_name is '交易代办人名称';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.src_module_type_cd is '源模块类型代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.effect_dt is '生效日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.revs_flow_num is '冲正流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.follow_id is '跟踪编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.revs_tran_cd is '冲正交易码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.revs_flg is '冲正标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.revs_dt is '冲正日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.clear_dt is '清算日期';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.post_flg is '过账标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.memo_code is '摘要码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_memo_descb is '交易摘要描述';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.init_tran_tm is '原交易时间';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_tm is '交易时间';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.beps_unpasew_flg is '小额免密标志';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.check_entry_cd is '对账代码';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.tran_id is '交易编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.prpery_sys_code is '来源系统编号';
comment on column ${idl_schema}.evt_dep_fin_tran_flow.src_table_name is '源表名称';

