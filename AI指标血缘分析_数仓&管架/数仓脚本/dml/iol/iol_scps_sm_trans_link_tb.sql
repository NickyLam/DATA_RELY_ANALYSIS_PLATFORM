/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_sm_trans_link_tb
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
create table ${iol_schema}.scps_sm_trans_link_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_sm_trans_link_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_sm_trans_link_tb_op purge;
drop table ${iol_schema}.scps_sm_trans_link_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_sm_trans_link_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_sm_trans_link_tb where 0=1;

create table ${iol_schema}.scps_sm_trans_link_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_sm_trans_link_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_sm_trans_link_tb_cl(
            trans_id -- 业务种类
            ,trans_name -- 业务种类名称
            ,trans_desc -- 业务种类描述
            ,transtype -- 业务类别
            ,bus_id -- 业务流程id
            ,last_modi_date -- 最后修改时间
            ,service_object -- 服务对象
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,mode_type -- 作业模式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_sm_trans_link_tb_op(
            trans_id -- 业务种类
            ,trans_name -- 业务种类名称
            ,trans_desc -- 业务种类描述
            ,transtype -- 业务类别
            ,bus_id -- 业务流程id
            ,last_modi_date -- 最后修改时间
            ,service_object -- 服务对象
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,mode_type -- 作业模式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_id, o.trans_id) as trans_id -- 业务种类
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 业务种类名称
    ,nvl(n.trans_desc, o.trans_desc) as trans_desc -- 业务种类描述
    ,nvl(n.transtype, o.transtype) as transtype -- 业务类别
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务流程id
    ,nvl(n.last_modi_date, o.last_modi_date) as last_modi_date -- 最后修改时间
    ,nvl(n.service_object, o.service_object) as service_object -- 服务对象
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统号
    ,nvl(n.mode_type, o.mode_type) as mode_type -- 作业模式
    ,case when
            n.trans_id is null
            and n.bank_no is null
            and n.system_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_id is null
            and n.bank_no is null
            and n.system_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_id is null
            and n.bank_no is null
            and n.system_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_sm_trans_link_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_sm_trans_link_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_id = n.trans_id
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
where (
        o.trans_id is null
        and o.bank_no is null
        and o.system_no is null
    )
    or (
        n.trans_id is null
        and n.bank_no is null
        and n.system_no is null
    )
    or (
        o.trans_name <> n.trans_name
        or o.trans_desc <> n.trans_desc
        or o.transtype <> n.transtype
        or o.bus_id <> n.bus_id
        or o.last_modi_date <> n.last_modi_date
        or o.service_object <> n.service_object
        or o.mode_type <> n.mode_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_sm_trans_link_tb_cl(
            trans_id -- 业务种类
            ,trans_name -- 业务种类名称
            ,trans_desc -- 业务种类描述
            ,transtype -- 业务类别
            ,bus_id -- 业务流程id
            ,last_modi_date -- 最后修改时间
            ,service_object -- 服务对象
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,mode_type -- 作业模式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_sm_trans_link_tb_op(
            trans_id -- 业务种类
            ,trans_name -- 业务种类名称
            ,trans_desc -- 业务种类描述
            ,transtype -- 业务类别
            ,bus_id -- 业务流程id
            ,last_modi_date -- 最后修改时间
            ,service_object -- 服务对象
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,mode_type -- 作业模式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_id -- 业务种类
    ,o.trans_name -- 业务种类名称
    ,o.trans_desc -- 业务种类描述
    ,o.transtype -- 业务类别
    ,o.bus_id -- 业务流程id
    ,o.last_modi_date -- 最后修改时间
    ,o.service_object -- 服务对象
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统号
    ,o.mode_type -- 作业模式
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
from ${iol_schema}.scps_sm_trans_link_tb_bk o
    left join ${iol_schema}.scps_sm_trans_link_tb_op n
        on
            o.trans_id = n.trans_id
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_sm_trans_link_tb_cl d
        on
            o.trans_id = d.trans_id
            and o.bank_no = d.bank_no
            and o.system_no = d.system_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_sm_trans_link_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_sm_trans_link_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_sm_trans_link_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_sm_trans_link_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_sm_trans_link_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_sm_trans_link_tb_cl;
alter table ${iol_schema}.scps_sm_trans_link_tb exchange partition p_20991231 with table ${iol_schema}.scps_sm_trans_link_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_sm_trans_link_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_sm_trans_link_tb_op purge;
drop table ${iol_schema}.scps_sm_trans_link_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_sm_trans_link_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_sm_trans_link_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
