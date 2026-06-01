/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_rpp_plan_h_ibmsf1
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
alter table ${iml_schema}.prd_ibank_rpp_plan_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_rpp_plan_h partition for ('ibmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_rpp_plan_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_rpp_plan_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_rpp_plan_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_capital_repay_plan-
insert into ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.i_code -- 金融工具编号
    ,'9999' -- 法人编号
    ,P1.a_type -- 资产类型编号
    ,P1.m_type -- 市场类型编号
    ,P1.repay_date -- 还款日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REPAY_TYPE END -- 还款类型代码
    ,P1.amount -- 还本金额
    ,P1.ai -- 偿还利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_capital_repay_plan' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_capital_repay_plan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAY_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_CAPITAL_REPAY_PLAN'
        AND R1.SRC_FIELD_EN_NAME= 'REPAY_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_IBANK_RPP_PLAN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.repay_dt, o.repay_dt) as repay_dt -- 还款日期
    ,nvl(n.repay_type_cd, o.repay_type_cd) as repay_type_cd -- 还款类型代码
    ,nvl(n.rpp_amt, o.rpp_amt) as rpp_amt -- 还本金额
    ,nvl(n.repay_int, o.repay_int) as repay_int -- 偿还利息
    ,case when
            n.fin_instm_id is null
            and n.lp_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.repay_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_instm_id is null
            and n.lp_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.repay_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_instm_id is null
            and n.lp_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.repay_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.lp_id = n.lp_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.repay_dt = n.repay_dt
where (
        o.fin_instm_id is null
        and o.lp_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.repay_dt is null
    )
    or (
        n.fin_instm_id is null
        and n.lp_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.repay_dt is null
    )
    or (
        o.repay_type_cd <> n.repay_type_cd
        or o.rpp_amt <> n.rpp_amt
        or o.repay_int <> n.repay_int
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,repay_dt -- 还款日期
    ,repay_type_cd -- 还款类型代码
    ,rpp_amt -- 还本金额
    ,repay_int -- 偿还利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_instm_id -- 金融工具编号
    ,o.lp_id -- 法人编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.repay_dt -- 还款日期
    ,o.repay_type_cd -- 还款类型代码
    ,o.rpp_amt -- 还本金额
    ,o.repay_int -- 偿还利息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_bk o
    left join ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.lp_id = n.lp_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.repay_dt = n.repay_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl d
        on
            o.fin_instm_id = d.fin_instm_id
            and o.lp_id = d.lp_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.repay_dt = d.repay_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_ibank_rpp_plan_h;
alter table ${iml_schema}.prd_ibank_rpp_plan_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_ibank_rpp_plan_h exchange subpartition p_ibmsf1_19000101 with table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl;
alter table ${iml_schema}.prd_ibank_rpp_plan_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_rpp_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_ibank_rpp_plan_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_rpp_plan_h', partname => 'p_ibmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
