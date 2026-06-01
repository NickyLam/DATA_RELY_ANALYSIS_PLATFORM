/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ntsalarybat
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
create table ${iol_schema}.mpcs_a1ntsalarybat_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1ntsalarybat
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1ntsalarybat_op purge;
drop table ${iol_schema}.mpcs_a1ntsalarybat_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ntsalarybat_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ntsalarybat where 0=1;

create table ${iol_schema}.mpcs_a1ntsalarybat_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ntsalarybat where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1ntsalarybat_cl(
            specialaccount -- 专用账户号
            ,wagecode -- 工资表编号
            ,wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
            ,month -- 工资月份
            ,total -- 应发总金额     以分单位
            ,creatime -- 创建时间
            ,remarks -- 备注
            ,batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
            ,updt -- 更新时间
            ,clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
            ,projno -- 签约号
            ,acctna -- 委托单位名称
            ,payacc -- 代发账号
            ,paynam -- 代发账号名称
            ,projtp -- 类型
            ,bachdt -- 批次日期
            ,bachsq -- 批次流水
            ,times -- 上报次数 最大值5次
            ,dfinstid -- 代发工资机构标识
            ,totalnum -- 代发笔数
            ,totalamt -- 代发总金额
            ,bankserialno -- 银行流水号
            ,requestip -- 请求方ip地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1ntsalarybat_op(
            specialaccount -- 专用账户号
            ,wagecode -- 工资表编号
            ,wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
            ,month -- 工资月份
            ,total -- 应发总金额     以分单位
            ,creatime -- 创建时间
            ,remarks -- 备注
            ,batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
            ,updt -- 更新时间
            ,clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
            ,projno -- 签约号
            ,acctna -- 委托单位名称
            ,payacc -- 代发账号
            ,paynam -- 代发账号名称
            ,projtp -- 类型
            ,bachdt -- 批次日期
            ,bachsq -- 批次流水
            ,times -- 上报次数 最大值5次
            ,dfinstid -- 代发工资机构标识
            ,totalnum -- 代发笔数
            ,totalamt -- 代发总金额
            ,bankserialno -- 银行流水号
            ,requestip -- 请求方ip地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.specialaccount, o.specialaccount) as specialaccount -- 专用账户号
    ,nvl(n.wagecode, o.wagecode) as wagecode -- 工资表编号
    ,nvl(n.wagestate, o.wagestate) as wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
    ,nvl(n.month, o.month) as month -- 工资月份
    ,nvl(n.total, o.total) as total -- 应发总金额     以分单位
    ,nvl(n.creatime, o.creatime) as creatime -- 创建时间
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.batstatus, o.batstatus) as batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
    ,nvl(n.updt, o.updt) as updt -- 更新时间
    ,nvl(n.clockstatus, o.clockstatus) as clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
    ,nvl(n.projno, o.projno) as projno -- 签约号
    ,nvl(n.acctna, o.acctna) as acctna -- 委托单位名称
    ,nvl(n.payacc, o.payacc) as payacc -- 代发账号
    ,nvl(n.paynam, o.paynam) as paynam -- 代发账号名称
    ,nvl(n.projtp, o.projtp) as projtp -- 类型
    ,nvl(n.bachdt, o.bachdt) as bachdt -- 批次日期
    ,nvl(n.bachsq, o.bachsq) as bachsq -- 批次流水
    ,nvl(n.times, o.times) as times -- 上报次数 最大值5次
    ,nvl(n.dfinstid, o.dfinstid) as dfinstid -- 代发工资机构标识
    ,nvl(n.totalnum, o.totalnum) as totalnum -- 代发笔数
    ,nvl(n.totalamt, o.totalamt) as totalamt -- 代发总金额
    ,nvl(n.bankserialno, o.bankserialno) as bankserialno -- 银行流水号
    ,nvl(n.requestip, o.requestip) as requestip -- 请求方ip地址
    ,case when
            n.specialaccount is null
            and n.wagecode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.specialaccount is null
            and n.wagecode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.specialaccount is null
            and n.wagecode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1ntsalarybat_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1ntsalarybat where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.specialaccount = n.specialaccount
            and o.wagecode = n.wagecode
