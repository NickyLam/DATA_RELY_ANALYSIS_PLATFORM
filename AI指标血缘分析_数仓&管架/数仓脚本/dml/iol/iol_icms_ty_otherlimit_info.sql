/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ty_otherlimit_info
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
create table ${iol_schema}.icms_ty_otherlimit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ty_otherlimit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ty_otherlimit_info_op purge;
drop table ${iol_schema}.icms_ty_otherlimit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ty_otherlimit_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ty_otherlimit_info where 0=1;

create table ${iol_schema}.icms_ty_otherlimit_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ty_otherlimit_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ty_otherlimit_info_cl(
            objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
            ,objectno -- 对象编号
            ,creditcontno -- (他用额度的)额度合同号
            ,relacceptbankid -- 银票贴现承兑行总行行号
            ,updateuserid -- 更新员工编号
            ,acceptbankid -- 银票贴现承兑行行号
            ,updateorgid -- 更新机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 新增机构编号
            ,businesstype -- 业务合同的产品类型或押品类型
            ,inputuserid -- 新增员工编号
            ,updatedate -- 更新时间
            ,batchno -- 银票贴现批次号
            ,relacceptbankcustid -- 银票贴现承兑行总行行客户号
            ,inputdate -- 新增时间
            ,relbusinesstype -- 他用额度类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ty_otherlimit_info_op(
            objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
            ,objectno -- 对象编号
            ,creditcontno -- (他用额度的)额度合同号
            ,relacceptbankid -- 银票贴现承兑行总行行号
            ,updateuserid -- 更新员工编号
            ,acceptbankid -- 银票贴现承兑行行号
            ,updateorgid -- 更新机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 新增机构编号
            ,businesstype -- 业务合同的产品类型或押品类型
            ,inputuserid -- 新增员工编号
            ,updatedate -- 更新时间
            ,batchno -- 银票贴现批次号
            ,relacceptbankcustid -- 银票贴现承兑行总行行客户号
            ,inputdate -- 新增时间
            ,relbusinesstype -- 他用额度类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objecttype, o.objecttype) as objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.creditcontno, o.creditcontno) as creditcontno -- (他用额度的)额度合同号
    ,nvl(n.relacceptbankid, o.relacceptbankid) as relacceptbankid -- 银票贴现承兑行总行行号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新员工编号
    ,nvl(n.acceptbankid, o.acceptbankid) as acceptbankid -- 银票贴现承兑行行号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 新增机构编号
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务合同的产品类型或押品类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 新增员工编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.batchno, o.batchno) as batchno -- 银票贴现批次号
    ,nvl(n.relacceptbankcustid, o.relacceptbankcustid) as relacceptbankcustid -- 银票贴现承兑行总行行客户号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增时间
    ,nvl(n.relbusinesstype, o.relbusinesstype) as relbusinesstype -- 他用额度类型
    ,case when
            n.objecttype is null
            and n.objectno is null
            and n.creditcontno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objecttype is null
            and n.objectno is null
            and n.creditcontno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objecttype is null
            and n.objectno is null
            and n.creditcontno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ty_otherlimit_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ty_otherlimit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.creditcontno = n.creditcontno
where (
        o.objecttype is null
        and o.objectno is null
        and o.creditcontno is null
    )
    or (
        n.objecttype is null
        and n.objectno is null
        and n.creditcontno is null
    )
    or (
        o.relacceptbankid <> n.relacceptbankid
        or o.updateuserid <> n.updateuserid
        or o.acceptbankid <> n.acceptbankid
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.inputorgid <> n.inputorgid
        or o.businesstype <> n.businesstype
        or o.inputuserid <> n.inputuserid
        or o.updatedate <> n.updatedate
        or o.batchno <> n.batchno
        or o.relacceptbankcustid <> n.relacceptbankcustid
        or o.inputdate <> n.inputdate
        or o.relbusinesstype <> n.relbusinesstype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ty_otherlimit_info_cl(
            objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
            ,objectno -- 对象编号
            ,creditcontno -- (他用额度的)额度合同号
            ,relacceptbankid -- 银票贴现承兑行总行行号
            ,updateuserid -- 更新员工编号
            ,acceptbankid -- 银票贴现承兑行行号
            ,updateorgid -- 更新机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 新增机构编号
            ,businesstype -- 业务合同的产品类型或押品类型
            ,inputuserid -- 新增员工编号
            ,updatedate -- 更新时间
            ,batchno -- 银票贴现批次号
            ,relacceptbankcustid -- 银票贴现承兑行总行行客户号
            ,inputdate -- 新增时间
            ,relbusinesstype -- 他用额度类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ty_otherlimit_info_op(
            objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
            ,objectno -- 对象编号
            ,creditcontno -- (他用额度的)额度合同号
            ,relacceptbankid -- 银票贴现承兑行总行行号
            ,updateuserid -- 更新员工编号
            ,acceptbankid -- 银票贴现承兑行行号
            ,updateorgid -- 更新机构编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputorgid -- 新增机构编号
            ,businesstype -- 业务合同的产品类型或押品类型
            ,inputuserid -- 新增员工编号
            ,updatedate -- 更新时间
            ,batchno -- 银票贴现批次号
            ,relacceptbankcustid -- 银票贴现承兑行总行行客户号
            ,inputdate -- 新增时间
            ,relbusinesstype -- 他用额度类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objecttype -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
    ,o.objectno -- 对象编号
    ,o.creditcontno -- (他用额度的)额度合同号
    ,o.relacceptbankid -- 银票贴现承兑行总行行号
    ,o.updateuserid -- 更新员工编号
    ,o.acceptbankid -- 银票贴现承兑行行号
    ,o.updateorgid -- 更新机构编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputorgid -- 新增机构编号
    ,o.businesstype -- 业务合同的产品类型或押品类型
    ,o.inputuserid -- 新增员工编号
    ,o.updatedate -- 更新时间
    ,o.batchno -- 银票贴现批次号
    ,o.relacceptbankcustid -- 银票贴现承兑行总行行客户号
    ,o.inputdate -- 新增时间
    ,o.relbusinesstype -- 他用额度类型
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
from ${iol_schema}.icms_ty_otherlimit_info_bk o
    left join ${iol_schema}.icms_ty_otherlimit_info_op n
        on
            o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.creditcontno = n.creditcontno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ty_otherlimit_info_cl d
        on
            o.objecttype = d.objecttype
            and o.objectno = d.objectno
            and o.creditcontno = d.creditcontno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ty_otherlimit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ty_otherlimit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ty_otherlimit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ty_otherlimit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ty_otherlimit_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ty_otherlimit_info_cl;
alter table ${iol_schema}.icms_ty_otherlimit_info exchange partition p_20991231 with table ${iol_schema}.icms_ty_otherlimit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ty_otherlimit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ty_otherlimit_info_op purge;
drop table ${iol_schema}.icms_ty_otherlimit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ty_otherlimit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ty_otherlimit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
