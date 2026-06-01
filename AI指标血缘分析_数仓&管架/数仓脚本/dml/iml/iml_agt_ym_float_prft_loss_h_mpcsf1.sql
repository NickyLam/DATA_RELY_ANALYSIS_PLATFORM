/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ym_float_prft_loss_h_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ym_float_prft_loss_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_float_prft_loss_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_float_prft_loss_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_float_prft_loss_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_float_prft_loss_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a92ym_asset_view-
insert into ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170000'||P1.CUSTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CUSTNO -- 客户编号
    ,P1.CARDNO -- 账户编号
    ,P1.FUNDCODE -- 基金代码
    ,P1.FUNDFULLNAME -- 基金名称
    ,P1.FUNDNAME -- 基金简称
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.FUNDTYPE END -- 基金类型代码
    ,P1.TOTALSHARE -- 基金份额
    ,${iml_schema}.DATEFORMAT_MAX(P1.TOTALSHAREDT) -- 份额日期
    ,P1.NAV -- 净值
    ,${iml_schema}.DATEFORMAT_MAX(P1.NAVDT) -- 净值日期
    ,P1.DIVAMT -- 分红金额
    ,P1.OLDTOTALSHARE -- 上日份额
    ,${iml_schema}.DATEFORMAT_MAX(P1.OLDTOTALSHAREDT) -- 上日份额日期
    ,P1.OLDNAV -- 上日净值
    ,${iml_schema}.DATEFORMAT_MAX(P1.OLDNAVTDT) -- 上日净值日期
    ,P1.OLDDIVAMT -- 上日分红金额
    ,P1.TOTAL_COSR -- 投资金额
    ,P1.TOTAL_INCOME -- 不含分红收益
    ,P1.TOTAL_DIV -- 分红收益
    ,P1.OLD_TOTAL_COSR -- 上日投资金额
    ,P1.OLD_TOTAL_INCOME -- 上日不含分红收益
    ,P1.OLD_TOTAL_DIV -- 上日分红收益
    ,P1.INCOME -- 净值计算最新收益
    ,P1.ACCPROFIT -- 浮动盈亏金额
    ,P1.LASTACCPROFIT -- 上日浮动盈亏金额
    ,P1.FUND_INCOME -- 浮动盈亏计算最新收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92ym_asset_view' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92ym_asset_view p1
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.FUNDTYPE = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'MPCS'
        AND R9.SRC_TAB_EN_NAME= 'MPCS_A92YM_ASSET_VIEW'
        AND R9.SRC_FIELD_EN_NAME= 'FUNDTYPE'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_YM_FLOAT_PRFT_LOSS_H'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'FUND_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 基金名称
    ,nvl(n.fund_abbr, o.fund_abbr) as fund_abbr -- 基金简称
    ,nvl(n.fund_type_cd, o.fund_type_cd) as fund_type_cd -- 基金类型代码
    ,nvl(n.fund_lot, o.fund_lot) as fund_lot -- 基金份额
    ,nvl(n.lot_dt, o.lot_dt) as lot_dt -- 份额日期
    ,nvl(n.nv, o.nv) as nv -- 净值
    ,nvl(n.nv_dt, o.nv_dt) as nv_dt -- 净值日期
    ,nvl(n.divd_amt, o.divd_amt) as divd_amt -- 分红金额
    ,nvl(n.ld_lot, o.ld_lot) as ld_lot -- 上日份额
    ,nvl(n.ld_lot_dt, o.ld_lot_dt) as ld_lot_dt -- 上日份额日期
    ,nvl(n.ld_nv, o.ld_nv) as ld_nv -- 上日净值
    ,nvl(n.ld_nv_dt, o.ld_nv_dt) as ld_nv_dt -- 上日净值日期
    ,nvl(n.ld_divd_amt, o.ld_divd_amt) as ld_divd_amt -- 上日分红金额
    ,nvl(n.invest_amt, o.invest_amt) as invest_amt -- 投资金额
    ,nvl(n.exclude_divd_prft, o.exclude_divd_prft) as exclude_divd_prft -- 不含分红收益
    ,nvl(n.divd_prft, o.divd_prft) as divd_prft -- 分红收益
    ,nvl(n.ld_invest_amt, o.ld_invest_amt) as ld_invest_amt -- 上日投资金额
    ,nvl(n.ld_exclude_divd_prft, o.ld_exclude_divd_prft) as ld_exclude_divd_prft -- 上日不含分红收益
    ,nvl(n.ld_divd_prft, o.ld_divd_prft) as ld_divd_prft -- 上日分红收益
    ,nvl(n.nv_calc_latest_prft, o.nv_calc_latest_prft) as nv_calc_latest_prft -- 净值计算最新收益
    ,nvl(n.float_prft_loss_amt, o.float_prft_loss_amt) as float_prft_loss_amt -- 浮动盈亏金额
    ,nvl(n.ld_float_prft_loss_amt, o.ld_float_prft_loss_amt) as ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,nvl(n.float_prft_loss_calc_latest, o.float_prft_loss_calc_latest) as float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fund_cd is null
            and n.nv_dt is null
            and n.ld_nv_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fund_cd is null
            and n.nv_dt is null
            and n.ld_nv_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.fund_cd is null
            and n.nv_dt is null
            and n.ld_nv_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.fund_cd = n.fund_cd
            and o.nv_dt = n.nv_dt
            and o.ld_nv_dt = n.ld_nv_dt
