/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_dep_acct_info
CreateDate: 20210129
Logs:
    郑沛隆 2021-01-29 新建脚本
    郑沛隆 2022-04-18 因新一代改造，根据数仓数据模型更新
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cmm_dep_acct_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_dep_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_dep_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_dep_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_sub_acct_num -- 客户账户子户号
    ,cds_liab_acct_num -- 负债账户编号
    ,old_acct_id -- 旧账户编号
    ,cust_acct_card_no -- 客户账户卡号
    ,cust_id -- 客户编号
    ,subj_id -- 科目编号
    ,int_paybl_subj_id -- 应付利息科目编号
    ,int_paybl_adj_subj_id -- 应付利息调整科目编号
    ,int_expns_subj_id -- 利息支出科目编号
    ,int_expns_adj_subj_id -- 利息支出调整科目编号
    ,dep_kind_cd -- 储种代码
    ,acct_cls_cd -- 账户分类代码
    ,acct_type_cd -- 账户类型代码
    ,acct_attr_cd -- 账户属性代码
    ,dep_term -- 存期
    ,std_prod_id -- 标准产品编号
    ,ext_prod_id -- 外部产品编号
    ,intnal_prod_id -- 内部产品编号
    ,open_oa_apv_form_num -- 开户OA审批单号
    ,approval_id -- 核准件编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,cust_type_cd -- 客户类型代码
    ,corp_acct_flg -- 对公账户标志
    ,stop_pay_status_cd -- 止付状态代码
    ,general_exch_flg -- 通兑标志
    ,general_storage_flg -- 通存标志
    ,advise_dep_flg -- 通知存款标志
    ,agt_dep_flg -- 协议存款标志
    ,float_int_rat_flg -- 浮动利率标志
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,corp_supv_acct_flg -- 对公监管户标志
    ,rc_flg -- 定活标志
    ,margin_flg -- 保证金标志
    ,bill_pool_margin_flg -- 票据池保证金标志
    ,bill_pool_type_cd -- 票据池类型代码
    ,agree_dep_flg -- 协定存款标志
    ,ibank_dep_flg -- 同业存款标志
    ,web_dep_flg -- 网络存款标志
    ,dep_basic_acct_flg -- 存款基本户标志
    ,ec_flg -- 钞汇标志
    ,privavy_acct_flg -- 隐私账户标志
    ,legal_acct_flg -- 涉案账户标志
    ,auto_redt_flg -- 自动转存标志
    ,redted_cnt -- 已转存次数
    ,itg_dep_earliest_drawbl_dt -- 智能存款最早可提支日期
    ,sleep_acct_flg -- 睡眠户标志
    ,dormt_acct_flg -- 不动户标志
    ,long_hang_acct_flg -- 久悬户标志
    ,vtual_acct_flg -- 虚拟账户标志
    ,entry_flg -- 记账标志
    ,mater_acct_flg -- 母户标志
    ,sal_acct_flg -- 工资账户标志
    ,froz_flg -- 冻结标志
    ,advd_draw_flg -- 可提前支取标志
    ,tranbl_flg -- 可转让标志
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cash_flg -- 取现标志
    ,int_set_way_cd -- 结息方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,allow_od_flg -- 允许透支标志
    ,curr_cd -- 币种代码
    ,redt_way_cd -- 转存方式代码
    ,open_acct_chn_type_cd -- 开户渠道类型代码
    ,tran_chn_status_cd -- 交易渠道状态代码
    ,acct_usage_cd -- 账户用途代码
    ,dep_char_cd -- 存款性质代码
    ,open_acct_dt -- 开户日期
    ,open_acct_tm -- 开户时间
    ,open_flow_num -- 开户流水号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,clos_flow_num -- 销户流水号
    ,actv_dt -- 激活日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,final_activ_acct_dt -- 最后动户日期
    ,agree_dep_value_dt -- 协定存款起息日期
    ,agree_dep_exp_dt -- 协定存款到期日期
    ,agree_dep_rels_dt -- 协定存款解约日期
    ,agt_dep_earliest_drawbl_dt -- 协议存款最早可提支日期
    ,froz_dt -- 冻结日期
    ,unfrz_dt -- 解冻日期
    ,last_int_set_dt -- 上次结息日期
    ,next_int_set_dt -- 下次结息日期
    ,fir_value_dt -- 首次起息日期
    ,agree_int_rat -- 协定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,td_acru_int -- 当日应计利息
    ,currt_acru_int -- 当期应计利息
    ,currt_int_paybl_adj -- 当期应付利息调整
    ,td_int_expns -- 当日利息支出
    ,td_int_expns_adj -- 当日利息支出调整
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_teller_id -- 开户柜员编号
    ,clos_acct_teller_id -- 销户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,close_acct_org_id -- 销户机构编号
    ,belong_org_id -- 所属机构编号
    ,loc_flg -- 开立存款证实书标志
    ,expe_higt_yld_rat -- 预期最高收益率
    ,agree_dep_init_amt -- 协定存款起存金额
    ,lowt_bal -- 最低余额
    ,open_acct_amt -- 开户金额
    ,currt_bal -- 当期余额
    ,aval_bal -- 可用余额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,cl_curr_currt_bal -- 折本币当期余额
    ,ear_d_bal -- 日初余额
    ,ear_m_bal -- 月初余额
    ,ear_s_bal -- 季初余额
    ,ear_y_bal -- 年初余额
    ,y_acm_bal -- 年累计余额
    ,s_acm_bal -- 季累计余额
    ,m_acm_bal -- 月累计余额
    ,cl_curr_ear_d_bal -- 折本币日初余额
    ,cl_curr_ear_m_bal -- 折本币月初余额
    ,cl_curr_ear_s_bal -- 折本币季初余额
    ,cl_curr_ear_y_bal -- 折本币年初余额
    ,cl_curr_y_acm_bal -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
    ,y_avg_bal -- 年日均余额
    ,q_avg_bal -- 季日均余额
    ,m_avg_bal -- 月日均余额
    ,cl_curr_y_avg_bal -- 折本币年日均余额
    ,cl_curr_q_avg_bal -- 折本币季日均余额
    ,cl_curr_m_avg_bal -- 折本币月日均余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(cust_acct_id), ' ') as cust_acct_id -- 客户账户编号
    ,nvl(trim(cust_acct_sub_acct_num), ' ') as cust_acct_sub_acct_num -- 客户账户子户号
    ,nvl(trim(cds_liab_acct_num), ' ') as cds_liab_acct_num -- 负债账户编号
    ,nvl(trim(old_acct_id), ' ') as old_acct_id -- 旧账户编号
    ,nvl(trim(cust_acct_card_no), ' ') as cust_acct_card_no -- 客户账户卡号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(subj_id), ' ') as subj_id -- 科目编号
    ,nvl(trim(int_paybl_subj_id), ' ') as int_paybl_subj_id -- 应付利息科目编号
    ,nvl(trim(int_paybl_adj_subj_id), ' ') as int_paybl_adj_subj_id -- 应付利息调整科目编号
    ,nvl(trim(int_expns_subj_id), ' ') as int_expns_subj_id -- 利息支出科目编号
    ,nvl(trim(int_expns_adj_subj_id), ' ') as int_expns_adj_subj_id -- 利息支出调整科目编号
    ,nvl(trim(dep_kind_cd), ' ') as dep_kind_cd -- 储种代码
    ,nvl(trim(acct_cls_cd), ' ') as acct_cls_cd -- 账户分类代码
    ,nvl(trim(acct_type_cd), ' ') as acct_type_cd -- 账户类型代码
    ,nvl(trim(acct_attr_cd), ' ') as acct_attr_cd -- 账户属性代码
    ,nvl(trim(dep_term), ' ') as dep_term -- 存期
    ,nvl(trim(std_prod_id), ' ') as std_prod_id -- 标准产品编号
    ,nvl(trim(ext_prod_id), ' ') as ext_prod_id -- 外部产品编号
    ,nvl(trim(intnal_prod_id), ' ') as intnal_prod_id -- 内部产品编号
    ,nvl(trim(open_oa_apv_form_num), ' ') as open_oa_apv_form_num -- 开户OA审批单号
    ,nvl(trim(approval_id), ' ') as approval_id -- 核准件编号
    ,nvl(trim(dep_acct_status_cd), ' ') as dep_acct_status_cd -- 存款账户状态代码
    ,nvl(trim(cust_type_cd), ' ') as cust_type_cd -- 客户类型代码
    ,nvl(trim(corp_acct_flg), ' ') as corp_acct_flg -- 对公账户标志
    ,nvl(trim(stop_pay_status_cd), ' ') as stop_pay_status_cd -- 止付状态代码
    ,nvl(trim(general_exch_flg), ' ') as general_exch_flg -- 通兑标志
    ,nvl(trim(general_storage_flg), ' ') as general_storage_flg -- 通存标志
    ,nvl(trim(advise_dep_flg), ' ') as advise_dep_flg -- 通知存款标志
    ,nvl(trim(agt_dep_flg), ' ') as agt_dep_flg -- 协议存款标志
    ,nvl(trim(float_int_rat_flg), ' ') as float_int_rat_flg -- 浮动利率标志
    ,nvl(trim(int_rat_float_way_cd), ' ') as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(trim(int_rat_adj_ped_corp_cd), ' ') as int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,nvl(trim(int_rat_adj_ped_freq), 0) as int_rat_adj_ped_freq -- 利率调整周期频率
    ,nvl(trim(corp_supv_acct_flg), ' ') as corp_supv_acct_flg -- 对公监管户标志
    ,nvl(trim(rc_flg), ' ') as rc_flg -- 定活标志
    ,nvl(trim(margin_flg), ' ') as margin_flg -- 保证金标志
    ,nvl(trim(bill_pool_margin_flg), ' ') as bill_pool_margin_flg -- 票据池保证金标志
    ,nvl(trim(bill_pool_type_cd), ' ') as bill_pool_type_cd -- 票据池类型代码
    ,nvl(trim(agree_dep_flg), ' ') as agree_dep_flg -- 协定存款标志
    ,nvl(trim(ibank_dep_flg), ' ') as ibank_dep_flg -- 同业存款标志
    ,nvl(trim(web_dep_flg), ' ') as web_dep_flg -- 网络存款标志
    ,nvl(trim(dep_basic_acct_flg), ' ') as dep_basic_acct_flg -- 存款基本户标志
    ,nvl(trim(ec_flg), ' ') as ec_flg -- 钞汇标志
    ,nvl(trim(privavy_acct_flg), ' ') as privavy_acct_flg -- 隐私账户标志
    ,nvl(trim(legal_acct_flg), ' ') as legal_acct_flg -- 涉案账户标志
    ,nvl(trim(auto_redt_flg), ' ') as auto_redt_flg -- 自动转存标志
    ,nvl(trim(redted_cnt), ' ') as redted_cnt -- 已转存次数
    ,nvl(itg_dep_earliest_drawbl_dt, to_date('00010101', 'yyyymmdd')) as itg_dep_earliest_drawbl_dt -- 智能存款最早可提支日期
    ,nvl(trim(sleep_acct_flg), ' ') as sleep_acct_flg -- 睡眠户标志
    ,nvl(trim(dormt_acct_flg), ' ') as dormt_acct_flg -- 不动户标志
    ,nvl(trim(long_hang_acct_flg), ' ') as long_hang_acct_flg -- 久悬户标志
    ,nvl(trim(vtual_acct_flg), ' ') as vtual_acct_flg -- 虚拟账户标志
    ,nvl(trim(entry_flg), ' ') as entry_flg -- 记账标志
    ,nvl(trim(mater_acct_flg), ' ') as mater_acct_flg -- 母户标志
    ,nvl(trim(sal_acct_flg), ' ') as sal_acct_flg -- 工资账户标志
    ,nvl(trim(froz_flg), ' ') as froz_flg -- 冻结标志
    ,nvl(trim(advd_draw_flg), ' ') as advd_draw_flg -- 可提前支取标志
    ,nvl(trim(tranbl_flg), ' ') as tranbl_flg -- 可转让标志
    ,nvl(trim(int_accr_base_cd), ' ') as int_accr_base_cd -- 计息基准代码
    ,nvl(trim(int_accr_flg), ' ') as int_accr_flg -- 计息标志
    ,nvl(trim(cash_flg), ' ') as cash_flg -- 取现标志
    ,nvl(trim(int_set_way_cd), ' ') as int_set_way_cd -- 结息方式代码
    ,nvl(trim(int_accr_way_cd), ' ') as int_accr_way_cd -- 计息方式代码
    ,nvl(trim(allow_od_flg), ' ') as allow_od_flg -- 允许透支标志
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(redt_way_cd), ' ') as redt_way_cd -- 转存方式代码
    ,nvl(trim(open_acct_chn_type_cd), ' ') as open_acct_chn_type_cd -- 开户渠道类型代码
    ,nvl(trim(tran_chn_status_cd), ' ') as tran_chn_status_cd -- 交易渠道状态代码
    ,nvl(trim(acct_usage_cd), ' ') as acct_usage_cd -- 账户用途代码
    ,nvl(trim(dep_char_cd), ' ') as dep_char_cd -- 存款性质代码
    ,nvl(open_acct_dt, to_date('00010101', 'yyyymmdd')) as open_acct_dt -- 开户日期
    ,nvl(open_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as open_acct_tm -- 开户时间
    ,nvl(trim(open_flow_num), ' ') as open_flow_num -- 开户流水号
    ,nvl(clos_acct_dt, to_date('00010101', 'yyyymmdd')) as clos_acct_dt -- 销户日期
    ,nvl(clos_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as clos_acct_tm -- 销户时间
    ,nvl(trim(clos_flow_num), ' ') as clos_flow_num -- 销户流水号
    ,nvl(actv_dt, to_date('00010101', 'yyyymmdd')) as actv_dt -- 激活日期
    ,nvl(value_dt, to_date('00010101', 'yyyymmdd')) as value_dt -- 起息日期
    ,nvl(exp_dt, to_date('00010101', 'yyyymmdd')) as exp_dt -- 到期日期
    ,nvl(final_activ_acct_dt, to_date('00010101', 'yyyymmdd')) as final_activ_acct_dt -- 最后动户日期
    ,nvl(agree_dep_value_dt, to_date('00010101', 'yyyymmdd')) as agree_dep_value_dt -- 协定存款起息日期
    ,nvl(agree_dep_exp_dt, to_date('00010101', 'yyyymmdd')) as agree_dep_exp_dt -- 协定存款到期日期
    ,nvl(agree_dep_rels_dt, to_date('00010101', 'yyyymmdd')) as agree_dep_rels_dt -- 协定存款解约日期
    ,nvl(agt_dep_earliest_drawbl_dt, to_date('00010101', 'yyyymmdd')) as agt_dep_earliest_drawbl_dt -- 协议存款最早可提支日期
    ,nvl(froz_dt, to_date('00010101', 'yyyymmdd')) as froz_dt -- 冻结日期
    ,nvl(unfrz_dt, to_date('00010101', 'yyyymmdd')) as unfrz_dt -- 解冻日期
    ,nvl(last_int_set_dt, to_date('00010101', 'yyyymmdd')) as last_int_set_dt -- 上次结息日期
    ,nvl(next_int_set_dt, to_date('00010101', 'yyyymmdd')) as next_int_set_dt -- 下次结息日期
    ,nvl(fir_value_dt, to_date('00010101', 'yyyymmdd')) as fir_value_dt -- 首次起息日期
    ,nvl(trim(agree_int_rat), 0) as agree_int_rat -- 协定利率
    ,nvl(trim(base_rat_type_cd), ' ') as base_rat_type_cd -- 基准利率类型代码
    ,nvl(trim(base_rat), 0) as base_rat -- 基准利率
    ,nvl(trim(exec_int_rat), 0) as exec_int_rat -- 执行利率
    ,nvl(trim(td_acru_int), 0) as td_acru_int -- 当日应计利息
    ,nvl(trim(currt_acru_int), 0) as currt_acru_int -- 当期应计利息
    ,nvl(trim(currt_int_paybl_adj), 0) as currt_int_paybl_adj -- 当期应付利息调整
    ,nvl(trim(td_int_expns), 0) as td_int_expns -- 当日利息支出
    ,nvl(trim(td_int_expns_adj), 0) as td_int_expns_adj -- 当日利息支出调整
    ,nvl(trim(cust_mgr_id), ' ') as cust_mgr_id -- 客户经理编号
    ,nvl(trim(open_acct_teller_id), ' ') as open_acct_teller_id -- 开户柜员编号
    ,nvl(trim(clos_acct_teller_id), ' ') as clos_acct_teller_id -- 销户柜员编号
    ,nvl(trim(open_acct_org_id), ' ') as open_acct_org_id -- 开户机构编号
    ,nvl(trim(close_acct_org_id), ' ') as close_acct_org_id -- 销户机构编号
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(loc_flg), ' ') as loc_flg -- 开立存款证实书标志
    ,nvl(trim(expe_higt_yld_rat), 0) as expe_higt_yld_rat -- 预期最高收益率
    ,nvl(trim(agree_dep_init_amt), 0) as agree_dep_init_amt -- 协定存款起存金额
    ,nvl(trim(lowt_bal), 0) as lowt_bal -- 最低余额
    ,nvl(trim(open_acct_amt), 0) as open_acct_amt -- 开户金额
    ,nvl(trim(currt_bal), 0) as currt_bal -- 当期余额
    ,nvl(trim(aval_bal), 0) as aval_bal -- 可用余额
    ,nvl(trim(froz_amt), 0) as froz_amt -- 冻结金额
    ,nvl(trim(stop_pay_amt), 0) as stop_pay_amt -- 止付金额
    ,nvl(trim(cl_curr_currt_bal), 0) as cl_curr_currt_bal -- 折本币当期余额
    ,nvl(trim(ear_d_bal), 0) as ear_d_bal -- 日初余额
    ,nvl(trim(ear_m_bal), 0) as ear_m_bal -- 月初余额
    ,nvl(trim(ear_s_bal), 0) as ear_s_bal -- 季初余额
    ,nvl(trim(ear_y_bal), 0) as ear_y_bal -- 年初余额
    ,nvl(trim(y_acm_bal), 0) as y_acm_bal -- 年累计余额
    ,nvl(trim(s_acm_bal), 0) as s_acm_bal -- 季累计余额
    ,nvl(trim(m_acm_bal), 0) as m_acm_bal -- 月累计余额
    ,nvl(trim(cl_curr_ear_d_bal), 0) as cl_curr_ear_d_bal -- 折本币日初余额
    ,nvl(trim(cl_curr_ear_m_bal), 0) as cl_curr_ear_m_bal -- 折本币月初余额
    ,nvl(trim(cl_curr_ear_s_bal), 0) as cl_curr_ear_s_bal -- 折本币季初余额
    ,nvl(trim(cl_curr_ear_y_bal), 0) as cl_curr_ear_y_bal -- 折本币年初余额
    ,nvl(trim(cl_curr_y_acm_bal), 0) as cl_curr_y_acm_bal -- 折本币年累计余额
    ,nvl(trim(cl_curr_ear_d_y_acm_bal), 0) as cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
    ,nvl(trim(cl_curr_ear_m_y_acm_bal), 0) as cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
    ,nvl(trim(cl_curr_ear_s_y_acm_bal), 0) as cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
    ,nvl(trim(cl_curr_ear_y_y_acm_bal), 0) as cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
    ,nvl(trim(cl_curr_s_acm_bal), 0) as cl_curr_s_acm_bal -- 折本币季累计余额
    ,nvl(trim(cl_curr_ear_d_s_acm_bal), 0) as cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
    ,nvl(trim(cl_curr_ear_s_s_acm_bal), 0) as cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
    ,nvl(trim(cl_curr_ear_y_s_acm_bal), 0) as cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
    ,nvl(trim(cl_curr_m_acm_bal), 0) as cl_curr_m_acm_bal -- 折本币月累计余额
    ,nvl(trim(cl_curr_ear_d_m_acm_bal), 0) as cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
    ,nvl(trim(cl_curr_ear_m_m_acm_bal), 0) as cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
    ,nvl(trim(cl_curr_ear_y_m_acm_bal), 0) as cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
    ,nvl(trim(y_avg_bal), 0) as y_avg_bal -- 年日均余额
    ,nvl(trim(q_avg_bal), 0) as q_avg_bal -- 季日均余额
    ,nvl(trim(m_avg_bal), 0) as m_avg_bal -- 月日均余额
    ,nvl(trim(cl_curr_y_avg_bal), 0) as cl_curr_y_avg_bal -- 折本币年日均余额
    ,nvl(trim(cl_curr_q_avg_bal), 0) as cl_curr_q_avg_bal -- 折本币季日均余额
    ,nvl(trim(cl_curr_m_avg_bal), 0) as cl_curr_m_avg_bal -- 折本币月日均余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_dep_acct_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_dep_acct_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_dep_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);