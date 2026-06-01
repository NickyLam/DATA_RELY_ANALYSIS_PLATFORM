/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_return_info
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
create table ${iol_schema}.icms_ap_return_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_return_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_return_info_op purge;
drop table ${iol_schema}.icms_ap_return_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_return_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_return_info where 0=1;

create table ${iol_schema}.icms_ap_return_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_return_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_return_info_cl(
            returnno -- 回款编号
            ,updateuserid -- 更新人编号
            ,inputuserid -- 登记人编号
            ,liquidatecost -- 清收费用
            ,returndate -- 回款日期
            ,tmsp -- 时间戳
            ,caseprogramstage -- 程序阶段
            ,updateorgid -- 更新机构编号
            ,remark -- 备注
            ,payno -- 还款账号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,liquidateinterest -- 清收利息
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,returnsum -- 本次回款金额
            ,liquidatesum -- 清收本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_return_info_op(
            returnno -- 回款编号
            ,updateuserid -- 更新人编号
            ,inputuserid -- 登记人编号
            ,liquidatecost -- 清收费用
            ,returndate -- 回款日期
            ,tmsp -- 时间戳
            ,caseprogramstage -- 程序阶段
            ,updateorgid -- 更新机构编号
            ,remark -- 备注
            ,payno -- 还款账号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,liquidateinterest -- 清收利息
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,returnsum -- 本次回款金额
            ,liquidatesum -- 清收本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.returnno, o.returnno) as returnno -- 回款编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.liquidatecost, o.liquidatecost) as liquidatecost -- 清收费用
    ,nvl(n.returndate, o.returndate) as returndate -- 回款日期
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.payno, o.payno) as payno -- 还款账号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.liquidateinterest, o.liquidateinterest) as liquidateinterest -- 清收利息
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.returnsum, o.returnsum) as returnsum -- 本次回款金额
    ,nvl(n.liquidatesum, o.liquidatesum) as liquidatesum -- 清收本金
    ,case when
            n.returnno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.returnno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.returnno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_return_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_return_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.returnno = n.returnno
where (
        o.returnno is null
    )
    or (
        n.returnno is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.inputuserid <> n.inputuserid
        or o.liquidatecost <> n.liquidatecost
        or o.returndate <> n.returndate
        or o.tmsp <> n.tmsp
        or o.caseprogramstage <> n.caseprogramstage
        or o.updateorgid <> n.updateorgid
        or o.remark <> n.remark
        or o.payno <> n.payno
        or o.updatedate <> n.updatedate
        or o.caseno <> n.caseno
        or o.liquidateinterest <> n.liquidateinterest
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.returnsum <> n.returnsum
        or o.liquidatesum <> n.liquidatesum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_return_info_cl(
            returnno -- 回款编号
            ,updateuserid -- 更新人编号
            ,inputuserid -- 登记人编号
            ,liquidatecost -- 清收费用
            ,returndate -- 回款日期
            ,tmsp -- 时间戳
            ,caseprogramstage -- 程序阶段
            ,updateorgid -- 更新机构编号
            ,remark -- 备注
            ,payno -- 还款账号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,liquidateinterest -- 清收利息
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,returnsum -- 本次回款金额
            ,liquidatesum -- 清收本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_return_info_op(
            returnno -- 回款编号
            ,updateuserid -- 更新人编号
            ,inputuserid -- 登记人编号
            ,liquidatecost -- 清收费用
            ,returndate -- 回款日期
            ,tmsp -- 时间戳
            ,caseprogramstage -- 程序阶段
            ,updateorgid -- 更新机构编号
            ,remark -- 备注
            ,payno -- 还款账号
            ,updatedate -- 更新日期
            ,caseno -- 关联案件项目编号
            ,liquidateinterest -- 清收利息
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,returnsum -- 本次回款金额
            ,liquidatesum -- 清收本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.returnno -- 回款编号
    ,o.updateuserid -- 更新人编号
    ,o.inputuserid -- 登记人编号
    ,o.liquidatecost -- 清收费用
    ,o.returndate -- 回款日期
    ,o.tmsp -- 时间戳
    ,o.caseprogramstage -- 程序阶段
    ,o.updateorgid -- 更新机构编号
    ,o.remark -- 备注
    ,o.payno -- 还款账号
    ,o.updatedate -- 更新日期
    ,o.caseno -- 关联案件项目编号
    ,o.liquidateinterest -- 清收利息
    ,o.inputorgid -- 登记机构编号
    ,o.inputdate -- 登记日期
    ,o.returnsum -- 本次回款金额
    ,o.liquidatesum -- 清收本金
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
from ${iol_schema}.icms_ap_return_info_bk o
    left join ${iol_schema}.icms_ap_return_info_op n
        on
            o.returnno = n.returnno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_return_info_cl d
        on
            o.returnno = d.returnno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_return_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_return_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_return_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_return_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_return_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_return_info_cl;
alter table ${iol_schema}.icms_ap_return_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_return_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_return_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_return_info_op purge;
drop table ${iol_schema}.icms_ap_return_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_return_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_return_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
