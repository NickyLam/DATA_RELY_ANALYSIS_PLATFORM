/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_am_tran_provi_famsi1
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
drop table ${iml_schema}.evt_am_tran_provi_famsi1_tm purge;
alter table ${iml_schema}.evt_am_tran_provi add partition p_famsi1 values ('famsi1')(
        subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_am_tran_provi modify partition p_famsi1
    add subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_am_tran_provi_famsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,provi_dt -- 计提日期
    ,prod_acct_id -- 产品账户编号
    ,bus_id -- 业务编号
    ,bus_module_id -- 业务模块编号
    ,pos_type_cd -- 头寸类型代码
    ,tran_create_dt -- 交易生成日期
    ,tran_update_dt -- 交易更新日期
    ,cash_pos -- 现金头寸
    ,asset_pos -- 资产头寸
    ,provi_pos -- 计提头寸
    ,asset_liab_type_cd -- 资产负债类型代码
    ,exp_yld_rat -- 到期收益率
    ,td_acru_int -- 当日应计利息
    ,td_pay_int_provi_adj -- 当日付息计提调整
    ,td_adv_rpp_provi_adj -- 当日提前还本计提调整
    ,upaid_acru_int -- 未支付应计利息
    ,td_acm_acru_int_inco -- 当日累计应计利息收入
    ,td_add_paybl_int -- 当日新增应付未付利息
    ,td_upaid_turn_actl_amt -- 当日待支付转实付金额
    ,acm_upaid_amt -- 累计待支付金额
    ,td_bf_adj_acm_acru_int_inco -- 当日调整前累计应计利息收入
    ,td_tran_actl_acru_int -- 当日交易实付应计利息
    ,td_tran_actl_acru_int_aa -- 当日交易实付应计利息累计额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,upaid_pos -- 待支付头寸
    ,ld_intrv_acm_upaid_acru_int -- 上日区间累计未支付应计利息
    ,ld_acm_acru_int_inco -- 上日累计应计利息收入
    ,yd_acm_upaid -- 昨日累计待支付
    ,ld_bf_adj_acm_acru_int_inco -- 上日调整前累计应计利息收入
    ,yd_tran_actl_acru_int_aa -- 昨日交易实付应计利息累计额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,rpp_not_int_pos -- 已还本但未付息头寸
    ,full_amt_ia_td_ac -- 全额收益法当日核算成本
    ,full_amt_ia_yd_ac -- 全额收益法昨日核算成本
    ,full_amt_ia_td_prft -- 全额收益法当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,bal_ia_td_accti_pric_cost -- 差额收益法当日核算本金成本
    ,bal_ia_yd_accti_pric_cost -- 差额收益法昨日核算本金成本
    ,bal_ia_td_accti_int_cost -- 差额收益法当日核算利息成本
    ,bal_ia_yd_accti_int_cost -- 差额收益法昨日核算利息成本
    ,bal_ia_td_prft -- 差额收益法当日收益
    ,bal_ia_yd_prft -- 差额收益法昨日收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_tran_provi
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_bok_account_draw_details-
insert into ${iml_schema}.evt_am_tran_provi_famsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,provi_dt -- 计提日期
    ,prod_acct_id -- 产品账户编号
    ,bus_id -- 业务编号
    ,bus_module_id -- 业务模块编号
    ,pos_type_cd -- 头寸类型代码
    ,tran_create_dt -- 交易生成日期
    ,tran_update_dt -- 交易更新日期
    ,cash_pos -- 现金头寸
    ,asset_pos -- 资产头寸
    ,provi_pos -- 计提头寸
    ,asset_liab_type_cd -- 资产负债类型代码
    ,exp_yld_rat -- 到期收益率
    ,td_acru_int -- 当日应计利息
    ,td_pay_int_provi_adj -- 当日付息计提调整
    ,td_adv_rpp_provi_adj -- 当日提前还本计提调整
    ,upaid_acru_int -- 未支付应计利息
    ,td_acm_acru_int_inco -- 当日累计应计利息收入
    ,td_add_paybl_int -- 当日新增应付未付利息
    ,td_upaid_turn_actl_amt -- 当日待支付转实付金额
    ,acm_upaid_amt -- 累计待支付金额
    ,td_bf_adj_acm_acru_int_inco -- 当日调整前累计应计利息收入
    ,td_tran_actl_acru_int -- 当日交易实付应计利息
    ,td_tran_actl_acru_int_aa -- 当日交易实付应计利息累计额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,upaid_pos -- 待支付头寸
    ,ld_intrv_acm_upaid_acru_int -- 上日区间累计未支付应计利息
    ,ld_acm_acru_int_inco -- 上日累计应计利息收入
    ,yd_acm_upaid -- 昨日累计待支付
    ,ld_bf_adj_acm_acru_int_inco -- 上日调整前累计应计利息收入
    ,yd_tran_actl_acru_int_aa -- 昨日交易实付应计利息累计额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,rpp_not_int_pos -- 已还本但未付息头寸
    ,full_amt_ia_td_ac -- 全额收益法当日核算成本
    ,full_amt_ia_yd_ac -- 全额收益法昨日核算成本
    ,full_amt_ia_td_prft -- 全额收益法当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,bal_ia_td_accti_pric_cost -- 差额收益法当日核算本金成本
    ,bal_ia_yd_accti_pric_cost -- 差额收益法昨日核算本金成本
    ,bal_ia_td_accti_int_cost -- 差额收益法当日核算利息成本
    ,bal_ia_yd_accti_int_cost -- 差额收益法昨日核算利息成本
    ,bal_ia_td_prft -- 差额收益法当日收益
    ,bal_ia_yd_prft -- 差额收益法昨日收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104005'||TO_CHAR(P1.DRAWDATE,'YYYYMMDD')||ROW_NUMBER() OVER (PARTITION BY P1.BUSINESSSEQNO ORDER BY P1.DRAWDATE)||P1.BUSINESSSEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BUSINESSSEQNO -- 交易流水号
    ,P1.DRAWDATE -- 计提日期
    ,P1.ACCOUNTID -- 产品账户编号
    ,P1.BUSINESSID -- 业务编号
    ,P1.MODULEID -- 业务模块编号
    ,P1.PTYPE -- 头寸类型代码
    ,P1.GENDATE -- 交易生成日期
    ,P1.UPDATEDATE -- 交易更新日期
    ,P1.CASHAMT -- 现金头寸
    ,P1.ASSETAMT -- 资产头寸
    ,P1.PRINAMT -- 计提头寸
    ,P1.BALANCEFLAG -- 资产负债类型代码
    ,P1.YIELD -- 到期收益率
    ,P1.TDDRAW_ADD -- 当日应计利息
    ,P1.TDDRAW_INTPAY_ADJ -- 当日付息计提调整
    ,P1.TDDRAW_REPAY_ADJ -- 当日提前还本计提调整
    ,P1.PERIODDRAW -- 未支付应计利息
    ,P1.TOTALDRAW -- 当日累计应计利息收入
    ,P1.TDTOUNPAYDRAW -- 当日新增应付未付利息
    ,P1.TDTOACTPAYDRAW -- 当日待支付转实付金额
    ,P1.TOTALTOUNPAYDRAW -- 累计待支付金额
    ,P1.TOTALDRAW_UNADJ -- 当日调整前累计应计利息收入
    ,P1.TDACTPAYINT -- 当日交易实付应计利息
    ,P1.TOTALACTPAYINT -- 当日交易实付应计利息累计额
    ,P1.TOTALUNPAYINT -- 当日累计未付应计利息余额
    ,P1.UNPAYAMT -- 待支付头寸
    ,P1.YSTPERIODDRAW -- 上日区间累计未支付应计利息
    ,P1.YSTTOTALDRAW -- 上日累计应计利息收入
    ,P1.YSTTOTALTOUNPAYDRAW -- 昨日累计待支付
    ,P1.YSTTOTALDRAW_UNADJ -- 上日调整前累计应计利息收入
    ,P1.YSTTOTALACTPAYINT -- 昨日交易实付应计利息累计额
    ,P1.YSTTOTALUNPAYINT -- 昨日累计未付应计利息余额
    ,P1.PAYUNPAYINTAMT -- 已还本但未付息头寸
    ,P1.TDYCOSTA -- 全额收益法当日核算成本
    ,P1.YSTCOSTA -- 全额收益法昨日核算成本
    ,P1.TDYPROFITLOSSA -- 全额收益法当日收益
    ,P1.YSTPROFITLOSSA -- 全额收益法昨日收益
    ,P1.TDYCOSTCOSTB -- 差额收益法当日核算本金成本
    ,P1.YSTCOSTCOSTB -- 差额收益法昨日核算本金成本
    ,P1.TDYCOSTINTB -- 差额收益法当日核算利息成本
    ,P1.YSTCOSTINTB -- 差额收益法昨日核算利息成本
    ,P1.TDYPROFITLOSSB -- 差额收益法当日收益
    ,P1.YSTPROFITLOSSB -- 差额收益法昨日收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_account_draw_details' -- 源表名称
    ,'famsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_account_draw_details p1
where  1 = 1 
    AND P1.ETL_DT=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_am_tran_provi truncate subpartition p_famsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_am_tran_provi exchange subpartition p_famsi1_${batch_date} with table ${iml_schema}.evt_am_tran_provi_famsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_am_tran_provi to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_am_tran_provi_famsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_am_tran_provi', partname => 'p_famsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);