/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_ebank_property_pool
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
create table ${iol_schema}.bdps_ebank_property_pool_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_ebank_property_pool;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_ebank_property_pool_op purge;
drop table ${iol_schema}.bdps_ebank_property_pool_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_ebank_property_pool_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_ebank_property_pool where 0=1;

create table ${iol_schema}.bdps_ebank_property_pool_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_ebank_property_pool where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_ebank_property_pool_cl(
            id -- 
            ,txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,app_date -- 网银操作员申请指令日期
            ,app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,ebank_seq_no -- 网银流水号
            ,branch_id -- 所属机构 票所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
            ,misc -- 备注 保留
            ,chn_src -- 渠道来源 系统英文简称
            ,ebank_oper -- 网银提交人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_ebank_property_pool_op(
            id -- 
            ,txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,app_date -- 网银操作员申请指令日期
            ,app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,ebank_seq_no -- 网银流水号
            ,branch_id -- 所属机构 票所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
            ,misc -- 备注 保留
            ,chn_src -- 渠道来源 系统英文简称
            ,ebank_oper -- 网银提交人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
    ,nvl(n.property_id, o.property_id) as property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,nvl(n.app_date, o.app_date) as app_date -- 网银操作员申请指令日期
    ,nvl(n.app_status, o.app_status) as app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
    ,nvl(n.reason, o.reason) as reason -- 驳回理由
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.ebank_seq_no, o.ebank_seq_no) as ebank_seq_no -- 网银流水号
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 所属机构 票所属机构
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.int_tm, o.int_tm) as int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
    ,nvl(n.misc, o.misc) as misc -- 备注 保留
    ,nvl(n.chn_src, o.chn_src) as chn_src -- 渠道来源 系统英文简称
    ,nvl(n.ebank_oper, o.ebank_oper) as ebank_oper -- 网银提交人
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_ebank_property_pool_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_ebank_property_pool where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.txn_type <> n.txn_type
        or o.property_id <> n.property_id
        or o.app_date <> n.app_date
        or o.app_status <> n.app_status
        or o.reason <> n.reason
        or o.cust_no <> n.cust_no
        or o.ebank_seq_no <> n.ebank_seq_no
        or o.branch_id <> n.branch_id
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.int_tm <> n.int_tm
        or o.misc <> n.misc
        or o.chn_src <> n.chn_src
        or o.ebank_oper <> n.ebank_oper
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_ebank_property_pool_cl(
            id -- 
            ,txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,app_date -- 网银操作员申请指令日期
            ,app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,ebank_seq_no -- 网银流水号
            ,branch_id -- 所属机构 票所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
            ,misc -- 备注 保留
            ,chn_src -- 渠道来源 系统英文简称
            ,ebank_oper -- 网银提交人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_ebank_property_pool_op(
            id -- 
            ,txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,app_date -- 网银操作员申请指令日期
            ,app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,ebank_seq_no -- 网银流水号
            ,branch_id -- 所属机构 票所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
            ,misc -- 备注 保留
            ,chn_src -- 渠道来源 系统英文简称
            ,ebank_oper -- 网银提交人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.txn_type -- 业务类型 LR-理财质押入池 LC-理财质押解除
    ,o.property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,o.app_date -- 网银操作员申请指令日期
    ,o.app_status -- 申请状态 1-申请中 2-驳回申请 3-审批中 4-申请通过
    ,o.reason -- 驳回理由
    ,o.cust_no -- 客户号
    ,o.ebank_seq_no -- 网银流水号
    ,o.branch_id -- 所属机构 票所属机构
    ,o.last_upd_oper_id -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.int_tm -- 插入时间 初始插入时间戳 YYYY-MM-DD HH:MM:SS.0
    ,o.misc -- 备注 保留
    ,o.chn_src -- 渠道来源 系统英文简称
    ,o.ebank_oper -- 网银提交人
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_ebank_property_pool_bk o
    left join ${iol_schema}.bdps_ebank_property_pool_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_ebank_property_pool_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_ebank_property_pool;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_ebank_property_pool exchange partition p_19000101 with table ${iol_schema}.bdps_ebank_property_pool_cl;
alter table ${iol_schema}.bdps_ebank_property_pool exchange partition p_20991231 with table ${iol_schema}.bdps_ebank_property_pool_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_ebank_property_pool to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_ebank_property_pool_op purge;
drop table ${iol_schema}.bdps_ebank_property_pool_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_ebank_property_pool_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_ebank_property_pool',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
