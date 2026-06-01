/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_fin_tran_flow_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_dep_fin_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_fin_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_fin_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_fin_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,tran_ref_no -- 交易参考号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,bus_prod_id -- 业务产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,sub_acct_id -- 子账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_status_cd -- 账户状态代码
    ,vtual_acct_flg -- 虚户标志
    ,cash_tran_flg -- 现金交易标志
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,evt_cate_id -- 事件类别编号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,debit_crdt_flg -- 借贷标志
    ,tran_curr_cd -- 交易币种代码
    ,tran_cd -- 交易码
    ,tran_descb -- 交易描述
    ,bef_tran_bal -- 交易前余额
    ,tran_amt -- 交易金额
    ,actl_bal -- 实际余额
    ,tran_kind_cd -- 交易种类代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_acct_curr_cd -- 交易对手账户币种代码
    ,cntpty_sub_acct_num -- 交易对手子账号
    ,cap_froz_flow_num -- 资金冻结流水号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_unionpay_num -- 交易对手银联号
    ,cntpty_bank_name -- 交易对手银行名称
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,real_cntpty_fin_inst_id -- 真实交易对手金融机构编号
    ,real_cntpty_fin_inst_name -- 交易对手行名
    ,real_cntpty_acct_type_cd -- 真实交易对手产品编号
    ,real_cntpty_acct_id -- 真实交易对手账户编号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,begin_curr_cd -- 起始币种代码
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,aim_curr_cd -- 目的币种代码
    ,buy_amt -- 买入金额
    ,sell_amt -- 卖出金额
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,cash_proj_cd -- 现金项目代码
    ,amt_calc_type_cd -- 金额计算类型代码
    ,chn_id -- 渠道编号
    ,src_chn_id -- 源渠道编号
    ,amt_type_cd -- 金额类型代码
    ,bal_type_cd -- 钞汇余额代码
    ,base_equvl_amt -- 基础等值金额
    ,offset_exch_rat -- 平盘汇率
    ,cross_exch_rat -- 交叉汇率
    ,buyer_exch_rat_cls_cd -- 买方汇率分类代码
    ,buyer_exch_rat_val -- 买方汇率值
    ,actl_cross_exch_rat -- 实际交叉汇率
    ,seller_exch_rat_cls_cd -- 卖方汇率分类代码
    ,seller_exch_rat_val -- 卖方汇率值
    ,inter_bus_type_cd -- 中间业务类型代码
    ,finc_type_cd -- 理财类型代码
    ,quot_type_cd -- 牌价类型代码
    ,med_flg -- 介质标志
    ,med_type_cd -- 介质类型代码
    ,bus_cls_cd -- 业务分类代码
    ,cntpty_cert_type_cd -- 交易对手证件类型代码
    ,attach_rgst_dep_flg -- 补登存标志
    ,main_evt_cls_cd -- 主事件分类代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,avl_way_cd -- 到账方式代码
    ,wdraw_way_cd -- 支取方式代码
    ,bus_tran_batch_no -- 业务交易批次号
    ,bank_tran_seq_num -- 银行交易序号
    ,agent_tel_num -- 代理人电话号码
    ,cust_name -- 客户名称
    ,lmt_code -- 限额编码
    ,cntpty_fin_inst_dist_cd -- 交易对手金融机构行政区划代码
    ,cntpty_cert_no -- 交易对手证件号码
    ,real_cntpty_fin_inst_dist_cd -- 真实交易对手金融机构行政区划代码
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,tran_happ_site -- 交易发生地点
    ,real_tran_happ_site -- 真实交易发生地点
    ,cntpty_name -- 交易对手名称
    ,real_cntpty_name -- 真实交易对手名称
    ,payment_corp_name -- 交款单位名称
    ,prior_level -- 优先等级
    ,seller_quot_type_cd -- 卖方牌价类型代码
    ,chn_dt -- 渠道日期
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,bill_num -- 票据号码
    ,sob_cate_cd -- 账套类别代码
    ,tran_postsc -- 交易附言
    ,bus_proc_status_cd -- 业务处理状态代码
    ,auto_revs_flg -- 自动冲正标志
    ,cntpty_equvl_amt -- 交易对手等值金额
    ,tran_post_bal_add_finc -- 交易后余额加理财
    ,free_serv_fee_flg -- 免服务费标志
    ,tran_public_agent_name -- 交易代办人名称
    ,src_module_type_cd -- 源模块类型代码
    ,effect_dt -- 生效日期
    ,revs_flow_num -- 冲正流水号
    ,tran_termn_id -- 交易终端编号
    ,follow_id -- 跟踪编号
    ,revs_tran_cd -- 冲正交易码
    ,revs_flg -- 冲正标志
    ,revs_dt -- 冲正日期
    ,clear_dt -- 清算日期
    ,post_flg -- 过账标志
    ,memo_code -- 摘要码
    ,tran_memo_descb -- 交易摘要描述
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,init_tran_tm -- 原交易时间
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,beps_unpasew_flg -- 小额免密标志
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账码
    ,tran_id -- 交易编号
    ,prpery_sys_code -- 来源系统编号
    ,cash_from_cd -- 现钞来源代码
    ,cash_usage_cd -- 现钞提取用途代码
    ,cash_from_cty_rg_cd -- 现钞来源国家地区代码
    ,cash_to_cty_rg_cd -- 现钞去向国家地区代码
    ,old_core_memo_code -- 旧核心摘要码
    ,subj_id -- 科目编号
    ,cust_type_cd -- 客户类型代码
    ,obank_tran_dt -- 他行交易日期
    ,check_vouch_draw_dt -- 支票凭证出票日期
    ,belong_module -- 所属模块
    ,loan_prod_id -- 贷款产品编号
    ,remark -- 备注
    ,init_chn_flow_num -- 原渠道流水号
    ,trdpty_bus_type_cd -- 第三方业务类型代码
    ,camp_prod_name -- 营销产品名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_fin_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_tran_hist-1
