/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_distr_finc_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_distr_finc_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_distr_finc_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_distr_finc_prod(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,prod_name varchar2(750) -- 产品名称
    ,prod_alias varchar2(750) -- 产品别名
    ,prod_belong_cate_cd varchar2(30) -- 产品归属类别代码
    ,bus_cate_cd varchar2(30) -- 业务类别代码
    ,ta_cd varchar2(30) -- TA代码
    ,curr_cd varchar2(30) -- 币种代码
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,prod_sponsor_id varchar2(60) -- 产品发起人编号
    ,prod_trustee_cd varchar2(30) -- 产品托管人代码
    ,mger_cd varchar2(30) -- 管理人代码
    ,allow_divd_way_cd varchar2(30) -- 允许分红方式代码
    ,deflt_divd_way_cd varchar2(30) -- 默认分红方式代码
    ,coll_term_acct_mode_cd varchar2(30) -- 募集期账务模式代码
    ,open_term_acct_mode_cd varchar2(30) -- 开放期账务模式代码
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,subscr_export_way_cd varchar2(30) -- 认购导出方式代码
    ,prft_embody_way_cd varchar2(30) -- 收益体现方式代码
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_cd varchar2(30) -- 转换代码
    ,tard_way_cd varchar2(30) -- 交易方式代码
    ,prod_nv number(30,8) -- 产品净值
    ,nv_dt date -- 净值日期
    ,nv_days number(10) -- 净值天数
    ,prod_fac_val number(30,8) -- 产品面值
    ,issue_price number(30,8) -- 发行价格
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,prod_found_dt date -- 产品成立日期
    ,prod_value_dt date -- 产品起息日期
    ,prod_end_dt date -- 产品结束日期
    ,int_exp_dt date -- 利息到期日期
    ,prft_exp_dt date -- 收益到期日期
    ,coll_fail_dt date -- 募集失败日期
    ,aft_coll_close_exp_dt date -- 募集后封闭到期日期
    ,actl_found_dt date -- 实际成立日期
    ,prod_lowt_coll_amt number(30,2) -- 产品最低募集金额
    ,prod_higt_coll_amt number(30,2) -- 产品最高募集金额
    ,prod_lowt_coll_lot number(30,8) -- 产品最低募集份额
    ,prod_higt_coll_lot number(30,8) -- 产品最高募集份额
    ,prod_actl_coll_amt number(30,2) -- 产品实际募集金额
    ,curr_lot number(30,2) -- 当前份额
    ,sell_rg_ctrl_flg varchar2(30) -- 销售区域控制标志
    ,lmt_ctrl_flg varchar2(30) -- 额度控制标志
    ,tepla_flg varchar2(30) -- 模板标志
    ,ctrl_flg_comb varchar2(375) -- 控制标志组合
    ,bta_ctrl_flg_comb varchar2(375) -- BTA控制标志组合
    ,cfm_ratio number(18,8) -- 确认比例
    ,out_charge_flg varchar2(30) -- 外收费标志
    ,prod_curr_tot_lot number(30,8) -- 产品当前总份额
    ,prod_acm_nv number(30,8) -- 产品累计净值
    ,indv_min_buy_corp number(10) -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt number(30,2) -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt number(30,2) -- 个人追加最低投资金额
    ,indv_lowt_aip_amt number(30,2) -- 个人最低定投金额
    ,indv_lowt_hold_lot number(30,8) -- 个人最低持有份额
    ,indv_sig_max_buy_amt number(30,2) -- 个人单笔最大购买金额
    ,indv_single_amax_bamt number(30,2) -- 个人单户累计最大购买金额
    ,org_min_buy_corp number(10) -- 机构最小购买单位
    ,org_fir_lowt_invest_amt number(30,2) -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt number(30,2) -- 机构追加最低投资金额
    ,org_lowt_aip_amt number(30,2) -- 机构最低定投金额
    ,org_lowt_hold_lot number(30,8) -- 机构最低持有份额
    ,org_sig_max_buy_amt number(30,2) -- 机构单笔最大购买金额
    ,org_single_amax_bamt number(30,2) -- 机构单户累计最大购买金额
    ,acm_corp_divd number(30,8) -- 累计单位分红
    ,clear_post_days number(10) -- 清算延后天数
    ,expe_yld_rat number(18,8) -- 预期收益率
    ,ped_days number(10) -- 周期天数
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
grant select on ${iml_schema}.prd_distr_finc_prod to ${icl_schema};
grant select on ${iml_schema}.prd_distr_finc_prod to ${idl_schema};
grant select on ${iml_schema}.prd_distr_finc_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_distr_finc_prod is '分销理财产品';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_distr_finc_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_distr_finc_prod.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.prd_distr_finc_prod.src_prod_id is '源产品编号';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_name is '产品名称';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_alias is '产品别名';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_belong_cate_cd is '产品归属类别代码';
comment on column ${iml_schema}.prd_distr_finc_prod.bus_cate_cd is '业务类别代码';
comment on column ${iml_schema}.prd_distr_finc_prod.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_distr_finc_prod.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_distr_finc_prod.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_sponsor_id is '产品发起人编号';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_trustee_cd is '产品托管人代码';
comment on column ${iml_schema}.prd_distr_finc_prod.mger_cd is '管理人代码';
comment on column ${iml_schema}.prd_distr_finc_prod.allow_divd_way_cd is '允许分红方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.coll_term_acct_mode_cd is '募集期账务模式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.open_term_acct_mode_cd is '开放期账务模式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.subscr_export_way_cd is '认购导出方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.prft_embody_way_cd is '收益体现方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.prd_distr_finc_prod.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.prd_distr_finc_prod.tran_cd is '转换代码';
comment on column ${iml_schema}.prd_distr_finc_prod.tard_way_cd is '交易方式代码';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_nv is '产品净值';
comment on column ${iml_schema}.prd_distr_finc_prod.nv_dt is '净值日期';
comment on column ${iml_schema}.prd_distr_finc_prod.nv_days is '净值天数';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_fac_val is '产品面值';
comment on column ${iml_schema}.prd_distr_finc_prod.issue_price is '发行价格';
comment on column ${iml_schema}.prd_distr_finc_prod.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.prd_distr_finc_prod.coll_start_dt is '募集开始日期';
comment on column ${iml_schema}.prd_distr_finc_prod.coll_end_dt is '募集结束日期';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_found_dt is '产品成立日期';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_value_dt is '产品起息日期';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_end_dt is '产品结束日期';
comment on column ${iml_schema}.prd_distr_finc_prod.int_exp_dt is '利息到期日期';
comment on column ${iml_schema}.prd_distr_finc_prod.prft_exp_dt is '收益到期日期';
comment on column ${iml_schema}.prd_distr_finc_prod.coll_fail_dt is '募集失败日期';
comment on column ${iml_schema}.prd_distr_finc_prod.aft_coll_close_exp_dt is '募集后封闭到期日期';
comment on column ${iml_schema}.prd_distr_finc_prod.actl_found_dt is '实际成立日期';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_lowt_coll_amt is '产品最低募集金额';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_higt_coll_amt is '产品最高募集金额';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_lowt_coll_lot is '产品最低募集份额';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_higt_coll_lot is '产品最高募集份额';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_actl_coll_amt is '产品实际募集金额';
comment on column ${iml_schema}.prd_distr_finc_prod.curr_lot is '当前份额';
comment on column ${iml_schema}.prd_distr_finc_prod.sell_rg_ctrl_flg is '销售区域控制标志';
comment on column ${iml_schema}.prd_distr_finc_prod.lmt_ctrl_flg is '额度控制标志';
comment on column ${iml_schema}.prd_distr_finc_prod.tepla_flg is '模板标志';
comment on column ${iml_schema}.prd_distr_finc_prod.ctrl_flg_comb is '控制标志组合';
comment on column ${iml_schema}.prd_distr_finc_prod.bta_ctrl_flg_comb is 'BTA控制标志组合';
comment on column ${iml_schema}.prd_distr_finc_prod.cfm_ratio is '确认比例';
comment on column ${iml_schema}.prd_distr_finc_prod.out_charge_flg is '外收费标志';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_curr_tot_lot is '产品当前总份额';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_acm_nv is '产品累计净值';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_min_buy_corp is '个人最小购买单位';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_fir_lowt_invest_amt is '个人首次最低投资金额';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_supp_lowt_invest_amt is '个人追加最低投资金额';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_lowt_aip_amt is '个人最低定投金额';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_lowt_hold_lot is '个人最低持有份额';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_sig_max_buy_amt is '个人单笔最大购买金额';
comment on column ${iml_schema}.prd_distr_finc_prod.indv_single_amax_bamt is '个人单户累计最大购买金额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_min_buy_corp is '机构最小购买单位';
comment on column ${iml_schema}.prd_distr_finc_prod.org_fir_lowt_invest_amt is '机构首次最低投资金额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_supp_lowt_invest_amt is '机构追加最低投资金额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_lowt_aip_amt is '机构最低定投金额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_lowt_hold_lot is '机构最低持有份额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_sig_max_buy_amt is '机构单笔最大购买金额';
comment on column ${iml_schema}.prd_distr_finc_prod.org_single_amax_bamt is '机构单户累计最大购买金额';
comment on column ${iml_schema}.prd_distr_finc_prod.acm_corp_divd is '累计单位分红';
comment on column ${iml_schema}.prd_distr_finc_prod.clear_post_days is '清算延后天数';
comment on column ${iml_schema}.prd_distr_finc_prod.expe_yld_rat is '预期收益率';
comment on column ${iml_schema}.prd_distr_finc_prod.ped_days is '周期天数';
comment on column ${iml_schema}.prd_distr_finc_prod.prod_tepla_id is '产品模板编号';
comment on column ${iml_schema}.prd_distr_finc_prod.create_dt is '创建日期';
comment on column ${iml_schema}.prd_distr_finc_prod.update_dt is '更新日期';
comment on column ${iml_schema}.prd_distr_finc_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_distr_finc_prod.id_mark is '增删标志';
comment on column ${iml_schema}.prd_distr_finc_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_distr_finc_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_distr_finc_prod.etl_timestamp is 'ETL处理时间戳';
