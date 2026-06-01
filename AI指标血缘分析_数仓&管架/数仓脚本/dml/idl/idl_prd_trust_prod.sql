/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_trust_prod
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.prd_trust_prod drop partition p_${last_date};
alter table ${idl_schema}.prd_trust_prod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_trust_prod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_trust_prod (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,belong_cate_cd  -- 归属类别代码
    ,prod_tepla  -- 产品模板
    ,prod_cate_cd  -- 产品类别代码
    ,ta_cd  -- TA代码
    ,std_prod_id  -- 标准产品编号
    ,init_prod_id  -- 原产品编号
    ,prod_name  -- 产品名称
    ,prod_descb  -- 产品描述
    ,prod_nv  -- 产品净值
    ,nv_dt  -- 净值日期
    ,nv_days  -- 净值天数
    ,prod_fac_val  -- 产品面值
    ,issue_price  -- 发行价格
    ,prod_sponsor_id  -- 产品发起人编号
    ,prod_trustee_id  -- 产品托管人编号
    ,prod_mger_id  -- 产品管理人编号
    ,prod_host_dept_id  -- 产品主办部门编号
    ,prod_host_org_id  -- 产品主办机构编号
    ,coll_start_dt  -- 募集开始日期
    ,coll_end_dt  -- 募集结束日期
    ,prod_found_dt  -- 产品成立日期
    ,prod_value_dt  -- 产品起息日期
    ,prod_end_dt  -- 产品结束日期
    ,int_closing_dt  -- 利息截止日期
    ,prft_exp_dt  -- 收益到期日期
    ,aft_coll_close_exp_dt  -- 募集后封闭到期日期
    ,actl_found_dt  -- 实际成立日期
    ,prod_lowt_coll_amt  -- 产品最低募集金额
    ,prod_higt_coll_amt  -- 产品最高募集金额
    ,prod_lowt_coll_lot  -- 产品最低募集份额
    ,prod_higt_coll_lot  -- 产品最高募集份额
    ,prod_actl_coll_amt  -- 产品实际募集金额
    ,prod_curr_size  -- 产品当前规模
    ,allow_divd_way_cd  -- 允许分红方式代码
    ,deflt_divd_way_cd  -- 默认分红方式代码
    ,sell_rg_ctrl_flg  -- 销售区域控制标志
    ,lmt_ctrl_flg_cd  -- 额度控制标志代码
    ,coll_term_acct_mode_cd  -- 募集期账务模式代码
    ,open_term_acct_mode_cd  -- 开放期账务模式代码
    ,chn_cd_comb  -- 渠道代码组合
    ,allow_cust_type_cd_comb  -- 允许客户类型代码组合
    ,tepla_flg_cd  -- 模板标志代码
    ,ctrl_flg_comb  -- 控制标志组合
    ,bta_ctrl_flg_comb  -- BTA控制标志组合
    ,charge_way_cd  -- 收费方式代码
    ,out_charge_flg  -- 外收费标志
    ,subscr_export_mode_cd  -- 认购导出模式代码
    ,prft_embody_way_cd  -- 收益体现方式代码
    ,prod_attr_cd  -- 产品属性代码
    ,risk_level_cd  -- 风险等级代码
    ,estim_level_cd  -- 评估等级代码
    ,status_cd  -- 状态代码
    ,tran_flg_cd  -- 转换标志代码
    ,prod_curr_tot_lot  -- 产品当前总份额
    ,prod_acm_nv  -- 产品累计净值
    ,curr_cd  -- 币种代码
    ,prft_curr_cd  -- 收益币种代码
    ,ec_flg  -- 钞汇标志
    ,discnt_way_cd  -- 折扣方式代码
    ,open_tm  -- 开市时间
    ,close_tm  -- 闭市时间
    ,indv_min_buy_corp  -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt  -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt  -- 个人追加最低投资金额
    ,indv_lowt_aip_amt  -- 个人最低定投金额
    ,indv_lowt_hold_lot  -- 个人最低持有份额
    ,indv_sig_least_redem_lot  -- 个人单笔最少赎回份额
    ,indv_sig_max_redem_lot  -- 个人单笔最大赎回份额
    ,indv_redem_corp  -- 个人赎回单位
    ,indv_lowt_fund_tran_lot  -- 个人最低基金转换份额
    ,indv_lowt_reg_redem_lot  -- 个人最低定赎份额
    ,indv_sig_max_buy_amt  -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt  -- 个人单户累计最大购买金额
    ,coll_start_tm  -- 募集开始时间
    ,aip_fail_cnt  -- 定投失败次数
    ,sp_acct_id  -- 认申购账户编号
    ,redem_acct_id  -- 赎回账户编号
    ,comm_fee_assign_acct_id  -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id  -- 管理费分配账户编号
    ,redem_cap_avl_days  -- 赎回资金到帐天数
    ,divd_cap_avl_days  -- 分红资金到帐天数
    ,prod_exp_cap_avl_days  -- 产品到期资金到帐天数
    ,issue_fail_refund_days  -- 发行失败退款天数
    ,prod_int_accr_base  -- 产品计息基数
    ,subscr_int_accr_base  -- 认购利息计息基数
    ,mgmt_fee_base_days  -- 管理费基础天数
    ,expe_yld_rat  -- 预期收益率
    ,ped_days  -- 周期天数
    ,tard_way_cd  -- 交易方式代码
    ,prod_tepla_id  -- 产品模板编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.belong_cate_cd,chr(13),''),chr(10),'')  -- 归属类别代码
    ,replace(replace(t1.prod_tepla,chr(13),''),chr(10),'')  -- 产品模板
    ,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'')  -- 产品类别代码
    ,replace(replace(t1.ta_cd,chr(13),''),chr(10),'')  -- TA代码
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'')  -- 标准产品编号
    ,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'')  -- 原产品编号
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.prod_descb,chr(13),''),chr(10),'')  -- 产品描述
    ,t1.prod_nv  -- 产品净值
    ,t1.nv_dt  -- 净值日期
    ,t1.nv_days  -- 净值天数
    ,t1.prod_fac_val  -- 产品面值
    ,t1.issue_price  -- 发行价格
    ,replace(replace(t1.prod_sponsor_id,chr(13),''),chr(10),'')  -- 产品发起人编号
    ,replace(replace(t1.prod_trustee_id,chr(13),''),chr(10),'')  -- 产品托管人编号
    ,replace(replace(t1.prod_mger_id,chr(13),''),chr(10),'')  -- 产品管理人编号
    ,replace(replace(t1.prod_host_dept_id,chr(13),''),chr(10),'')  -- 产品主办部门编号
    ,replace(replace(t1.prod_host_org_id,chr(13),''),chr(10),'')  -- 产品主办机构编号
    ,t1.coll_start_dt  -- 募集开始日期
    ,t1.coll_end_dt  -- 募集结束日期
    ,t1.prod_found_dt  -- 产品成立日期
    ,t1.prod_value_dt  -- 产品起息日期
    ,t1.prod_end_dt  -- 产品结束日期
    ,t1.int_closing_dt  -- 利息截止日期
    ,t1.prft_exp_dt  -- 收益到期日期
    ,t1.aft_coll_close_exp_dt  -- 募集后封闭到期日期
    ,t1.actl_found_dt  -- 实际成立日期
    ,t1.prod_lowt_coll_amt  -- 产品最低募集金额
    ,t1.prod_higt_coll_amt  -- 产品最高募集金额
    ,t1.prod_lowt_coll_lot  -- 产品最低募集份额
    ,t1.prod_higt_coll_lot  -- 产品最高募集份额
    ,t1.prod_actl_coll_amt  -- 产品实际募集金额
    ,t1.prod_curr_size  -- 产品当前规模
    ,replace(replace(t1.allow_divd_way_cd,chr(13),''),chr(10),'')  -- 允许分红方式代码
    ,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'')  -- 默认分红方式代码
    ,replace(replace(t1.sell_rg_ctrl_flg,chr(13),''),chr(10),'')  -- 销售区域控制标志
    ,replace(replace(t1.lmt_ctrl_flg_cd,chr(13),''),chr(10),'')  -- 额度控制标志代码
    ,replace(replace(t1.coll_term_acct_mode_cd,chr(13),''),chr(10),'')  -- 募集期账务模式代码
    ,replace(replace(t1.open_term_acct_mode_cd,chr(13),''),chr(10),'')  -- 开放期账务模式代码
    ,replace(replace(t1.chn_cd_comb,chr(13),''),chr(10),'')  -- 渠道代码组合
    ,replace(replace(t1.allow_cust_type_cd_comb,chr(13),''),chr(10),'')  -- 允许客户类型代码组合
    ,replace(replace(t1.tepla_flg_cd,chr(13),''),chr(10),'')  -- 模板标志代码
    ,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'')  -- 控制标志组合
    ,replace(replace(t1.bta_ctrl_flg_comb,chr(13),''),chr(10),'')  -- BTA控制标志组合
    ,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'')  -- 收费方式代码
    ,replace(replace(t1.out_charge_flg,chr(13),''),chr(10),'')  -- 外收费标志
    ,replace(replace(t1.subscr_export_mode_cd,chr(13),''),chr(10),'')  -- 认购导出模式代码
    ,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'')  -- 收益体现方式代码
    ,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'')  -- 产品属性代码
    ,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'')  -- 风险等级代码
    ,replace(replace(t1.estim_level_cd,chr(13),''),chr(10),'')  -- 评估等级代码
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,replace(replace(t1.tran_flg_cd,chr(13),''),chr(10),'')  -- 转换标志代码
    ,t1.prod_curr_tot_lot  -- 产品当前总份额
    ,t1.prod_acm_nv  -- 产品累计净值
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.prft_curr_cd,chr(13),''),chr(10),'')  -- 收益币种代码
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.discnt_way_cd,chr(13),''),chr(10),'')  -- 折扣方式代码
    ,replace(replace(t1.open_tm,chr(13),''),chr(10),'')  -- 开市时间
    ,replace(replace(t1.close_tm,chr(13),''),chr(10),'')  -- 闭市时间
    ,t1.indv_min_buy_corp  -- 个人最小购买单位
    ,t1.indv_fir_lowt_invest_amt  -- 个人首次最低投资金额
    ,t1.indv_supp_lowt_invest_amt  -- 个人追加最低投资金额
    ,t1.indv_lowt_aip_amt  -- 个人最低定投金额
    ,t1.indv_lowt_hold_lot  -- 个人最低持有份额
    ,t1.indv_sig_least_redem_lot  -- 个人单笔最少赎回份额
    ,t1.indv_sig_max_redem_lot  -- 个人单笔最大赎回份额
    ,t1.indv_redem_corp  -- 个人赎回单位
    ,t1.indv_lowt_fund_tran_lot  -- 个人最低基金转换份额
    ,t1.indv_lowt_reg_redem_lot  -- 个人最低定赎份额
    ,t1.indv_sig_max_buy_amt  -- 个人单笔最大购买金额
    ,t1.indv_single_acct_amax_bamt  -- 个人单户累计最大购买金额
    ,replace(replace(t1.coll_start_tm,chr(13),''),chr(10),'')  -- 募集开始时间
    ,t1.aip_fail_cnt  -- 定投失败次数
    ,replace(replace(t1.sp_acct_id,chr(13),''),chr(10),'')  -- 认申购账户编号
    ,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'')  -- 赎回账户编号
    ,replace(replace(t1.comm_fee_assign_acct_id,chr(13),''),chr(10),'')  -- 手续费分配账户编号
    ,replace(replace(t1.mgmt_fee_assign_acct_id,chr(13),''),chr(10),'')  -- 管理费分配账户编号
    ,t1.redem_cap_avl_days  -- 赎回资金到帐天数
    ,t1.divd_cap_avl_days  -- 分红资金到帐天数
    ,t1.prod_exp_cap_avl_days  -- 产品到期资金到帐天数
    ,t1.issue_fail_refund_days  -- 发行失败退款天数
    ,t1.prod_int_accr_base  -- 产品计息基数
    ,t1.subscr_int_accr_base  -- 认购利息计息基数
    ,t1.mgmt_fee_base_days  -- 管理费基础天数
    ,t1.expe_yld_rat  -- 预期收益率
    ,t1.ped_days  -- 周期天数
    ,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'')  -- 交易方式代码
    ,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'')  -- 产品模板编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_trust_prod t1    --信托产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_trust_prod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);