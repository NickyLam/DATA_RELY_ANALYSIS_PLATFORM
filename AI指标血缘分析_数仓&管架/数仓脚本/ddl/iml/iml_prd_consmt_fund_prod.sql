/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_consmt_fund_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_consmt_fund_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_consmt_fund_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_consmt_fund_prod(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,belong_cate_cd varchar2(30) -- 归属类别代码
    ,prod_tepla varchar2(1000) -- 产品模板
    ,prod_cate_cd varchar2(30) -- 产品类别代码
    ,ta_cd varchar2(30) -- TA代码
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,init_prod_id varchar2(100) -- 原产品编号
    ,prod_name varchar2(375) -- 产品名称
    ,prod_descb varchar2(375) -- 产品描述
    ,prod_nv number(30,8) -- 产品净值
    ,nv_dt date -- 净值日期
    ,nv_days number(10) -- 净值天数
    ,prod_fac_val number(30,8) -- 产品面值
    ,issue_price number(30,8) -- 发行价格
    ,prod_sponsor_id varchar2(100) -- 产品发起人编号
    ,prod_trustee_id varchar2(100) -- 产品托管人编号
    ,prod_mger_id varchar2(100) -- 产品管理人编号
    ,prod_host_dept_id varchar2(500) -- 产品主办部门编号
    ,prod_host_org_id varchar2(100) -- 产品主办机构编号
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,prod_found_dt date -- 产品成立日期
    ,prod_value_dt date -- 产品起息日期
    ,prod_end_dt date -- 产品结束日期
    ,int_closing_dt date -- 利息截止日期
    ,prft_exp_dt date -- 收益到期日期
    ,aft_coll_close_exp_dt date -- 募集后封闭到期日期
    ,actl_found_dt date -- 实际成立日期
    ,prod_lowt_coll_amt number(30,2) -- 产品最低募集金额
    ,prod_higt_coll_amt number(30,2) -- 产品最高募集金额
    ,prod_lowt_coll_lot number(30,2) -- 产品最低募集份额
    ,prod_higt_coll_lot number(30,2) -- 产品最高募集份额
    ,prod_actl_coll_amt number(30,2) -- 产品实际募集金额
    ,prod_curr_size number(30,2) -- 产品当前规模
    ,allow_divd_way_cd varchar2(30) -- 允许分红方式代码
    ,deflt_divd_way_cd varchar2(30) -- 默认分红方式代码
    ,sell_rg_ctrl_flg varchar2(10) -- 销售区域控制标志
    ,lmt_ctrl_flg_cd varchar2(30) -- 额度控制标志代码
    ,coll_term_acct_mode_cd varchar2(30) -- 募集期账务模式代码
    ,open_term_acct_mode_cd varchar2(30) -- 开放期账务模式代码
    ,chn_cd_comb varchar2(60) -- 渠道代码组合
    ,allow_cust_type_cd_comb varchar2(30) -- 允许客户类型代码组合
    ,tepla_flg_cd varchar2(30) -- 模板标志代码
    ,ctrl_flg_comb varchar2(1000) -- 控制标志组合
    ,bta_ctrl_flg_comb varchar2(375) -- BTA控制标志组合
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,out_charge_flg varchar2(10) -- 外收费标志
    ,subscr_export_mode_cd varchar2(30) -- 认购导出模式代码
    ,prft_embody_way_cd varchar2(30) -- 收益体现方式代码
    ,prod_attr_cd varchar2(30) -- 产品属性代码
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,estim_level_cd varchar2(30) -- 评估等级代码
    ,status_cd varchar2(30) -- 状态代码
    ,tran_flg_cd varchar2(30) -- 转换标志代码
    ,prod_curr_tot_lot number(30,2) -- 产品当前总份额
    ,prod_acm_nv number(38,8) -- 产品累计净值
    ,curr_cd varchar2(30) -- 币种代码
    ,prft_curr_cd varchar2(30) -- 收益币种代码
    ,ec_flg varchar2(10) -- 钞汇标志
    ,discnt_way_cd varchar2(30) -- 折扣方式代码
    ,open_tm varchar2(10) -- 开市时间
    ,close_tm varchar2(10) -- 闭市时间
    ,indv_min_buy_corp number(30,2) -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt number(30,2) -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt number(30,2) -- 个人追加最低投资金额
    ,indv_lowt_aip_amt number(30,2) -- 个人最低定投金额
    ,indv_lowt_hold_lot number(30,2) -- 个人最低持有份额
    ,indv_sig_least_redem_lot number(30,2) -- 个人单笔最少赎回份额
    ,indv_sig_max_redem_lot number(30,2) -- 个人单笔最大赎回份额
    ,indv_redem_corp number(30,2) -- 个人赎回单位
    ,indv_lowt_fund_tran_lot number(30,2) -- 个人最低基金转换份额
    ,indv_lowt_reg_redem_lot number(30,2) -- 个人最低定赎份额
    ,indv_sig_max_buy_amt number(30,2) -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt number(30,2) -- 个人单户累计最大购买金额
    ,coll_start_tm varchar2(10) -- 募集开始时间
    ,aip_fail_cnt number(10) -- 定投失败次数
    ,sp_acct_id varchar2(100) -- 认申购账户编号
    ,redem_acct_id varchar2(100) -- 赎回账户编号
    ,comm_fee_assign_acct_id varchar2(100) -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id varchar2(100) -- 管理费分配账户编号
    ,redem_cap_avl_days number(10) -- 赎回资金到帐天数
    ,divd_cap_avl_days number(10) -- 分红资金到帐天数
    ,prod_exp_cap_avl_days number(10) -- 产品到期资金到帐天数
    ,issue_fail_refund_days number(10) -- 发行失败退款天数
    ,prod_int_accr_base number(10) -- 产品计息基数
    ,subscr_int_accr_base number(10) -- 认购利息计息基数
    ,mgmt_fee_base_days number(10) -- 管理费基础天数
    ,expe_yld_rat number(18,8) -- 预期收益率
    ,ped_days number(10) -- 周期天数
    ,tard_way_cd varchar2(30) -- 交易方式代码
    ,prod_tepla_id varchar2(250) -- 产品模板编号
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
grant select on ${iml_schema}.prd_consmt_fund_prod to ${icl_schema};
grant select on ${iml_schema}.prd_consmt_fund_prod to ${idl_schema};
grant select on ${iml_schema}.prd_consmt_fund_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_consmt_fund_prod is '代销基金产品';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.belong_cate_cd is '归属类别代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_tepla is '产品模板';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.init_prod_id is '原产品编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_name is '产品名称';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_descb is '产品描述';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_nv is '产品净值';
comment on column ${iml_schema}.prd_consmt_fund_prod.nv_dt is '净值日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.nv_days is '净值天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_fac_val is '产品面值';
comment on column ${iml_schema}.prd_consmt_fund_prod.issue_price is '发行价格';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_sponsor_id is '产品发起人编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_trustee_id is '产品托管人编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_mger_id is '产品管理人编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_host_dept_id is '产品主办部门编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_host_org_id is '产品主办机构编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.coll_start_dt is '募集开始日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.coll_end_dt is '募集结束日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_found_dt is '产品成立日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_value_dt is '产品起息日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_end_dt is '产品结束日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.int_closing_dt is '利息截止日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.prft_exp_dt is '收益到期日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.aft_coll_close_exp_dt is '募集后封闭到期日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.actl_found_dt is '实际成立日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_lowt_coll_amt is '产品最低募集金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_higt_coll_amt is '产品最高募集金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_lowt_coll_lot is '产品最低募集份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_higt_coll_lot is '产品最高募集份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_actl_coll_amt is '产品实际募集金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_curr_size is '产品当前规模';
comment on column ${iml_schema}.prd_consmt_fund_prod.allow_divd_way_cd is '允许分红方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.sell_rg_ctrl_flg is '销售区域控制标志';
comment on column ${iml_schema}.prd_consmt_fund_prod.lmt_ctrl_flg_cd is '额度控制标志代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.coll_term_acct_mode_cd is '募集期账务模式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.open_term_acct_mode_cd is '开放期账务模式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.chn_cd_comb is '渠道代码组合';
comment on column ${iml_schema}.prd_consmt_fund_prod.allow_cust_type_cd_comb is '允许客户类型代码组合';
comment on column ${iml_schema}.prd_consmt_fund_prod.tepla_flg_cd is '模板标志代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.ctrl_flg_comb is '控制标志组合';
comment on column ${iml_schema}.prd_consmt_fund_prod.bta_ctrl_flg_comb is 'BTA控制标志组合';
comment on column ${iml_schema}.prd_consmt_fund_prod.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.out_charge_flg is '外收费标志';
comment on column ${iml_schema}.prd_consmt_fund_prod.subscr_export_mode_cd is '认购导出模式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prft_embody_way_cd is '收益体现方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_attr_cd is '产品属性代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.estim_level_cd is '评估等级代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.status_cd is '状态代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.tran_flg_cd is '转换标志代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_curr_tot_lot is '产品当前总份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_acm_nv is '产品累计净值';
comment on column ${iml_schema}.prd_consmt_fund_prod.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prft_curr_cd is '收益币种代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.ec_flg is '钞汇标志';
comment on column ${iml_schema}.prd_consmt_fund_prod.discnt_way_cd is '折扣方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.open_tm is '开市时间';
comment on column ${iml_schema}.prd_consmt_fund_prod.close_tm is '闭市时间';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_min_buy_corp is '个人最小购买单位';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_fir_lowt_invest_amt is '个人首次最低投资金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_supp_lowt_invest_amt is '个人追加最低投资金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_lowt_aip_amt is '个人最低定投金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_lowt_hold_lot is '个人最低持有份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_sig_least_redem_lot is '个人单笔最少赎回份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_sig_max_redem_lot is '个人单笔最大赎回份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_redem_corp is '个人赎回单位';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_lowt_fund_tran_lot is '个人最低基金转换份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_lowt_reg_redem_lot is '个人最低定赎份额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_sig_max_buy_amt is '个人单笔最大购买金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.indv_single_acct_amax_bamt is '个人单户累计最大购买金额';
comment on column ${iml_schema}.prd_consmt_fund_prod.coll_start_tm is '募集开始时间';
comment on column ${iml_schema}.prd_consmt_fund_prod.aip_fail_cnt is '定投失败次数';
comment on column ${iml_schema}.prd_consmt_fund_prod.sp_acct_id is '认申购账户编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.redem_acct_id is '赎回账户编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.comm_fee_assign_acct_id is '手续费分配账户编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.mgmt_fee_assign_acct_id is '管理费分配账户编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.redem_cap_avl_days is '赎回资金到帐天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.divd_cap_avl_days is '分红资金到帐天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_exp_cap_avl_days is '产品到期资金到帐天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.issue_fail_refund_days is '发行失败退款天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_int_accr_base is '产品计息基数';
comment on column ${iml_schema}.prd_consmt_fund_prod.subscr_int_accr_base is '认购利息计息基数';
comment on column ${iml_schema}.prd_consmt_fund_prod.mgmt_fee_base_days is '管理费基础天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.expe_yld_rat is '预期收益率';
comment on column ${iml_schema}.prd_consmt_fund_prod.ped_days is '周期天数';
comment on column ${iml_schema}.prd_consmt_fund_prod.tard_way_cd is '交易方式代码';
comment on column ${iml_schema}.prd_consmt_fund_prod.prod_tepla_id is '产品模板编号';
comment on column ${iml_schema}.prd_consmt_fund_prod.create_dt is '创建日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.update_dt is '更新日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_consmt_fund_prod.id_mark is '增删标志';
comment on column ${iml_schema}.prd_consmt_fund_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_consmt_fund_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_consmt_fund_prod.etl_timestamp is 'ETL处理时间戳';
