/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_prod_bal_dtl_h_fdmsf1
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
alter table ${iml_schema}.agt_prod_bal_dtl_h add partition p_fdmsf1 values ('fdmsf1')(
        subpartition p_fdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_bal_dtl_h partition for ('fdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_tm purge;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op purge;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_bal_dtl_h partition for ('fdmsf1')
where 0=1
;

create table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_bal_dtl_h partition for ('fdmsf1') where 0=1;

create table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_bal_dtl_h partition for ('fdmsf1') where 0=1;

-- 3.1 get new data into table
-- fdms_fdm_ledger_balance_info-
insert into ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    CASE WHEN P1.ORIGIN_SYS_ID='EASS' THEN '120011'||P1.ACCOUNT_NUMBER
     WHEN P1.ORIGIN_SYS_ID='EEAS' THEN '120012'||P1.ACCOUNT_NUMBER
     WHEN P1.ORIGIN_SYS_ID='LPSS' THEN '130012'||P1.ACCOUNT_NUMBER
     ELSE P1.ACCOUNT_NUMBER END -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRD_ID -- 产品编号
    ,P1.ACCOUNT_NUMBER -- 账号
    ,P1.ORG_NO -- 账务机构编号
    ,NVL(TRIM(P1.CURRENCY_UOM_ID),'CNY') -- 币种代码
    ,P1.ORIGIN_SYS_ID -- 系统来源简称
    ,P1.ACCOUNT_TYPE -- 产品类型代码
    ,P1.BALANCE -- 账户余额
    ,P1.BAL_TYP_CD -- 产品余额类型代码
    ,P1.ACCT_CATEG_CD -- 业务类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdms_fdm_ledger_balance_info' -- 源表名称
    ,'fdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdms_fdm_ledger_balance_info p1
where  1 = 1 
    and p1.POSTING_DATE=to_date('${batch_date}','yyyy-mm-dd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
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
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 账号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sys_src_abbr, o.sys_src_abbr) as sys_src_abbr -- 系统来源简称
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.acct_bal, o.acct_bal) as acct_bal -- 账户余额
    ,nvl(n.prod_bal_type_cd, o.prod_bal_type_cd) as prod_bal_type_cd -- 产品余额类型代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.prod_id is null
            and n.acct_num is null
            and n.acct_instit_id is null
            and n.sys_src_abbr is null
            and n.prod_type_cd is null
            and n.prod_bal_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.prod_id is null
            and n.acct_num is null
            and n.acct_instit_id is null
            and n.sys_src_abbr is null
            and n.prod_type_cd is null
            and n.prod_bal_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.prod_id is null
            and n.acct_num is null
            and n.acct_instit_id is null
            and n.sys_src_abbr is null
            and n.prod_type_cd is null
            and n.prod_bal_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_tm n
    full join (select * from ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
            and o.acct_num = n.acct_num
            and o.acct_instit_id = n.acct_instit_id
            and o.sys_src_abbr = n.sys_src_abbr
            and o.prod_type_cd = n.prod_type_cd
            and o.prod_bal_type_cd = n.prod_bal_type_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.prod_id is null
        and o.acct_num is null
        and o.acct_instit_id is null
        and o.sys_src_abbr is null
        and o.prod_type_cd is null
        and o.prod_bal_type_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.prod_id is null
        and n.acct_num is null
        and n.acct_instit_id is null
        and n.sys_src_abbr is null
        and n.prod_type_cd is null
        and n.prod_bal_type_cd is null
    )
    or (
        o.curr_cd <> n.curr_cd
        or o.acct_bal <> n.acct_bal
        or o.bus_type_cd <> n.bus_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,acct_num -- 账号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,sys_src_abbr -- 系统来源简称
    ,prod_type_cd -- 产品类型代码
    ,acct_bal -- 账户余额
    ,prod_bal_type_cd -- 产品余额类型代码
    ,bus_type_cd -- 业务类型代码
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
    ,o.prod_id -- 产品编号
    ,o.acct_num -- 账号
    ,o.acct_instit_id -- 账务机构编号
    ,o.curr_cd -- 币种代码
    ,o.sys_src_abbr -- 系统来源简称
    ,o.prod_type_cd -- 产品类型代码
    ,o.acct_bal -- 账户余额
    ,o.prod_bal_type_cd -- 产品余额类型代码
    ,o.bus_type_cd -- 业务类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_bk o
    left join ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
            and o.acct_num = n.acct_num
            and o.acct_instit_id = n.acct_instit_id
            and o.sys_src_abbr = n.sys_src_abbr
            and o.prod_type_cd = n.prod_type_cd
            and o.prod_bal_type_cd = n.prod_bal_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.prod_id = d.prod_id
            and o.acct_num = d.acct_num
            and o.acct_instit_id = d.acct_instit_id
            and o.sys_src_abbr = d.sys_src_abbr
            and o.prod_type_cd = d.prod_type_cd
            and o.prod_bal_type_cd = d.prod_bal_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_prod_bal_dtl_h;
alter table ${iml_schema}.agt_prod_bal_dtl_h truncate partition for ('fdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_prod_bal_dtl_h exchange subpartition p_fdmsf1_19000101 with table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl;
alter table ${iml_schema}.agt_prod_bal_dtl_h exchange subpartition p_fdmsf1_20991231 with table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_prod_bal_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_tm purge;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_op purge;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_prod_bal_dtl_h_fdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_prod_bal_dtl_h', partname => 'p_fdmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