where (
        o.agt_id is null
        and o.lp_id is null
        and o.fund_cd is null
        and o.nv_dt is null
        and o.ld_nv_dt is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.fund_cd is null
        and n.nv_dt is null
        and n.ld_nv_dt is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.acct_id <> n.acct_id
        or o.fund_name <> n.fund_name
        or o.fund_abbr <> n.fund_abbr
        or o.fund_type_cd <> n.fund_type_cd
        or o.fund_lot <> n.fund_lot
        or o.lot_dt <> n.lot_dt
        or o.nv <> n.nv
        or o.divd_amt <> n.divd_amt
        or o.ld_lot <> n.ld_lot
        or o.ld_lot_dt <> n.ld_lot_dt
        or o.ld_nv <> n.ld_nv
        or o.ld_divd_amt <> n.ld_divd_amt
        or o.invest_amt <> n.invest_amt
        or o.exclude_divd_prft <> n.exclude_divd_prft
        or o.divd_prft <> n.divd_prft
        or o.ld_invest_amt <> n.ld_invest_amt
        or o.ld_exclude_divd_prft <> n.ld_exclude_divd_prft
        or o.ld_divd_prft <> n.ld_divd_prft
        or o.nv_calc_latest_prft <> n.nv_calc_latest_prft
        or o.float_prft_loss_amt <> n.float_prft_loss_amt
        or o.ld_float_prft_loss_amt <> n.ld_float_prft_loss_amt
        or o.float_prft_loss_calc_latest <> n.float_prft_loss_calc_latest
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,fund_abbr -- 基金简称
    ,fund_type_cd -- 基金类型代码
    ,fund_lot -- 基金份额
    ,lot_dt -- 份额日期
    ,nv -- 净值
    ,nv_dt -- 净值日期
    ,divd_amt -- 分红金额
    ,ld_lot -- 上日份额
    ,ld_lot_dt -- 上日份额日期
    ,ld_nv -- 上日净值
    ,ld_nv_dt -- 上日净值日期
    ,ld_divd_amt -- 上日分红金额
    ,invest_amt -- 投资金额
    ,exclude_divd_prft -- 不含分红收益
    ,divd_prft -- 分红收益
    ,ld_invest_amt -- 上日投资金额
    ,ld_exclude_divd_prft -- 上日不含分红收益
    ,ld_divd_prft -- 上日分红收益
    ,nv_calc_latest_prft -- 净值计算最新收益
    ,float_prft_loss_amt -- 浮动盈亏金额
    ,ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.fund_cd -- 基金代码
    ,o.fund_name -- 基金名称
    ,o.fund_abbr -- 基金简称
    ,o.fund_type_cd -- 基金类型代码
    ,o.fund_lot -- 基金份额
    ,o.lot_dt -- 份额日期
    ,o.nv -- 净值
    ,o.nv_dt -- 净值日期
    ,o.divd_amt -- 分红金额
    ,o.ld_lot -- 上日份额
    ,o.ld_lot_dt -- 上日份额日期
    ,o.ld_nv -- 上日净值
    ,o.ld_nv_dt -- 上日净值日期
    ,o.ld_divd_amt -- 上日分红金额
    ,o.invest_amt -- 投资金额
    ,o.exclude_divd_prft -- 不含分红收益
    ,o.divd_prft -- 分红收益
    ,o.ld_invest_amt -- 上日投资金额
    ,o.ld_exclude_divd_prft -- 上日不含分红收益
    ,o.ld_divd_prft -- 上日分红收益
    ,o.nv_calc_latest_prft -- 净值计算最新收益
    ,o.float_prft_loss_amt -- 浮动盈亏金额
    ,o.ld_float_prft_loss_amt -- 上日浮动盈亏金额
    ,o.float_prft_loss_calc_latest -- 浮动盈亏计算最新收益
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_bk o
    left join ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.fund_cd = n.fund_cd
            and o.nv_dt = n.nv_dt
            and o.ld_nv_dt = n.ld_nv_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.fund_cd = d.fund_cd
            and o.nv_dt = d.nv_dt
            and o.ld_nv_dt = d.ld_nv_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ym_float_prft_loss_h;
alter table ${iml_schema}.agt_ym_float_prft_loss_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ym_float_prft_loss_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl;
alter table ${iml_schema}.agt_ym_float_prft_loss_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ym_float_prft_loss_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ym_float_prft_loss_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ym_float_prft_loss_h', partname => 'p_mpcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
