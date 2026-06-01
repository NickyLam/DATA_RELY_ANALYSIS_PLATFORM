/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svss_svs_accadm_accinfo
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
create table ${iol_schema}.svss_svs_accadm_accinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svss_svs_accadm_accinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_svs_accadm_accinfo_op purge;
drop table ${iol_schema}.svss_svs_accadm_accinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_svs_accadm_accinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svss_svs_accadm_accinfo where 0=1;

create table ${iol_schema}.svss_svs_accadm_accinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svss_svs_accadm_accinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svss_svs_accadm_accinfo_cl(
            id -- 账户ID
            ,main_acc_id -- 主账户的ID
            ,acc_no -- 账号
            ,acc_name -- 账户名称
            ,open_date -- 开始日期
            ,start_date -- 启用日期
            ,end_date -- 注销日期
            ,create_date -- 建模日期（录入印鉴系统的日期）
            ,point_no -- 开户网点
            ,point_name -- 开户网点名
            ,link_man -- 联系人
            ,address -- 地址
            ,telephone -- 电话
            ,if_combine -- 是否存在印鉴组合1:有0:没有
            ,with_draw_flag -- 通兑标志
            ,extend -- 扩展字段
            ,last_change_date -- 上次变更日期
            ,input_op -- 录入柜员
            ,check_op -- 审核柜员
            ,crud_flag -- 账户状态
            ,acc_type -- 账户类型
            ,acc_category -- 账户种类
            ,memo -- 备注
            ,sleep_flag -- 久悬标志
            ,main_acc_no -- 主账户的账号
            ,currency_type -- 币种
            ,cust_no -- 客户号
            ,with_draw_org_no -- 指定通兑机构
            ,upload_date -- 更新日期
            ,upload_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svss_svs_accadm_accinfo_op(
            id -- 账户ID
            ,main_acc_id -- 主账户的ID
            ,acc_no -- 账号
            ,acc_name -- 账户名称
            ,open_date -- 开始日期
            ,start_date -- 启用日期
            ,end_date -- 注销日期
            ,create_date -- 建模日期（录入印鉴系统的日期）
            ,point_no -- 开户网点
            ,point_name -- 开户网点名
            ,link_man -- 联系人
            ,address -- 地址
            ,telephone -- 电话
            ,if_combine -- 是否存在印鉴组合1:有0:没有
            ,with_draw_flag -- 通兑标志
            ,extend -- 扩展字段
            ,last_change_date -- 上次变更日期
            ,input_op -- 录入柜员
            ,check_op -- 审核柜员
            ,crud_flag -- 账户状态
            ,acc_type -- 账户类型
            ,acc_category -- 账户种类
            ,memo -- 备注
            ,sleep_flag -- 久悬标志
            ,main_acc_no -- 主账户的账号
            ,currency_type -- 币种
            ,cust_no -- 客户号
            ,with_draw_org_no -- 指定通兑机构
            ,upload_date -- 更新日期
            ,upload_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 账户ID
    ,nvl(n.main_acc_id, o.main_acc_id) as main_acc_id -- 主账户的ID
    ,nvl(n.acc_no, o.acc_no) as acc_no -- 账号
    ,nvl(n.acc_name, o.acc_name) as acc_name -- 账户名称
    ,nvl(n.open_date, o.open_date) as open_date -- 开始日期
    ,nvl(n.start_date, o.start_date) as start_date -- 启用日期
    ,nvl(n.end_date, o.end_date) as end_date -- 注销日期
    ,nvl(n.create_date, o.create_date) as create_date -- 建模日期（录入印鉴系统的日期）
    ,nvl(n.point_no, o.point_no) as point_no -- 开户网点
    ,nvl(n.point_name, o.point_name) as point_name -- 开户网点名
    ,nvl(n.link_man, o.link_man) as link_man -- 联系人
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.if_combine, o.if_combine) as if_combine -- 是否存在印鉴组合1:有0:没有
    ,nvl(n.with_draw_flag, o.with_draw_flag) as with_draw_flag -- 通兑标志
    ,nvl(n.extend, o.extend) as extend -- 扩展字段
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 上次变更日期
    ,nvl(n.input_op, o.input_op) as input_op -- 录入柜员
    ,nvl(n.check_op, o.check_op) as check_op -- 审核柜员
    ,nvl(n.crud_flag, o.crud_flag) as crud_flag -- 账户状态
    ,nvl(n.acc_type, o.acc_type) as acc_type -- 账户类型
    ,nvl(n.acc_category, o.acc_category) as acc_category -- 账户种类
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.sleep_flag, o.sleep_flag) as sleep_flag -- 久悬标志
    ,nvl(n.main_acc_no, o.main_acc_no) as main_acc_no -- 主账户的账号
    ,nvl(n.currency_type, o.currency_type) as currency_type -- 币种
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.with_draw_org_no, o.with_draw_org_no) as with_draw_org_no -- 指定通兑机构
    ,nvl(n.upload_date, o.upload_date) as upload_date -- 更新日期
    ,nvl(n.upload_time, o.upload_time) as upload_time -- 更新时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.svss_svs_accadm_accinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.svss_svs_accadm_accinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.main_acc_id <> n.main_acc_id
        or o.acc_no <> n.acc_no
        or o.acc_name <> n.acc_name
        or o.open_date <> n.open_date
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.create_date <> n.create_date
        or o.point_no <> n.point_no
        or o.point_name <> n.point_name
        or o.link_man <> n.link_man
        or o.address <> n.address
        or o.telephone <> n.telephone
        or o.if_combine <> n.if_combine
        or o.with_draw_flag <> n.with_draw_flag
        or o.extend <> n.extend
        or o.last_change_date <> n.last_change_date
        or o.input_op <> n.input_op
        or o.check_op <> n.check_op
        or o.crud_flag <> n.crud_flag
        or o.acc_type <> n.acc_type
        or o.acc_category <> n.acc_category
        or o.memo <> n.memo
        or o.sleep_flag <> n.sleep_flag
        or o.main_acc_no <> n.main_acc_no
        or o.currency_type <> n.currency_type
        or o.cust_no <> n.cust_no
        or o.with_draw_org_no <> n.with_draw_org_no
        or o.upload_date <> n.upload_date
        or o.upload_time <> n.upload_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svss_svs_accadm_accinfo_cl(
            id -- 账户ID
            ,main_acc_id -- 主账户的ID
            ,acc_no -- 账号
            ,acc_name -- 账户名称
            ,open_date -- 开始日期
            ,start_date -- 启用日期
            ,end_date -- 注销日期
            ,create_date -- 建模日期（录入印鉴系统的日期）
            ,point_no -- 开户网点
            ,point_name -- 开户网点名
            ,link_man -- 联系人
            ,address -- 地址
            ,telephone -- 电话
            ,if_combine -- 是否存在印鉴组合1:有0:没有
            ,with_draw_flag -- 通兑标志
            ,extend -- 扩展字段
            ,last_change_date -- 上次变更日期
            ,input_op -- 录入柜员
            ,check_op -- 审核柜员
            ,crud_flag -- 账户状态
            ,acc_type -- 账户类型
            ,acc_category -- 账户种类
            ,memo -- 备注
            ,sleep_flag -- 久悬标志
            ,main_acc_no -- 主账户的账号
            ,currency_type -- 币种
            ,cust_no -- 客户号
            ,with_draw_org_no -- 指定通兑机构
            ,upload_date -- 更新日期
            ,upload_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svss_svs_accadm_accinfo_op(
            id -- 账户ID
            ,main_acc_id -- 主账户的ID
            ,acc_no -- 账号
            ,acc_name -- 账户名称
            ,open_date -- 开始日期
            ,start_date -- 启用日期
            ,end_date -- 注销日期
            ,create_date -- 建模日期（录入印鉴系统的日期）
            ,point_no -- 开户网点
            ,point_name -- 开户网点名
            ,link_man -- 联系人
            ,address -- 地址
            ,telephone -- 电话
            ,if_combine -- 是否存在印鉴组合1:有0:没有
            ,with_draw_flag -- 通兑标志
            ,extend -- 扩展字段
            ,last_change_date -- 上次变更日期
            ,input_op -- 录入柜员
            ,check_op -- 审核柜员
            ,crud_flag -- 账户状态
            ,acc_type -- 账户类型
            ,acc_category -- 账户种类
            ,memo -- 备注
            ,sleep_flag -- 久悬标志
            ,main_acc_no -- 主账户的账号
            ,currency_type -- 币种
            ,cust_no -- 客户号
            ,with_draw_org_no -- 指定通兑机构
            ,upload_date -- 更新日期
            ,upload_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 账户ID
    ,o.main_acc_id -- 主账户的ID
    ,o.acc_no -- 账号
    ,o.acc_name -- 账户名称
    ,o.open_date -- 开始日期
    ,o.start_date -- 启用日期
    ,o.end_date -- 注销日期
    ,o.create_date -- 建模日期（录入印鉴系统的日期）
    ,o.point_no -- 开户网点
    ,o.point_name -- 开户网点名
    ,o.link_man -- 联系人
    ,o.address -- 地址
    ,o.telephone -- 电话
    ,o.if_combine -- 是否存在印鉴组合1:有0:没有
    ,o.with_draw_flag -- 通兑标志
    ,o.extend -- 扩展字段
    ,o.last_change_date -- 上次变更日期
    ,o.input_op -- 录入柜员
    ,o.check_op -- 审核柜员
    ,o.crud_flag -- 账户状态
    ,o.acc_type -- 账户类型
    ,o.acc_category -- 账户种类
    ,o.memo -- 备注
    ,o.sleep_flag -- 久悬标志
    ,o.main_acc_no -- 主账户的账号
    ,o.currency_type -- 币种
    ,o.cust_no -- 客户号
    ,o.with_draw_org_no -- 指定通兑机构
    ,o.upload_date -- 更新日期
    ,o.upload_time -- 更新时间
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
from ${iol_schema}.svss_svs_accadm_accinfo_bk o
    left join ${iol_schema}.svss_svs_accadm_accinfo_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.svss_svs_accadm_accinfo_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svss_svs_accadm_accinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svss_svs_accadm_accinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svss_svs_accadm_accinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svss_svs_accadm_accinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svss_svs_accadm_accinfo exchange partition p_${batch_date} with table ${iol_schema}.svss_svs_accadm_accinfo_cl;
alter table ${iol_schema}.svss_svs_accadm_accinfo exchange partition p_20991231 with table ${iol_schema}.svss_svs_accadm_accinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svss_svs_accadm_accinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svss_svs_accadm_accinfo_op purge;
drop table ${iol_schema}.svss_svs_accadm_accinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svss_svs_accadm_accinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svss_svs_accadm_accinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
