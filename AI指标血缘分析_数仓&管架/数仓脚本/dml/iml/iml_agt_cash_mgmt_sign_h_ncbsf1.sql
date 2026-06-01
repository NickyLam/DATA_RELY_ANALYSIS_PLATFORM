/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cash_mgmt_sign_h_ncbsf1
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
alter table ${iml_schema}.agt_cash_mgmt_sign_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cash_mgmt_sign_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cash_mgmt_sign_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cash_mgmt_sign_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cash_mgmt_sign_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_cash_ctl_sign-1
insert into ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '140010'||P1.BASE_ACCT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.SUB_BASE_ACCT_NO -- 子账户账号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.STATUS -- 状态代码
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.TRAN_DATE -- 交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_cash_ctl_sign' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_cash_ctl_sign p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,cust_acct_num
  	                                        ,sub_acct_acct_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
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
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_acct_num, o.sub_acct_acct_num) as sub_acct_acct_num -- 子账户账号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.sub_acct_acct_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.sub_acct_acct_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.sub_acct_acct_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_acct_num = n.cust_acct_num
            and o.sub_acct_acct_num = n.sub_acct_acct_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cust_acct_num is null
        and o.sub_acct_acct_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cust_acct_num is null
        and n.sub_acct_acct_num is null
    )
    or (
        o.ova_flow_num <> n.ova_flow_num
        or o.status_cd <> n.status_cd
        or o.core_flow_num <> n.core_flow_num
        or o.tran_dt <> n.tran_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_acct_num -- 子账户账号
    ,ova_flow_num -- 全局流水号
    ,status_cd -- 状态代码
    ,core_flow_num -- 核心流水号
    ,tran_dt -- 交易日期
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
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_acct_num -- 子账户账号
    ,o.ova_flow_num -- 全局流水号
    ,o.status_cd -- 状态代码
    ,o.core_flow_num -- 核心流水号
    ,o.tran_dt -- 交易日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_acct_num = n.cust_acct_num
            and o.sub_acct_acct_num = n.sub_acct_acct_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.cust_acct_num = d.cust_acct_num
            and o.sub_acct_acct_num = d.sub_acct_acct_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cash_mgmt_sign_h;
alter table ${iml_schema}.agt_cash_mgmt_sign_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_cash_mgmt_sign_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cash_mgmt_sign_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cash_mgmt_sign_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cash_mgmt_sign_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cash_mgmt_sign_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
