/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_stall
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
create table ${iol_schema}.icms_ind_stall_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_stall
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_stall_op purge;
drop table ${iol_schema}.icms_ind_stall_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_stall_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_stall where 0=1;

create table ${iol_schema}.icms_ind_stall_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_stall where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_stall_cl(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,purchaseprice -- 买入/租赁价格
            ,updateorgid -- 更新机构
            ,certificateno -- 产权证号
            ,stallname -- 摊位/厂房名称
            ,evaluatevalue -- 评估价格
            ,inputuserid -- 登记人
            ,uptodate -- 统计截止时间
            ,inputdate -- 登记日期
            ,insurecompany -- 投保公司
            ,stallarea -- 摊位/厂房面积
            ,remark -- 备注
            ,pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
            ,stalladd -- 摊位/厂房地址
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,purchasedate -- 买入/租赁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_stall_op(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,purchaseprice -- 买入/租赁价格
            ,updateorgid -- 更新机构
            ,certificateno -- 产权证号
            ,stallname -- 摊位/厂房名称
            ,evaluatevalue -- 评估价格
            ,inputuserid -- 登记人
            ,uptodate -- 统计截止时间
            ,inputdate -- 登记日期
            ,insurecompany -- 投保公司
            ,stallarea -- 摊位/厂房面积
            ,remark -- 备注
            ,pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
            ,stalladd -- 摊位/厂房地址
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,purchasedate -- 买入/租赁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.purchaseprice, o.purchaseprice) as purchaseprice -- 买入/租赁价格
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.certificateno, o.certificateno) as certificateno -- 产权证号
    ,nvl(n.stallname, o.stallname) as stallname -- 摊位/厂房名称
    ,nvl(n.evaluatevalue, o.evaluatevalue) as evaluatevalue -- 评估价格
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.uptodate, o.uptodate) as uptodate -- 统计截止时间
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.insurecompany, o.insurecompany) as insurecompany -- 投保公司
    ,nvl(n.stallarea, o.stallarea) as stallarea -- 摊位/厂房面积
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.pledgestatus, o.pledgestatus) as pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.stallnature, o.stallnature) as stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
    ,nvl(n.stalladd, o.stalladd) as stalladd -- 摊位/厂房地址
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.purchasedate, o.purchasedate) as purchasedate -- 买入/租赁日期
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
from (select * from ${iol_schema}.icms_ind_stall_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_stall where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.updatedate <> n.updatedate
        or o.purchaseprice <> n.purchaseprice
        or o.updateorgid <> n.updateorgid
        or o.certificateno <> n.certificateno
        or o.stallname <> n.stallname
        or o.evaluatevalue <> n.evaluatevalue
        or o.inputuserid <> n.inputuserid
        or o.uptodate <> n.uptodate
        or o.inputdate <> n.inputdate
        or o.insurecompany <> n.insurecompany
        or o.stallarea <> n.stallarea
        or o.remark <> n.remark
        or o.pledgestatus <> n.pledgestatus
        or o.updateuserid <> n.updateuserid
        or o.corporgid <> n.corporgid
        or o.stallnature <> n.stallnature
        or o.stalladd <> n.stalladd
        or o.inputorgid <> n.inputorgid
        or o.customerid <> n.customerid
        or o.migtflag <> n.migtflag
        or o.purchasedate <> n.purchasedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_stall_cl(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,purchaseprice -- 买入/租赁价格
            ,updateorgid -- 更新机构
            ,certificateno -- 产权证号
            ,stallname -- 摊位/厂房名称
            ,evaluatevalue -- 评估价格
            ,inputuserid -- 登记人
            ,uptodate -- 统计截止时间
            ,inputdate -- 登记日期
            ,insurecompany -- 投保公司
            ,stallarea -- 摊位/厂房面积
            ,remark -- 备注
            ,pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
            ,stalladd -- 摊位/厂房地址
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,purchasedate -- 买入/租赁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_stall_op(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,purchaseprice -- 买入/租赁价格
            ,updateorgid -- 更新机构
            ,certificateno -- 产权证号
            ,stallname -- 摊位/厂房名称
            ,evaluatevalue -- 评估价格
            ,inputuserid -- 登记人
            ,uptodate -- 统计截止时间
            ,inputdate -- 登记日期
            ,insurecompany -- 投保公司
            ,stallarea -- 摊位/厂房面积
            ,remark -- 备注
            ,pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
            ,stalladd -- 摊位/厂房地址
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,purchasedate -- 买入/租赁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.updatedate -- 更新日期
    ,o.purchaseprice -- 买入/租赁价格
    ,o.updateorgid -- 更新机构
    ,o.certificateno -- 产权证号
    ,o.stallname -- 摊位/厂房名称
    ,o.evaluatevalue -- 评估价格
    ,o.inputuserid -- 登记人
    ,o.uptodate -- 统计截止时间
    ,o.inputdate -- 登记日期
    ,o.insurecompany -- 投保公司
    ,o.stallarea -- 摊位/厂房面积
    ,o.remark -- 备注
    ,o.pledgestatus -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
    ,o.updateuserid -- 更新人
    ,o.corporgid -- 法人机构编号
    ,o.stallnature -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
    ,o.stalladd -- 摊位/厂房地址
    ,o.inputorgid -- 登记机构
    ,o.customerid -- 客户编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.purchasedate -- 买入/租赁日期
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
from ${iol_schema}.icms_ind_stall_bk o
    left join ${iol_schema}.icms_ind_stall_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_stall_cl d
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
--truncate table ${iol_schema}.icms_ind_stall;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_stall') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_stall drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_stall add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_stall exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_stall_cl;
alter table ${iol_schema}.icms_ind_stall exchange partition p_20991231 with table ${iol_schema}.icms_ind_stall_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_stall to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_stall_op purge;
drop table ${iol_schema}.icms_ind_stall_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_stall_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_stall',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
