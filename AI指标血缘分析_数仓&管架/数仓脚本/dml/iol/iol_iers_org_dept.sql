/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_org_dept
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
create table ${iol_schema}.iers_org_dept_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_org_dept
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_org_dept_op purge;
drop table ${iol_schema}.iers_org_dept_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_org_dept_op nologging
for exchange with table
${iol_schema}.iers_org_dept;

create table ${iol_schema}.iers_org_dept_cl nologging
for exchange with table
${iol_schema}.iers_org_dept;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_org_dept_cl(
            address -- 地址
            ,code -- 编码
            ,createdate -- 部门成立时间
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deptcanceldate -- 部门撤销日期
            ,depttype -- 部门类型
            ,displayorder -- 显示顺序
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,hrcanceled -- HR撤销标志
            ,innercode -- 内部编码
            ,islastversion -- 是否最近版本
            ,isretail -- 适用零售
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,pk_dept -- 部门主键
            ,pk_fatherorg -- 上级部门
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,resposition -- 负责岗位
            ,shortname -- 简称
            ,shortname2 -- 简称2
            ,shortname3 -- 简称3
            ,shortname4 -- 简称4
            ,shortname5 -- 简称5
            ,shortname6 -- 简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效时间
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效时间
            ,chargeleader -- 分管领导
            ,deptlevel -- 部门级别
            ,orgtype13 -- 报表
            ,orgtype17 -- 预算
            ,deptduty -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_org_dept_op(
            address -- 地址
            ,code -- 编码
            ,createdate -- 部门成立时间
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deptcanceldate -- 部门撤销日期
            ,depttype -- 部门类型
            ,displayorder -- 显示顺序
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,hrcanceled -- HR撤销标志
            ,innercode -- 内部编码
            ,islastversion -- 是否最近版本
            ,isretail -- 适用零售
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,pk_dept -- 部门主键
            ,pk_fatherorg -- 上级部门
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,resposition -- 负责岗位
            ,shortname -- 简称
            ,shortname2 -- 简称2
            ,shortname3 -- 简称3
            ,shortname4 -- 简称4
            ,shortname5 -- 简称5
            ,shortname6 -- 简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效时间
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效时间
            ,chargeleader -- 分管领导
            ,deptlevel -- 部门级别
            ,orgtype13 -- 报表
            ,orgtype17 -- 预算
            ,deptduty -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.address, o.address) as address -- 地址
    ,nvl(n.code, o.code) as code -- 编码
    ,nvl(n.createdate, o.createdate) as createdate -- 部门成立时间
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 分布式
    ,nvl(n.def1, o.def1) as def1 -- 自定义项1
    ,nvl(n.def10, o.def10) as def10 -- 自定义项10
    ,nvl(n.def11, o.def11) as def11 -- 自定义项11
    ,nvl(n.def12, o.def12) as def12 -- 自定义项12
    ,nvl(n.def13, o.def13) as def13 -- 自定义项13
    ,nvl(n.def14, o.def14) as def14 -- 自定义项14
    ,nvl(n.def15, o.def15) as def15 -- 自定义项15
    ,nvl(n.def16, o.def16) as def16 -- 自定义项16
    ,nvl(n.def17, o.def17) as def17 -- 自定义项17
    ,nvl(n.def18, o.def18) as def18 -- 自定义项18
    ,nvl(n.def19, o.def19) as def19 -- 自定义项19
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def20, o.def20) as def20 -- 自定义项20
    ,nvl(n.def3, o.def3) as def3 -- 自定义项3
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.def6, o.def6) as def6 -- 自定义项6
    ,nvl(n.def7, o.def7) as def7 -- 自定义项7
    ,nvl(n.def8, o.def8) as def8 -- 自定义项8
    ,nvl(n.def9, o.def9) as def9 -- 自定义项9
    ,nvl(n.deptcanceldate, o.deptcanceldate) as deptcanceldate -- 部门撤销日期
    ,nvl(n.depttype, o.depttype) as depttype -- 部门类型
    ,nvl(n.displayorder, o.displayorder) as displayorder -- 显示顺序
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.hrcanceled, o.hrcanceled) as hrcanceled -- HR撤销标志
    ,nvl(n.innercode, o.innercode) as innercode -- 内部编码
    ,nvl(n.islastversion, o.islastversion) as islastversion -- 是否最近版本
    ,nvl(n.isretail, o.isretail) as isretail -- 适用零售
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 助记码
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 名称
    ,nvl(n.name2, o.name2) as name2 -- 名称2
    ,nvl(n.name3, o.name3) as name3 -- 名称3
    ,nvl(n.name4, o.name4) as name4 -- 名称4
    ,nvl(n.name5, o.name5) as name5 -- 名称5
    ,nvl(n.name6, o.name6) as name6 -- 名称6
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 部门主键
    ,nvl(n.pk_fatherorg, o.pk_fatherorg) as pk_fatherorg -- 上级部门
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_vid, o.pk_vid) as pk_vid -- 版本主键
    ,nvl(n.principal, o.principal) as principal -- 负责人
    ,nvl(n.resposition, o.resposition) as resposition -- 负责岗位
    ,nvl(n.shortname, o.shortname) as shortname -- 简称
    ,nvl(n.shortname2, o.shortname2) as shortname2 -- 简称2
    ,nvl(n.shortname3, o.shortname3) as shortname3 -- 简称3
    ,nvl(n.shortname4, o.shortname4) as shortname4 -- 简称4
    ,nvl(n.shortname5, o.shortname5) as shortname5 -- 简称5
    ,nvl(n.shortname6, o.shortname6) as shortname6 -- 简称6
    ,nvl(n.tel, o.tel) as tel -- 电话
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.venddate, o.venddate) as venddate -- 版本失效时间
    ,nvl(n.vname, o.vname) as vname -- 版本名称
    ,nvl(n.vname2, o.vname2) as vname2 -- 版本名称2
    ,nvl(n.vname3, o.vname3) as vname3 -- 版本名称3
    ,nvl(n.vname4, o.vname4) as vname4 -- 版本名称4
    ,nvl(n.vname5, o.vname5) as vname5 -- 版本名称5
    ,nvl(n.vname6, o.vname6) as vname6 -- 版本名称6
    ,nvl(n.vno, o.vno) as vno -- 版本号
    ,nvl(n.vstartdate, o.vstartdate) as vstartdate -- 版本生效时间
    ,nvl(n.chargeleader, o.chargeleader) as chargeleader -- 分管领导
    ,nvl(n.deptlevel, o.deptlevel) as deptlevel -- 部门级别
    ,nvl(n.orgtype13, o.orgtype13) as orgtype13 -- 报表
    ,nvl(n.orgtype17, o.orgtype17) as orgtype17 -- 预算
    ,nvl(n.deptduty, o.deptduty) as deptduty -- 
    ,case when
            n.pk_dept is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_dept is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_dept is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_org_dept_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_org_dept where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_dept = n.pk_dept
