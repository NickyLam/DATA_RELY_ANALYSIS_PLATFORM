/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ftp_register
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
create table ${iol_schema}.ibms_ttrd_ftp_register_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_ftp_register;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ftp_register_op purge;
drop table ${iol_schema}.ibms_ttrd_ftp_register_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_register_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ftp_register where 0=1;

create table ${iol_schema}.ibms_ttrd_ftp_register_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ftp_register where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ftp_register_cl(
            ord_id -- 审批单号
            ,ftp_code -- 方案编号 年月日+3位序列号
            ,ftp_name -- 方案名称
            ,type -- 方案类别
            ,spread -- FTP点差(BP)
            ,start_date -- 起始日
            ,end_date -- 终止日
            ,remark -- 内容说明
            ,opreator -- 登记用户
            ,reg_date -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ftp_register_op(
            ord_id -- 审批单号
            ,ftp_code -- 方案编号 年月日+3位序列号
            ,ftp_name -- 方案名称
            ,type -- 方案类别
            ,spread -- FTP点差(BP)
            ,start_date -- 起始日
            ,end_date -- 终止日
            ,remark -- 内容说明
            ,opreator -- 登记用户
            ,reg_date -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ord_id, o.ord_id) as ord_id -- 审批单号
    ,nvl(n.ftp_code, o.ftp_code) as ftp_code -- 方案编号 年月日+3位序列号
    ,nvl(n.ftp_name, o.ftp_name) as ftp_name -- 方案名称
    ,nvl(n.type, o.type) as type -- 方案类别
    ,nvl(n.spread, o.spread) as spread -- FTP点差(BP)
    ,nvl(n.start_date, o.start_date) as start_date -- 起始日
    ,nvl(n.end_date, o.end_date) as end_date -- 终止日
    ,nvl(n.remark, o.remark) as remark -- 内容说明
    ,nvl(n.opreator, o.opreator) as opreator -- 登记用户
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 登记日期
    ,case when
            n.ord_id is null
            and n.ftp_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ord_id is null
            and n.ftp_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ord_id is null
            and n.ftp_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_ftp_register_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_ftp_register where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ord_id = n.ord_id
            and o.ftp_code = n.ftp_code
where (
        o.ord_id is null
        and o.ftp_code is null
    )
    or (
        n.ord_id is null
        and n.ftp_code is null
    )
    or (
        o.ftp_name <> n.ftp_name
        or o.type <> n.type
        or o.spread <> n.spread
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.remark <> n.remark
        or o.opreator <> n.opreator
        or o.reg_date <> n.reg_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ftp_register_cl(
            ord_id -- 审批单号
            ,ftp_code -- 方案编号 年月日+3位序列号
            ,ftp_name -- 方案名称
            ,type -- 方案类别
            ,spread -- FTP点差(BP)
            ,start_date -- 起始日
            ,end_date -- 终止日
            ,remark -- 内容说明
            ,opreator -- 登记用户
            ,reg_date -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ftp_register_op(
            ord_id -- 审批单号
            ,ftp_code -- 方案编号 年月日+3位序列号
            ,ftp_name -- 方案名称
            ,type -- 方案类别
            ,spread -- FTP点差(BP)
            ,start_date -- 起始日
            ,end_date -- 终止日
            ,remark -- 内容说明
            ,opreator -- 登记用户
            ,reg_date -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ord_id -- 审批单号
    ,o.ftp_code -- 方案编号 年月日+3位序列号
    ,o.ftp_name -- 方案名称
    ,o.type -- 方案类别
    ,o.spread -- FTP点差(BP)
    ,o.start_date -- 起始日
    ,o.end_date -- 终止日
    ,o.remark -- 内容说明
    ,o.opreator -- 登记用户
    ,o.reg_date -- 登记日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_ftp_register_bk o
    left join ${iol_schema}.ibms_ttrd_ftp_register_op n
        on
            o.ord_id = n.ord_id
            and o.ftp_code = n.ftp_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_ftp_register_cl d
        on
            o.ord_id = d.ord_id
            and o.ftp_code = d.ftp_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_ftp_register;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_ftp_register exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_ftp_register_cl;
alter table ${iol_schema}.ibms_ttrd_ftp_register exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_ftp_register_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ftp_register to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ftp_register_op purge;
drop table ${iol_schema}.ibms_ttrd_ftp_register_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_ftp_register_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ftp_register',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
