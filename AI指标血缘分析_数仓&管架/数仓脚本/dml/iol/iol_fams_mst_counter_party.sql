/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_counter_party
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
create table ${iol_schema}.fams_mst_counter_party_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_counter_party;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_counter_party_op purge;
drop table ${iol_schema}.fams_mst_counter_party_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_counter_party_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_counter_party where 0=1;

create table ${iol_schema}.fams_mst_counter_party_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_counter_party where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_counter_party_cl(
            counter_id -- 交易对手代码
            ,counter_type -- 交易对手类型，市场机构、资管产品、通道
            ,counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
            ,link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
            ,manager_id -- 管理人，资管产品时录入
            ,head_bank -- 所属总行
            ,contact -- 联系人
            ,contact_way -- 联系方式
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,link_dept_code -- 关联内部机构
            ,p_type_one -- 人行一级分类
            ,p_type_two -- 人行二级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_counter_party_op(
            counter_id -- 交易对手代码
            ,counter_type -- 交易对手类型，市场机构、资管产品、通道
            ,counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
            ,link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
            ,manager_id -- 管理人，资管产品时录入
            ,head_bank -- 所属总行
            ,contact -- 联系人
            ,contact_way -- 联系方式
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,link_dept_code -- 关联内部机构
            ,p_type_one -- 人行一级分类
            ,p_type_two -- 人行二级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.counter_id, o.counter_id) as counter_id -- 交易对手代码
    ,nvl(n.counter_type, o.counter_type) as counter_type -- 交易对手类型，市场机构、资管产品、通道
    ,nvl(n.counter_name, o.counter_name) as counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
    ,nvl(n.link_id, o.link_id) as link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 管理人，资管产品时录入
    ,nvl(n.head_bank, o.head_bank) as head_bank -- 所属总行
    ,nvl(n.contact, o.contact) as contact -- 联系人
    ,nvl(n.contact_way, o.contact_way) as contact_way -- 联系方式
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.link_dept_code, o.link_dept_code) as link_dept_code -- 关联内部机构
    ,nvl(n.p_type_one, o.p_type_one) as p_type_one -- 人行一级分类
    ,nvl(n.p_type_two, o.p_type_two) as p_type_two -- 人行二级分类
    ,case when
            n.counter_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.counter_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.counter_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_counter_party_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_counter_party where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.counter_id = n.counter_id
where (
        o.counter_id is null
    )
    or (
        n.counter_id is null
    )
    or (
        o.counter_type <> n.counter_type
        or o.counter_name <> n.counter_name
        or o.link_id <> n.link_id
        or o.manager_id <> n.manager_id
        or o.head_bank <> n.head_bank
        or o.contact <> n.contact
        or o.contact_way <> n.contact_way
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.link_dept_code <> n.link_dept_code
        or o.p_type_one <> n.p_type_one
        or o.p_type_two <> n.p_type_two
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_counter_party_cl(
            counter_id -- 交易对手代码
            ,counter_type -- 交易对手类型，市场机构、资管产品、通道
            ,counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
            ,link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
            ,manager_id -- 管理人，资管产品时录入
            ,head_bank -- 所属总行
            ,contact -- 联系人
            ,contact_way -- 联系方式
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,link_dept_code -- 关联内部机构
            ,p_type_one -- 人行一级分类
            ,p_type_two -- 人行二级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_counter_party_op(
            counter_id -- 交易对手代码
            ,counter_type -- 交易对手类型，市场机构、资管产品、通道
            ,counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
            ,link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
            ,manager_id -- 管理人，资管产品时录入
            ,head_bank -- 所属总行
            ,contact -- 联系人
            ,contact_way -- 联系方式
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,link_dept_code -- 关联内部机构
            ,p_type_one -- 人行一级分类
            ,p_type_two -- 人行二级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.counter_id -- 交易对手代码
    ,o.counter_type -- 交易对手类型，市场机构、资管产品、通道
    ,o.counter_name -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
    ,o.link_id -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
    ,o.manager_id -- 管理人，资管产品时录入
    ,o.head_bank -- 所属总行
    ,o.contact -- 联系人
    ,o.contact_way -- 联系方式
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.link_dept_code -- 关联内部机构
    ,o.p_type_one -- 人行一级分类
    ,o.p_type_two -- 人行二级分类
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_mst_counter_party_bk o
    left join ${iol_schema}.fams_mst_counter_party_op n
        on
            o.counter_id = n.counter_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_counter_party_cl d
        on
            o.counter_id = d.counter_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_mst_counter_party;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_mst_counter_party exchange partition p_19000101 with table ${iol_schema}.fams_mst_counter_party_cl;
alter table ${iol_schema}.fams_mst_counter_party exchange partition p_20991231 with table ${iol_schema}.fams_mst_counter_party_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_counter_party to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_counter_party_op purge;
drop table ${iol_schema}.fams_mst_counter_party_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_counter_party_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_counter_party',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
