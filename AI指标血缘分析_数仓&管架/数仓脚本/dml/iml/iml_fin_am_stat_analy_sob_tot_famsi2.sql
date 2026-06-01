/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_stat_analy_sob_tot_famsi2
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
drop table ${iml_schema}.fin_am_stat_analy_sob_tot_famsi2_tm purge;
alter table ${iml_schema}.fin_am_stat_analy_sob_tot add partition p_famsi2 values ('famsi2')(
        subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_am_stat_analy_sob_tot modify partition p_famsi2
    add subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_stat_analy_sob_tot_famsi2_tm
compress ${option_switch} for query high
as
select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,happ_dt -- 发生日期
    ,enter_acct_dt -- 入账日期
    ,layered_id -- 分层编号
    ,sub_prod_flg -- 子产品标志
    ,sob_dt -- 账套日期
    ,prft_mode_cd -- 收益模式代码
    ,paid_in_capital -- 实收资本
    ,td_paybl_margin -- 当日应付利润
    ,acm_paybl_margin -- 累计应付利润
    ,provi_int_rat -- 计提利率
    ,fee_bf_asset_nv -- 费前资产净值
    ,asset_nv -- 资产净值
    ,fee_f_unit_nv -- 费前单位净值
    ,corp_nv -- 单位净值
    ,bf_ten_thous_prft -- 费前万份收益
    ,ten_thous_prft -- 万份收益
    ,bf_td_aual_yld -- 费前当日年化收益率
    ,td_aual_yld -- 当日年化收益率
    ,fee_ped_aual_yld -- 费用周期年化收益率
    ,ped_aual_yld -- 周期年化收益率
    ,bf_sevn_aual_yld -- 费前七日年化收益率
    ,sevn_aual_yld -- 七日年化收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_stat_analy_sob_tot
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_bok_stat_bok_position-1
insert into ${iml_schema}.fin_am_stat_analy_sob_tot_famsi2_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,happ_dt -- 发生日期
    ,enter_acct_dt -- 入账日期
    ,layered_id -- 分层编号
    ,sub_prod_flg -- 子产品标志
    ,sob_dt -- 账套日期
    ,prft_mode_cd -- 收益模式代码
    ,paid_in_capital -- 实收资本
    ,td_paybl_margin -- 当日应付利润
    ,acm_paybl_margin -- 累计应付利润
    ,provi_int_rat -- 计提利率
    ,fee_bf_asset_nv -- 费前资产净值
    ,asset_nv -- 资产净值
    ,fee_f_unit_nv -- 费前单位净值
    ,corp_nv -- 单位净值
    ,bf_ten_thous_prft -- 费前万份收益
    ,ten_thous_prft -- 万份收益
    ,bf_td_aual_yld -- 费前当日年化收益率
    ,td_aual_yld -- 当日年化收益率
    ,fee_ped_aual_yld -- 费用周期年化收益率
    ,ped_aual_yld -- 周期年化收益率
    ,bf_sevn_aual_yld -- 费前七日年化收益率
    ,sevn_aual_yld -- 七日年化收益率
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
    ,P1.LAYERING_ID -- 分层编号
    ,P1.IS_SUB_PRD -- 子产品标志
    ,P1.BOOKSET_DATE -- 账套日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFIT_TYPE END -- 收益模式代码
    ,P1.CAPITAL -- 实收资本
    ,P1.PROFIT_AMT -- 当日应付利润
    ,P1.TOT_PROFIT_AMT -- 累计应付利润
    ,P1.INT_RATE*100 -- 计提利率
    ,P1.NET_ASSET_VALUE_BEF -- 费前资产净值
    ,P1.NET_ASSET_VALUE -- 资产净值
    ,P1.NET_UNIT_VALUE_BEF -- 费前单位净值
    ,P1.NET_UNIT_VALUE -- 单位净值
    ,P1.P_YIELD_BEF -- 费前万份收益
    ,P1.P_YIELD -- 万份收益
    ,P1.TDY_YIELD_BEF -- 费前当日年化收益率
    ,P1.TDY_YIELD -- 当日年化收益率
    ,P1.YIELD_TERM_BEF -- 费用周期年化收益率
    ,P1.YIELD_TERM -- 周期年化收益率
    ,P1.YIELD_7_BEF -- 费前七日年化收益率
    ,P1.YIELD_7 -- 七日年化收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_stat_bok_position' -- 源表名称
    ,'famsi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_stat_bok_position p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFIT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_BOK_STAT_BOK_POSITION'
        AND R1.SRC_FIELD_EN_NAME= 'PROFIT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'FIN_AM_STAT_ANALY_SOB_TOT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and to_date(to_char(p1.BOOKSET_DATE,'yyyymmdd'),'yyyymmdd')=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.fin_am_stat_analy_sob_tot truncate subpartition p_famsi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.fin_am_stat_analy_sob_tot exchange subpartition p_famsi2_${batch_date} with table ${iml_schema}.fin_am_stat_analy_sob_tot_famsi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_stat_analy_sob_tot to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_am_stat_analy_sob_tot_famsi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_stat_analy_sob_tot', partname => 'p_famsi2_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);