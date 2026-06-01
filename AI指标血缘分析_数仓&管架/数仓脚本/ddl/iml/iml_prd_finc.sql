/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_finc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_finc
whenever sqlerror continue none;
drop table ${iml_schema}.prd_finc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,std_prod_id varchar2(2000) -- 标准产品编号
    ,prod_belong_cate_cd varchar2(10) -- 产品归属类别代码
    ,ref_yld_rat_comnt varchar2(1000) -- 参考收益率说明
    ,prod_cbond_id varchar2(100) -- 产品中债编号
    ,prod_cate_cd varchar2(10) -- 产品类别代码
    ,ta_cd varchar2(30) -- TA代码
    ,prod_name varchar2(375) -- 产品名称
    ,prod_alias varchar2(750) -- 产品别名
    ,prod_nv number(30,8) -- 产品净值
    ,prod_fac_val number(30,8) -- 产品面值
    ,issue_price number(30,8) -- 发行价格
    ,prod_sponsor_cd varchar2(30) -- 产品发起人代码
    ,prod_trustee_cd varchar2(100) -- 产品托管人代码
    ,prod_mger_cd varchar2(30) -- 产品管理人代码
    ,prod_host_org_id varchar2(60) -- 产品主办机构编号
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,prod_found_dt date -- 产品成立日期
    ,prod_value_dt date -- 产品起息日期
    ,prod_end_dt date -- 产品结束日期
    ,prft_exp_dt date -- 收益到期日期
    ,coll_fail_dt date -- 募集失败日期
    ,coll_post_close_exp_day date -- 募集后封闭到期日
    ,actl_found_dt date -- 实际成立日期
    ,prod_lowt_coll_amt number(30,2) -- 产品最低募集金额
    ,prod_higt_coll_amt number(30,2) -- 产品最高募集金额
    ,prod_lowt_coll_lot number(30,2) -- 产品最低募集份额
    ,prod_higt_coll_lot number(30,2) -- 产品最高募集份额
    ,prod_actl_coll_amt number(30,2) -- 产品实际募集金额
    ,curr_size number(30,2) -- 当前规模
    ,allow_divd_way_cd varchar2(10) -- 允许的分红方式代码
    ,deflt_divd_way_cd varchar2(10) -- 默认分红方式代码
    ,sell_rg_ctrl_flg varchar2(10) -- 销售区域控制标志
    ,lmt_ctrl_flg varchar2(10) -- 额度控制标志
    ,coll_term_acct_mode_cd varchar2(10) -- 募集期账务模式代码
    ,open_term_acct_mode_cd varchar2(10) -- 开放期账务模式代码
    ,chn_cd varchar2(60) -- 渠道代码
    ,allow_cust_group_list varchar2(90) -- 允许客户组列表
    ,ctrl_flg varchar2(1000) -- 控制标志
    ,bta_ctrl_flg varchar2(250) -- BTA控制标志
    ,charge_way_cd varchar2(10) -- 收费方式代码
    ,prft_embody_way_cd varchar2(10) -- 收益体现方式代码
    ,prod_attr_cd varchar2(10) -- 产品属性代码
    ,risk_level_cd varchar2(10) -- 风险等级代码
    ,status_cd varchar2(10) -- 状态代码
    ,tran_flg varchar2(10) -- 转换标志
    ,curr_cd varchar2(10) -- 币种代码
    ,ec_flg varchar2(10) -- 钞汇标志
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
    ,indv_sig_max_buy_amt number(30,2) -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt number(30,2) -- 个人单户累计最大购买金额
    ,org_min_buy_corp number(30,2) -- 机构最小购买单位
    ,org_fir_lowt_invest_amt number(30,2) -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt number(30,2) -- 机构追加最低投资金额
    ,org_lowt_aip_amt number(30,2) -- 机构最低定投金额
    ,org_lowt_hold_lot number(30,2) -- 机构最低持有份额
    ,org_sig_min_redem_lot number(30,2) -- 机构单笔最小赎回份额
    ,org_sig_max_redem_lot number(30,2) -- 机构单笔最大赎回份额
    ,org_redem_corp number(10) -- 机构赎回单位
    ,org_lowt_fund_tran_lot number(30,2) -- 机构最低基金转换份额
    ,org_sig_max_buy_amt number(30,2) -- 机构单笔最大购买金额
    ,org_single_acct_amax_bamt number(30,2) -- 机构单户累计最大购买金额
    ,coll_start_tm varchar2(10) -- 募集开始时间
    ,buy_acct_id varchar2(60) -- 购买账户编号
    ,redem_acct_id varchar2(60) -- 赎回账户编号
    ,realtm_redem_adv_exp_acct_id varchar2(60) -- 实时赎回垫支账户编号
    ,redem_cap_avl_days number(10) -- 赎回资金到账天数
    ,divd_cap_avl_days number(10) -- 分红资金到账天数
    ,prod_exp_cap_avl_days number(10) -- 产品到期资金到账天数
    ,huge_redem_ratio number(18,6) -- 巨额赎回比例
    ,prod_int_accr_base number(10) -- 产品计息基数
    ,subscr_int_accr_base number(10) -- 认购利息计息基数
    ,mgmt_fee_base_days number(10) -- 管理费基础天数
    ,expe_yld_rat number(18,6) -- 预期收益率
    ,ped_days number(10) -- 周期天数
    ,tard_way_cd varchar2(10) -- 交易方式代码
    ,prod_tepla_id varchar2(250) -- 产品模板编号
    ,supt_buy_way_cd varchar2(30) -- 支持购买方式代码
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
grant select on ${iml_schema}.prd_finc to ${icl_schema};
grant select on ${iml_schema}.prd_finc to ${idl_schema};
grant select on ${iml_schema}.prd_finc to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_finc is '理财产品';
comment on column ${iml_schema}.prd_finc.prod_id is '产品编号';
comment on column ${iml_schema}.prd_finc.lp_id is '法人编号';
comment on column ${iml_schema}.prd_finc.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.prd_finc.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_finc.prod_belong_cate_cd is '产品归属类别代码';
comment on column ${iml_schema}.prd_finc.ref_yld_rat_comnt is '参考收益率说明';
comment on column ${iml_schema}.prd_finc.prod_cbond_id is '产品中债编号';
comment on column ${iml_schema}.prd_finc.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.prd_finc.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_finc.prod_name is '产品名称';
comment on column ${iml_schema}.prd_finc.prod_alias is '产品别名';
comment on column ${iml_schema}.prd_finc.prod_nv is '产品净值';
comment on column ${iml_schema}.prd_finc.prod_fac_val is '产品面值';
comment on column ${iml_schema}.prd_finc.issue_price is '发行价格';
comment on column ${iml_schema}.prd_finc.prod_sponsor_cd is '产品发起人代码';
comment on column ${iml_schema}.prd_finc.prod_trustee_cd is '产品托管人代码';
comment on column ${iml_schema}.prd_finc.prod_mger_cd is '产品管理人代码';
comment on column ${iml_schema}.prd_finc.prod_host_org_id is '产品主办机构编号';
comment on column ${iml_schema}.prd_finc.coll_start_dt is '募集开始日期';
comment on column ${iml_schema}.prd_finc.coll_end_dt is '募集结束日期';
comment on column ${iml_schema}.prd_finc.prod_found_dt is '产品成立日期';
comment on column ${iml_schema}.prd_finc.prod_value_dt is '产品起息日期';
comment on column ${iml_schema}.prd_finc.prod_end_dt is '产品结束日期';
comment on column ${iml_schema}.prd_finc.prft_exp_dt is '收益到期日期';
comment on column ${iml_schema}.prd_finc.coll_fail_dt is '募集失败日期';
comment on column ${iml_schema}.prd_finc.coll_post_close_exp_day is '募集后封闭到期日';
comment on column ${iml_schema}.prd_finc.actl_found_dt is '实际成立日期';
comment on column ${iml_schema}.prd_finc.prod_lowt_coll_amt is '产品最低募集金额';
comment on column ${iml_schema}.prd_finc.prod_higt_coll_amt is '产品最高募集金额';
comment on column ${iml_schema}.prd_finc.prod_lowt_coll_lot is '产品最低募集份额';
comment on column ${iml_schema}.prd_finc.prod_higt_coll_lot is '产品最高募集份额';
comment on column ${iml_schema}.prd_finc.prod_actl_coll_amt is '产品实际募集金额';
comment on column ${iml_schema}.prd_finc.curr_size is '当前规模';
comment on column ${iml_schema}.prd_finc.allow_divd_way_cd is '允许的分红方式代码';
comment on column ${iml_schema}.prd_finc.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${iml_schema}.prd_finc.sell_rg_ctrl_flg is '销售区域控制标志';
comment on column ${iml_schema}.prd_finc.lmt_ctrl_flg is '额度控制标志';
comment on column ${iml_schema}.prd_finc.coll_term_acct_mode_cd is '募集期账务模式代码';
comment on column ${iml_schema}.prd_finc.open_term_acct_mode_cd is '开放期账务模式代码';
comment on column ${iml_schema}.prd_finc.chn_cd is '渠道代码';
comment on column ${iml_schema}.prd_finc.allow_cust_group_list is '允许客户组列表';
comment on column ${iml_schema}.prd_finc.ctrl_flg is '控制标志';
comment on column ${iml_schema}.prd_finc.bta_ctrl_flg is 'BTA控制标志';
comment on column ${iml_schema}.prd_finc.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.prd_finc.prft_embody_way_cd is '收益体现方式代码';
comment on column ${iml_schema}.prd_finc.prod_attr_cd is '产品属性代码';
comment on column ${iml_schema}.prd_finc.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.prd_finc.status_cd is '状态代码';
comment on column ${iml_schema}.prd_finc.tran_flg is '转换标志';
comment on column ${iml_schema}.prd_finc.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_finc.ec_flg is '钞汇标志';
comment on column ${iml_schema}.prd_finc.open_tm is '开市时间';
comment on column ${iml_schema}.prd_finc.close_tm is '闭市时间';
comment on column ${iml_schema}.prd_finc.indv_min_buy_corp is '个人最小购买单位';
comment on column ${iml_schema}.prd_finc.indv_fir_lowt_invest_amt is '个人首次最低投资金额';
comment on column ${iml_schema}.prd_finc.indv_supp_lowt_invest_amt is '个人追加最低投资金额';
comment on column ${iml_schema}.prd_finc.indv_lowt_aip_amt is '个人最低定投金额';
comment on column ${iml_schema}.prd_finc.indv_lowt_hold_lot is '个人最低持有份额';
comment on column ${iml_schema}.prd_finc.indv_sig_least_redem_lot is '个人单笔最少赎回份额';
comment on column ${iml_schema}.prd_finc.indv_sig_max_redem_lot is '个人单笔最大赎回份额';
comment on column ${iml_schema}.prd_finc.indv_redem_corp is '个人赎回单位';
comment on column ${iml_schema}.prd_finc.indv_lowt_fund_tran_lot is '个人最低基金转换份额';
comment on column ${iml_schema}.prd_finc.indv_sig_max_buy_amt is '个人单笔最大购买金额';
comment on column ${iml_schema}.prd_finc.indv_single_acct_amax_bamt is '个人单户累计最大购买金额';
comment on column ${iml_schema}.prd_finc.org_min_buy_corp is '机构最小购买单位';
comment on column ${iml_schema}.prd_finc.org_fir_lowt_invest_amt is '机构首次最低投资金额';
comment on column ${iml_schema}.prd_finc.org_supp_lowt_invest_amt is '机构追加最低投资金额';
comment on column ${iml_schema}.prd_finc.org_lowt_aip_amt is '机构最低定投金额';
comment on column ${iml_schema}.prd_finc.org_lowt_hold_lot is '机构最低持有份额';
comment on column ${iml_schema}.prd_finc.org_sig_min_redem_lot is '机构单笔最小赎回份额';
comment on column ${iml_schema}.prd_finc.org_sig_max_redem_lot is '机构单笔最大赎回份额';
comment on column ${iml_schema}.prd_finc.org_redem_corp is '机构赎回单位';
comment on column ${iml_schema}.prd_finc.org_lowt_fund_tran_lot is '机构最低基金转换份额';
comment on column ${iml_schema}.prd_finc.org_sig_max_buy_amt is '机构单笔最大购买金额';
comment on column ${iml_schema}.prd_finc.org_single_acct_amax_bamt is '机构单户累计最大购买金额';
comment on column ${iml_schema}.prd_finc.coll_start_tm is '募集开始时间';
comment on column ${iml_schema}.prd_finc.buy_acct_id is '购买账户编号';
comment on column ${iml_schema}.prd_finc.redem_acct_id is '赎回账户编号';
comment on column ${iml_schema}.prd_finc.realtm_redem_adv_exp_acct_id is '实时赎回垫支账户编号';
comment on column ${iml_schema}.prd_finc.redem_cap_avl_days is '赎回资金到账天数';
comment on column ${iml_schema}.prd_finc.divd_cap_avl_days is '分红资金到账天数';
comment on column ${iml_schema}.prd_finc.prod_exp_cap_avl_days is '产品到期资金到账天数';
comment on column ${iml_schema}.prd_finc.huge_redem_ratio is '巨额赎回比例';
comment on column ${iml_schema}.prd_finc.prod_int_accr_base is '产品计息基数';
comment on column ${iml_schema}.prd_finc.subscr_int_accr_base is '认购利息计息基数';
comment on column ${iml_schema}.prd_finc.mgmt_fee_base_days is '管理费基础天数';
comment on column ${iml_schema}.prd_finc.expe_yld_rat is '预期收益率';
comment on column ${iml_schema}.prd_finc.ped_days is '周期天数';
comment on column ${iml_schema}.prd_finc.tard_way_cd is '交易方式代码';
comment on column ${iml_schema}.prd_finc.prod_tepla_id is '产品模板编号';
comment on column ${iml_schema}.prd_finc.supt_buy_way_cd is '支持购买方式代码';
comment on column ${iml_schema}.prd_finc.create_dt is '创建日期';
comment on column ${iml_schema}.prd_finc.update_dt is '更新日期';
comment on column ${iml_schema}.prd_finc.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_finc.id_mark is '增删标志';
comment on column ${iml_schema}.prd_finc.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_finc.job_cd is '任务编码';
comment on column ${iml_schema}.prd_finc.etl_timestamp is 'ETL处理时间戳';
