/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_cashflow_int_rat_h_famsf2
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
alter table ${iml_schema}.prd_am_cashflow_int_rat_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_int_rat_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_int_rat_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_int_rat_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_cashflow_int_rat_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_fin_rate_info-1
insert into ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_tm(
    cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CASH_ID -- 现金流编号
    ,'9999' -- 法人编号
    ,P1.EFF_DATE -- 生效日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INT_TYPE END -- 利率调整方式代码
    ,nvl(trim(P1.BASIS),'-')  -- 计息基准代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.RESET_TYPE END -- 重置类型代码
    ,P1.RATE*100 -- 初始利率
    ,CASE WHEN P1.FINPROD_TYPE2=' ' THEN '-' ELSE P1.FINPROD_TYPE2 END  -- 产品类别代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_rate_info' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_rate_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_RATE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'INT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_CASHFLOW_INT_RAT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RESET_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_FIN_RATE_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'RESET_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_CASHFLOW_INT_RAT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RESET_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cashflow_id, o.cashflow_id) as cashflow_id -- 现金流编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.reset_type_cd, o.reset_type_cd) as reset_type_cd -- 重置类型代码
    ,nvl(n.init_int_rat, o.init_int_rat) as init_int_rat -- 初始利率
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cashflow_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_tm n
    full join (select * from ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cashflow_id = n.cashflow_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
where (
        o.cashflow_id is null
        and o.lp_id is null
        and o.effect_dt is null
    )
    or (
        n.cashflow_id is null
        and n.lp_id is null
        and n.effect_dt is null
    )
    or (
        o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.reset_type_cd <> n.reset_type_cd
        or o.init_int_rat <> n.init_int_rat
        or o.prod_cate_cd <> n.prod_cate_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op(
            cashflow_id -- 现金流编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,reset_type_cd -- 重置类型代码
    ,init_int_rat -- 初始利率
    ,prod_cate_cd -- 产品类别代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cashflow_id -- 现金流编号
    ,o.lp_id -- 法人编号
    ,o.effect_dt -- 生效日期
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.reset_type_cd -- 重置类型代码
    ,o.init_int_rat -- 初始利率
    ,o.prod_cate_cd -- 产品类别代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_bk o
    left join ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op n
        on
            o.cashflow_id = n.cashflow_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl d
        on
            o.cashflow_id = d.cashflow_id
            and o.lp_id = d.lp_id
            and o.effect_dt = d.effect_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_am_cashflow_int_rat_h;
alter table ${iml_schema}.prd_am_cashflow_int_rat_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_am_cashflow_int_rat_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl;
alter table ${iml_schema}.prd_am_cashflow_int_rat_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_cashflow_int_rat_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_am_cashflow_int_rat_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_cashflow_int_rat_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
