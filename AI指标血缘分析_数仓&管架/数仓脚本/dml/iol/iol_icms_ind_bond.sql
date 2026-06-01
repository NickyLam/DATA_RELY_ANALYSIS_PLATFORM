/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_bond
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
create table ${iol_schema}.icms_ind_bond_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_bond
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_bond_op purge;
drop table ${iol_schema}.icms_ind_bond_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_bond_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_bond where 0=1;

create table ${iol_schema}.icms_ind_bond_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_bond where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_bond_cl(
            serialno -- 流水号
            ,inputorgid -- 登记机构
            ,bondsum -- 购买总价格
            ,enddate -- 债券到期日期
            ,bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
            ,customerid -- 客户编号
            ,uptodate -- 统计截止日期
            ,bondno -- 债券号债券编号
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,remark -- 备注
            ,bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
            ,corporgid -- 法人机构编号
            ,bondname -- 债券名称
            ,begindate -- 债券起始日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_bond_op(
            serialno -- 流水号
            ,inputorgid -- 登记机构
            ,bondsum -- 购买总价格
            ,enddate -- 债券到期日期
            ,bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
            ,customerid -- 客户编号
            ,uptodate -- 统计截止日期
            ,bondno -- 债券号债券编号
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,remark -- 备注
            ,bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
            ,corporgid -- 法人机构编号
            ,bondname -- 债券名称
            ,begindate -- 债券起始日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.bondsum, o.bondsum) as bondsum -- 购买总价格
    ,nvl(n.enddate, o.enddate) as enddate -- 债券到期日期
    ,nvl(n.bondtype, o.bondtype) as bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.uptodate, o.uptodate) as uptodate -- 统计截止日期
    ,nvl(n.bondno, o.bondno) as bondno -- 债券号债券编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bondcurrency, o.bondcurrency) as bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.bondname, o.bondname) as bondname -- 债券名称
    ,nvl(n.begindate, o.begindate) as begindate -- 债券起始日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
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
from (select * from ${iol_schema}.icms_ind_bond_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_bond where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.inputorgid <> n.inputorgid
        or o.bondsum <> n.bondsum
        or o.enddate <> n.enddate
        or o.bondtype <> n.bondtype
        or o.customerid <> n.customerid
        or o.uptodate <> n.uptodate
        or o.bondno <> n.bondno
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
        or o.bondcurrency <> n.bondcurrency
        or o.corporgid <> n.corporgid
        or o.bondname <> n.bondname
        or o.begindate <> n.begindate
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_bond_cl(
            serialno -- 流水号
            ,inputorgid -- 登记机构
            ,bondsum -- 购买总价格
            ,enddate -- 债券到期日期
            ,bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
            ,customerid -- 客户编号
            ,uptodate -- 统计截止日期
            ,bondno -- 债券号债券编号
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,remark -- 备注
            ,bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
            ,corporgid -- 法人机构编号
            ,bondname -- 债券名称
            ,begindate -- 债券起始日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_bond_op(
            serialno -- 流水号
            ,inputorgid -- 登记机构
            ,bondsum -- 购买总价格
            ,enddate -- 债券到期日期
            ,bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
            ,customerid -- 客户编号
            ,uptodate -- 统计截止日期
            ,bondno -- 债券号债券编号
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,remark -- 备注
            ,bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
            ,corporgid -- 法人机构编号
            ,bondname -- 债券名称
            ,begindate -- 债券起始日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.inputorgid -- 登记机构
    ,o.bondsum -- 购买总价格
    ,o.enddate -- 债券到期日期
    ,o.bondtype -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
    ,o.customerid -- 客户编号
    ,o.uptodate -- 统计截止日期
    ,o.bondno -- 债券号债券编号
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新时间
    ,o.remark -- 备注
    ,o.bondcurrency -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
    ,o.corporgid -- 法人机构编号
    ,o.bondname -- 债券名称
    ,o.begindate -- 债券起始日期
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
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
from ${iol_schema}.icms_ind_bond_bk o
    left join ${iol_schema}.icms_ind_bond_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_bond_cl d
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
--truncate table ${iol_schema}.icms_ind_bond;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_bond') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_bond drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_bond add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_bond exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_bond_cl;
alter table ${iol_schema}.icms_ind_bond exchange partition p_20991231 with table ${iol_schema}.icms_ind_bond_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_bond to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_bond_op purge;
drop table ${iol_schema}.icms_ind_bond_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_bond_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_bond',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
