/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_stat_analy_acct_dtl_famsi2
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
drop table ${iml_schema}.fin_am_stat_analy_acct_dtl_famsi2_tm purge;
alter table ${iml_schema}.fin_am_stat_analy_acct_dtl add partition p_famsi2 values ('famsi2')(
        subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_am_stat_analy_acct_dtl modify partition p_famsi2
    add subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_stat_analy_acct_dtl_famsi2_tm
compress ${option_switch} for query high
as
select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,happ_dt -- 发生日期
    ,enter_acct_dt -- 入账日期
    ,acct_dtl_id -- 账务明细编号
    ,proc_order_id -- 处理序列编号
    ,sob_dt -- 账套日期
    ,curr_post_amt -- 当前持仓金额
    ,provi_int_rat -- 计提利率
    ,day_amort_yld_rat -- 日摊销收益率
    ,td_happ_acru_int -- 当日发生应计利息
    ,td_acm_acru_int_bal -- 当日累计应计利息余额
    ,prod_cate_cd -- 产品类别代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pass_id -- 通道编号
    ,invest_aim_cd -- 投资目的代码
    ,td_provi_lot -- 当日计提份额
    ,td_cost_tot -- 当日成本总额
    ,td_evha_val_chag -- 当日公允价值变动
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,fin_prod_id -- 金融产品编号
    ,ext_evltion_dt -- 外部估值日期
    ,td_acm_evha_val_chag -- 当日累计公允价值变动
    ,curr_cd -- 币种代码
    ,dc_curr_cd -- 本币币种代码
    ,dc_td_happ_acru_int -- 本币当日发生应计利息
    ,dc_td_cost_tot -- 本币当日成本总额
    ,dc_td_evha_val_chag -- 本币当日公允价值变动
    ,dc_td_acm_evha_val_chag -- 本币当日累计公允价值变动
    ,dc_td_acm_acru_int_bal -- 本币当日累计应计利息余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_stat_analy_acct_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_bok_stat_det_posiiton-1
insert into ${iml_schema}.fin_am_stat_analy_acct_dtl_famsi2_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,happ_dt -- 发生日期
    ,enter_acct_dt -- 入账日期
    ,acct_dtl_id -- 账务明细编号
    ,proc_order_id -- 处理序列编号
    ,sob_dt -- 账套日期
    ,curr_post_amt -- 当前持仓金额
    ,provi_int_rat -- 计提利率
    ,day_amort_yld_rat -- 日摊销收益率
    ,td_happ_acru_int -- 当日发生应计利息
    ,td_acm_acru_int_bal -- 当日累计应计利息余额
    ,prod_cate_cd -- 产品类别代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pass_id -- 通道编号
    ,invest_aim_cd -- 投资目的代码
    ,td_provi_lot -- 当日计提份额
    ,td_cost_tot -- 当日成本总额
    ,td_evha_val_chag -- 当日公允价值变动
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,fin_prod_id -- 金融产品编号
    ,ext_evltion_dt -- 外部估值日期
    ,td_acm_evha_val_chag -- 当日累计公允价值变动
    ,curr_cd -- 币种代码
    ,dc_curr_cd -- 本币币种代码
    ,dc_td_happ_acru_int -- 本币当日发生应计利息
    ,dc_td_cost_tot -- 本币当日成本总额
    ,dc_td_evha_val_chag -- 本币当日公允价值变动
    ,dc_td_acm_evha_val_chag -- 本币当日累计公允价值变动
    ,dc_td_acm_acru_int_bal -- 本币当日累计应计利息余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.HAPPEN_DATE -- 发生日期
    ,P1.BOOK_DATE -- 入账日期
    ,P1.BOK_DETAIL_ID -- 账务明细编号
    ,P1.BOOK_SUMMARY_ORDER -- 处理序列编号
    ,P1.BOOKSET_DATE -- 账套日期
    ,P1.POS_AMT -- 当前持仓金额
    ,P1.INT_RATE*100 -- 计提利率
    ,P1.DAILYDSC_YIELD -- 日摊销收益率
    ,P1.TDY_INTINCEXP_ADD -- 当日发生应计利息
    ,P1.TDY_INTINCEXP -- 当日累计应计利息余额
    ,CASE WHEN P1.FINPROD_TYPE=' ' THEN '-' ELSE P1.FINPROD_TYPE END  -- 产品类别代码
    ,P1.VDATE -- 起息日期
    ,P1.MDATE -- 到期日期
    ,P1.CHL_ID -- 通道编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INV_AIM END -- 投资目的代码
    ,P1.TDY_POSITION -- 当日计提份额
    ,P1.TDY_COST_AMT -- 当日成本总额
    ,P1.TDY_FLOAT_INGPL -- 当日公允价值变动
    ,P1.END_DAYS_1 -- 剩余期限
    ,P1.END_DAYS_2 -- 剩余存续期限
    ,P1.BUSI_ID -- 金融产品编号
    ,P1.VAL_DATE -- 外部估值日期
    ,P1.TDY_FLOAT_INGPL_EXP -- 当日累计公允价值变动
    ,P1.CCY -- 币种代码
    ,P1.B_CCY -- 本币币种代码
    ,P1.TDY_INTINCEXP_ADD_B -- 本币当日发生应计利息
    ,P1.TDY_COST_AMT_B -- 本币当日成本总额
    ,P1.TDY_FLOAT_INGPL_B -- 本币当日公允价值变动
    ,P1.TDY_FLOAT_INGPL_EXP_B -- 本币当日累计公允价值变动
    ,P1.TDY_INTINCEXP_B -- 本币当日累计应计利息余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_stat_det_posiiton' -- 源表名称
    ,'famsi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_stat_det_posiiton p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INV_AIM = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_BOK_STAT_DET_POSIITON'
        AND R1.SRC_FIELD_EN_NAME= 'INV_AIM'
        AND R1.TARGET_TAB_EN_NAME= 'FIN_AM_STAT_ANALY_ACCT_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INVEST_AIM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and to_date(to_char(p1.BOOKSET_DATE,'yyyymmdd'),'yyyymmdd')=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.fin_am_stat_analy_acct_dtl truncate subpartition p_famsi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.fin_am_stat_analy_acct_dtl exchange subpartition p_famsi2_${batch_date} with table ${iml_schema}.fin_am_stat_analy_acct_dtl_famsi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_stat_analy_acct_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_am_stat_analy_acct_dtl_famsi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_stat_analy_acct_dtl', partname => 'p_famsi2_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);