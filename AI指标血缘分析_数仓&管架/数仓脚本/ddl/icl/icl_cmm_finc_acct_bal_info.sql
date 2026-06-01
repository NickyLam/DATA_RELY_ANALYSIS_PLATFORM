/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_finc_acct_bal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_finc_acct_bal_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_finc_acct_bal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_finc_acct_bal_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,subj_id varchar2(60) -- 科目编号
    ,prft_adj_subj_id varchar2(60) -- 收益调整科目编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,cont_id varchar2(60) -- 合约编号
    ,open_dt date -- 开立日期
    ,clos_acct_dt date -- 销户日期
    ,last_activ_acct_dt date -- 上次动户日期
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,open_org_id varchar2(60) -- 开立机构编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,cap_stl_acct_num varchar2(60) -- 资金结算账号
    ,seller_cd varchar2(10) -- 销售商代码
    ,bank_id varchar2(60) -- 银行编号
    ,prft_fea_cd varchar2(10) -- 收益特征代码
    ,divd_way_cd varchar2(10) -- 分红方式代码
    ,tard_way_cd varchar2(10) -- 交易方式代码
    ,prod_status_cd varchar2(10) -- 产品状态代码
    ,prod_risk_level_cd varchar2(10) -- 产品风险等级代码
    ,prft_embody_way_cd varchar2(10) -- 收益体现方式代码
    ,charge_way_cd varchar2(10) -- 收费方式代码
    ,ctrl_flg_comb varchar2(375) -- 控制标志组合
    ,prod_found_dt date -- 产品成立日期
    ,allow_buy_begin_day date -- 允许购买起始日
    ,allow_buy_exp_day date -- 允许购买到期日
    ,prod_ped_days number(10) -- 产品周期天数
    ,expe_yld_rat number(18,6) -- 预期收益率
    ,annual_yld_rat number(18,6) -- 年化收益率
    ,open_flg varchar2(10) -- 开放式标志
    ,ec_flg varchar2(10) -- 钞汇标志
    ,indv_allow_buy_flg varchar2(10) -- 个人允许购买标志
    ,inpwn_flg varchar2(10) -- 质押标志
    ,prod_tepla_id varchar2(250) -- 产品模板编号
    ,prod_tepla_comnt varchar2(1000) -- 产品模板说明
    ,brkevn_flg varchar2(10) -- 保本标志
    ,purch_dt date -- 申购日期
    ,exp_dt date -- 到期日期
    ,value_dt date -- 起息日期
    ,prft_exp_day date -- 收益到期日
    ,actl_value_dt date -- 实际起息日期
    ,actl_exp_dt date -- 实际到期日期
    ,curr_cd varchar2(10) -- 币种代码
    ,acct_bal number(30,2) -- 账户余额
    ,mk_val_bal number(30,2) -- 市值余额
    ,subscr_tot_amt number(30,2) -- 认购总金额
    ,subscr_tot_lot number(30,2) -- 认购总份额
    ,redem_lot number(30,2) -- 赎回份额
    ,redem_amt number(30,2) -- 赎回金额
    ,curr_lot number(30,2) -- 当前份额
    ,aval_lot number(30,2) -- 可用份额
    ,tran_froz_lot number(30,2) -- 交易冻结份额
    ,lonterm_froz_lot number(30,2) -- 长期冻结份额
    ,loc_froz_lot number(30,2) -- 本地冻结份额
    ,prod_fee_f_unit_nv number(18,8) -- 产品费前单位净值
    ,prod_fee_post_corp_nv number(18,8) -- 产品费后单位净值
    ,td_cust_yld_rat number(18,8) -- 当日客户收益率
    ,prod_fee_bf_ten_thous_prft number(18,8) -- 产品费前万份收益
    ,td_prft number(30,2) -- 本日收益
    ,invest_prft number(30,2) -- 投资收益
    ,curr_issue_prft number(30,2) -- 本期收益
    ,cl_curr_acct_bal number(30,2) -- 折本币账户余额
    ,ear_d_bal number(30,2) -- 日初余额
    ,ear_m_bal number(30,2) -- 月初余额
    ,ear_s_bal number(30,2) -- 季初余额
    ,ear_y_bal number(30,2) -- 年初余额
    ,m_acm_bal number(30,2) -- 月累计余额
    ,s_acm_bal number(30,2) -- 季累计余额
    ,y_acm_bal number(30,2) -- 年累计余额
    ,cl_curr_ear_d_bal number(30,2) -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2) -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2) -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2) -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2) -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2) -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2) -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2) -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2) -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2) -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2) -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
    ,cl_curr_mk_val_bal number(30,2) -- 折本币市值余额
    ,ear_d_mk_val_bal number(30,2) -- 日初市值余额
    ,ear_m_mk_val_bal number(30,2) -- 月初市值余额
    ,ear_s_mk_val_bal number(30,2) -- 季初市值余额
    ,ear_y_mk_val_bal number(30,2) -- 年初市值余额
    ,m_acm_mk_val_bal number(30,2) -- 月累计市值余额
    ,s_acm_mk_val_bal number(30,2) -- 季累计市值余额
    ,y_acm_mk_val_bal number(30,2) -- 年累计市值余额
    ,cl_curr_ear_d_mk_val_bal number(30,2) -- 折本币日初市值余额
    ,cl_curr_ear_m_mk_val_bal number(30,2) -- 折本币月初市值余额
    ,cl_curr_ear_s_mk_val_bal number(30,2) -- 折本币季初市值余额
    ,cl_curr_ear_y_mk_val_bal number(30,2) -- 折本币年初市值余额
    ,cl_curr_y_acm_mk_val_bal number(30,2) -- 折本币年累计市值余额
    ,cl_curr_ear_d_y_acm_mk_val_bal number(30,2) -- 折本币日初年累计市值余额
    ,cl_curr_ear_m_y_acm_mk_val_bal number(30,2) -- 折本币月初年累计市值余额
    ,cl_curr_ear_s_y_acm_mk_val_bal number(30,2) -- 折本币季初年累计市值余额
    ,cl_curr_ear_y_y_acm_mk_val_bal number(30,2) -- 折本币年初年累计市值余额
    ,cl_curr_s_acm_mk_val_bal number(30,2) -- 折本币季累计市值余额
    ,cl_curr_ear_d_s_acm_mk_val_bal number(30,2) -- 折本币日初季累计市值余额
    ,cl_curr_ear_s_s_acm_mk_val_bal number(30,2) -- 折本币季初季累计市值余额
    ,cl_curr_ear_y_s_acm_mk_val_bal number(30,2) -- 折本币年初季累计市值余额
    ,cl_curr_m_acm_mk_val_bal number(30,2) -- 折本币月累计市值余额
    ,cl_curr_ear_d_m_acm_mk_val_bal number(30,2) -- 折本币日初月累计市值余额
    ,cl_curr_ear_m_m_acm_mk_val_bal number(30,2) -- 折本币月初月累计市值余额
    ,cl_curr_ear_y_m_acm_mk_val_bal number(30,2) -- 折本币年初月累计市值余额
    ,y_avg_mk_val_bal number(30,2) -- 年日均市值余额
    ,q_avg_mk_val_bal number(30,2) -- 季日均市值余额
    ,m_avg_mk_val_bal number(30,2) -- 月日均市值余额
    ,cl_curr_y_avg_mk_val_bal number(30,2) -- 折本币年日均市值余额
    ,cl_curr_q_avg_mk_val_bal number(30,2) -- 折本币季日均市值余额
    ,cl_curr_m_avg_mk_val_bal number(30,2) -- 折本币月日均市值余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_finc_acct_bal_info to ${idl_schema};
