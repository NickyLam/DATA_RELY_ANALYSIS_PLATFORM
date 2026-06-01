/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_non_std_asset_pos_famsi1
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
drop table ${iml_schema}.prd_am_non_std_asset_pos_famsi1_tm purge;
alter table ${iml_schema}.prd_am_non_std_asset_pos add partition p_famsi1 values ('famsi1')(
        subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_non_std_asset_pos modify partition p_famsi1
    add subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_non_std_asset_pos_famsi1_tm
compress ${option_switch} for query high
as
select
    pos_dt -- 头寸日期
    ,lp_id -- 法人编号
    ,prod_acct_id -- 产品账户编号
    ,prod_id -- 产品编号
    ,pos_type_cd -- 头寸类型代码
    ,asset_plan_cd -- 资产计划代码
    ,cash_pos -- 现金头寸
    ,asset_pos -- 资产头寸
    ,init_provi_pos -- 原始计提头寸
    ,provi_pos -- 计提头寸
    ,td_provi_acru_int -- 当日计提的应计利息
    ,td_adj_acru_int -- 当日调整的应计利息
    ,td_tran_actl_acru_int -- 当日交易实付的应计利息
    ,td_tran_actl_acru_int_aa -- 当日交易实付的应计利息累计额
    ,yd_tran_actl_acru_int_aa -- 昨日交易实付的应计利息累计额
    ,td_intrv_acm_acru_int_bal -- 当日区间累计应计利息余额
    ,td_add_upaid_acru_int_tot -- 当日新增的待支付应计利息总额
    ,td_carr_upaid_acru_int_tot -- 当日结转的待支付应计利息总额
    ,td_upaid_acru_int_aa -- 当日待支付应计利息累计额
    ,yd_upaid_acru_int_aa -- 昨日待支付应计利息累计额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,td_adj_acm_acru_int_inco_bal -- 当日调整累计应计利息收入余额
    ,yd_adj_acm_acru_int_inco -- 昨日调整累计应计利息收入
    ,td_acm_acru_int_inco_bal -- 当日累计应计利息收入余额
    ,yd_acm_acru_int_inco -- 昨日累计应计利息收入
    ,td_entry_int -- 当日记账利息
    ,yd_intrv_acm_acru_int_bal -- 昨日区间累计的应计利息余额
    ,full_amt_ia_td_ac -- 全额收益法当日核算成本
    ,full_amt_ia_yd_ac -- 全额收益法昨日核算成本
    ,full_amt_ia_td_prft -- 全额收益法当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,bal_ia_cost_td_ac -- 差额收益法成本当日核算成本
    ,bal_ia_cost_yd_ac -- 差额收益法成本昨日核算成本
    ,bal_ia_int_td_ac -- 差额收益法利息当日核算成本
    ,bal_ia_int_yd_ac -- 差额收益法利息昨日核算成本
    ,bal_ia_td_prft -- 差额收益法当日收益
    ,bal_ia_yd_prft -- 差额收益法昨日收益
    ,td_happ_int_adj -- 当日发生利息调整
    ,td_int_adj_chg_lmt -- 当日利息调整变动额
    ,td_int_adj_chg_tot -- 当日利息调整变动总额
    ,yd_int_adj_chg_tot -- 昨日利息调整变动总额
    ,td_acm_int_adj_bal -- 当日累计利息调整余额
    ,yd_acm_int_adj_bal -- 昨日累计利息调整余额
    ,td_acm_amort_inco -- 当日累计摊销收入
    ,yd_acm_amort_inco -- 昨日累计摊销收入
    ,td_acm_spd_inco -- 当日累计价差收入
    ,yd_acm_spd_inco -- 昨日累计价差收入
    ,amort_bf_td_cost_net_price -- 摊余前当日成本净价
    ,td_cost_net_price -- 当日成本净价
    ,yd_cost_net_price -- 昨日成本净价
    ,td_cost_tot -- 当日成本总额
    ,yd_cost_tot -- 昨日成本总额
    ,exp_yld_rat -- 到期收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_non_std_asset_pos
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_bok_draw_us-
insert into ${iml_schema}.prd_am_non_std_asset_pos_famsi1_tm(
    pos_dt -- 头寸日期
    ,lp_id -- 法人编号
    ,prod_acct_id -- 产品账户编号
    ,prod_id -- 产品编号
    ,pos_type_cd -- 头寸类型代码
    ,asset_plan_cd -- 资产计划代码
    ,cash_pos -- 现金头寸
    ,asset_pos -- 资产头寸
    ,init_provi_pos -- 原始计提头寸
    ,provi_pos -- 计提头寸
    ,td_provi_acru_int -- 当日计提的应计利息
    ,td_adj_acru_int -- 当日调整的应计利息
    ,td_tran_actl_acru_int -- 当日交易实付的应计利息
    ,td_tran_actl_acru_int_aa -- 当日交易实付的应计利息累计额
    ,yd_tran_actl_acru_int_aa -- 昨日交易实付的应计利息累计额
    ,td_intrv_acm_acru_int_bal -- 当日区间累计应计利息余额
    ,td_add_upaid_acru_int_tot -- 当日新增的待支付应计利息总额
    ,td_carr_upaid_acru_int_tot -- 当日结转的待支付应计利息总额
    ,td_upaid_acru_int_aa -- 当日待支付应计利息累计额
    ,yd_upaid_acru_int_aa -- 昨日待支付应计利息累计额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,td_adj_acm_acru_int_inco_bal -- 当日调整累计应计利息收入余额
    ,yd_adj_acm_acru_int_inco -- 昨日调整累计应计利息收入
    ,td_acm_acru_int_inco_bal -- 当日累计应计利息收入余额
    ,yd_acm_acru_int_inco -- 昨日累计应计利息收入
    ,td_entry_int -- 当日记账利息
    ,yd_intrv_acm_acru_int_bal -- 昨日区间累计的应计利息余额
    ,full_amt_ia_td_ac -- 全额收益法当日核算成本
    ,full_amt_ia_yd_ac -- 全额收益法昨日核算成本
    ,full_amt_ia_td_prft -- 全额收益法当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,bal_ia_cost_td_ac -- 差额收益法成本当日核算成本
    ,bal_ia_cost_yd_ac -- 差额收益法成本昨日核算成本
    ,bal_ia_int_td_ac -- 差额收益法利息当日核算成本
    ,bal_ia_int_yd_ac -- 差额收益法利息昨日核算成本
    ,bal_ia_td_prft -- 差额收益法当日收益
    ,bal_ia_yd_prft -- 差额收益法昨日收益
    ,td_happ_int_adj -- 当日发生利息调整
    ,td_int_adj_chg_lmt -- 当日利息调整变动额
    ,td_int_adj_chg_tot -- 当日利息调整变动总额
    ,yd_int_adj_chg_tot -- 昨日利息调整变动总额
    ,td_acm_int_adj_bal -- 当日累计利息调整余额
    ,yd_acm_int_adj_bal -- 昨日累计利息调整余额
    ,td_acm_amort_inco -- 当日累计摊销收入
    ,yd_acm_amort_inco -- 昨日累计摊销收入
    ,td_acm_spd_inco -- 当日累计价差收入
    ,yd_acm_spd_inco -- 昨日累计价差收入
    ,amort_bf_td_cost_net_price -- 摊余前当日成本净价
    ,td_cost_net_price -- 当日成本净价
    ,yd_cost_net_price -- 昨日成本净价
    ,td_cost_tot -- 当日成本总额
    ,yd_cost_tot -- 昨日成本总额
    ,exp_yld_rat -- 到期收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.DRAWDATE -- 头寸日期
    ,'9999' -- 法人编号
    ,P1.ACCOUNTID -- 产品账户编号
    ,P1.TRUSTUUID -- 产品编号
    ,P1.PTYPE -- 头寸类型代码
    ,P1.TRUSTID -- 资产计划代码
    ,P1.CASHAMT -- 现金头寸
    ,P1.ASSETAMT -- 资产头寸
    ,P1.ORIPRINAMT -- 原始计提头寸
    ,P1.DRAWPRINAMT -- 计提头寸
    ,P1.TDYINTINCEXP_ADD -- 当日计提的应计利息
    ,P1.TDYINTINCEXP_ADJ -- 当日调整的应计利息
    ,P1.TDYINTINCEXP_CHA -- 当日交易实付的应计利息
    ,P1.TDYINTINCEXPCHASUM -- 当日交易实付的应计利息累计额
    ,P1.YSTINTINCEXPCHASUM -- 昨日交易实付的应计利息累计额
    ,P1.TDYREGIONTINTINCEXP -- 当日区间累计应计利息余额
    ,P1.TDYTOBEPAIDINTINCEXP_ADD -- 当日新增的待支付应计利息总额
    ,P1.TDYTOBEPAIDINTINCEXP_DEL -- 当日结转的待支付应计利息总额
    ,P1.TDYTOBEPAIDINTINCEXP -- 当日待支付应计利息累计额
    ,P1.YSTTOBEPAIDINTINCEXP -- 昨日待支付应计利息累计额
    ,P1.TDYUNPAIDINTINCEXP -- 当日累计未付应计利息余额
    ,P1.YSTUNPAIDINTINCEXP -- 昨日累计未付应计利息余额
    ,P1.TDYINTINCEXP -- 当日调整累计应计利息收入余额
    ,P1.YSTINTINCEXP -- 昨日调整累计应计利息收入
    ,P1.TDYINTINCEXP_UN -- 当日累计应计利息收入余额
    ,P1.YSTINTINCEXP_UN -- 昨日累计应计利息收入
    ,P1.TDYINTINC_DR -- 当日记账利息
    ,P1.YSTREGIONTINTINCEXP -- 昨日区间累计的应计利息余额
    ,P1.TDYCOSTA -- 全额收益法当日核算成本
    ,P1.YSTCOSTA -- 全额收益法昨日核算成本
    ,P1.TDYPROFITLOSSA -- 全额收益法当日收益
    ,P1.YSTPROFITLOSSA -- 全额收益法昨日收益
    ,P1.TDYCOSTCOSTB -- 差额收益法成本当日核算成本
    ,P1.YSTCOSTCOSTB -- 差额收益法成本昨日核算成本
    ,P1.TDYCOSTINTB -- 差额收益法利息当日核算成本
    ,P1.YSTCOSTINTB -- 差额收益法利息昨日核算成本
    ,P1.TDYPROFITLOSSB -- 差额收益法当日收益
    ,P1.YSTPROFITLOSSB -- 差额收益法昨日收益
    ,P1.TDYDSCINCEXP_ADD -- 当日发生利息调整
    ,P1.TDYDSCINCEXP_CHA -- 当日利息调整变动额
    ,P1.TDYDSCINCEXPCHASUM -- 当日利息调整变动总额
    ,P1.YSTDSCINCEXPCHASUM -- 昨日利息调整变动总额
    ,P1.TDYUNPAIDDSCINCEXP -- 当日累计利息调整余额
    ,P1.YSTUNPAIDDSCINCEXP -- 昨日累计利息调整余额
    ,P1.TDYDSCINCEXP -- 当日累计摊销收入
    ,P1.YSTDSCINCEXP -- 昨日累计摊销收入
    ,P1.TDYPROFITLOSS -- 当日累计价差收入
    ,P1.YSTPROFITLOSS -- 昨日累计价差收入
    ,P1.TDYCPRICEBF -- 摊余前当日成本净价
    ,P1.TDYCPRICE -- 当日成本净价
    ,P1.YSTCPRICE -- 昨日成本净价
    ,P1.TDYCOSTAMT -- 当日成本总额
    ,P1.YSTCOSTAMT -- 昨日成本总额
    ,P1.MAYIELD -- 到期收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_draw_us' -- 源表名称
    ,'famsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_draw_us p1
where  1 = 1 
    AND P1.ETL_DT=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_am_non_std_asset_pos truncate subpartition p_famsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_am_non_std_asset_pos exchange subpartition p_famsi1_${batch_date} with table ${iml_schema}.prd_am_non_std_asset_pos_famsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_non_std_asset_pos to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_non_std_asset_pos_famsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_non_std_asset_pos', partname => 'p_famsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);