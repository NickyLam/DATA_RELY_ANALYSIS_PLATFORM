/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_accasoa
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
create table ${iol_schema}.iers_bd_accasoa_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_accasoa
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_accasoa_op purge;
drop table ${iol_schema}.iers_bd_accasoa_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_accasoa_op nologging
for exchange with table
${iol_schema}.iers_bd_accasoa;

create table ${iol_schema}.iers_bd_accasoa_cl nologging
for exchange with table
${iol_schema}.iers_bd_accasoa;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_accasoa_cl(
            allowclose -- 提前关账
            ,balancetype -- 结算方式
            ,balanflag -- 余额方向控制
            ,bankacc -- 银行账号
            ,billdate -- 票据日期
            ,billnumber -- 票据号
            ,billtype -- 票据类型
            ,bothorient -- 账簿余额双向显示
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,ctrlmodules -- 受控模块
            ,currency -- 默认币种
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dispname -- 科目显示名称
            ,dispname2 -- 科目显示名称2
            ,dispname3 -- 科目显示名称3
            ,dispname4 -- 科目显示名称4
            ,dispname5 -- 科目显示名称5
            ,dispname6 -- 科目显示名称6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,endflag -- 末级标志
            ,incurflag -- 发生额方向控制
            ,innerinfo -- 内部交易信息
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 科目名称
            ,name2 -- 科目名称2
            ,name3 -- 科目名称3
            ,name4 -- 科目名称4
            ,name5 -- 科目名称5
            ,name6 -- 科目名称6
            ,pk_accasoa -- 主键
            ,pk_accchart -- 所属科目表
            ,pk_account -- 科目主键
            ,price -- 单价
            ,quantity -- 数量
            ,remcode -- 助记码
            ,sumprint_level -- 汇总打印级次
            ,ts -- 时间戳
            ,unit -- 默认计量单位
            ,usedesc -- 使用说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_accasoa_op(
            allowclose -- 提前关账
            ,balancetype -- 结算方式
            ,balanflag -- 余额方向控制
            ,bankacc -- 银行账号
            ,billdate -- 票据日期
            ,billnumber -- 票据号
            ,billtype -- 票据类型
            ,bothorient -- 账簿余额双向显示
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,ctrlmodules -- 受控模块
            ,currency -- 默认币种
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dispname -- 科目显示名称
            ,dispname2 -- 科目显示名称2
            ,dispname3 -- 科目显示名称3
            ,dispname4 -- 科目显示名称4
            ,dispname5 -- 科目显示名称5
            ,dispname6 -- 科目显示名称6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,endflag -- 末级标志
            ,incurflag -- 发生额方向控制
            ,innerinfo -- 内部交易信息
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 科目名称
            ,name2 -- 科目名称2
            ,name3 -- 科目名称3
            ,name4 -- 科目名称4
            ,name5 -- 科目名称5
            ,name6 -- 科目名称6
            ,pk_accasoa -- 主键
            ,pk_accchart -- 所属科目表
            ,pk_account -- 科目主键
            ,price -- 单价
            ,quantity -- 数量
            ,remcode -- 助记码
            ,sumprint_level -- 汇总打印级次
            ,ts -- 时间戳
            ,unit -- 默认计量单位
            ,usedesc -- 使用说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.allowclose, o.allowclose) as allowclose -- 提前关账
    ,nvl(n.balancetype, o.balancetype) as balancetype -- 结算方式
    ,nvl(n.balanflag, o.balanflag) as balanflag -- 余额方向控制
    ,nvl(n.bankacc, o.bankacc) as bankacc -- 银行账号
    ,nvl(n.billdate, o.billdate) as billdate -- 票据日期
    ,nvl(n.billnumber, o.billnumber) as billnumber -- 票据号
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.bothorient, o.bothorient) as bothorient -- 账簿余额双向显示
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.ctrlmodules, o.ctrlmodules) as ctrlmodules -- 受控模块
    ,nvl(n.currency, o.currency) as currency -- 默认币种
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 数据来源
    ,nvl(n.def1, o.def1) as def1 -- 自定义项1
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def3, o.def3) as def3 -- 自定义项3
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.dispname, o.dispname) as dispname -- 科目显示名称
    ,nvl(n.dispname2, o.dispname2) as dispname2 -- 科目显示名称2
    ,nvl(n.dispname3, o.dispname3) as dispname3 -- 科目显示名称3
    ,nvl(n.dispname4, o.dispname4) as dispname4 -- 科目显示名称4
    ,nvl(n.dispname5, o.dispname5) as dispname5 -- 科目显示名称5
    ,nvl(n.dispname6, o.dispname6) as dispname6 -- 科目显示名称6
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.endflag, o.endflag) as endflag -- 末级标志
    ,nvl(n.incurflag, o.incurflag) as incurflag -- 发生额方向控制
    ,nvl(n.innerinfo, o.innerinfo) as innerinfo -- 内部交易信息
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 科目名称
    ,nvl(n.name2, o.name2) as name2 -- 科目名称2
    ,nvl(n.name3, o.name3) as name3 -- 科目名称3
    ,nvl(n.name4, o.name4) as name4 -- 科目名称4
    ,nvl(n.name5, o.name5) as name5 -- 科目名称5
    ,nvl(n.name6, o.name6) as name6 -- 科目名称6
    ,nvl(n.pk_accasoa, o.pk_accasoa) as pk_accasoa -- 主键
    ,nvl(n.pk_accchart, o.pk_accchart) as pk_accchart -- 所属科目表
    ,nvl(n.pk_account, o.pk_account) as pk_account -- 科目主键
    ,nvl(n.price, o.price) as price -- 单价
    ,nvl(n.quantity, o.quantity) as quantity -- 数量
    ,nvl(n.remcode, o.remcode) as remcode -- 助记码
    ,nvl(n.sumprint_level, o.sumprint_level) as sumprint_level -- 汇总打印级次
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.unit, o.unit) as unit -- 默认计量单位
    ,nvl(n.usedesc, o.usedesc) as usedesc -- 使用说明
    ,case when
            n.pk_accasoa is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_accasoa is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_accasoa is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_accasoa_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_accasoa where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_accasoa = n.pk_accasoa
