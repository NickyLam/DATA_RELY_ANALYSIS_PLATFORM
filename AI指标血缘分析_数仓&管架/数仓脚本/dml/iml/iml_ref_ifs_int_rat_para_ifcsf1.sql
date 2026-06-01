/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ifs_int_rat_para_ifcsf1
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
alter table ${iml_schema}.ref_ifs_int_rat_para add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ifs_int_rat_para partition for ('ifcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_tm purge;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op purge;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_tm nologging
compress ${option_switch} for query high
as select
    int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ifs_int_rat_para partition for ('ifcsf1')
where 0=1
;

create table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ifs_int_rat_para partition for ('ifcsf1') where 0=1;

create table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ifs_int_rat_para partition for ('ifcsf1') where 0=1;

-- 3.1 get new data into table
-- ifcs_int_rat_info-
insert into ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_tm(
    int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INT_RAT_TYPE -- 利率类别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DEP_TERM_CD END -- 利率期限代码
    ,P1.CURR_CD -- 币种代码
    ,${iml_schema}.dateformat_min(P1.EFFECT_DT) -- 生效日期
    ,${iml_schema}.dateformat_max(P1.INVALID_DT) -- 失效日期
    ,NVL(P1.INT_RAT_STATUS,'-') -- 利率状态代码
    ,P1.BASE_RAT -- 基准利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_int_rat_info' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_int_rat_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DEP_TERM_CD = R1.SRC_CODE_VAL 
 AND R1.SORC_SYS_CD= 'IFCS'
 AND R1.SRC_TAB_EN_NAME= 'IFCS_INT_RAT_INFO'
 AND R1.SRC_FIELD_EN_NAME= 'DEP_TERM_CD'
 AND R1.TARGET_TAB_EN_NAME= 'REF_IFS_INT_RAT_PARA'
 AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_TENOR_CD'
where  1 = 1 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl(
            int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op(
            int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.int_rat_cate_cd, o.int_rat_cate_cd) as int_rat_cate_cd -- 利率类别代码
    ,nvl(n.int_rat_tenor_cd, o.int_rat_tenor_cd) as int_rat_tenor_cd -- 利率期限代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.int_rat_status_cd, o.int_rat_status_cd) as int_rat_status_cd -- 利率状态代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,case when
            n.int_rat_cate_cd is null
            and n.int_rat_tenor_cd is null
            and n.curr_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.int_rat_cate_cd is null
            and n.int_rat_tenor_cd is null
            and n.curr_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.int_rat_cate_cd is null
            and n.int_rat_tenor_cd is null
            and n.curr_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_tm n
    full join (select * from ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.int_rat_cate_cd = n.int_rat_cate_cd
            and o.int_rat_tenor_cd = n.int_rat_tenor_cd
            and o.curr_cd = n.curr_cd
where (
        o.int_rat_cate_cd is null
        and o.int_rat_tenor_cd is null
        and o.curr_cd is null
    )
    or (
        n.int_rat_cate_cd is null
        and n.int_rat_tenor_cd is null
        and n.curr_cd is null
    )
    or (
        o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.int_rat_status_cd <> n.int_rat_status_cd
        or o.base_rat <> n.base_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl(
            int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op(
            int_rat_cate_cd -- 利率类别代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_status_cd -- 利率状态代码
    ,base_rat -- 基准利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.int_rat_cate_cd -- 利率类别代码
    ,o.int_rat_tenor_cd -- 利率期限代码
    ,o.curr_cd -- 币种代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.int_rat_status_cd -- 利率状态代码
    ,o.base_rat -- 基准利率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_bk o
    left join ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op n
        on
            o.int_rat_cate_cd = n.int_rat_cate_cd
            and o.int_rat_tenor_cd = n.int_rat_tenor_cd
            and o.curr_cd = n.curr_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl d
        on
            o.int_rat_cate_cd = d.int_rat_cate_cd
            and o.int_rat_tenor_cd = d.int_rat_tenor_cd
            and o.curr_cd = d.curr_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_ifs_int_rat_para;
alter table ${iml_schema}.ref_ifs_int_rat_para truncate partition for ('ifcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_ifs_int_rat_para exchange subpartition p_ifcsf1_19000101 with table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl;
alter table ${iml_schema}.ref_ifs_int_rat_para exchange subpartition p_ifcsf1_20991231 with table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ifs_int_rat_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_tm purge;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_op purge;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_ifs_int_rat_para_ifcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ifs_int_rat_para', partname => 'p_ifcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
