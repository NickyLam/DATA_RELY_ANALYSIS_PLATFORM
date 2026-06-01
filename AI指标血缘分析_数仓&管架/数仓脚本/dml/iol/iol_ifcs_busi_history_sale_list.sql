/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_busi_history_sale_list
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
create table ${iol_schema}.ifcs_busi_history_sale_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_busi_history_sale_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_busi_history_sale_list_op purge;
drop table ${iol_schema}.ifcs_busi_history_sale_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_busi_history_sale_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_busi_history_sale_list where 0=1;

create table ${iol_schema}.ifcs_busi_history_sale_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_busi_history_sale_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_busi_history_sale_list_cl(
            bhsl_id -- 主键id
            ,bhsl_industry_id -- 关联产业信息id
            ,bhsl_transdate -- 数据日期
            ,bhsl_filename -- 文件名
            ,bhsl_company -- 公司
            ,bhsl_userareatype -- 客户区域分类
            ,bhsl_username -- 客户名称
            ,bhsl_certtype -- 客户证件类型
            ,bhsl_certnum -- 客户证件号码
            ,bhsl_department -- 部门名称
            ,bhsl_dist_code -- 区域
            ,bhsl_province -- 省
            ,bhsl_city -- 市
            ,bhsl_area -- 区
            ,bhsl_address -- 详细地址
            ,bhsl_salesman -- 业务员名称
            ,bhsl_is17 -- is17
            ,bhsl_date -- 单据日期
            ,bhsl_stockcode -- 存货编码
            ,bhsl_productname -- 产品名称
            ,bhsl_stocktype -- 存货分类
            ,bhsl_materialtype -- 物料大类
            ,bhsl_brand -- 品牌
            ,bhsl_particlesize -- 粒径
            ,bhsl_specifications -- 规格
            ,bhsl_tonnage -- 吨数
            ,bhsl_packagenumber -- 包数
            ,bhsl_unitprice -- 单价
            ,bhsl_salesvolume -- 销售额
            ,bhsl_delete_flag -- 删除表示0-正常；1-已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_busi_history_sale_list_op(
            bhsl_id -- 主键id
            ,bhsl_industry_id -- 关联产业信息id
            ,bhsl_transdate -- 数据日期
            ,bhsl_filename -- 文件名
            ,bhsl_company -- 公司
            ,bhsl_userareatype -- 客户区域分类
            ,bhsl_username -- 客户名称
            ,bhsl_certtype -- 客户证件类型
            ,bhsl_certnum -- 客户证件号码
            ,bhsl_department -- 部门名称
            ,bhsl_dist_code -- 区域
            ,bhsl_province -- 省
            ,bhsl_city -- 市
            ,bhsl_area -- 区
            ,bhsl_address -- 详细地址
            ,bhsl_salesman -- 业务员名称
            ,bhsl_is17 -- is17
            ,bhsl_date -- 单据日期
            ,bhsl_stockcode -- 存货编码
            ,bhsl_productname -- 产品名称
            ,bhsl_stocktype -- 存货分类
            ,bhsl_materialtype -- 物料大类
            ,bhsl_brand -- 品牌
            ,bhsl_particlesize -- 粒径
            ,bhsl_specifications -- 规格
            ,bhsl_tonnage -- 吨数
            ,bhsl_packagenumber -- 包数
            ,bhsl_unitprice -- 单价
            ,bhsl_salesvolume -- 销售额
            ,bhsl_delete_flag -- 删除表示0-正常；1-已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bhsl_id, o.bhsl_id) as bhsl_id -- 主键id
    ,nvl(n.bhsl_industry_id, o.bhsl_industry_id) as bhsl_industry_id -- 关联产业信息id
    ,nvl(n.bhsl_transdate, o.bhsl_transdate) as bhsl_transdate -- 数据日期
    ,nvl(n.bhsl_filename, o.bhsl_filename) as bhsl_filename -- 文件名
    ,nvl(n.bhsl_company, o.bhsl_company) as bhsl_company -- 公司
    ,nvl(n.bhsl_userareatype, o.bhsl_userareatype) as bhsl_userareatype -- 客户区域分类
    ,nvl(n.bhsl_username, o.bhsl_username) as bhsl_username -- 客户名称
    ,nvl(n.bhsl_certtype, o.bhsl_certtype) as bhsl_certtype -- 客户证件类型
    ,nvl(n.bhsl_certnum, o.bhsl_certnum) as bhsl_certnum -- 客户证件号码
    ,nvl(n.bhsl_department, o.bhsl_department) as bhsl_department -- 部门名称
    ,nvl(n.bhsl_dist_code, o.bhsl_dist_code) as bhsl_dist_code -- 区域
    ,nvl(n.bhsl_province, o.bhsl_province) as bhsl_province -- 省
    ,nvl(n.bhsl_city, o.bhsl_city) as bhsl_city -- 市
    ,nvl(n.bhsl_area, o.bhsl_area) as bhsl_area -- 区
    ,nvl(n.bhsl_address, o.bhsl_address) as bhsl_address -- 详细地址
    ,nvl(n.bhsl_salesman, o.bhsl_salesman) as bhsl_salesman -- 业务员名称
    ,nvl(n.bhsl_is17, o.bhsl_is17) as bhsl_is17 -- is17
    ,nvl(n.bhsl_date, o.bhsl_date) as bhsl_date -- 单据日期
    ,nvl(n.bhsl_stockcode, o.bhsl_stockcode) as bhsl_stockcode -- 存货编码
    ,nvl(n.bhsl_productname, o.bhsl_productname) as bhsl_productname -- 产品名称
    ,nvl(n.bhsl_stocktype, o.bhsl_stocktype) as bhsl_stocktype -- 存货分类
    ,nvl(n.bhsl_materialtype, o.bhsl_materialtype) as bhsl_materialtype -- 物料大类
    ,nvl(n.bhsl_brand, o.bhsl_brand) as bhsl_brand -- 品牌
    ,nvl(n.bhsl_particlesize, o.bhsl_particlesize) as bhsl_particlesize -- 粒径
    ,nvl(n.bhsl_specifications, o.bhsl_specifications) as bhsl_specifications -- 规格
    ,nvl(n.bhsl_tonnage, o.bhsl_tonnage) as bhsl_tonnage -- 吨数
    ,nvl(n.bhsl_packagenumber, o.bhsl_packagenumber) as bhsl_packagenumber -- 包数
    ,nvl(n.bhsl_unitprice, o.bhsl_unitprice) as bhsl_unitprice -- 单价
    ,nvl(n.bhsl_salesvolume, o.bhsl_salesvolume) as bhsl_salesvolume -- 销售额
    ,nvl(n.bhsl_delete_flag, o.bhsl_delete_flag) as bhsl_delete_flag -- 删除表示0-正常；1-已删除
    ,case when
            n.bhsl_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bhsl_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bhsl_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifcs_busi_history_sale_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifcs_busi_history_sale_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bhsl_id = n.bhsl_id
where (
        o.bhsl_id is null
    )
    or (
        n.bhsl_id is null
    )
    or (
        o.bhsl_industry_id <> n.bhsl_industry_id
        or o.bhsl_transdate <> n.bhsl_transdate
        or o.bhsl_filename <> n.bhsl_filename
        or o.bhsl_company <> n.bhsl_company
        or o.bhsl_userareatype <> n.bhsl_userareatype
        or o.bhsl_username <> n.bhsl_username
        or o.bhsl_certtype <> n.bhsl_certtype
        or o.bhsl_certnum <> n.bhsl_certnum
        or o.bhsl_department <> n.bhsl_department
        or o.bhsl_dist_code <> n.bhsl_dist_code
        or o.bhsl_province <> n.bhsl_province
        or o.bhsl_city <> n.bhsl_city
        or o.bhsl_area <> n.bhsl_area
        or o.bhsl_address <> n.bhsl_address
        or o.bhsl_salesman <> n.bhsl_salesman
        or o.bhsl_is17 <> n.bhsl_is17
        or o.bhsl_date <> n.bhsl_date
        or o.bhsl_stockcode <> n.bhsl_stockcode
        or o.bhsl_productname <> n.bhsl_productname
        or o.bhsl_stocktype <> n.bhsl_stocktype
        or o.bhsl_materialtype <> n.bhsl_materialtype
        or o.bhsl_brand <> n.bhsl_brand
        or o.bhsl_particlesize <> n.bhsl_particlesize
        or o.bhsl_specifications <> n.bhsl_specifications
        or o.bhsl_tonnage <> n.bhsl_tonnage
        or o.bhsl_packagenumber <> n.bhsl_packagenumber
        or o.bhsl_unitprice <> n.bhsl_unitprice
        or o.bhsl_salesvolume <> n.bhsl_salesvolume
        or o.bhsl_delete_flag <> n.bhsl_delete_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_busi_history_sale_list_cl(
            bhsl_id -- 主键id
            ,bhsl_industry_id -- 关联产业信息id
            ,bhsl_transdate -- 数据日期
            ,bhsl_filename -- 文件名
            ,bhsl_company -- 公司
            ,bhsl_userareatype -- 客户区域分类
            ,bhsl_username -- 客户名称
            ,bhsl_certtype -- 客户证件类型
            ,bhsl_certnum -- 客户证件号码
            ,bhsl_department -- 部门名称
            ,bhsl_dist_code -- 区域
            ,bhsl_province -- 省
            ,bhsl_city -- 市
            ,bhsl_area -- 区
            ,bhsl_address -- 详细地址
            ,bhsl_salesman -- 业务员名称
            ,bhsl_is17 -- is17
            ,bhsl_date -- 单据日期
            ,bhsl_stockcode -- 存货编码
            ,bhsl_productname -- 产品名称
            ,bhsl_stocktype -- 存货分类
            ,bhsl_materialtype -- 物料大类
            ,bhsl_brand -- 品牌
            ,bhsl_particlesize -- 粒径
            ,bhsl_specifications -- 规格
            ,bhsl_tonnage -- 吨数
            ,bhsl_packagenumber -- 包数
            ,bhsl_unitprice -- 单价
            ,bhsl_salesvolume -- 销售额
            ,bhsl_delete_flag -- 删除表示0-正常；1-已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_busi_history_sale_list_op(
            bhsl_id -- 主键id
            ,bhsl_industry_id -- 关联产业信息id
            ,bhsl_transdate -- 数据日期
            ,bhsl_filename -- 文件名
            ,bhsl_company -- 公司
            ,bhsl_userareatype -- 客户区域分类
            ,bhsl_username -- 客户名称
            ,bhsl_certtype -- 客户证件类型
            ,bhsl_certnum -- 客户证件号码
            ,bhsl_department -- 部门名称
            ,bhsl_dist_code -- 区域
            ,bhsl_province -- 省
            ,bhsl_city -- 市
            ,bhsl_area -- 区
            ,bhsl_address -- 详细地址
            ,bhsl_salesman -- 业务员名称
            ,bhsl_is17 -- is17
            ,bhsl_date -- 单据日期
            ,bhsl_stockcode -- 存货编码
            ,bhsl_productname -- 产品名称
            ,bhsl_stocktype -- 存货分类
            ,bhsl_materialtype -- 物料大类
            ,bhsl_brand -- 品牌
            ,bhsl_particlesize -- 粒径
            ,bhsl_specifications -- 规格
            ,bhsl_tonnage -- 吨数
            ,bhsl_packagenumber -- 包数
            ,bhsl_unitprice -- 单价
            ,bhsl_salesvolume -- 销售额
            ,bhsl_delete_flag -- 删除表示0-正常；1-已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bhsl_id -- 主键id
    ,o.bhsl_industry_id -- 关联产业信息id
    ,o.bhsl_transdate -- 数据日期
    ,o.bhsl_filename -- 文件名
    ,o.bhsl_company -- 公司
    ,o.bhsl_userareatype -- 客户区域分类
    ,o.bhsl_username -- 客户名称
    ,o.bhsl_certtype -- 客户证件类型
    ,o.bhsl_certnum -- 客户证件号码
    ,o.bhsl_department -- 部门名称
    ,o.bhsl_dist_code -- 区域
    ,o.bhsl_province -- 省
    ,o.bhsl_city -- 市
    ,o.bhsl_area -- 区
    ,o.bhsl_address -- 详细地址
    ,o.bhsl_salesman -- 业务员名称
    ,o.bhsl_is17 -- is17
    ,o.bhsl_date -- 单据日期
    ,o.bhsl_stockcode -- 存货编码
    ,o.bhsl_productname -- 产品名称
    ,o.bhsl_stocktype -- 存货分类
    ,o.bhsl_materialtype -- 物料大类
    ,o.bhsl_brand -- 品牌
    ,o.bhsl_particlesize -- 粒径
    ,o.bhsl_specifications -- 规格
    ,o.bhsl_tonnage -- 吨数
    ,o.bhsl_packagenumber -- 包数
    ,o.bhsl_unitprice -- 单价
    ,o.bhsl_salesvolume -- 销售额
    ,o.bhsl_delete_flag -- 删除表示0-正常；1-已删除
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
from ${iol_schema}.ifcs_busi_history_sale_list_bk o
    left join ${iol_schema}.ifcs_busi_history_sale_list_op n
        on
            o.bhsl_id = n.bhsl_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_busi_history_sale_list_cl d
        on
            o.bhsl_id = d.bhsl_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifcs_busi_history_sale_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifcs_busi_history_sale_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifcs_busi_history_sale_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifcs_busi_history_sale_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifcs_busi_history_sale_list exchange partition p_${batch_date} with table ${iol_schema}.ifcs_busi_history_sale_list_cl;
alter table ${iol_schema}.ifcs_busi_history_sale_list exchange partition p_20991231 with table ${iol_schema}.ifcs_busi_history_sale_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_busi_history_sale_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_busi_history_sale_list_op purge;
drop table ${iol_schema}.ifcs_busi_history_sale_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_busi_history_sale_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_busi_history_sale_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