where (
        o.pk_accasoa is null
    )
    or (
        n.pk_accasoa is null
    )
    or (
        o.allowclose <> n.allowclose
        or o.balancetype <> n.balancetype
        or o.balanflag <> n.balanflag
        or o.bankacc <> n.bankacc
        or o.billdate <> n.billdate
        or o.billnumber <> n.billnumber
        or o.billtype <> n.billtype
        or o.bothorient <> n.bothorient
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.ctrlmodules <> n.ctrlmodules
        or o.currency <> n.currency
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def2 <> n.def2
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.dispname <> n.dispname
        or o.dispname2 <> n.dispname2
        or o.dispname3 <> n.dispname3
        or o.dispname4 <> n.dispname4
        or o.dispname5 <> n.dispname5
        or o.dispname6 <> n.dispname6
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.endflag <> n.endflag
        or o.incurflag <> n.incurflag
        or o.innerinfo <> n.innerinfo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_accchart <> n.pk_accchart
        or o.pk_account <> n.pk_account
        or o.price <> n.price
        or o.quantity <> n.quantity
        or o.remcode <> n.remcode
        or o.sumprint_level <> n.sumprint_level
        or o.ts <> n.ts
        or o.unit <> n.unit
        or o.usedesc <> n.usedesc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_accasoa_cl(
            allowclose -- 提前关账
            ,balancetype -- 结算方式
            ,balanflag -- 余额方向控制
            ,bankacc -- 银行账号
            ,billdate -- 票据日期
            ,billnumber -- 票据号
            ,billtype -- 票据类型
            ,bothorient -- 账簿余额双向显示
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,ctrlmodules -- 受控模块
            ,currency -- 默认币种
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dispname -- 科目显示名称
            ,dispname2 -- 科目显示名称2
            ,dispname3 -- 科目显示名称3
            ,dispname4 -- 科目显示名称4
            ,dispname5 -- 科目显示名称5
            ,dispname6 -- 科目显示名称6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,endflag -- 末级标志
            ,incurflag -- 发生额方向控制
            ,innerinfo -- 内部交易信息
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 科目名称
            ,name2 -- 科目名称2
            ,name3 -- 科目名称3
            ,name4 -- 科目名称4
            ,name5 -- 科目名称5
            ,name6 -- 科目名称6
            ,pk_accasoa -- 主键
            ,pk_accchart -- 所属科目表
            ,pk_account -- 科目主键
            ,price -- 单价
            ,quantity -- 数量
            ,remcode -- 助记码
            ,sumprint_level -- 汇总打印级次
            ,ts -- 时间戳
            ,unit -- 默认计量单位
            ,usedesc -- 使用说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_accasoa_op(
            allowclose -- 提前关账
            ,balancetype -- 结算方式
            ,balanflag -- 余额方向控制
            ,bankacc -- 银行账号
            ,billdate -- 票据日期
            ,billnumber -- 票据号
            ,billtype -- 票据类型
            ,bothorient -- 账簿余额双向显示
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,ctrlmodules -- 受控模块
            ,currency -- 默认币种
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dispname -- 科目显示名称
            ,dispname2 -- 科目显示名称2
            ,dispname3 -- 科目显示名称3
            ,dispname4 -- 科目显示名称4
            ,dispname5 -- 科目显示名称5
            ,dispname6 -- 科目显示名称6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,endflag -- 末级标志
            ,incurflag -- 发生额方向控制
            ,innerinfo -- 内部交易信息
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 科目名称
            ,name2 -- 科目名称2
            ,name3 -- 科目名称3
            ,name4 -- 科目名称4
            ,name5 -- 科目名称5
            ,name6 -- 科目名称6
            ,pk_accasoa -- 主键
            ,pk_accchart -- 所属科目表
            ,pk_account -- 科目主键
            ,price -- 单价
            ,quantity -- 数量
            ,remcode -- 助记码
            ,sumprint_level -- 汇总打印级次
            ,ts -- 时间戳
            ,unit -- 默认计量单位
            ,usedesc -- 使用说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.allowclose -- 提前关账
    ,o.balancetype -- 结算方式
    ,o.balanflag -- 余额方向控制
    ,o.bankacc -- 银行账号
    ,o.billdate -- 票据日期
    ,o.billnumber -- 票据号
    ,o.billtype -- 票据类型
    ,o.bothorient -- 账簿余额双向显示
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.ctrlmodules -- 受控模块
    ,o.currency -- 默认币种
    ,o.dataoriginflag -- 数据来源
    ,o.def1 -- 自定义项1
    ,o.def2 -- 自定义项2
    ,o.def3 -- 自定义项3
    ,o.def4 -- 自定义项4
    ,o.def5 -- 自定义项5
    ,o.dispname -- 科目显示名称
    ,o.dispname2 -- 科目显示名称2
    ,o.dispname3 -- 科目显示名称3
    ,o.dispname4 -- 科目显示名称4
    ,o.dispname5 -- 科目显示名称5
    ,o.dispname6 -- 科目显示名称6
    ,o.dr -- 删除标志
    ,o.enablestate -- 启用状态
    ,o.endflag -- 末级标志
    ,o.incurflag -- 发生额方向控制
    ,o.innerinfo -- 内部交易信息
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 科目名称
    ,o.name2 -- 科目名称2
    ,o.name3 -- 科目名称3
    ,o.name4 -- 科目名称4
    ,o.name5 -- 科目名称5
    ,o.name6 -- 科目名称6
    ,o.pk_accasoa -- 主键
    ,o.pk_accchart -- 所属科目表
    ,o.pk_account -- 科目主键
    ,o.price -- 单价
    ,o.quantity -- 数量
    ,o.remcode -- 助记码
    ,o.sumprint_level -- 汇总打印级次
    ,o.ts -- 时间戳
    ,o.unit -- 默认计量单位
    ,o.usedesc -- 使用说明
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
from ${iol_schema}.iers_bd_accasoa_bk o
    left join ${iol_schema}.iers_bd_accasoa_op n
        on
            o.pk_accasoa = n.pk_accasoa
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_accasoa_cl d
        on
            o.pk_accasoa = d.pk_accasoa
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_accasoa;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_accasoa') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_accasoa drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_accasoa add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_accasoa exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_accasoa_cl;
alter table ${iol_schema}.iers_bd_accasoa exchange partition p_20991231 with table ${iol_schema}.iers_bd_accasoa_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_accasoa to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_accasoa_op purge;
drop table ${iol_schema}.iers_bd_accasoa_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_accasoa_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_accasoa',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
