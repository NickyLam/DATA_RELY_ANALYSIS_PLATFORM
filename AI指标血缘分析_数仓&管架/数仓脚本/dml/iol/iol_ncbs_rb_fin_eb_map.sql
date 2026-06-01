/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_fin_eb_map
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
create table ${iol_schema}.ncbs_rb_fin_eb_map_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_fin_eb_map
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fin_eb_map_op purge;
drop table ${iol_schema}.ncbs_rb_fin_eb_map_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fin_eb_map_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fin_eb_map where 0=1;

create table ${iol_schema}.ncbs_rb_fin_eb_map_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fin_eb_map where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fin_eb_map_cl(
            prod_type -- 产品编号
            ,remark -- 备注
            ,tran_type -- 交易类型
            ,bill_code -- 汇票类型
            ,bill_medium_type -- 票据介质类型
            ,branch_flag -- 机构取值标志
            ,busi_type -- 业务种类
            ,company -- 法人
            ,eb_acct_class -- 电子汇票账户分类
            ,eb_amt_flag -- 电子汇票金额类型
            ,eb_busi_type -- 业务类型
            ,entity_flag -- 实物标识
            ,event_type -- 事件类型
            ,memo1 -- 备用字段1
            ,memo2 -- 备用字段2
            ,memo3 -- 备用字段3
            ,online_flag -- 是否联机
            ,online_offline_flag -- 线上线下清算标识
            ,operate_nature_desc -- 操作属性描述
            ,prod_desc -- 产品名称
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,eb_operate_type -- 电子汇票操作类型
            ,eb_operate_type_desc -- 电子汇票操作类型描述
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fin_eb_map_op(
            prod_type -- 产品编号
            ,remark -- 备注
            ,tran_type -- 交易类型
            ,bill_code -- 汇票类型
            ,bill_medium_type -- 票据介质类型
            ,branch_flag -- 机构取值标志
            ,busi_type -- 业务种类
            ,company -- 法人
            ,eb_acct_class -- 电子汇票账户分类
            ,eb_amt_flag -- 电子汇票金额类型
            ,eb_busi_type -- 业务类型
            ,entity_flag -- 实物标识
            ,event_type -- 事件类型
            ,memo1 -- 备用字段1
            ,memo2 -- 备用字段2
            ,memo3 -- 备用字段3
            ,online_flag -- 是否联机
            ,online_offline_flag -- 线上线下清算标识
            ,operate_nature_desc -- 操作属性描述
            ,prod_desc -- 产品名称
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,eb_operate_type -- 电子汇票操作类型
            ,eb_operate_type_desc -- 电子汇票操作类型描述
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.bill_code, o.bill_code) as bill_code -- 汇票类型
    ,nvl(n.bill_medium_type, o.bill_medium_type) as bill_medium_type -- 票据介质类型
    ,nvl(n.branch_flag, o.branch_flag) as branch_flag -- 机构取值标志
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务种类
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.eb_acct_class, o.eb_acct_class) as eb_acct_class -- 电子汇票账户分类
    ,nvl(n.eb_amt_flag, o.eb_amt_flag) as eb_amt_flag -- 电子汇票金额类型
    ,nvl(n.eb_busi_type, o.eb_busi_type) as eb_busi_type -- 业务类型
    ,nvl(n.entity_flag, o.entity_flag) as entity_flag -- 实物标识
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.memo1, o.memo1) as memo1 -- 备用字段1
    ,nvl(n.memo2, o.memo2) as memo2 -- 备用字段2
    ,nvl(n.memo3, o.memo3) as memo3 -- 备用字段3
    ,nvl(n.online_flag, o.online_flag) as online_flag -- 是否联机
    ,nvl(n.online_offline_flag, o.online_offline_flag) as online_offline_flag -- 线上线下清算标识
    ,nvl(n.operate_nature_desc, o.operate_nature_desc) as operate_nature_desc -- 操作属性描述
    ,nvl(n.prod_desc, o.prod_desc) as prod_desc -- 产品名称
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.eb_operate_type, o.eb_operate_type) as eb_operate_type -- 电子汇票操作类型
    ,nvl(n.eb_operate_type_desc, o.eb_operate_type_desc) as eb_operate_type_desc -- 电子汇票操作类型描述
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.tran_type is null
            and n.bill_code is null
            and n.bill_medium_type is null
            and n.eb_busi_type is null
            and n.entity_flag is null
            and n.event_type is null
            and n.seq_no is null
            and n.eb_operate_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_type is null
            and n.bill_code is null
            and n.bill_medium_type is null
            and n.eb_busi_type is null
            and n.entity_flag is null
            and n.event_type is null
            and n.seq_no is null
            and n.eb_operate_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_type is null
            and n.bill_code is null
            and n.bill_medium_type is null
            and n.eb_busi_type is null
            and n.entity_flag is null
            and n.event_type is null
            and n.seq_no is null
            and n.eb_operate_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_fin_eb_map_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_fin_eb_map where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tran_type = n.tran_type
            and o.bill_code = n.bill_code
            and o.bill_medium_type = n.bill_medium_type
            and o.eb_busi_type = n.eb_busi_type
            and o.entity_flag = n.entity_flag
            and o.event_type = n.event_type
            and o.seq_no = n.seq_no
            and o.eb_operate_type = n.eb_operate_type