grant select on ${icl_schema}.cmm_finc_acct_bal_info to ${iel_schema};
grant select on ${icl_schema}.cmm_finc_acct_bal_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_finc_acct_bal_info is '理财账户余额信息';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prft_adj_subj_id is '收益调整科目编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.finc_acct_id is '理财账户编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cont_id is '合约编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.open_dt is '开立日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.last_activ_acct_dt is '上次动户日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.open_org_id is '开立机构编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cap_stl_acct_num is '资金结算账号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.seller_cd is '销售商代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.bank_id is '银行编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prft_fea_cd is '收益特征代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.divd_way_cd is '分红方式代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.tard_way_cd is '交易方式代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_status_cd is '产品状态代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_risk_level_cd is '产品风险等级代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prft_embody_way_cd is '收益体现方式代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.charge_way_cd is '收费方式代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ctrl_flg_comb is '控制标志组合';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_found_dt is '产品成立日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.allow_buy_begin_day is '允许购买起始日';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.allow_buy_exp_day is '允许购买到期日';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_ped_days is '产品周期天数';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.expe_yld_rat is '预期收益率';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.annual_yld_rat is '年化收益率';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.open_flg is '开放式标志';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ec_flg is '钞汇标志';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.indv_allow_buy_flg is '个人允许购买标志';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.inpwn_flg is '质押标志';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_tepla_id is '产品模板编号';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_tepla_comnt is '产品模板说明';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.brkevn_flg is '保本标志';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.purch_dt is '申购日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prft_exp_day is '收益到期日';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.actl_value_dt is '实际起息日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.actl_exp_dt is '实际到期日期';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.acct_bal is '账户余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.mk_val_bal is '市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.subscr_tot_amt is '认购总金额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.subscr_tot_lot is '认购总份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.redem_lot is '赎回份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.redem_amt is '赎回金额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.curr_lot is '当前份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.aval_lot is '可用份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.tran_froz_lot is '交易冻结份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.lonterm_froz_lot is '长期冻结份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.loc_froz_lot is '本地冻结份额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_fee_f_unit_nv is '产品费前单位净值';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_fee_post_corp_nv is '产品费后单位净值';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.td_cust_yld_rat is '当日客户收益率';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.prod_fee_bf_ten_thous_prft is '产品费前万份收益';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.td_prft is '本日收益';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.invest_prft is '投资收益';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.curr_issue_prft is '本期收益';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_acct_bal is '折本币账户余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_mk_val_bal is '折本币市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_d_mk_val_bal is '日初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_m_mk_val_bal is '月初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_s_mk_val_bal is '季初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.ear_y_mk_val_bal is '年初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.m_acm_mk_val_bal is '月累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.s_acm_mk_val_bal is '季累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.y_acm_mk_val_bal is '年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_mk_val_bal is '折本币日初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_mk_val_bal is '折本币月初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_mk_val_bal is '折本币季初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_mk_val_bal is '折本币年初市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_y_acm_mk_val_bal is '折本币年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_y_acm_mk_val_bal is '折本币日初年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_y_acm_mk_val_bal is '折本币月初年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_y_acm_mk_val_bal is '折本币季初年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_y_acm_mk_val_bal is '折本币年初年累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_s_acm_mk_val_bal is '折本币季累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_s_acm_mk_val_bal is '折本币日初季累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_s_s_acm_mk_val_bal is '折本币季初季累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_s_acm_mk_val_bal is '折本币年初季累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_m_acm_mk_val_bal is '折本币月累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_d_m_acm_mk_val_bal is '折本币日初月累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_m_m_acm_mk_val_bal is '折本币月初月累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_ear_y_m_acm_mk_val_bal is '折本币年初月累计市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.y_avg_mk_val_bal is '年日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.q_avg_mk_val_bal is '季日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.m_avg_mk_val_bal is '月日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_y_avg_mk_val_bal is '折本币年日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_q_avg_mk_val_bal is '折本币季日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.cl_curr_m_avg_mk_val_bal is '折本币月日均市值余额';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_finc_acct_bal_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_finc_acct_bal_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_finc_acct_bal_info.etl_timestamp is 'ETL处理时间戳';
