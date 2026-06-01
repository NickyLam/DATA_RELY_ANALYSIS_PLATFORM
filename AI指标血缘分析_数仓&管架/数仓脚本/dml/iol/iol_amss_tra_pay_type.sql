/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_tra_pay_type
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
create table ${iol_schema}.amss_tra_pay_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_tra_pay_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tra_pay_type_op purge;
drop table ${iol_schema}.amss_tra_pay_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tra_pay_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tra_pay_type where 0=1;

create table ${iol_schema}.amss_tra_pay_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tra_pay_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tra_pay_type_cl(
            pay_type_id -- 类型ID.
            ,pay_type_name -- 类型名称.
            ,api_code -- 接口编码.关联支付接口表的API_CODE字段
            ,pay_center_id -- 支付中心ID.
            ,data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
            ,bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
            ,deprecated -- 是否弃用 0/null 否  1是
            ,priority -- 支付优先级.
            ,update_emp -- 更新人.
            ,fld_n1 -- 
            ,fld_n2 -- 
            ,fld_n3 -- 
            ,fld_n4 -- 
            ,fld_n5 -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
            ,product_type -- 产品分类,详见系统类型PRODUCT_TYPE
            ,pay_accept_org -- 所属受理机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tra_pay_type_op(
            pay_type_id -- 类型ID.
            ,pay_type_name -- 类型名称.
            ,api_code -- 接口编码.关联支付接口表的API_CODE字段
            ,pay_center_id -- 支付中心ID.
            ,data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
            ,bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
            ,deprecated -- 是否弃用 0/null 否  1是
            ,priority -- 支付优先级.
            ,update_emp -- 更新人.
            ,fld_n1 -- 
            ,fld_n2 -- 
            ,fld_n3 -- 
            ,fld_n4 -- 
            ,fld_n5 -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
            ,product_type -- 产品分类,详见系统类型PRODUCT_TYPE
            ,pay_accept_org -- 所属受理机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pay_type_id, o.pay_type_id) as pay_type_id -- 类型ID.
    ,nvl(n.pay_type_name, o.pay_type_name) as pay_type_name -- 类型名称.
    ,nvl(n.api_code, o.api_code) as api_code -- 接口编码.关联支付接口表的API_CODE字段
    ,nvl(n.pay_center_id, o.pay_center_id) as pay_center_id -- 支付中心ID.
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.cost_calculation_rules, o.cost_calculation_rules) as cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
    ,nvl(n.bill_calculation_rules, o.bill_calculation_rules) as bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
    ,nvl(n.deprecated, o.deprecated) as deprecated -- 是否弃用 0/null 否  1是
    ,nvl(n.priority, o.priority) as priority -- 支付优先级.
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新人.
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- 
    ,nvl(n.fld_n4, o.fld_n4) as fld_n4 -- 
    ,nvl(n.fld_n5, o.fld_n5) as fld_n5 -- 
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- 
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- 
    ,nvl(n.is_allow_activate, o.is_allow_activate) as is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
    ,nvl(n.product_type, o.product_type) as product_type -- 产品分类,详见系统类型PRODUCT_TYPE
    ,nvl(n.pay_accept_org, o.pay_accept_org) as pay_accept_org -- 所属受理机构号
    ,case when
            n.pay_type_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pay_type_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pay_type_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_tra_pay_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_tra_pay_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pay_type_id = n.pay_type_id
where (
        o.pay_type_id is null
    )
    or (
        n.pay_type_id is null
    )
    or (
        o.pay_type_name <> n.pay_type_name
        or o.api_code <> n.api_code
        or o.pay_center_id <> n.pay_center_id
        or o.data_source <> n.data_source
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.cost_calculation_rules <> n.cost_calculation_rules
        or o.bill_calculation_rules <> n.bill_calculation_rules
        or o.deprecated <> n.deprecated
        or o.priority <> n.priority
        or o.update_emp <> n.update_emp
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_n3 <> n.fld_n3
        or o.fld_n4 <> n.fld_n4
        or o.fld_n5 <> n.fld_n5
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_s4 <> n.fld_s4
        or o.fld_s5 <> n.fld_s5
        or o.is_allow_activate <> n.is_allow_activate
        or o.product_type <> n.product_type
        or o.pay_accept_org <> n.pay_accept_org
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tra_pay_type_cl(
            pay_type_id -- 类型ID.
            ,pay_type_name -- 类型名称.
            ,api_code -- 接口编码.关联支付接口表的API_CODE字段
            ,pay_center_id -- 支付中心ID.
            ,data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
            ,bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
            ,deprecated -- 是否弃用 0/null 否  1是
            ,priority -- 支付优先级.
            ,update_emp -- 更新人.
            ,fld_n1 -- 
            ,fld_n2 -- 
            ,fld_n3 -- 
            ,fld_n4 -- 
            ,fld_n5 -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
            ,product_type -- 产品分类,详见系统类型PRODUCT_TYPE
            ,pay_accept_org -- 所属受理机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tra_pay_type_op(
            pay_type_id -- 类型ID.
            ,pay_type_name -- 类型名称.
            ,api_code -- 接口编码.关联支付接口表的API_CODE字段
            ,pay_center_id -- 支付中心ID.
            ,data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
            ,bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
            ,deprecated -- 是否弃用 0/null 否  1是
            ,priority -- 支付优先级.
            ,update_emp -- 更新人.
            ,fld_n1 -- 
            ,fld_n2 -- 
            ,fld_n3 -- 
            ,fld_n4 -- 
            ,fld_n5 -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
            ,product_type -- 产品分类,详见系统类型PRODUCT_TYPE
            ,pay_accept_org -- 所属受理机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pay_type_id -- 类型ID.
    ,o.pay_type_name -- 类型名称.
    ,o.api_code -- 接口编码.关联支付接口表的API_CODE字段
    ,o.pay_center_id -- 支付中心ID.
    ,o.data_source -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
    ,o.remark -- 备注.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.cost_calculation_rules -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
    ,o.bill_calculation_rules -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
    ,o.deprecated -- 是否弃用 0/null 否  1是
    ,o.priority -- 支付优先级.
    ,o.update_emp -- 更新人.
    ,o.fld_n1 -- 
    ,o.fld_n2 -- 
    ,o.fld_n3 -- 
    ,o.fld_n4 -- 
    ,o.fld_n5 -- 
    ,o.fld_s1 -- 
    ,o.fld_s2 -- 
    ,o.fld_s3 -- 
    ,o.fld_s4 -- 
    ,o.fld_s5 -- 
    ,o.is_allow_activate -- 是否允许激活,0:不允许,1:允许 默认允许
    ,o.product_type -- 产品分类,详见系统类型PRODUCT_TYPE
    ,o.pay_accept_org -- 所属受理机构号
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
from ${iol_schema}.amss_tra_pay_type_bk o
    left join ${iol_schema}.amss_tra_pay_type_op n
        on
            o.pay_type_id = n.pay_type_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_tra_pay_type_cl d
        on
            o.pay_type_id = d.pay_type_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_tra_pay_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_tra_pay_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_tra_pay_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_tra_pay_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_tra_pay_type exchange partition p_${batch_date} with table ${iol_schema}.amss_tra_pay_type_cl;
alter table ${iol_schema}.amss_tra_pay_type exchange partition p_20991231 with table ${iol_schema}.amss_tra_pay_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_tra_pay_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tra_pay_type_op purge;
drop table ${iol_schema}.amss_tra_pay_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_tra_pay_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_tra_pay_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