insert into ${iml_schema}.evt_dep_fin_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,tran_ref_no -- 交易参考号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,bus_prod_id -- 业务产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,sub_acct_id -- 子账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_status_cd -- 账户状态代码
    ,vtual_acct_flg -- 虚户标志
    ,cash_tran_flg -- 现金交易标志
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,evt_cate_id -- 事件类别编号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,debit_crdt_flg -- 借贷标志
    ,tran_curr_cd -- 交易币种代码
    ,tran_cd -- 交易码
    ,tran_descb -- 交易描述
    ,bef_tran_bal -- 交易前余额
    ,tran_amt -- 交易金额
    ,actl_bal -- 实际余额
    ,tran_kind_cd -- 交易种类代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_acct_curr_cd -- 交易对手账户币种代码
    ,cntpty_sub_acct_num -- 交易对手子账号
    ,cap_froz_flow_num -- 资金冻结流水号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_unionpay_num -- 交易对手银联号
    ,cntpty_bank_name -- 交易对手银行名称
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,real_cntpty_fin_inst_id -- 真实交易对手金融机构编号
    ,real_cntpty_fin_inst_name -- 交易对手行名
    ,real_cntpty_acct_type_cd -- 真实交易对手产品编号
    ,real_cntpty_acct_id -- 真实交易对手账户编号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,begin_curr_cd -- 起始币种代码
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,aim_curr_cd -- 目的币种代码
    ,buy_amt -- 买入金额
    ,sell_amt -- 卖出金额
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,cash_proj_cd -- 现金项目代码
    ,amt_calc_type_cd -- 金额计算类型代码
    ,chn_id -- 渠道编号
    ,src_chn_id -- 源渠道编号
    ,amt_type_cd -- 金额类型代码
    ,bal_type_cd -- 钞汇余额代码
    ,base_equvl_amt -- 基础等值金额
    ,offset_exch_rat -- 平盘汇率
    ,cross_exch_rat -- 交叉汇率
    ,buyer_exch_rat_cls_cd -- 买方汇率分类代码
    ,buyer_exch_rat_val -- 买方汇率值
    ,actl_cross_exch_rat -- 实际交叉汇率
    ,seller_exch_rat_cls_cd -- 卖方汇率分类代码
    ,seller_exch_rat_val -- 卖方汇率值
    ,inter_bus_type_cd -- 中间业务类型代码
    ,finc_type_cd -- 理财类型代码
    ,quot_type_cd -- 牌价类型代码
    ,med_flg -- 介质标志
    ,med_type_cd -- 介质类型代码
    ,bus_cls_cd -- 业务分类代码
    ,cntpty_cert_type_cd -- 交易对手证件类型代码
    ,attach_rgst_dep_flg -- 补登存标志
    ,main_evt_cls_cd -- 主事件分类代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,avl_way_cd -- 到账方式代码
    ,wdraw_way_cd -- 支取方式代码
    ,bus_tran_batch_no -- 业务交易批次号
    ,bank_tran_seq_num -- 银行交易序号
    ,agent_tel_num -- 代理人电话号码
    ,cust_name -- 客户名称
    ,lmt_code -- 限额编码
    ,cntpty_fin_inst_dist_cd -- 交易对手金融机构行政区划代码
    ,cntpty_cert_no -- 交易对手证件号码
    ,real_cntpty_fin_inst_dist_cd -- 真实交易对手金融机构行政区划代码
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,tran_happ_site -- 交易发生地点
    ,real_tran_happ_site -- 真实交易发生地点
    ,cntpty_name -- 交易对手名称
    ,real_cntpty_name -- 真实交易对手名称
    ,payment_corp_name -- 交款单位名称
    ,prior_level -- 优先等级
    ,seller_quot_type_cd -- 卖方牌价类型代码
    ,chn_dt -- 渠道日期
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,bill_num -- 票据号码
    ,sob_cate_cd -- 账套类别代码
    ,tran_postsc -- 交易附言
    ,bus_proc_status_cd -- 业务处理状态代码
    ,auto_revs_flg -- 自动冲正标志
    ,cntpty_equvl_amt -- 交易对手等值金额
    ,tran_post_bal_add_finc -- 交易后余额加理财
    ,free_serv_fee_flg -- 免服务费标志
    ,tran_public_agent_name -- 交易代办人名称
    ,src_module_type_cd -- 源模块类型代码
    ,effect_dt -- 生效日期
    ,revs_flow_num -- 冲正流水号
    ,tran_termn_id -- 交易终端编号
    ,follow_id -- 跟踪编号
    ,revs_tran_cd -- 冲正交易码
    ,revs_flg -- 冲正标志
    ,revs_dt -- 冲正日期
    ,clear_dt -- 清算日期
    ,post_flg -- 过账标志
    ,memo_code -- 摘要码
    ,tran_memo_descb -- 交易摘要描述
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,init_tran_tm -- 原交易时间
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,beps_unpasew_flg -- 小额免密标志
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账码
    ,tran_id -- 交易编号
    ,prpery_sys_code -- 来源系统编号
    ,cash_from_cd -- 现钞来源代码
    ,cash_usage_cd -- 现钞提取用途代码
    ,cash_from_cty_rg_cd -- 现钞来源国家地区代码
    ,cash_to_cty_rg_cd -- 现钞去向国家地区代码
    ,old_core_memo_code -- 旧核心摘要码
    ,subj_id -- 科目编号
    ,cust_type_cd -- 客户类型代码
    ,obank_tran_dt -- 他行交易日期
    ,check_vouch_draw_dt -- 支票凭证出票日期
    ,belong_module -- 所属模块
    ,loan_prod_id -- 贷款产品编号
    ,remark -- 备注
    ,init_chn_flow_num -- 原渠道流水号
    ,trdpty_bus_type_cd -- 第三方业务类型代码
    ,camp_prod_name -- 营销产品名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101066'||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 交易流水号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 业务产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.SUB_ACCT_NO -- 子账户编号
    ,nvl(trim(P1.ACCT_CLASS),'-') -- 账户类型代码
    ,P1.ACCT_STATUS -- 账户状态代码
    ,decode(trim(P1.ACCT_REAL_FLAG),'','-','Y','1','N','0',P1.ACCT_REAL_FLAG) -- 虚户标志
    ,decode(trim(P1.ACCT_TRAN_FLAG),'','-','M','1','T','0',P1.ACCT_TRAN_FLAG) -- 现金交易标志
    ,P1.ACCT_DESC -- 账户名称
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.CR_DR_IND -- 借贷标志
    ,P1.CCY -- 交易币种代码
    ,coalesce(trim(P1.OLD_DATA_REMARK),trim(p1.tran_type),'-') -- 交易码
    ,P1.TRAN_DESC -- 交易描述
    ,P1.PREVIOUS_BAL_AMT -- 交易前余额
    ,P1.TRAN_AMT -- 交易金额
    ,P1.ACTUAL_BAL -- 实际余额
    ,nvl(trim(P1.TRAN_CATEGORY),'XXX') -- 交易种类代码
    ,P1.OTH_REFERENCE -- 交易对手交易参考号
    ,P1.OTH_INTERNAL_KEY -- 交易对手账户编号
    ,nvl(trim(p9.card_no),p1.OTH_BASE_ACCT_NO) -- 交易对手客户账号
    ,nvl(trim(P1.OTH_ACCT_CCY),'-') -- 交易对手账户币种代码
    ,P1.OTH_ACCT_SEQ_NO -- 交易对手子账号
    ,P1.FH_SEQ_NO -- 资金冻结流水号
    ,P1.OTH_PROD_TYPE -- 交易对手账户产品编号
    ,P1.OTH_ACCT_DESC -- 交易对手账户名称
    ,P1.OTH_BANK_CODE -- 交易对手银联号
    ,P1.OTH_BANK_NAME -- 交易对手银行名称
    ,P1.OTH_BRANCH -- 交易对手开户机构编号
    ,P1.OTH_REAL_BANK_CODE -- 真实交易对手金融机构编号
    ,P1.OTH_REAL_BANK_NAME -- 交易对手行名
    ,P1.OTH_REAL_PROD_TYPE -- 真实交易对手产品编号
    ,nvl(trim(p10.card_no),p1.OTH_REAL_BASE_ACCT_NO) -- 真实交易对手账户编号
    ,nvl(trim(P1.CONTRA_ACCT_CCY),'-') -- 交易对手币种代码
    ,nvl(trim(P1.FROM_CCY),'-') -- 起始币种代码
    ,P1.OTH_SEQ_NO -- 交易对手交易流水号
    ,nvl(trim(P1.TO_CCY),'-') -- 目的币种代码
    ,P1.FROM_AMOUNT -- 买入金额
    ,P1.TO_AMOUNT -- 卖出金额
    ,nvl(trim(P1.DOC_TYPE),'999') -- 凭证类型代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,nvl(trim(P1.CASH_ITEM),'-') -- 现金项目代码
    ,P1.AMT_CALC_TYPE -- 金额计算类型代码
    ,nvl(trim(P1.CHANNEL),'-') -- 渠道编号
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 源渠道编号
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,nvl(trim(P1.BAL_TYPE),'-') -- 钞汇余额代码
    ,P1.BASE_EQUIV_AMT -- 基础等值金额
    ,P1.FLAT_RATE -- 平盘汇率
    ,P1.CROSS_RATE -- 交叉汇率
    ,nvl(trim(P1.FROM_RATE_FLAG),'-') -- 买方汇率分类代码
    ,P1.FROM_XRATE -- 买方汇率值
    ,P1.OV_CROSS_RATE -- 实际交叉汇率
    ,nvl(trim(P1.TO_RATE_FLAG),'-') -- 卖方汇率分类代码
    ,P1.TO_XRATE -- 卖方汇率值
    ,nvl(trim(P1.BIZ_TYPE),'-') -- 中间业务类型代码
    ,nvl(trim(P1.FIN_TYPE),'-') -- 理财类型代码
    ,nvl(trim(P1.QUOTE_TYPE),'-') -- 牌价类型代码
    ,decode(trim(P1.MEDIUM_FLAG),'','-','Y','1','N','0',P1.MEDIUM_FLAG) -- 介质标志
    ,nvl(trim(P1.MEDIUM_TYPE),'-') -- 介质类型代码
    ,nvl(trim(P1.ORIG_SYSTEM),'-') -- 业务分类代码
    ,nvl(trim(P1.OTH_DOCUMENT_TYPE),'0000') -- 交易对手证件类型代码
    ,decode(trim(P1.PBK_UPD_FLAG),'','-','Y','1','N','0',P1.PBK_UPD_FLAG) -- 补登存标志
    ,nvl(trim(P1.PRIMARY_EVENT_TYPE),'-') -- 主事件分类代码
    ,nvl(trim(P1.RATE_TYPE),'-') -- 汇率类型代码
    ,nvl(trim(P1.TRAN_METHOD),'-') -- 到账方式代码
    ,nvl(trim(P1.WITHDRAWAL_TYPE),'-') -- 支取方式代码
    ,P1.BATCH_NO -- 业务交易批次号
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,P1.COMMISSION_CLIENT_TEL -- 代理人电话号码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.LIMIT_REF -- 限额编码
    ,nvl(trim(P1.OTH_BRANCH_REGIONALISM_CODE),'000000') -- 交易对手金融机构行政区划代码
    ,P1.OTH_DOCUMENT_ID -- 交易对手证件号码
    ,nvl(trim(P1.OTH_REAL_BRANCH_REGION_CODE),'000000') -- 真实交易对手金融机构行政区划代码
    ,P1.OTH_REAL_DOCUMENT_ID -- 真实交易对手证件号码
    ,nvl(trim(P1.OTH_REAL_DOCUMENT_TYPE),'0000') -- 真实交易对手证件类型代码
    ,P1.OTH_TRAN_ADDR -- 交易发生地点
    ,P1.OTH_REAL_TRAN_ADDR -- 真实交易发生地点
    ,P1.OTH_TRAN_NAME -- 交易对手名称
    ,P1.OTH_REAL_TRAN_NAME -- 真实交易对手名称
    ,P1.PAY_UNIT -- 交款单位名称
    ,P1.PRIORITY -- 优先等级
    ,nvl(trim(P1.TO_ID),'-') -- 卖方牌价类型代码
    ,P1.CHANNEL_DATE -- 渠道日期
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,P1.BILL_NO -- 票据号码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类别代码
    ,P1.TRAN_NOTE -- 交易附言
    ,nvl(trim(P1.TRAN_STATUS),'-') -- 业务处理状态代码
    ,decode(trim(P1.AUTO_REVERSAL_FLAG),'','-','Y','1','N','0',P1.AUTO_REVERSAL_FLAG)  -- 自动冲正标志
    ,P1.CONTRA_EQUIV_AMT -- 交易对手等值金额
    ,P1.ACTUAL_BAL_AMT_FIN -- 交易后余额加理财
    ,DECODE(P1.SERV_CHARGE,'Y','1','N','0') -- 免服务费标志
    ,P1.COMMISSION_CLIENT_NAME -- 交易代办人名称
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.REVERSAL_SEQ_NO -- 冲正流水号
    ,P1.TERMINAL_ID -- 交易终端编号
    ,P1.TRACE_ID -- 跟踪编号
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,DECODE(P1.REVERSAL_FLAG,'Y','1','N','0') -- 冲正标志
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.SETTLEMENT_DATE -- 清算日期
    ,decode(trim(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.NARRATIVE_CODE -- 摘要码
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.ORIG_TRAN_TIMESTAMP,':','.',20,1)) -- 原交易时间
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,decode(trim(P1.PI_FLAG),'','-','Y','1','N','0',P1.PI_FLAG) -- 小额免密标志
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.REACCOUNT_CD -- 对账码
    ,P1.PROGRAM_ID -- 交易编号
    ,P1.SYSTEM_CODE -- 来源系统编号
    ,nvl(trim(p1.cash_from_code),'-') -- 现钞来源代码
    ,nvl(trim(p1.cash_to_code),'-') -- 现钞提取用途代码
    ,nvl(trim(p1.cash_from_country),'XXX') -- 现钞来源国家地区代码
    ,nvl(trim(p1.cash_to_country),'XXX') -- 现钞去向国家地区代码
    ,nvl(trim(P1.OLD_DATA_REMARK),'-') -- 旧核心摘要码
    ,P1.GL_CODE -- 科目编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.CONTRA_TRAN_DATE -- 他行交易日期
    ,P1.CHEQUE_DATE -- 支票凭证出票日期
    ,P1.MAIN_SOURCE_MODULE -- 所属模块
    ,P1.LOAN_PROD_TYPE -- 贷款产品编号
    ,P1.REMARK -- 备注
    ,P1.ORIG_CHANNEL_SEQ_NO -- 原渠道流水号
    ,P1.THIRD_BUS_TYPE -- 第三方业务类型代码
    ,P1.MARKETING_PROD_DESC -- 营销产品名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_tran_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_tran_hist p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no and p8.base_acct_no like '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.OTH_BASE_ACCT_NO = p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p10 on p1.OTH_REAL_BASE_ACCT_NO = p10.BASE_ACCT_NO and p10.BASE_ACCT_NO LIKE '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND  R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_TRAN_HIST'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_DEP_FIN_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
    and p1.tran_date = to_date('${batch_date}','yyyymmdd')     
     and p1.ETL_DT=to_date('${batch_date}','yyyymmdd')  
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_fin_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_fin_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_fin_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_fin_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_fin_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_fin_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);