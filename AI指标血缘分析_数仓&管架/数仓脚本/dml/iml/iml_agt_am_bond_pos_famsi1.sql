/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_am_bond_pos_famsi1
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
drop table ${iml_schema}.agt_am_bond_pos_famsi1_tm purge;
alter table ${iml_schema}.agt_am_bond_pos add partition p_famsi1 values ('famsi1')(
        subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_am_bond_pos modify partition p_famsi1
    add subpartition p_famsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_am_bond_pos_famsi1_tm
compress ${option_switch} for query high
as
select
    pos_dt -- 头寸日期
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,pos_type_cd -- 头寸类型代码
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,prod_acct_id -- 产品账户编号
    ,asset_cls4_cd -- 资产四分类代码
    ,surp_tenor -- 剩余期限
    ,exp_yld_rat -- 到期收益率
    ,currt_yld_rat -- 当期收益率
    ,ex_exp_yld_rat -- 行权到期收益率
    ,ex_currt_yld_rat -- 行权当期收益率
    ,day_amort_yld_rat -- 日摊销收益率
    ,cost_coret_duran -- 成本修正久期
    ,cost_cvty -- 成本凸性
    ,fr_bond_spd_duran -- 浮息债利差久期
    ,fr_bond_spd_cvty -- 浮息债利差凸性
    ,fr_bond_int_rat_duran -- 浮息债利率久期
    ,fr_bond_int_rat_cvty -- 浮息债利率凸性
    ,bp_val -- 基点价值
    ,nd_corp_acru_int -- 下日单位应计利息
    ,td_corp_acru_int -- 当日单位应计利息
    ,yd_corp_acru_int -- 昨日单位应计利息
    ,amort_bf_td_cost_net_price -- 摊余前当日成本净价
    ,td_cost_net_price -- 当日成本净价
    ,yd_cost_net_price -- 昨日成本净价
    ,td_mk_val_net_price -- 当日市值净价
    ,yd_mk_val_net_price -- 昨日市值净价
    ,td_mk_pri_yld_rat -- 当日市价收益率
    ,yd_mk_pri_yld_rat -- 昨日市价收益率
    ,td_cost_tot -- 当日成本总额
    ,yd_cost_tot -- 昨日成本总额
    ,dlvyd_td_tran_post_qtty -- 交割日当日交易持仓量
    ,dlvyd_ld_tran_post_qtty -- 交割日上日交易持仓量
    ,td_tran_post_qtty -- 当日交易持仓量
    ,ld_tran_post_qtty -- 上日交易持仓量
    ,td_mk_val_chg -- 当日市值变动
    ,yd_mk_val_chg -- 昨日市值变动
    ,td_float_prft_loss -- 当日浮动盈亏
    ,yd_float_prft_loss -- 昨日浮动盈亏
    ,td_happ_int_adj -- 当日发生利息调整
    ,td_int_adj_chg_lmt -- 当日利息调整变动额
    ,td_int_adj_chg_tot -- 当日利息调整变动总额
    ,yd_int_adj_chg_tot -- 昨日利息调整变动总额
    ,td_acm_int_adj_bal -- 当日累计利息调整余额
    ,yd_acm_int_adj_bal -- 昨日累计利息调整余额
    ,td_acm_amort_inco -- 当日累计摊销收入
    ,yd_acm_amort_inco -- 昨日累计摊销收入
    ,td_acru_int -- 当日应计利息
    ,td_acru_int_adj -- 当日应计利息调整
    ,td_acru_int_chg_lmt -- 当日应计利息变动额
    ,td_acru_int_chg_tot -- 当日应计利息变动总额
    ,yd_acru_int_chg_tot -- 昨日应计利息变动总额
    ,td_intrv_acm_acru_int_bal -- 当日区间累计应计利息余额
    ,yd_intrv_acm_acru_int_bal -- 昨日区间累计应计利息余额
    ,td_happ_upaid_acru_int_tot -- 当日发生待支付应计利息总额
    ,td_carr_upaid_acru_int_tot -- 当日结转待支付应计利息总额
    ,td_acm_upaid_acru_int_tot -- 当日累计待支付应计利息总额
    ,yd_acm_upaid_acru_int_tot -- 昨日累计待支付应计利息总额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,td_acm_acru_int_inco -- 当日累计应计利息收入
    ,yd_acm_acru_int_inco -- 昨日累计应计利息收入
    ,td_nadj_acm_acru_int_inco -- 当日不调整累计应计利息收入
    ,yd_nadj_acm_acru_int_inco -- 昨日不调整累计应计利息收入
    ,td_acm_spd_inco -- 当日累计价差收入
    ,yd_acm_spd_inco -- 昨日累计价差收入
    ,bond_ac -- 债券核算成本
    ,bond_prft -- 债券收益
    ,yd_spd_inco -- 昨日价差收入
    ,td_tran_fac_val -- 当日交易面值
    ,ld_tran_fac_val -- 上日交易面值
    ,td_upaid_cost_tot -- 当日待支付成本总额
    ,yd_upaid_cost_tot -- 昨日待支付成本总额
    ,td_acm_upaid_amort_tot -- 当日累计待支付摊销总额
    ,yd_acm_upaid_amort_tot -- 昨日累计待支付摊销总额
    ,td_happ_upaid_amort_tot -- 当日发生待支付摊销总额
    ,td_carr_upaid_amort_tot -- 当日结转待支付摊销总额
    ,td_acm_upaid_bond_ac -- 当日累计待支付债券核算成本
    ,td_hundred_y_cert_face_val -- 当日百元券面面值
    ,td_happ_upaid_cost_tot -- 当日发生待支付成本总额
    ,td_carr_upaid_cost_tot -- 当日结转待支付成本总额
    ,ld_bond_ac -- 上日债券核算成本
    ,td_happ_upaid_bond_ac -- 当日发生待支付债券核算成本
    ,td_carr_upaid_bond_ac -- 当日结转待支付债券核算成本
    ,ld_acm_upaid_bond_ac -- 上日累计待支付债券核算成本
    ,td_cost_ac -- 当日成本核算成本
    ,yd_cost_ac -- 昨日成本核算成本
    ,td_int_ac -- 当日利息核算成本
    ,yd_int_ac -- 昨日利息核算成本
    ,td_prft -- 当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,init_tran_id -- 原始交易编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_bond_pos
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_sec_trad_position_deal_bok-
insert into ${iml_schema}.agt_am_bond_pos_famsi1_tm(
    pos_dt -- 头寸日期
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,pos_type_cd -- 头寸类型代码
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,prod_acct_id -- 产品账户编号
    ,asset_cls4_cd -- 资产四分类代码
    ,surp_tenor -- 剩余期限
    ,exp_yld_rat -- 到期收益率
    ,currt_yld_rat -- 当期收益率
    ,ex_exp_yld_rat -- 行权到期收益率
    ,ex_currt_yld_rat -- 行权当期收益率
    ,day_amort_yld_rat -- 日摊销收益率
    ,cost_coret_duran -- 成本修正久期
    ,cost_cvty -- 成本凸性
    ,fr_bond_spd_duran -- 浮息债利差久期
    ,fr_bond_spd_cvty -- 浮息债利差凸性
    ,fr_bond_int_rat_duran -- 浮息债利率久期
    ,fr_bond_int_rat_cvty -- 浮息债利率凸性
    ,bp_val -- 基点价值
    ,nd_corp_acru_int -- 下日单位应计利息
    ,td_corp_acru_int -- 当日单位应计利息
    ,yd_corp_acru_int -- 昨日单位应计利息
    ,amort_bf_td_cost_net_price -- 摊余前当日成本净价
    ,td_cost_net_price -- 当日成本净价
    ,yd_cost_net_price -- 昨日成本净价
    ,td_mk_val_net_price -- 当日市值净价
    ,yd_mk_val_net_price -- 昨日市值净价
    ,td_mk_pri_yld_rat -- 当日市价收益率
    ,yd_mk_pri_yld_rat -- 昨日市价收益率
    ,td_cost_tot -- 当日成本总额
    ,yd_cost_tot -- 昨日成本总额
    ,dlvyd_td_tran_post_qtty -- 交割日当日交易持仓量
    ,dlvyd_ld_tran_post_qtty -- 交割日上日交易持仓量
    ,td_tran_post_qtty -- 当日交易持仓量
    ,ld_tran_post_qtty -- 上日交易持仓量
    ,td_mk_val_chg -- 当日市值变动
    ,yd_mk_val_chg -- 昨日市值变动
    ,td_float_prft_loss -- 当日浮动盈亏
    ,yd_float_prft_loss -- 昨日浮动盈亏
    ,td_happ_int_adj -- 当日发生利息调整
    ,td_int_adj_chg_lmt -- 当日利息调整变动额
    ,td_int_adj_chg_tot -- 当日利息调整变动总额
    ,yd_int_adj_chg_tot -- 昨日利息调整变动总额
    ,td_acm_int_adj_bal -- 当日累计利息调整余额
    ,yd_acm_int_adj_bal -- 昨日累计利息调整余额
    ,td_acm_amort_inco -- 当日累计摊销收入
    ,yd_acm_amort_inco -- 昨日累计摊销收入
    ,td_acru_int -- 当日应计利息
    ,td_acru_int_adj -- 当日应计利息调整
    ,td_acru_int_chg_lmt -- 当日应计利息变动额
    ,td_acru_int_chg_tot -- 当日应计利息变动总额
    ,yd_acru_int_chg_tot -- 昨日应计利息变动总额
    ,td_intrv_acm_acru_int_bal -- 当日区间累计应计利息余额
    ,yd_intrv_acm_acru_int_bal -- 昨日区间累计应计利息余额
    ,td_happ_upaid_acru_int_tot -- 当日发生待支付应计利息总额
    ,td_carr_upaid_acru_int_tot -- 当日结转待支付应计利息总额
    ,td_acm_upaid_acru_int_tot -- 当日累计待支付应计利息总额
    ,yd_acm_upaid_acru_int_tot -- 昨日累计待支付应计利息总额
    ,td_acm_unpaid_acru_int_bal -- 当日累计未付应计利息余额
    ,yd_acm_unpaid_acru_int_bal -- 昨日累计未付应计利息余额
    ,td_acm_acru_int_inco -- 当日累计应计利息收入
    ,yd_acm_acru_int_inco -- 昨日累计应计利息收入
    ,td_nadj_acm_acru_int_inco -- 当日不调整累计应计利息收入
    ,yd_nadj_acm_acru_int_inco -- 昨日不调整累计应计利息收入
    ,td_acm_spd_inco -- 当日累计价差收入
    ,yd_acm_spd_inco -- 昨日累计价差收入
    ,bond_ac -- 债券核算成本
    ,bond_prft -- 债券收益
    ,yd_spd_inco -- 昨日价差收入
    ,td_tran_fac_val -- 当日交易面值
    ,ld_tran_fac_val -- 上日交易面值
    ,td_upaid_cost_tot -- 当日待支付成本总额
    ,yd_upaid_cost_tot -- 昨日待支付成本总额
    ,td_acm_upaid_amort_tot -- 当日累计待支付摊销总额
    ,yd_acm_upaid_amort_tot -- 昨日累计待支付摊销总额
    ,td_happ_upaid_amort_tot -- 当日发生待支付摊销总额
    ,td_carr_upaid_amort_tot -- 当日结转待支付摊销总额
    ,td_acm_upaid_bond_ac -- 当日累计待支付债券核算成本
    ,td_hundred_y_cert_face_val -- 当日百元券面面值
    ,td_happ_upaid_cost_tot -- 当日发生待支付成本总额
    ,td_carr_upaid_cost_tot -- 当日结转待支付成本总额
    ,ld_bond_ac -- 上日债券核算成本
    ,td_happ_upaid_bond_ac -- 当日发生待支付债券核算成本
    ,td_carr_upaid_bond_ac -- 当日结转待支付债券核算成本
    ,ld_acm_upaid_bond_ac -- 上日累计待支付债券核算成本
    ,td_cost_ac -- 当日成本核算成本
    ,yd_cost_ac -- 昨日成本核算成本
    ,td_int_ac -- 当日利息核算成本
    ,yd_int_ac -- 昨日利息核算成本
    ,td_prft -- 当日收益
    ,full_amt_ia_yd_prft -- 全额收益法昨日收益
    ,init_tran_id -- 原始交易编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    ${iml_schema}.DATEFORMAT_MAX(to_char(P1.CDATE)) -- 头寸日期
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 交易流水号
    ,P1.PTYPE -- 头寸类型代码
    ,P1.TRADEID -- 业务编号
    ,P1.SECID -- 产品编号
    ,P1.ACCOUNT -- 产品账户编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.INVESTTYPE END -- 资产四分类代码
    ,P1.ENCASHYEARS -- 剩余期限
    ,P1.MAYIELD -- 到期收益率
    ,P1.IMYIELD -- 当期收益率
    ,P1.OPTION_MAYIELD -- 行权到期收益率
    ,P1.OPTION_IMYIELD -- 行权当期收益率
    ,P1.DAILYDSCYIELD -- 日摊销收益率
    ,P1.DURATION -- 成本修正久期
    ,P1.CNVXTY -- 成本凸性
    ,P1.MSPRD_D -- 浮息债利差久期
    ,P1.MSPRD_CNVXTY -- 浮息债利差凸性
    ,P1.MYIELD_D -- 浮息债利率久期
    ,P1.MYIELD_CNVXTY -- 浮息债利率凸性
    ,P1.DV01 -- 基点价值
    ,P1.TOMACCRUE -- 下日单位应计利息
    ,P1.TDYACCRUE -- 当日单位应计利息
    ,P1.YSTACCRUE -- 昨日单位应计利息
    ,P1.TDYCPRICEBF -- 摊余前当日成本净价
    ,P1.TDYCPRICE -- 当日成本净价
    ,P1.YSTCPRICE -- 昨日成本净价
    ,P1.TDYMARKETCPRICE -- 当日市值净价
    ,P1.YSTMARKETCPRICE -- 昨日市值净价
    ,P1.TDYMARKETYIELD -- 当日市价收益率
    ,P1.YSTMARKETYIELD -- 昨日市价收益率
    ,P1.TDYCOSTAMT -- 当日成本总额
    ,P1.YSTCOSTAMT -- 昨日成本总额
    ,P1.TDYPRINAMT -- 交割日当日交易持仓量
    ,P1.YSTPRINAMT -- 交割日上日交易持仓量
    ,P1.TDYPRINAMT_PAID -- 当日交易持仓量
    ,P1.YSTPRINAMT_PAID -- 上日交易持仓量
    ,P1.TDYMTM -- 当日市值变动
    ,P1.YSTMTM -- 昨日市值变动
    ,P1.TDYFLOATINGPL -- 当日浮动盈亏
    ,P1.YSTFLOATINGPL -- 昨日浮动盈亏
    ,P1.TDYDSCINCEXP_ADD -- 当日发生利息调整
    ,P1.TDYDSCINCEXP_CHA -- 当日利息调整变动额
    ,P1.TDYDSCINCEXPCHASUM -- 当日利息调整变动总额
    ,P1.YSTDSCINCEXPCHASUM -- 昨日利息调整变动总额
    ,P1.TDYUNPAIDDSCINCEXP -- 当日累计利息调整余额
    ,P1.YSTUNPAIDDSCINCEXP -- 昨日累计利息调整余额
    ,P1.TDYDSCINCEXP -- 当日累计摊销收入
    ,P1.YSTDSCINCEXP -- 昨日累计摊销收入
    ,P1.TDYINTINCEXP_ADD -- 当日应计利息
    ,P1.TDYINTINCEXP_ADJ -- 当日应计利息调整
    ,P1.TDYINTINCEXP_CHA -- 当日应计利息变动额
    ,P1.TDYINTINCEXPCHASUM -- 当日应计利息变动总额
    ,P1.YSTINTINCEXPCHASUM -- 昨日应计利息变动总额
    ,P1.TDYREGIONTINTINCEXP -- 当日区间累计应计利息余额
    ,P1.YSTREGIONTINTINCEXP -- 昨日区间累计应计利息余额
    ,P1.TDYTOBEPAIDINTINCEXP_ADD -- 当日发生待支付应计利息总额
    ,P1.TDYTOBEPAIDINTINCEXP_DEL -- 当日结转待支付应计利息总额
    ,P1.TDYTOBEPAIDINTINCEXP -- 当日累计待支付应计利息总额
    ,P1.YSTTOBEPAIDINTINCEXP -- 昨日累计待支付应计利息总额
    ,P1.TDYUNPAIDINTINCEXP -- 当日累计未付应计利息余额
    ,P1.YSTUNPAIDINTINCEXP -- 昨日累计未付应计利息余额
    ,P1.TDYINTINCEXP -- 当日累计应计利息收入
    ,P1.YSTINTINCEXP -- 昨日累计应计利息收入
    ,P1.TDYINTINCEXP_UN -- 当日不调整累计应计利息收入
    ,P1.YSTINTINCEXP_UN -- 昨日不调整累计应计利息收入
    ,P1.TDYPROFITLOSS -- 当日累计价差收入
    ,P1.YSTPROFITLOSS -- 昨日累计价差收入
    ,P1.COST_1 -- 债券核算成本
    ,P1.PROFITLOSS_1 -- 债券收益
    ,P1.PROFITLOSSBF_1 -- 昨日价差收入
    ,P1.TDYPRINAMT_ACT -- 当日交易面值
    ,P1.YSTPRINAMT_ACT -- 上日交易面值
    ,P1.TDYTOBEPAIDCOSTAMT -- 当日待支付成本总额
    ,P1.YSTTOBEPAIDCOSTAMT -- 昨日待支付成本总额
    ,P1.TDYTOBEPAIDDSCINCEXP -- 当日累计待支付摊销总额
    ,P1.YSTTOBEPAIDDSCINCEXP -- 昨日累计待支付摊销总额
    ,P1.TDYTOBEPAIDDSCINCEXP_ADD -- 当日发生待支付摊销总额
    ,P1.TDYTOBEPAIDDSCINCEXP_DEL -- 当日结转待支付摊销总额
    ,P1.TDYTOBEPAIDCOST_1 -- 当日累计待支付债券核算成本
    ,P1.FACEVALUE -- 当日百元券面面值
    ,P1.TDYTOBEPAIDCOSTAMT_ADD -- 当日发生待支付成本总额
    ,P1.TDYTOBEPAIDCOSTAMT_DEL -- 当日结转待支付成本总额
    ,P1.YSTCOST_1 -- 上日债券核算成本
    ,P1.TDYTOBEPAIDCOST_1_ADD -- 当日发生待支付债券核算成本
    ,P1.TDYTOBEPAIDCOST_1_DEL -- 当日结转待支付债券核算成本
    ,P1.YSTTOBEPAIDCOST_1 -- 上日累计待支付债券核算成本
    ,P1.TDYCOSTCOST_2 -- 当日成本核算成本
    ,P1.YSTCOSTCOST_2 -- 昨日成本核算成本
    ,P1.TDYCOSTINT_2 -- 当日利息核算成本
    ,P1.YSTCOSTINT_2 -- 昨日利息核算成本
    ,P1.TDYPROFITLOSS_2 -- 当日收益
    ,P1.YSTPROFITLOSS_2 -- 全额收益法昨日收益
    ,P1.ORIGINALSEQNO -- 原始交易编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_sec_trad_position_deal_bok' -- 源表名称
    ,'famsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_sec_trad_position_deal_bok p1
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.INVESTTYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_SEC_TRAD_POSITION_DEAL_BOK'
        AND R5.SRC_FIELD_EN_NAME= 'INVESTTYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_AM_BOND_POS'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ASSET_CLS4_CD'
where  1 = 1 
    AND P1.ETL_DT=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_am_bond_pos truncate subpartition p_famsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_am_bond_pos exchange subpartition p_famsi1_${batch_date} with table ${iml_schema}.agt_am_bond_pos_famsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_am_bond_pos to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_am_bond_pos_famsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_am_bond_pos', partname => 'p_famsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);