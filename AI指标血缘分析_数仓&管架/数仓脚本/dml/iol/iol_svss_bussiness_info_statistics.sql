/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svss_bussiness_info_statistics
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.svss_bussiness_info_statistics_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svss_bussiness_info_statistics
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_bussiness_info_statistics_op purge;
drop table ${iol_schema}.svss_bussiness_info_statistics_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_bussiness_info_statistics_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.svss_bussiness_info_statistics where 0=1;

create table ${iol_schema}.svss_bussiness_info_statistics_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.svss_bussiness_info_statistics where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.svss_bussiness_info_statistics_op(
        id -- ID
        ,txn_dt -- 交易日期
        ,txn_tm -- 交易时间
        ,blng_org_id -- 所属机构编号
        ,oper_teller_id -- 经办柜员编号
        ,oper_teller_name -- 经办柜员名称
        ,auth_teller_id -- 授权柜员编号
        ,auth_teller_name -- 授权柜员名称
        ,txn_num -- 交易码
        ,txn_desc -- 交易描述
        ,biz_sys_evt_id -- 业务系统流水号
        ,bcs_evt_id -- 核心系统流水号
        ,data_src_cd -- 系统代码
        ,pay_agt_id -- 付款账户
        ,rcv_agt_id -- 收款账户
        ,txn_amt -- 交易金额
        ,etl_dt_ora -- 数据日期
        ,menuid -- 柜面菜单码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- ID
    ,n.txn_dt -- 交易日期
    ,n.txn_tm -- 交易时间
    ,n.blng_org_id -- 所属机构编号
    ,n.oper_teller_id -- 经办柜员编号
    ,n.oper_teller_name -- 经办柜员名称
    ,n.auth_teller_id -- 授权柜员编号
    ,n.auth_teller_name -- 授权柜员名称
    ,n.txn_num -- 交易码
    ,n.txn_desc -- 交易描述
    ,n.biz_sys_evt_id -- 业务系统流水号
    ,n.bcs_evt_id -- 核心系统流水号
    ,n.data_src_cd -- 系统代码
    ,n.pay_agt_id -- 付款账户
    ,n.rcv_agt_id -- 收款账户
    ,n.txn_amt -- 交易金额
    ,n.etl_dt_ora -- 数据日期
    ,n.menuid -- 柜面菜单码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.svss_bussiness_info_statistics_bk o
    right join (select * from ${itl_schema}.svss_bussiness_info_statistics where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        o.txn_dt <> n.txn_dt
        or o.txn_tm <> n.txn_tm
        or o.blng_org_id <> n.blng_org_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_teller_name <> n.oper_teller_name
        or o.auth_teller_id <> n.auth_teller_id
        or o.auth_teller_name <> n.auth_teller_name
        or o.txn_num <> n.txn_num
        or o.txn_desc <> n.txn_desc
        or o.biz_sys_evt_id <> n.biz_sys_evt_id
        or o.bcs_evt_id <> n.bcs_evt_id
        or o.data_src_cd <> n.data_src_cd
        or o.pay_agt_id <> n.pay_agt_id
        or o.rcv_agt_id <> n.rcv_agt_id
        or o.txn_amt <> n.txn_amt
        or o.etl_dt_ora <> n.etl_dt_ora
        or o.menuid <> n.menuid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svss_bussiness_info_statistics_cl(
            id -- ID
        ,txn_dt -- 交易日期
        ,txn_tm -- 交易时间
        ,blng_org_id -- 所属机构编号
        ,oper_teller_id -- 经办柜员编号
        ,oper_teller_name -- 经办柜员名称
        ,auth_teller_id -- 授权柜员编号
        ,auth_teller_name -- 授权柜员名称
        ,txn_num -- 交易码
        ,txn_desc -- 交易描述
        ,biz_sys_evt_id -- 业务系统流水号
        ,bcs_evt_id -- 核心系统流水号
        ,data_src_cd -- 系统代码
        ,pay_agt_id -- 付款账户
        ,rcv_agt_id -- 收款账户
        ,txn_amt -- 交易金额
        ,etl_dt_ora -- 数据日期
        ,menuid -- 柜面菜单码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svss_bussiness_info_statistics_op(
            id -- ID
        ,txn_dt -- 交易日期
        ,txn_tm -- 交易时间
        ,blng_org_id -- 所属机构编号
        ,oper_teller_id -- 经办柜员编号
        ,oper_teller_name -- 经办柜员名称
        ,auth_teller_id -- 授权柜员编号
        ,auth_teller_name -- 授权柜员名称
        ,txn_num -- 交易码
        ,txn_desc -- 交易描述
        ,biz_sys_evt_id -- 业务系统流水号
        ,bcs_evt_id -- 核心系统流水号
        ,data_src_cd -- 系统代码
        ,pay_agt_id -- 付款账户
        ,rcv_agt_id -- 收款账户
        ,txn_amt -- 交易金额
        ,etl_dt_ora -- 数据日期
        ,menuid -- 柜面菜单码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.txn_dt -- 交易日期
    ,o.txn_tm -- 交易时间
    ,o.blng_org_id -- 所属机构编号
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_teller_name -- 经办柜员名称
    ,o.auth_teller_id -- 授权柜员编号
    ,o.auth_teller_name -- 授权柜员名称
    ,o.txn_num -- 交易码
    ,o.txn_desc -- 交易描述
    ,o.biz_sys_evt_id -- 业务系统流水号
    ,o.bcs_evt_id -- 核心系统流水号
    ,o.data_src_cd -- 系统代码
    ,o.pay_agt_id -- 付款账户
    ,o.rcv_agt_id -- 收款账户
    ,o.txn_amt -- 交易金额
    ,o.etl_dt_ora -- 数据日期
    ,o.menuid -- 柜面菜单码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.svss_bussiness_info_statistics_bk o
    left join ${iol_schema}.svss_bussiness_info_statistics_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svss_bussiness_info_statistics;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svss_bussiness_info_statistics') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svss_bussiness_info_statistics drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svss_bussiness_info_statistics add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svss_bussiness_info_statistics exchange partition p_${batch_date} with table ${iol_schema}.svss_bussiness_info_statistics_cl;
alter table ${iol_schema}.svss_bussiness_info_statistics exchange partition p_20991231 with table ${iol_schema}.svss_bussiness_info_statistics_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svss_bussiness_info_statistics to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_bussiness_info_statistics_op purge;
drop table ${iol_schema}.svss_bussiness_info_statistics_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svss_bussiness_info_statistics_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svss_bussiness_info_statistics',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