where (
        o.specialaccount is null
        and o.wagecode is null
    )
    or (
        n.specialaccount is null
        and n.wagecode is null
    )
    or (
        o.wagestate <> n.wagestate
        or o.month <> n.month
        or o.total <> n.total
        or o.creatime <> n.creatime
        or o.remarks <> n.remarks
        or o.batstatus <> n.batstatus
        or o.updt <> n.updt
        or o.clockstatus <> n.clockstatus
        or o.projno <> n.projno
        or o.acctna <> n.acctna
        or o.payacc <> n.payacc
        or o.paynam <> n.paynam
        or o.projtp <> n.projtp
        or o.bachdt <> n.bachdt
        or o.bachsq <> n.bachsq
        or o.times <> n.times
        or o.dfinstid <> n.dfinstid
        or o.totalnum <> n.totalnum
        or o.totalamt <> n.totalamt
        or o.bankserialno <> n.bankserialno
        or o.requestip <> n.requestip
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1ntsalarybat_cl(
            specialaccount -- 专用账户号
            ,wagecode -- 工资表编号
            ,wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
            ,month -- 工资月份
            ,total -- 应发总金额     以分单位
            ,creatime -- 创建时间
            ,remarks -- 备注
            ,batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
            ,updt -- 更新时间
            ,clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
            ,projno -- 签约号
            ,acctna -- 委托单位名称
            ,payacc -- 代发账号
            ,paynam -- 代发账号名称
            ,projtp -- 类型
            ,bachdt -- 批次日期
            ,bachsq -- 批次流水
            ,times -- 上报次数 最大值5次
            ,dfinstid -- 代发工资机构标识
            ,totalnum -- 代发笔数
            ,totalamt -- 代发总金额
            ,bankserialno -- 银行流水号
            ,requestip -- 请求方ip地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1ntsalarybat_op(
            specialaccount -- 专用账户号
            ,wagecode -- 工资表编号
            ,wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
            ,month -- 工资月份
            ,total -- 应发总金额     以分单位
            ,creatime -- 创建时间
            ,remarks -- 备注
            ,batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
            ,updt -- 更新时间
            ,clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
            ,projno -- 签约号
            ,acctna -- 委托单位名称
            ,payacc -- 代发账号
            ,paynam -- 代发账号名称
            ,projtp -- 类型
            ,bachdt -- 批次日期
            ,bachsq -- 批次流水
            ,times -- 上报次数 最大值5次
            ,dfinstid -- 代发工资机构标识
            ,totalnum -- 代发笔数
            ,totalamt -- 代发总金额
            ,bankserialno -- 银行流水号
            ,requestip -- 请求方ip地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.specialaccount -- 专用账户号
    ,o.wagecode -- 工资表编号
    ,o.wagestate -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
    ,o.month -- 工资月份
    ,o.total -- 应发总金额     以分单位
    ,o.creatime -- 创建时间
    ,o.remarks -- 备注
    ,o.batstatus -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
    ,o.updt -- 更新时间
    ,o.clockstatus -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
    ,o.projno -- 签约号
    ,o.acctna -- 委托单位名称
    ,o.payacc -- 代发账号
    ,o.paynam -- 代发账号名称
    ,o.projtp -- 类型
    ,o.bachdt -- 批次日期
    ,o.bachsq -- 批次流水
    ,o.times -- 上报次数 最大值5次
    ,o.dfinstid -- 代发工资机构标识
    ,o.totalnum -- 代发笔数
    ,o.totalamt -- 代发总金额
    ,o.bankserialno -- 银行流水号
    ,o.requestip -- 请求方ip地址
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
from ${iol_schema}.mpcs_a1ntsalarybat_bk o
    left join ${iol_schema}.mpcs_a1ntsalarybat_op n
        on
            o.specialaccount = n.specialaccount
            and o.wagecode = n.wagecode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1ntsalarybat_cl d
        on
            o.specialaccount = d.specialaccount
            and o.wagecode = d.wagecode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1ntsalarybat;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1ntsalarybat') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1ntsalarybat drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1ntsalarybat add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1ntsalarybat exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ntsalarybat_cl;
alter table ${iol_schema}.mpcs_a1ntsalarybat exchange partition p_20991231 with table ${iol_schema}.mpcs_a1ntsalarybat_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ntsalarybat to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1ntsalarybat_op purge;
drop table ${iol_schema}.mpcs_a1ntsalarybat_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1ntsalarybat_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ntsalarybat',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