where (
        o.tran_type is null
        and o.bill_code is null
        and o.bill_medium_type is null
        and o.eb_busi_type is null
        and o.entity_flag is null
        and o.event_type is null
        and o.seq_no is null
        and o.eb_operate_type is null
    )
    or (
        n.tran_type is null
        and n.bill_code is null
        and n.bill_medium_type is null
        and n.eb_busi_type is null
        and n.entity_flag is null
        and n.event_type is null
        and n.seq_no is null
        and n.eb_operate_type is null
    )
    or (
        o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.branch_flag <> n.branch_flag
        or o.busi_type <> n.busi_type
        or o.company <> n.company
        or o.eb_acct_class <> n.eb_acct_class
        or o.eb_amt_flag <> n.eb_amt_flag
        or o.memo1 <> n.memo1
        or o.memo2 <> n.memo2
        or o.memo3 <> n.memo3
        or o.online_flag <> n.online_flag
        or o.online_offline_flag <> n.online_offline_flag
        or o.operate_nature_desc <> n.operate_nature_desc
        or o.prod_desc <> n.prod_desc
        or o.source_type <> n.source_type
        or o.eb_operate_type_desc <> n.eb_operate_type_desc
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fin_eb_map_cl(
            prod_type -- 产品编号
            ,remark -- 备注
            ,tran_type -- 交易类型
            ,bill_code -- 汇票类型
            ,bill_medium_type -- 票据介质类型
            ,branch_flag -- 机构取值标志
            ,busi_type -- 业务种类
            ,company -- 法人
            ,eb_acct_class -- 电子汇票账户分类
            ,eb_amt_flag -- 电子汇票金额类型
            ,eb_busi_type -- 业务类型
            ,entity_flag -- 实物标识
            ,event_type -- 事件类型
            ,memo1 -- 备用字段1
            ,memo2 -- 备用字段2
            ,memo3 -- 备用字段3
            ,online_flag -- 是否联机
            ,online_offline_flag -- 线上线下清算标识
            ,operate_nature_desc -- 操作属性描述
            ,prod_desc -- 产品名称
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,eb_operate_type -- 电子汇票操作类型
            ,eb_operate_type_desc -- 电子汇票操作类型描述
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fin_eb_map_op(
            prod_type -- 产品编号
            ,remark -- 备注
            ,tran_type -- 交易类型
            ,bill_code -- 汇票类型
            ,bill_medium_type -- 票据介质类型
            ,branch_flag -- 机构取值标志
            ,busi_type -- 业务种类
            ,company -- 法人
            ,eb_acct_class -- 电子汇票账户分类
            ,eb_amt_flag -- 电子汇票金额类型
            ,eb_busi_type -- 业务类型
            ,entity_flag -- 实物标识
            ,event_type -- 事件类型
            ,memo1 -- 备用字段1
            ,memo2 -- 备用字段2
            ,memo3 -- 备用字段3
            ,online_flag -- 是否联机
            ,online_offline_flag -- 线上线下清算标识
            ,operate_nature_desc -- 操作属性描述
            ,prod_desc -- 产品名称
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,eb_operate_type -- 电子汇票操作类型
            ,eb_operate_type_desc -- 电子汇票操作类型描述
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.tran_type -- 交易类型
    ,o.bill_code -- 汇票类型
    ,o.bill_medium_type -- 票据介质类型
    ,o.branch_flag -- 机构取值标志
    ,o.busi_type -- 业务种类
    ,o.company -- 法人
    ,o.eb_acct_class -- 电子汇票账户分类
    ,o.eb_amt_flag -- 电子汇票金额类型
    ,o.eb_busi_type -- 业务类型
    ,o.entity_flag -- 实物标识
    ,o.event_type -- 事件类型
    ,o.memo1 -- 备用字段1
    ,o.memo2 -- 备用字段2
    ,o.memo3 -- 备用字段3
    ,o.online_flag -- 是否联机
    ,o.online_offline_flag -- 线上线下清算标识
    ,o.operate_nature_desc -- 操作属性描述
    ,o.prod_desc -- 产品名称
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.eb_operate_type -- 电子汇票操作类型
    ,o.eb_operate_type_desc -- 电子汇票操作类型描述
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_rb_fin_eb_map_bk o
    left join ${iol_schema}.ncbs_rb_fin_eb_map_op n
        on
            o.tran_type = n.tran_type
            and o.bill_code = n.bill_code
            and o.bill_medium_type = n.bill_medium_type
            and o.eb_busi_type = n.eb_busi_type
            and o.entity_flag = n.entity_flag
            and o.event_type = n.event_type
            and o.seq_no = n.seq_no
            and o.eb_operate_type = n.eb_operate_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_fin_eb_map_cl d
        on
            o.tran_type = d.tran_type
            and o.bill_code = d.bill_code
            and o.bill_medium_type = d.bill_medium_type
            and o.eb_busi_type = d.eb_busi_type
            and o.entity_flag = d.entity_flag
            and o.event_type = d.event_type
            and o.seq_no = d.seq_no
            and o.eb_operate_type = d.eb_operate_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_fin_eb_map;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_fin_eb_map') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_fin_eb_map drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_fin_eb_map add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_fin_eb_map exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_fin_eb_map_cl;
alter table ${iol_schema}.ncbs_rb_fin_eb_map exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_fin_eb_map_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_fin_eb_map to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fin_eb_map_op purge;
drop table ${iol_schema}.ncbs_rb_fin_eb_map_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_fin_eb_map_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_fin_eb_map',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