where (
        o.pk_dept is null
    )
    or (
        n.pk_dept is null
    )
    or (
        o.address <> n.address
        or o.code <> n.code
        or o.createdate <> n.createdate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.deptcanceldate <> n.deptcanceldate
        or o.depttype <> n.depttype
        or o.displayorder <> n.displayorder
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.hrcanceled <> n.hrcanceled
        or o.innercode <> n.innercode
        or o.islastversion <> n.islastversion
        or o.isretail <> n.isretail
        or o.memo <> n.memo
        or o.mnecode <> n.mnecode
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_fatherorg <> n.pk_fatherorg
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_vid <> n.pk_vid
        or o.principal <> n.principal
        or o.resposition <> n.resposition
        or o.shortname <> n.shortname
        or o.shortname2 <> n.shortname2
        or o.shortname3 <> n.shortname3
        or o.shortname4 <> n.shortname4
        or o.shortname5 <> n.shortname5
        or o.shortname6 <> n.shortname6
        or o.tel <> n.tel
        or o.ts <> n.ts
        or o.venddate <> n.venddate
        or o.vname <> n.vname
        or o.vname2 <> n.vname2
        or o.vname3 <> n.vname3
        or o.vname4 <> n.vname4
        or o.vname5 <> n.vname5
        or o.vname6 <> n.vname6
        or o.vno <> n.vno
        or o.vstartdate <> n.vstartdate
        or o.chargeleader <> n.chargeleader
        or o.deptlevel <> n.deptlevel
        or o.orgtype13 <> n.orgtype13
        or o.orgtype17 <> n.orgtype17
        or o.deptduty <> n.deptduty
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_org_dept_cl(
            address -- 地址
            ,code -- 编码
            ,createdate -- 部门成立时间
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deptcanceldate -- 部门撤销日期
            ,depttype -- 部门类型
            ,displayorder -- 显示顺序
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,hrcanceled -- HR撤销标志
            ,innercode -- 内部编码
            ,islastversion -- 是否最近版本
            ,isretail -- 适用零售
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,pk_dept -- 部门主键
            ,pk_fatherorg -- 上级部门
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,resposition -- 负责岗位
            ,shortname -- 简称
            ,shortname2 -- 简称2
            ,shortname3 -- 简称3
            ,shortname4 -- 简称4
            ,shortname5 -- 简称5
            ,shortname6 -- 简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效时间
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效时间
            ,chargeleader -- 分管领导
            ,deptlevel -- 部门级别
            ,orgtype13 -- 报表
            ,orgtype17 -- 预算
            ,deptduty -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_org_dept_op(
            address -- 地址
            ,code -- 编码
            ,createdate -- 部门成立时间
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deptcanceldate -- 部门撤销日期
            ,depttype -- 部门类型
            ,displayorder -- 显示顺序
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,hrcanceled -- HR撤销标志
            ,innercode -- 内部编码
            ,islastversion -- 是否最近版本
            ,isretail -- 适用零售
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 名称
            ,name2 -- 名称2
            ,name3 -- 名称3
            ,name4 -- 名称4
            ,name5 -- 名称5
            ,name6 -- 名称6
            ,pk_dept -- 部门主键
            ,pk_fatherorg -- 上级部门
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,resposition -- 负责岗位
            ,shortname -- 简称
            ,shortname2 -- 简称2
            ,shortname3 -- 简称3
            ,shortname4 -- 简称4
            ,shortname5 -- 简称5
            ,shortname6 -- 简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效时间
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效时间
            ,chargeleader -- 分管领导
            ,deptlevel -- 部门级别
            ,orgtype13 -- 报表
            ,orgtype17 -- 预算
            ,deptduty -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.address -- 地址
    ,o.code -- 编码
    ,o.createdate -- 部门成立时间
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dataoriginflag -- 分布式
    ,o.def1 -- 自定义项1
    ,o.def10 -- 自定义项10
    ,o.def11 -- 自定义项11
    ,o.def12 -- 自定义项12
    ,o.def13 -- 自定义项13
    ,o.def14 -- 自定义项14
    ,o.def15 -- 自定义项15
    ,o.def16 -- 自定义项16
    ,o.def17 -- 自定义项17
    ,o.def18 -- 自定义项18
    ,o.def19 -- 自定义项19
    ,o.def2 -- 自定义项2
    ,o.def20 -- 自定义项20
    ,o.def3 -- 自定义项3
    ,o.def4 -- 自定义项4
    ,o.def5 -- 自定义项5
    ,o.def6 -- 自定义项6
    ,o.def7 -- 自定义项7
    ,o.def8 -- 自定义项8
    ,o.def9 -- 自定义项9
    ,o.deptcanceldate -- 部门撤销日期
    ,o.depttype -- 部门类型
    ,o.displayorder -- 显示顺序
    ,o.dr -- 删除标志
    ,o.enablestate -- 启用状态
    ,o.hrcanceled -- HR撤销标志
    ,o.innercode -- 内部编码
    ,o.islastversion -- 是否最近版本
    ,o.isretail -- 适用零售
    ,o.memo -- 备注
    ,o.mnecode -- 助记码
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 名称
    ,o.name2 -- 名称2
    ,o.name3 -- 名称3
    ,o.name4 -- 名称4
    ,o.name5 -- 名称5
    ,o.name6 -- 名称6
    ,o.pk_dept -- 部门主键
    ,o.pk_fatherorg -- 上级部门
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_vid -- 版本主键
    ,o.principal -- 负责人
    ,o.resposition -- 负责岗位
    ,o.shortname -- 简称
    ,o.shortname2 -- 简称2
    ,o.shortname3 -- 简称3
    ,o.shortname4 -- 简称4
    ,o.shortname5 -- 简称5
    ,o.shortname6 -- 简称6
    ,o.tel -- 电话
    ,o.ts -- 时间戳
    ,o.venddate -- 版本失效时间
    ,o.vname -- 版本名称
    ,o.vname2 -- 版本名称2
    ,o.vname3 -- 版本名称3
    ,o.vname4 -- 版本名称4
    ,o.vname5 -- 版本名称5
    ,o.vname6 -- 版本名称6
    ,o.vno -- 版本号
    ,o.vstartdate -- 版本生效时间
    ,o.chargeleader -- 分管领导
    ,o.deptlevel -- 部门级别
    ,o.orgtype13 -- 报表
    ,o.orgtype17 -- 预算
    ,o.deptduty -- 
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
from ${iol_schema}.iers_org_dept_bk o
    left join ${iol_schema}.iers_org_dept_op n
        on
            o.pk_dept = n.pk_dept
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_org_dept_cl d
        on
            o.pk_dept = d.pk_dept
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_org_dept;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_org_dept') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_org_dept drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_org_dept add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_org_dept exchange partition p_${batch_date} with table ${iol_schema}.iers_org_dept_cl;
alter table ${iol_schema}.iers_org_dept exchange partition p_20991231 with table ${iol_schema}.iers_org_dept_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_org_dept to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_org_dept_op purge;
drop table ${iol_schema}.iers_org_dept_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_org_dept_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_org_dept',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
