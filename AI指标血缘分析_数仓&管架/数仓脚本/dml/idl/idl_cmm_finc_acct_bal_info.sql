/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_finc_acct_bal_info
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
--alter table ${idl_schema}.cmm_finc_acct_bal_info drop partition p_${last_date};
alter table ${idl_schema}.cmm_finc_acct_bal_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_finc_acct_bal_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_finc_acct_bal_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,tran_acct_id  -- 交易账户编号
    ,prod_id  -- 产品编号
    ,std_prod_id  -- 标准产品编号
    ,prod_name  -- 产品名称
    ,subj_id  -- 科目编号
    ,prft_adj_subj_id  -- 收益调整科目编号
    ,cust_id  -- 客户编号
    ,cust_type_cd  -- 客户类型代码
    ,finc_acct_id  -- 理财账户编号
    ,cont_id  -- 合约编号
    ,open_dt  -- 开立日期
    ,last_activ_acct_dt  -- 上次动户日期
    ,acct_status_cd  -- 账户状态代码
    ,open_org_id  -- 开立机构编号
    ,cust_mgr_id  -- 客户经理编号
    ,cap_stl_acct_num  -- 资金结算账号
    ,seller_cd  -- 销售商代码
    ,bank_id  -- 银行编号
    ,prft_fea_cd  -- 收益特征代码
    ,divd_way_cd  -- 分红方式代码
    ,tard_way_cd  -- 交易方式代码
    ,prod_status_cd  -- 产品状态代码
    ,prod_risk_level_cd  -- 产品风险等级代码
    ,prft_embody_way_cd  -- 收益体现方式代码
    ,charge_way_cd  -- 收费方式代码
    ,ctrl_flg_comb  -- 控制标志组合
    ,prod_found_dt  -- 产品成立日期
    ,prod_ped_days  -- 产品周期天数
    ,expe_yld_rat  -- 预期收益率
    ,annual_yld_rat  -- 年化收益率
    ,open_flg  -- 开放式标志
    ,ec_flg  -- 钞汇标志
    ,indv_allow_buy_flg  -- 个人允许购买标志
    ,prod_tepla_id  -- 产品模板编号
    ,prod_tepla_comnt  -- 产品模板说明
    ,brkevn_flg  -- 保本标志
    ,purch_dt  -- 申购日期
    ,exp_dt  -- 到期日期
    ,value_dt  -- 起息日期
    ,prft_exp_day  -- 收益到期日
    ,actl_value_dt  -- 实际起息日期
    ,actl_exp_dt  -- 实际到期日期
    ,curr_cd  -- 币种代码
    ,acct_bal  -- 账户余额
    ,mk_val_bal  -- 市值余额
    ,subscr_tot_amt  -- 认购总金额
    ,subscr_tot_lot  -- 认购总份额
    ,redem_lot  -- 赎回份额
    ,redem_amt  -- 赎回金额
    ,curr_lot  -- 当前份额
    ,aval_lot  -- 可用份额
    ,tran_froz_lot  -- 交易冻结份额
    ,lonterm_froz_lot  -- 长期冻结份额
    ,loc_froz_lot  -- 本地冻结份额
    ,prod_fee_f_unit_nv  -- 产品费前单位净值
    ,prod_fee_post_corp_nv  -- 产品费后单位净值
    ,td_cust_yld_rat  -- 当日客户收益率
    ,prod_fee_bf_ten_thous_prft  -- 产品费前万份收益
    ,td_prft  -- 本日收益
    ,invest_prft  -- 投资收益
    ,curr_issue_prft  -- 本期收益
    ,cl_curr_acct_bal  -- 折本币账户余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,m_acm_bal  -- 月累计余额
    ,s_acm_bal  -- 季累计余额
    ,y_acm_bal  -- 年累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,y_avg_bal  -- 年日均余额
    ,q_avg_bal  -- 季日均余额
    ,m_avg_bal  -- 月日均余额
    ,cl_curr_y_avg_bal  -- 折本币年日均余额
    ,cl_curr_q_avg_bal  -- 折本币季日均余额
    ,cl_curr_m_avg_bal  -- 折本币月日均余额
    ,cl_curr_mk_val_bal  -- 折本币市值余额
    ,ear_d_mk_val_bal  -- 日初市值余额
    ,ear_m_mk_val_bal  -- 月初市值余额
    ,ear_s_mk_val_bal  -- 季初市值余额
    ,ear_y_mk_val_bal  -- 年初市值余额
    ,m_acm_mk_val_bal  -- 月累计市值余额
    ,s_acm_mk_val_bal  -- 季累计市值余额
    ,y_acm_mk_val_bal  -- 年累计市值余额
    ,cl_curr_ear_d_mk_val_bal  -- 折本币日初市值余额
    ,cl_curr_ear_m_mk_val_bal  -- 折本币月初市值余额
    ,cl_curr_ear_s_mk_val_bal  -- 折本币季初市值余额
    ,cl_curr_ear_y_mk_val_bal  -- 折本币年初市值余额
    ,cl_curr_y_acm_mk_val_bal  -- 折本币年累计市值余额
    ,cl_curr_ear_d_y_acm_mk_val_bal  -- 折本币日初年累计市值余额
    ,cl_curr_ear_m_y_acm_mk_val_bal  -- 折本币月初年累计市值余额
    ,cl_curr_ear_s_y_acm_mk_val_bal  -- 折本币季初年累计市值余额
    ,cl_curr_ear_y_y_acm_mk_val_bal  -- 折本币年初年累计市值余额
    ,cl_curr_s_acm_mk_val_bal  -- 折本币季累计市值余额
    ,cl_curr_ear_d_s_acm_mk_val_bal  -- 折本币日初季累计市值余额
    ,cl_curr_ear_s_s_acm_mk_val_bal  -- 折本币季初季累计市值余额
    ,cl_curr_ear_y_s_acm_mk_val_bal  -- 折本币年初季累计市值余额
    ,cl_curr_m_acm_mk_val_bal  -- 折本币月累计市值余额
    ,cl_curr_ear_d_m_acm_mk_val_bal  -- 折本币日初月累计市值余额
    ,cl_curr_ear_m_m_acm_mk_val_bal  -- 折本币月初月累计市值余额
    ,cl_curr_ear_y_m_acm_mk_val_bal  -- 折本币年初月累计市值余额
    ,y_avg_mk_val_bal  -- 年日均市值余额
    ,q_avg_mk_val_bal  -- 季日均市值余额
    ,m_avg_mk_val_bal  -- 月日均市值余额
    ,cl_curr_y_avg_mk_val_bal  -- 折本币年日均市值余额
    ,cl_curr_q_avg_mk_val_bal  -- 折本币季日均市值余额
    ,cl_curr_m_avg_mk_val_bal  -- 折本币月日均市值余额
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'')  -- 交易账户编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'')  -- 标准产品编号
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.prft_adj_subj_id,chr(13),''),chr(10),'')  -- 收益调整科目编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'')  -- 客户类型代码
    ,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'')  -- 理财账户编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合约编号
    ,t1.open_dt  -- 开立日期
    ,t1.last_activ_acct_dt  -- 上次动户日期
    ,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'')  -- 账户状态代码
    ,replace(replace(t1.open_org_id,chr(13),''),chr(10),'')  -- 开立机构编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'')  -- 资金结算账号
    ,replace(replace(t1.seller_cd,chr(13),''),chr(10),'')  -- 销售商代码
    ,replace(replace(t1.bank_id,chr(13),''),chr(10),'')  -- 银行编号
    ,replace(replace(t1.prft_fea_cd,chr(13),''),chr(10),'')  -- 收益特征代码
    ,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'')  -- 分红方式代码
    ,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'')  -- 交易方式代码
    ,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'')  -- 产品状态代码
    ,replace(replace(t1.prod_risk_level_cd,chr(13),''),chr(10),'')  -- 产品风险等级代码
    ,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'')  -- 收益体现方式代码
    ,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'')  -- 收费方式代码
    ,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'')  -- 控制标志组合
    ,t1.prod_found_dt  -- 产品成立日期
    ,t1.prod_ped_days  -- 产品周期天数
    ,t1.expe_yld_rat  -- 预期收益率
    ,t1.annual_yld_rat  -- 年化收益率
    ,replace(replace(t1.open_flg,chr(13),''),chr(10),'')  -- 开放式标志
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.indv_allow_buy_flg,chr(13),''),chr(10),'')  -- 个人允许购买标志
    ,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'')  -- 产品模板编号
    ,replace(replace(t1.prod_tepla_comnt,chr(13),''),chr(10),'')  -- 产品模板说明
    ,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'')  -- 保本标志
    ,t1.purch_dt  -- 申购日期
    ,t1.exp_dt  -- 到期日期
    ,t1.value_dt  -- 起息日期
    ,t1.prft_exp_day  -- 收益到期日
    ,t1.actl_value_dt  -- 实际起息日期
    ,t1.actl_exp_dt  -- 实际到期日期
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.acct_bal  -- 账户余额
    ,t1.mk_val_bal  -- 市值余额
    ,t1.subscr_tot_amt  -- 认购总金额
    ,t1.subscr_tot_lot  -- 认购总份额
    ,t1.redem_lot  -- 赎回份额
    ,t1.redem_amt  -- 赎回金额
    ,t1.curr_lot  -- 当前份额
    ,t1.aval_lot  -- 可用份额
    ,t1.tran_froz_lot  -- 交易冻结份额
    ,t1.lonterm_froz_lot  -- 长期冻结份额
    ,t1.loc_froz_lot  -- 本地冻结份额
    ,t1.prod_fee_f_unit_nv  -- 产品费前单位净值
    ,t1.prod_fee_post_corp_nv  -- 产品费后单位净值
    ,t1.td_cust_yld_rat  -- 当日客户收益率
    ,t1.prod_fee_bf_ten_thous_prft  -- 产品费前万份收益
    ,t1.td_prft  -- 本日收益
    ,t1.invest_prft  -- 投资收益
    ,t1.curr_issue_prft  -- 本期收益
    ,t1.cl_curr_acct_bal  -- 折本币账户余额
    ,t1.ear_d_bal  -- 日初余额
    ,t1.ear_m_bal  -- 月初余额
    ,t1.ear_s_bal  -- 季初余额
    ,t1.ear_y_bal  -- 年初余额
    ,t1.m_acm_bal  -- 月累计余额
    ,t1.s_acm_bal  -- 季累计余额
    ,t1.y_acm_bal  -- 年累计余额
    ,t1.cl_curr_ear_d_bal  -- 折本币日初余额
    ,t1.cl_curr_ear_m_bal  -- 折本币月初余额
    ,t1.cl_curr_ear_s_bal  -- 折本币季初余额
    ,t1.cl_curr_ear_y_bal  -- 折本币年初余额
    ,t1.cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t1.cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t1.cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t1.cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t1.cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t1.cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t1.cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t1.cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t1.cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t1.cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t1.cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t1.cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t1.cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,t1.y_avg_bal  -- 年日均余额
    ,t1.q_avg_bal  -- 季日均余额
    ,t1.m_avg_bal  -- 月日均余额
    ,t1.cl_curr_y_avg_bal  -- 折本币年日均余额
    ,t1.cl_curr_q_avg_bal  -- 折本币季日均余额
    ,t1.cl_curr_m_avg_bal  -- 折本币月日均余额
    ,t1.cl_curr_mk_val_bal  -- 折本币市值余额
    ,t1.ear_d_mk_val_bal  -- 日初市值余额
    ,t1.ear_m_mk_val_bal  -- 月初市值余额
    ,t1.ear_s_mk_val_bal  -- 季初市值余额
    ,t1.ear_y_mk_val_bal  -- 年初市值余额
    ,t1.m_acm_mk_val_bal  -- 月累计市值余额
    ,t1.s_acm_mk_val_bal  -- 季累计市值余额
    ,t1.y_acm_mk_val_bal  -- 年累计市值余额
    ,t1.cl_curr_ear_d_mk_val_bal  -- 折本币日初市值余额
    ,t1.cl_curr_ear_m_mk_val_bal  -- 折本币月初市值余额
    ,t1.cl_curr_ear_s_mk_val_bal  -- 折本币季初市值余额
    ,t1.cl_curr_ear_y_mk_val_bal  -- 折本币年初市值余额
    ,t1.cl_curr_y_acm_mk_val_bal  -- 折本币年累计市值余额
    ,t1.cl_curr_ear_d_y_acm_mk_val_bal  -- 折本币日初年累计市值余额
    ,t1.cl_curr_ear_m_y_acm_mk_val_bal  -- 折本币月初年累计市值余额
    ,t1.cl_curr_ear_s_y_acm_mk_val_bal  -- 折本币季初年累计市值余额
    ,t1.cl_curr_ear_y_y_acm_mk_val_bal  -- 折本币年初年累计市值余额
    ,t1.cl_curr_s_acm_mk_val_bal  -- 折本币季累计市值余额
    ,t1.cl_curr_ear_d_s_acm_mk_val_bal  -- 折本币日初季累计市值余额
    ,t1.cl_curr_ear_s_s_acm_mk_val_bal  -- 折本币季初季累计市值余额
    ,t1.cl_curr_ear_y_s_acm_mk_val_bal  -- 折本币年初季累计市值余额
    ,t1.cl_curr_m_acm_mk_val_bal  -- 折本币月累计市值余额
    ,t1.cl_curr_ear_d_m_acm_mk_val_bal  -- 折本币日初月累计市值余额
    ,t1.cl_curr_ear_m_m_acm_mk_val_bal  -- 折本币月初月累计市值余额
    ,t1.cl_curr_ear_y_m_acm_mk_val_bal  -- 折本币年初月累计市值余额
    ,t1.y_avg_mk_val_bal  -- 年日均市值余额
    ,t1.q_avg_mk_val_bal  -- 季日均市值余额
    ,t1.m_avg_mk_val_bal  -- 月日均市值余额
    ,t1.cl_curr_y_avg_mk_val_bal  -- 折本币年日均市值余额
    ,t1.cl_curr_q_avg_mk_val_bal  -- 折本币季日均市值余额
    ,t1.cl_curr_m_avg_mk_val_bal  -- 折本币月日均市值余额
from ${icl_schema}.cmm_finc_acct_bal_info t1    --理财账户余额信息
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_finc_acct_bal_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);