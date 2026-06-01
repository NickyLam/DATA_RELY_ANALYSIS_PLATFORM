/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_dep_acct_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ifcs_dep_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_dep_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_dep_acct_info_op purge;
drop table ${iol_schema}.ifcs_dep_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_dep_acct_info where 0=1;

create table ${iol_schema}.ifcs_dep_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_dep_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_dep_acct_info_cl(
            acct_id -- 账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,acct_type_cd -- 账户类型代码
            ,open_acct_chn_cd -- 开户渠道代码
            ,open_acct_dt -- 开户日期
            ,acct_status_cd -- 账户状态代码
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,acpt_pay_status -- 收付标志
            ,sleep_acct_flg -- 睡眠户标志
            ,dormt_acct_flg -- 不动户标志
            ,acct_usage_cd -- 账户用途代码
            ,open_acct_flow_num -- 开户流水号
            ,acct_kind_cd -- 账户种类代码
            ,open_acct_org_id -- 开户机构编号
            ,close_acct_dt -- 销户日期
            ,close_acct_ti -- 销户时间
            ,close_acct_flow_num -- 销户流水号
            ,last_sub_id -- 最后子户序号
            ,bind_acct_id -- 绑定微众账户编号
            ,last_activ_acct_dt -- 最后动户日期
            ,open_acct_tm -- 开户完成时间
            ,part_id -- 分区ID
            ,base_val -- 基准值
            ,sync_status_cd -- 同步状态
            ,accept_status -- 止收状态
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_dep_acct_info_op(
            acct_id -- 账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,acct_type_cd -- 账户类型代码
            ,open_acct_chn_cd -- 开户渠道代码
            ,open_acct_dt -- 开户日期
            ,acct_status_cd -- 账户状态代码
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,acpt_pay_status -- 收付标志
            ,sleep_acct_flg -- 睡眠户标志
            ,dormt_acct_flg -- 不动户标志
            ,acct_usage_cd -- 账户用途代码
            ,open_acct_flow_num -- 开户流水号
            ,acct_kind_cd -- 账户种类代码
            ,open_acct_org_id -- 开户机构编号
            ,close_acct_dt -- 销户日期
            ,close_acct_ti -- 销户时间
            ,close_acct_flow_num -- 销户流水号
            ,last_sub_id -- 最后子户序号
            ,bind_acct_id -- 绑定微众账户编号
            ,last_activ_acct_dt -- 最后动户日期
            ,open_acct_tm -- 开户完成时间
            ,part_id -- 分区ID
            ,base_val -- 基准值
            ,sync_status_cd -- 同步状态
            ,accept_status -- 止收状态
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.open_acct_chn_cd, o.open_acct_chn_cd) as open_acct_chn_cd -- 开户渠道代码
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.froz_status, o.froz_status) as froz_status -- 冻结状态
    ,nvl(n.stpay_status_cd, o.stpay_status_cd) as stpay_status_cd -- 止付状态
    ,nvl(n.acpt_pay_status, o.acpt_pay_status) as acpt_pay_status -- 收付标志
    ,nvl(n.sleep_acct_flg, o.sleep_acct_flg) as sleep_acct_flg -- 睡眠户标志
    ,nvl(n.dormt_acct_flg, o.dormt_acct_flg) as dormt_acct_flg -- 不动户标志
    ,nvl(n.acct_usage_cd, o.acct_usage_cd) as acct_usage_cd -- 账户用途代码
    ,nvl(n.open_acct_flow_num, o.open_acct_flow_num) as open_acct_flow_num -- 开户流水号
    ,nvl(n.acct_kind_cd, o.acct_kind_cd) as acct_kind_cd -- 账户种类代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.close_acct_dt, o.close_acct_dt) as close_acct_dt -- 销户日期
    ,nvl(n.close_acct_ti, o.close_acct_ti) as close_acct_ti -- 销户时间
    ,nvl(n.close_acct_flow_num, o.close_acct_flow_num) as close_acct_flow_num -- 销户流水号
    ,nvl(n.last_sub_id, o.last_sub_id) as last_sub_id -- 最后子户序号
    ,nvl(n.bind_acct_id, o.bind_acct_id) as bind_acct_id -- 绑定微众账户编号
    ,nvl(n.last_activ_acct_dt, o.last_activ_acct_dt) as last_activ_acct_dt -- 最后动户日期
    ,nvl(n.open_acct_tm, o.open_acct_tm) as open_acct_tm -- 开户完成时间
    ,nvl(n.part_id, o.part_id) as part_id -- 分区ID
    ,nvl(n.base_val, o.base_val) as base_val -- 基准值
    ,nvl(n.sync_status_cd, o.sync_status_cd) as sync_status_cd -- 同步状态
    ,nvl(n.accept_status, o.accept_status) as accept_status -- 止收状态
    ,nvl(n.dps_type_cd, o.dps_type_cd) as dps_type_cd -- 储种
    ,case when
            n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifcs_dep_acct_info_bk o
    full join (select * from ${itl_schema}.ifcs_dep_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_id = n.acct_id
where (
        o.acct_id is null
    )
    or (
        n.acct_id is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.cust_id <> n.cust_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.open_acct_chn_cd <> n.open_acct_chn_cd
        or o.open_acct_dt <> n.open_acct_dt
        or o.acct_status_cd <> n.acct_status_cd
        or o.froz_status <> n.froz_status
        or o.stpay_status_cd <> n.stpay_status_cd
        or o.acpt_pay_status <> n.acpt_pay_status
        or o.sleep_acct_flg <> n.sleep_acct_flg
        or o.dormt_acct_flg <> n.dormt_acct_flg
        or o.acct_usage_cd <> n.acct_usage_cd
        or o.open_acct_flow_num <> n.open_acct_flow_num
        or o.acct_kind_cd <> n.acct_kind_cd
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.close_acct_dt <> n.close_acct_dt
        or o.close_acct_ti <> n.close_acct_ti
        or o.close_acct_flow_num <> n.close_acct_flow_num
        or o.last_sub_id <> n.last_sub_id
        or o.bind_acct_id <> n.bind_acct_id
        or o.last_activ_acct_dt <> n.last_activ_acct_dt
        or o.open_acct_tm <> n.open_acct_tm
        or o.part_id <> n.part_id
        or o.base_val <> n.base_val
        or o.sync_status_cd <> n.sync_status_cd
        or o.accept_status <> n.accept_status
        or o.dps_type_cd <> n.dps_type_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_dep_acct_info_cl(
            acct_id -- 账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,acct_type_cd -- 账户类型代码
            ,open_acct_chn_cd -- 开户渠道代码
            ,open_acct_dt -- 开户日期
            ,acct_status_cd -- 账户状态代码
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,acpt_pay_status -- 收付标志
            ,sleep_acct_flg -- 睡眠户标志
            ,dormt_acct_flg -- 不动户标志
            ,acct_usage_cd -- 账户用途代码
            ,open_acct_flow_num -- 开户流水号
            ,acct_kind_cd -- 账户种类代码
            ,open_acct_org_id -- 开户机构编号
            ,close_acct_dt -- 销户日期
            ,close_acct_ti -- 销户时间
            ,close_acct_flow_num -- 销户流水号
            ,last_sub_id -- 最后子户序号
            ,bind_acct_id -- 绑定微众账户编号
            ,last_activ_acct_dt -- 最后动户日期
            ,open_acct_tm -- 开户完成时间
            ,part_id -- 分区ID
            ,base_val -- 基准值
            ,sync_status_cd -- 同步状态
            ,accept_status -- 止收状态
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_dep_acct_info_op(
            acct_id -- 账户编号
            ,acct_name -- 账户名称
            ,cust_id -- 客户编号
            ,acct_type_cd -- 账户类型代码
            ,open_acct_chn_cd -- 开户渠道代码
            ,open_acct_dt -- 开户日期
            ,acct_status_cd -- 账户状态代码
            ,froz_status -- 冻结状态
            ,stpay_status_cd -- 止付状态
            ,acpt_pay_status -- 收付标志
            ,sleep_acct_flg -- 睡眠户标志
            ,dormt_acct_flg -- 不动户标志
            ,acct_usage_cd -- 账户用途代码
            ,open_acct_flow_num -- 开户流水号
            ,acct_kind_cd -- 账户种类代码
            ,open_acct_org_id -- 开户机构编号
            ,close_acct_dt -- 销户日期
            ,close_acct_ti -- 销户时间
            ,close_acct_flow_num -- 销户流水号
            ,last_sub_id -- 最后子户序号
            ,bind_acct_id -- 绑定微众账户编号
            ,last_activ_acct_dt -- 最后动户日期
            ,open_acct_tm -- 开户完成时间
            ,part_id -- 分区ID
            ,base_val -- 基准值
            ,sync_status_cd -- 同步状态
            ,accept_status -- 止收状态
            ,dps_type_cd -- 储种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.cust_id -- 客户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.open_acct_chn_cd -- 开户渠道代码
    ,o.open_acct_dt -- 开户日期
    ,o.acct_status_cd -- 账户状态代码
    ,o.froz_status -- 冻结状态
    ,o.stpay_status_cd -- 止付状态
    ,o.acpt_pay_status -- 收付标志
    ,o.sleep_acct_flg -- 睡眠户标志
    ,o.dormt_acct_flg -- 不动户标志
    ,o.acct_usage_cd -- 账户用途代码
    ,o.open_acct_flow_num -- 开户流水号
    ,o.acct_kind_cd -- 账户种类代码
    ,o.open_acct_org_id -- 开户机构编号
    ,o.close_acct_dt -- 销户日期
    ,o.close_acct_ti -- 销户时间
    ,o.close_acct_flow_num -- 销户流水号
    ,o.last_sub_id -- 最后子户序号
    ,o.bind_acct_id -- 绑定微众账户编号
    ,o.last_activ_acct_dt -- 最后动户日期
    ,o.open_acct_tm -- 开户完成时间
    ,o.part_id -- 分区ID
    ,o.base_val -- 基准值
    ,o.sync_status_cd -- 同步状态
    ,o.accept_status -- 止收状态
    ,o.dps_type_cd -- 储种
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ifcs_dep_acct_info_bk o
    left join ${iol_schema}.ifcs_dep_acct_info_op n
        on
            o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_dep_acct_info_cl d
        on
            o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifcs_dep_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifcs_dep_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifcs_dep_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifcs_dep_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));


-- 4.3 exchange partition
alter table ${iol_schema}.ifcs_dep_acct_info exchange partition p_${batch_date} with table ${iol_schema}.ifcs_dep_acct_info_cl;
alter table ${iol_schema}.ifcs_dep_acct_info exchange partition p_20991231 with table ${iol_schema}.ifcs_dep_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_dep_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_dep_acct_info_op purge;
drop table ${iol_schema}.ifcs_dep_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_dep_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_dep_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
