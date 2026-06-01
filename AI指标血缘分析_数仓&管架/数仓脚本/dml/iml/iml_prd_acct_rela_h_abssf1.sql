/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_acct_rela_h_abssf1
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
alter table ${iml_schema}.prd_acct_rela_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_acct_rela_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_acct_rela_h partition for ('abssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_acct_rela_h_abssf1_tm purge;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_op purge;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_acct_rela_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_acct_rela_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.prd_acct_rela_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_acct_rela_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.prd_acct_rela_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_acct_rela_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_account_info-1
insert into ${iml_schema}.prd_acct_rela_h_abssf1_tm(
    rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ACCOUNTID -- 关系编号
    ,'9999' -- 法人编号
    ,'ABSS' -- 源系统代码
    ,P1.PRODUCTID -- 产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCOUNTTYPE END -- 账户类型代码
    ,P1.ACCOUNTNO -- 账户编号
    ,P1.ACCOUNTNAME -- 账户名称
    ,P1.ACCOUNTBANK -- 账户开户行名称
    ,P1.ACCOUNTAFFIORG -- 账户所有人编号
    ,P1.ACCOUNTBALANCE -- 账户余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_account_info' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_account_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ABSS'
        AND R1.SRC_TAB_EN_NAME= 'ABSS_ABS_ACCOUNT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_ACCT_RELA_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_acct_rela_h_abssf1_cl(
            rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_acct_rela_h_abssf1_op(
            rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rela_id, o.rela_id) as rela_id -- 关系编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_open_bank_name, o.acct_open_bank_name) as acct_open_bank_name -- 账户开户行名称
    ,nvl(n.acct_owner_id, o.acct_owner_id) as acct_owner_id -- 账户所有人编号
    ,nvl(n.acct_bal, o.acct_bal) as acct_bal -- 账户余额
    ,case when
            n.rela_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rela_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rela_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_acct_rela_h_abssf1_tm n
    full join (select * from ${iml_schema}.prd_acct_rela_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rela_id = n.rela_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
where (
        o.rela_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
    )
    or (
        n.rela_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.acct_id <> n.acct_id
        or o.acct_name <> n.acct_name
        or o.acct_open_bank_name <> n.acct_open_bank_name
        or o.acct_owner_id <> n.acct_owner_id
        or o.acct_bal <> n.acct_bal
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_acct_rela_h_abssf1_cl(
            rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_acct_rela_h_abssf1_op(
            rela_id -- 关系编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,acct_open_bank_name -- 账户开户行名称
    ,acct_owner_id -- 账户所有人编号
    ,acct_bal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rela_id -- 关系编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.prod_id -- 产品编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.acct_open_bank_name -- 账户开户行名称
    ,o.acct_owner_id -- 账户所有人编号
    ,o.acct_bal -- 账户余额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_acct_rela_h_abssf1_bk o
    left join ${iml_schema}.prd_acct_rela_h_abssf1_op n
        on
            o.rela_id = n.rela_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_acct_rela_h_abssf1_cl d
        on
            o.rela_id = d.rela_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_acct_rela_h;
alter table ${iml_schema}.prd_acct_rela_h truncate partition for ('abssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_acct_rela_h exchange subpartition p_abssf1_19000101 with table ${iml_schema}.prd_acct_rela_h_abssf1_cl;
alter table ${iml_schema}.prd_acct_rela_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.prd_acct_rela_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_acct_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_tm purge;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_op purge;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_acct_rela_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_acct_rela_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
