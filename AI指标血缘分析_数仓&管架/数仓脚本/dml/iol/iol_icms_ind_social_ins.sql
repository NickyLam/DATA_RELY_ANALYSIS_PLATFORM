/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_social_ins
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
create table ${iol_schema}.icms_ind_social_ins_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_social_ins
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_social_ins_op purge;
drop table ${iol_schema}.icms_ind_social_ins_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_social_ins_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_social_ins where 0=1;

create table ${iol_schema}.icms_ind_social_ins_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_social_ins where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_social_ins_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,sibalance -- 余额余额（单位：元）
            ,uptodate -- 统计截止日期
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateuserid -- 更新人
            ,sitno -- 社会保险号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_social_ins_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,sibalance -- 余额余额（单位：元）
            ,uptodate -- 统计截止日期
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateuserid -- 更新人
            ,sitno -- 社会保险号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.sibalance, o.sibalance) as sibalance -- 余额余额（单位：元）
    ,nvl(n.uptodate, o.uptodate) as uptodate -- 统计截止日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.sitype, o.sitype) as sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.sitno, o.sitno) as sitno -- 社会保险号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ind_social_ins_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_social_ins where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.sibalance <> n.sibalance
        or o.uptodate <> n.uptodate
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.sitype <> n.sitype
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
        or o.corporgid <> n.corporgid
        or o.migtflag <> n.migtflag
        or o.updateuserid <> n.updateuserid
        or o.sitno <> n.sitno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_social_ins_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,sibalance -- 余额余额（单位：元）
            ,uptodate -- 统计截止日期
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateuserid -- 更新人
            ,sitno -- 社会保险号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_social_ins_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,sibalance -- 余额余额（单位：元）
            ,uptodate -- 统计截止日期
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
            ,inputuserid -- 登记人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,corporgid -- 法人机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateuserid -- 更新人
            ,sitno -- 社会保险号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户编号
    ,o.sibalance -- 余额余额（单位：元）
    ,o.uptodate -- 统计截止日期
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.sitype -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
    ,o.inputuserid -- 登记人
    ,o.updatedate -- 更新日期
    ,o.remark -- 备注
    ,o.corporgid -- 法人机构编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.updateuserid -- 更新人
    ,o.sitno -- 社会保险号
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
from ${iol_schema}.icms_ind_social_ins_bk o
    left join ${iol_schema}.icms_ind_social_ins_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_social_ins_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ind_social_ins;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_social_ins') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_social_ins drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_social_ins add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_social_ins exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_social_ins_cl;
alter table ${iol_schema}.icms_ind_social_ins exchange partition p_20991231 with table ${iol_schema}.icms_ind_social_ins_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_social_ins to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_social_ins_op purge;
drop table ${iol_schema}.icms_ind_social_ins_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_social_ins_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_social_ins',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
