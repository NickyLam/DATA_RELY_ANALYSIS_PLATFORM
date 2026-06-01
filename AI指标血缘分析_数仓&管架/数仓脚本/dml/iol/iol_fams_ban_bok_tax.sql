/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_bok_tax
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
create table ${iol_schema}.fams_ban_bok_tax_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_bok_tax
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bok_tax_op purge;
drop table ${iol_schema}.fams_ban_bok_tax_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bok_tax_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bok_tax where 0=1;

create table ${iol_schema}.fams_ban_bok_tax_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bok_tax where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_bok_tax_cl(
            cdate -- 数据日期
            ,org_no -- 机构编号
            ,org_name -- 机构名称
            ,ccy -- 币种
            ,subject_no -- 科目编号
            ,subject_name -- 科目名称
            ,prod_code -- 产品
            ,business -- 业务场景
            ,tax_type -- 计税方法
            ,tax_rate -- 税率
            ,tax_nature -- 税目
            ,tax_code -- 免税代码
            ,amount -- 期间收入累计数
            ,amt -- 期间累计税额
            ,bill_no -- 发票号码
            ,busi_id -- 业务流水
            ,source -- 来源系统
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bok_tax_op(
            cdate -- 数据日期
            ,org_no -- 机构编号
            ,org_name -- 机构名称
            ,ccy -- 币种
            ,subject_no -- 科目编号
            ,subject_name -- 科目名称
            ,prod_code -- 产品
            ,business -- 业务场景
            ,tax_type -- 计税方法
            ,tax_rate -- 税率
            ,tax_nature -- 税目
            ,tax_code -- 免税代码
            ,amount -- 期间收入累计数
            ,amt -- 期间累计税额
            ,bill_no -- 发票号码
            ,busi_id -- 业务流水
            ,source -- 来源系统
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cdate, o.cdate) as cdate -- 数据日期
    ,nvl(n.org_no, o.org_no) as org_no -- 机构编号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目编号
    ,nvl(n.subject_name, o.subject_name) as subject_name -- 科目名称
    ,nvl(n.prod_code, o.prod_code) as prod_code -- 产品
    ,nvl(n.business, o.business) as business -- 业务场景
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 计税方法
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.tax_nature, o.tax_nature) as tax_nature -- 税目
    ,nvl(n.tax_code, o.tax_code) as tax_code -- 免税代码
    ,nvl(n.amount, o.amount) as amount -- 期间收入累计数
    ,nvl(n.amt, o.amt) as amt -- 期间累计税额
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 发票号码
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务流水
    ,nvl(n.source, o.source) as source -- 来源系统
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.busi_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.busi_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.busi_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_bok_tax_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_bok_tax where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.busi_id = n.busi_id
where (
        o.busi_id is null
    )
    or (
        n.busi_id is null
    )
    or (
        o.cdate <> n.cdate
        or o.org_no <> n.org_no
        or o.org_name <> n.org_name
        or o.ccy <> n.ccy
        or o.subject_no <> n.subject_no
        or o.subject_name <> n.subject_name
        or o.prod_code <> n.prod_code
        or o.business <> n.business
        or o.tax_type <> n.tax_type
        or o.tax_rate <> n.tax_rate
        or o.tax_nature <> n.tax_nature
        or o.tax_code <> n.tax_code
        or o.amount <> n.amount
        or o.amt <> n.amt
        or o.bill_no <> n.bill_no
        or o.source <> n.source
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_bok_tax_cl(
            cdate -- 数据日期
            ,org_no -- 机构编号
            ,org_name -- 机构名称
            ,ccy -- 币种
            ,subject_no -- 科目编号
            ,subject_name -- 科目名称
            ,prod_code -- 产品
            ,business -- 业务场景
            ,tax_type -- 计税方法
            ,tax_rate -- 税率
            ,tax_nature -- 税目
            ,tax_code -- 免税代码
            ,amount -- 期间收入累计数
            ,amt -- 期间累计税额
            ,bill_no -- 发票号码
            ,busi_id -- 业务流水
            ,source -- 来源系统
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bok_tax_op(
            cdate -- 数据日期
            ,org_no -- 机构编号
            ,org_name -- 机构名称
            ,ccy -- 币种
            ,subject_no -- 科目编号
            ,subject_name -- 科目名称
            ,prod_code -- 产品
            ,business -- 业务场景
            ,tax_type -- 计税方法
            ,tax_rate -- 税率
            ,tax_nature -- 税目
            ,tax_code -- 免税代码
            ,amount -- 期间收入累计数
            ,amt -- 期间累计税额
            ,bill_no -- 发票号码
            ,busi_id -- 业务流水
            ,source -- 来源系统
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cdate -- 数据日期
    ,o.org_no -- 机构编号
    ,o.org_name -- 机构名称
    ,o.ccy -- 币种
    ,o.subject_no -- 科目编号
    ,o.subject_name -- 科目名称
    ,o.prod_code -- 产品
    ,o.business -- 业务场景
    ,o.tax_type -- 计税方法
    ,o.tax_rate -- 税率
    ,o.tax_nature -- 税目
    ,o.tax_code -- 免税代码
    ,o.amount -- 期间收入累计数
    ,o.amt -- 期间累计税额
    ,o.bill_no -- 发票号码
    ,o.busi_id -- 业务流水
    ,o.source -- 来源系统
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_ban_bok_tax_bk o
    left join ${iol_schema}.fams_ban_bok_tax_op n
        on
            o.busi_id = n.busi_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_bok_tax_cl d
        on
            o.busi_id = d.busi_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ban_bok_tax;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ban_bok_tax') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ban_bok_tax drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ban_bok_tax add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ban_bok_tax exchange partition p_${batch_date} with table ${iol_schema}.fams_ban_bok_tax_cl;
alter table ${iol_schema}.fams_ban_bok_tax exchange partition p_20991231 with table ${iol_schema}.fams_ban_bok_tax_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_bok_tax to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bok_tax_op purge;
drop table ${iol_schema}.fams_ban_bok_tax_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_bok_tax_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_bok_tax',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
