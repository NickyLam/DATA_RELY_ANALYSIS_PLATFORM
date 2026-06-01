/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tmss_sys_tenant_bank_acc
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
create table ${iol_schema}.tmss_sys_tenant_bank_acc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tmss_sys_tenant_bank_acc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc_op purge;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_tenant_bank_acc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_tenant_bank_acc where 0=1;

create table ${iol_schema}.tmss_sys_tenant_bank_acc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_tenant_bank_acc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_tenant_bank_acc_cl(
            id -- 主键id
            ,tenant_id -- 客户ID
            ,tenant_code -- 客户号(租户号)
            ,bank_acc_no -- 银行账号
            ,bank_acc_name -- 账户名称
            ,bank_code -- 账户机构代码
            ,bank_name -- 账户机构名称
            ,cur_code -- 币种
            ,acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
            ,acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
            ,acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
            ,status -- 状态 0解挂 1加挂
            ,sign_date -- 加挂时间
            ,un_sign_date -- 解挂时间
            ,create_date -- 创建时间
            ,create_by -- 创建人
            ,update_date -- 更新时间
            ,update_by -- 更新人
            ,corp_code -- 成员企业编码
            ,corp_name -- 成员企业名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_tenant_bank_acc_op(
            id -- 主键id
            ,tenant_id -- 客户ID
            ,tenant_code -- 客户号(租户号)
            ,bank_acc_no -- 银行账号
            ,bank_acc_name -- 账户名称
            ,bank_code -- 账户机构代码
            ,bank_name -- 账户机构名称
            ,cur_code -- 币种
            ,acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
            ,acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
            ,acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
            ,status -- 状态 0解挂 1加挂
            ,sign_date -- 加挂时间
            ,un_sign_date -- 解挂时间
            ,create_date -- 创建时间
            ,create_by -- 创建人
            ,update_date -- 更新时间
            ,update_by -- 更新人
            ,corp_code -- 成员企业编码
            ,corp_name -- 成员企业名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 客户ID
    ,nvl(n.tenant_code, o.tenant_code) as tenant_code -- 客户号(租户号)
    ,nvl(n.bank_acc_no, o.bank_acc_no) as bank_acc_no -- 银行账号
    ,nvl(n.bank_acc_name, o.bank_acc_name) as bank_acc_name -- 账户名称
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 账户机构代码
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 账户机构名称
    ,nvl(n.cur_code, o.cur_code) as cur_code -- 币种
    ,nvl(n.acc_type, o.acc_type) as acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
    ,nvl(n.acc_nature, o.acc_nature) as acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
    ,nvl(n.acc_attribute, o.acc_attribute) as acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
    ,nvl(n.status, o.status) as status -- 状态 0解挂 1加挂
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 加挂时间
    ,nvl(n.un_sign_date, o.un_sign_date) as un_sign_date -- 解挂时间
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.update_by, o.update_by) as update_by -- 更新人
    ,nvl(n.corp_code, o.corp_code) as corp_code -- 成员企业编码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 成员企业名称
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
from (select * from ${iol_schema}.tmss_sys_tenant_bank_acc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tmss_sys_tenant_bank_acc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.tenant_id <> n.tenant_id
        or o.tenant_code <> n.tenant_code
        or o.bank_acc_no <> n.bank_acc_no
        or o.bank_acc_name <> n.bank_acc_name
        or o.bank_code <> n.bank_code
        or o.bank_name <> n.bank_name
        or o.cur_code <> n.cur_code
        or o.acc_type <> n.acc_type
        or o.acc_nature <> n.acc_nature
        or o.acc_attribute <> n.acc_attribute
        or o.status <> n.status
        or o.sign_date <> n.sign_date
        or o.un_sign_date <> n.un_sign_date
        or o.create_date <> n.create_date
        or o.create_by <> n.create_by
        or o.update_date <> n.update_date
        or o.update_by <> n.update_by
        or o.corp_code <> n.corp_code
        or o.corp_name <> n.corp_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_tenant_bank_acc_cl(
            id -- 主键id
            ,tenant_id -- 客户ID
            ,tenant_code -- 客户号(租户号)
            ,bank_acc_no -- 银行账号
            ,bank_acc_name -- 账户名称
            ,bank_code -- 账户机构代码
            ,bank_name -- 账户机构名称
            ,cur_code -- 币种
            ,acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
            ,acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
            ,acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
            ,status -- 状态 0解挂 1加挂
            ,sign_date -- 加挂时间
            ,un_sign_date -- 解挂时间
            ,create_date -- 创建时间
            ,create_by -- 创建人
            ,update_date -- 更新时间
            ,update_by -- 更新人
            ,corp_code -- 成员企业编码
            ,corp_name -- 成员企业名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_tenant_bank_acc_op(
            id -- 主键id
            ,tenant_id -- 客户ID
            ,tenant_code -- 客户号(租户号)
            ,bank_acc_no -- 银行账号
            ,bank_acc_name -- 账户名称
            ,bank_code -- 账户机构代码
            ,bank_name -- 账户机构名称
            ,cur_code -- 币种
            ,acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
            ,acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
            ,acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
            ,status -- 状态 0解挂 1加挂
            ,sign_date -- 加挂时间
            ,un_sign_date -- 解挂时间
            ,create_date -- 创建时间
            ,create_by -- 创建人
            ,update_date -- 更新时间
            ,update_by -- 更新人
            ,corp_code -- 成员企业编码
            ,corp_name -- 成员企业名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.tenant_id -- 客户ID
    ,o.tenant_code -- 客户号(租户号)
    ,o.bank_acc_no -- 银行账号
    ,o.bank_acc_name -- 账户名称
    ,o.bank_code -- 账户机构代码
    ,o.bank_name -- 账户机构名称
    ,o.cur_code -- 币种
    ,o.acc_type -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
    ,o.acc_nature -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
    ,o.acc_attribute -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
    ,o.status -- 状态 0解挂 1加挂
    ,o.sign_date -- 加挂时间
    ,o.un_sign_date -- 解挂时间
    ,o.create_date -- 创建时间
    ,o.create_by -- 创建人
    ,o.update_date -- 更新时间
    ,o.update_by -- 更新人
    ,o.corp_code -- 成员企业编码
    ,o.corp_name -- 成员企业名称
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
from ${iol_schema}.tmss_sys_tenant_bank_acc_bk o
    left join ${iol_schema}.tmss_sys_tenant_bank_acc_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tmss_sys_tenant_bank_acc_cl d
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
--truncate table ${iol_schema}.tmss_sys_tenant_bank_acc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tmss_sys_tenant_bank_acc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tmss_sys_tenant_bank_acc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tmss_sys_tenant_bank_acc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tmss_sys_tenant_bank_acc exchange partition p_${batch_date} with table ${iol_schema}.tmss_sys_tenant_bank_acc_cl;
alter table ${iol_schema}.tmss_sys_tenant_bank_acc exchange partition p_20991231 with table ${iol_schema}.tmss_sys_tenant_bank_acc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tmss_sys_tenant_bank_acc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc_op purge;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tmss_sys_tenant_bank_acc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
