/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_org_orgs
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
create table ${iol_schema}.iers_org_orgs_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_org_orgs
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_org_orgs_op purge;
drop table ${iol_schema}.iers_org_orgs_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_org_orgs_op nologging
for exchange with table
${iol_schema}.iers_org_orgs;

create table ${iol_schema}.iers_org_orgs_cl nologging
for exchange with table
${iol_schema}.iers_org_orgs;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_org_orgs_cl(
            address -- 地址
            ,code -- 组织编码
            ,countryzone -- 国家地区
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
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,isbusinessunit -- 是否业务单元数据
            ,islastversion -- 是否最近版本
            ,memo -- 说明
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 组织名称
            ,name2 -- 组织名称2
            ,name3 -- 组织名称3
            ,name4 -- 组织名称4
            ,name5 -- 组织名称5
            ,name6 -- 组织名称6
            ,ncindustry -- 所属NC行业
            ,organizationcode -- 组织机构代码
            ,orgtype1 -- 组织类型1
            ,orgtype10 -- 组织类型10
            ,orgtype11 -- 组织类型11
            ,orgtype12 -- 组织类型12
            ,orgtype13 -- 组织类型13
            ,orgtype14 -- 组织类型14
            ,orgtype15 -- 组织类型15
            ,orgtype16 -- 组织类型16
            ,orgtype17 -- 组织类型17
            ,orgtype18 -- 组织类型18
            ,orgtype19 -- 组织类型19
            ,orgtype2 -- 法人公司
            ,orgtype20 -- 组织类型20
            ,orgtype21 -- 组织类型21
            ,orgtype22 -- 组织类型22
            ,orgtype23 -- 组织类型23
            ,orgtype24 -- 组织类型24
            ,orgtype25 -- 组织类型25
            ,orgtype26 -- 组织类型26
            ,orgtype27 -- 组织类型27
            ,orgtype28 -- 组织类型28
            ,orgtype29 -- 行政组织
            ,orgtype3 -- 组织类型3
            ,orgtype30 -- 组织类型30
            ,orgtype31 -- 组织类型31
            ,orgtype32 -- 组织类型32
            ,orgtype33 -- 组织类型33
            ,orgtype34 -- 组织类型34
            ,orgtype35 -- 组织类型35
            ,orgtype36 -- 组织类型36
            ,orgtype37 -- 组织类型37
            ,orgtype38 -- 组织类型38
            ,orgtype39 -- 组织类型39
            ,orgtype4 -- 人力资源
            ,orgtype40 -- 组织类型40
            ,orgtype41 -- 组织类型41
            ,orgtype42 -- 组织类型42
            ,orgtype43 -- 组织类型43
            ,orgtype44 -- 组织类型44
            ,orgtype45 -- 组织类型45
            ,orgtype46 -- 组织类型46
            ,orgtype47 -- 组织类型47
            ,orgtype48 -- 组织类型48
            ,orgtype49 -- 组织类型49
            ,orgtype5 -- 财务组织
            ,orgtype50 -- 组织类型50
            ,orgtype6 -- 组织类型6
            ,orgtype7 -- 组织类型7
            ,orgtype8 -- 组织类型8
            ,orgtype9 -- 组织类型9
            ,pk_fatherorg -- 上级组织
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_org -- 组织主键
            ,pk_ownorg -- 对应业务单元主键
            ,pk_timezone -- 时区
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,shortname -- 组织简称
            ,shortname2 -- 组织简称2
            ,shortname3 -- 组织简称3
            ,shortname4 -- 组织简称4
            ,shortname5 -- 组织简称5
            ,shortname6 -- 组织简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效日期
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效日期
            ,chargeleader -- 分管领导
            ,entitytype -- 实体属性
            ,isbalanceunit -- 差额单位
            ,isretail -- 适用零售
            ,pk_accperiodscheme -- 会计期间方案
            ,pk_controlarea -- 所属管控范围
            ,pk_corp -- 所属公司
            ,pk_currtype -- 本位币
            ,pk_exratescheme -- 外币汇率方案
            ,reportconfirm -- 报表确认组织
            ,workcalendar -- 工作日历
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_org_orgs_op(
            address -- 地址
            ,code -- 组织编码
            ,countryzone -- 国家地区
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
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,isbusinessunit -- 是否业务单元数据
            ,islastversion -- 是否最近版本
            ,memo -- 说明
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 组织名称
            ,name2 -- 组织名称2
            ,name3 -- 组织名称3
            ,name4 -- 组织名称4
            ,name5 -- 组织名称5
            ,name6 -- 组织名称6
            ,ncindustry -- 所属NC行业
            ,organizationcode -- 组织机构代码
            ,orgtype1 -- 组织类型1
            ,orgtype10 -- 组织类型10
            ,orgtype11 -- 组织类型11
            ,orgtype12 -- 组织类型12
            ,orgtype13 -- 组织类型13
            ,orgtype14 -- 组织类型14
            ,orgtype15 -- 组织类型15
            ,orgtype16 -- 组织类型16
            ,orgtype17 -- 组织类型17
            ,orgtype18 -- 组织类型18
            ,orgtype19 -- 组织类型19
            ,orgtype2 -- 法人公司
            ,orgtype20 -- 组织类型20
            ,orgtype21 -- 组织类型21
            ,orgtype22 -- 组织类型22
            ,orgtype23 -- 组织类型23
            ,orgtype24 -- 组织类型24
            ,orgtype25 -- 组织类型25
            ,orgtype26 -- 组织类型26
            ,orgtype27 -- 组织类型27
            ,orgtype28 -- 组织类型28
            ,orgtype29 -- 行政组织
            ,orgtype3 -- 组织类型3
            ,orgtype30 -- 组织类型30
            ,orgtype31 -- 组织类型31
            ,orgtype32 -- 组织类型32
            ,orgtype33 -- 组织类型33
            ,orgtype34 -- 组织类型34
            ,orgtype35 -- 组织类型35
            ,orgtype36 -- 组织类型36
            ,orgtype37 -- 组织类型37
            ,orgtype38 -- 组织类型38
            ,orgtype39 -- 组织类型39
            ,orgtype4 -- 人力资源
            ,orgtype40 -- 组织类型40
            ,orgtype41 -- 组织类型41
            ,orgtype42 -- 组织类型42
            ,orgtype43 -- 组织类型43
            ,orgtype44 -- 组织类型44
            ,orgtype45 -- 组织类型45
            ,orgtype46 -- 组织类型46
            ,orgtype47 -- 组织类型47
            ,orgtype48 -- 组织类型48
            ,orgtype49 -- 组织类型49
            ,orgtype5 -- 财务组织
            ,orgtype50 -- 组织类型50
            ,orgtype6 -- 组织类型6
            ,orgtype7 -- 组织类型7
            ,orgtype8 -- 组织类型8
            ,orgtype9 -- 组织类型9
            ,pk_fatherorg -- 上级组织
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_org -- 组织主键
            ,pk_ownorg -- 对应业务单元主键
            ,pk_timezone -- 时区
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,shortname -- 组织简称
            ,shortname2 -- 组织简称2
            ,shortname3 -- 组织简称3
            ,shortname4 -- 组织简称4
            ,shortname5 -- 组织简称5
            ,shortname6 -- 组织简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效日期
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效日期
            ,chargeleader -- 分管领导
            ,entitytype -- 实体属性
            ,isbalanceunit -- 差额单位
            ,isretail -- 适用零售
            ,pk_accperiodscheme -- 会计期间方案
            ,pk_controlarea -- 所属管控范围
            ,pk_corp -- 所属公司
            ,pk_currtype -- 本位币
            ,pk_exratescheme -- 外币汇率方案
            ,reportconfirm -- 报表确认组织
            ,workcalendar -- 工作日历
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.address, o.address) as address -- 地址
    ,nvl(n.code, o.code) as code -- 组织编码
    ,nvl(n.countryzone, o.countryzone) as countryzone -- 国家地区
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
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.innercode, o.innercode) as innercode -- 内部编码
    ,nvl(n.isbusinessunit, o.isbusinessunit) as isbusinessunit -- 是否业务单元数据
    ,nvl(n.islastversion, o.islastversion) as islastversion -- 是否最近版本
    ,nvl(n.memo, o.memo) as memo -- 说明
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 助记码
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 组织名称
    ,nvl(n.name2, o.name2) as name2 -- 组织名称2
    ,nvl(n.name3, o.name3) as name3 -- 组织名称3
    ,nvl(n.name4, o.name4) as name4 -- 组织名称4
    ,nvl(n.name5, o.name5) as name5 -- 组织名称5
    ,nvl(n.name6, o.name6) as name6 -- 组织名称6
    ,nvl(n.ncindustry, o.ncindustry) as ncindustry -- 所属NC行业
    ,nvl(n.organizationcode, o.organizationcode) as organizationcode -- 组织机构代码
    ,nvl(n.orgtype1, o.orgtype1) as orgtype1 -- 组织类型1
    ,nvl(n.orgtype10, o.orgtype10) as orgtype10 -- 组织类型10
    ,nvl(n.orgtype11, o.orgtype11) as orgtype11 -- 组织类型11
    ,nvl(n.orgtype12, o.orgtype12) as orgtype12 -- 组织类型12
    ,nvl(n.orgtype13, o.orgtype13) as orgtype13 -- 组织类型13
    ,nvl(n.orgtype14, o.orgtype14) as orgtype14 -- 组织类型14
    ,nvl(n.orgtype15, o.orgtype15) as orgtype15 -- 组织类型15
    ,nvl(n.orgtype16, o.orgtype16) as orgtype16 -- 组织类型16
    ,nvl(n.orgtype17, o.orgtype17) as orgtype17 -- 组织类型17
    ,nvl(n.orgtype18, o.orgtype18) as orgtype18 -- 组织类型18
    ,nvl(n.orgtype19, o.orgtype19) as orgtype19 -- 组织类型19
    ,nvl(n.orgtype2, o.orgtype2) as orgtype2 -- 法人公司
    ,nvl(n.orgtype20, o.orgtype20) as orgtype20 -- 组织类型20
    ,nvl(n.orgtype21, o.orgtype21) as orgtype21 -- 组织类型21
    ,nvl(n.orgtype22, o.orgtype22) as orgtype22 -- 组织类型22
    ,nvl(n.orgtype23, o.orgtype23) as orgtype23 -- 组织类型23
    ,nvl(n.orgtype24, o.orgtype24) as orgtype24 -- 组织类型24
    ,nvl(n.orgtype25, o.orgtype25) as orgtype25 -- 组织类型25
    ,nvl(n.orgtype26, o.orgtype26) as orgtype26 -- 组织类型26
    ,nvl(n.orgtype27, o.orgtype27) as orgtype27 -- 组织类型27
    ,nvl(n.orgtype28, o.orgtype28) as orgtype28 -- 组织类型28
    ,nvl(n.orgtype29, o.orgtype29) as orgtype29 -- 行政组织
    ,nvl(n.orgtype3, o.orgtype3) as orgtype3 -- 组织类型3
    ,nvl(n.orgtype30, o.orgtype30) as orgtype30 -- 组织类型30
    ,nvl(n.orgtype31, o.orgtype31) as orgtype31 -- 组织类型31
    ,nvl(n.orgtype32, o.orgtype32) as orgtype32 -- 组织类型32
    ,nvl(n.orgtype33, o.orgtype33) as orgtype33 -- 组织类型33
    ,nvl(n.orgtype34, o.orgtype34) as orgtype34 -- 组织类型34
    ,nvl(n.orgtype35, o.orgtype35) as orgtype35 -- 组织类型35
    ,nvl(n.orgtype36, o.orgtype36) as orgtype36 -- 组织类型36
    ,nvl(n.orgtype37, o.orgtype37) as orgtype37 -- 组织类型37
    ,nvl(n.orgtype38, o.orgtype38) as orgtype38 -- 组织类型38
    ,nvl(n.orgtype39, o.orgtype39) as orgtype39 -- 组织类型39
    ,nvl(n.orgtype4, o.orgtype4) as orgtype4 -- 人力资源
    ,nvl(n.orgtype40, o.orgtype40) as orgtype40 -- 组织类型40
    ,nvl(n.orgtype41, o.orgtype41) as orgtype41 -- 组织类型41
    ,nvl(n.orgtype42, o.orgtype42) as orgtype42 -- 组织类型42
    ,nvl(n.orgtype43, o.orgtype43) as orgtype43 -- 组织类型43
    ,nvl(n.orgtype44, o.orgtype44) as orgtype44 -- 组织类型44
    ,nvl(n.orgtype45, o.orgtype45) as orgtype45 -- 组织类型45
    ,nvl(n.orgtype46, o.orgtype46) as orgtype46 -- 组织类型46
    ,nvl(n.orgtype47, o.orgtype47) as orgtype47 -- 组织类型47
    ,nvl(n.orgtype48, o.orgtype48) as orgtype48 -- 组织类型48
    ,nvl(n.orgtype49, o.orgtype49) as orgtype49 -- 组织类型49
    ,nvl(n.orgtype5, o.orgtype5) as orgtype5 -- 财务组织
    ,nvl(n.orgtype50, o.orgtype50) as orgtype50 -- 组织类型50
    ,nvl(n.orgtype6, o.orgtype6) as orgtype6 -- 组织类型6
    ,nvl(n.orgtype7, o.orgtype7) as orgtype7 -- 组织类型7
    ,nvl(n.orgtype8, o.orgtype8) as orgtype8 -- 组织类型8
    ,nvl(n.orgtype9, o.orgtype9) as orgtype9 -- 组织类型9
    ,nvl(n.pk_fatherorg, o.pk_fatherorg) as pk_fatherorg -- 上级组织
    ,nvl(n.pk_format, o.pk_format) as pk_format -- 数据格式
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织主键
    ,nvl(n.pk_ownorg, o.pk_ownorg) as pk_ownorg -- 对应业务单元主键
    ,nvl(n.pk_timezone, o.pk_timezone) as pk_timezone -- 时区
    ,nvl(n.pk_vid, o.pk_vid) as pk_vid -- 版本主键
    ,nvl(n.principal, o.principal) as principal -- 负责人
    ,nvl(n.shortname, o.shortname) as shortname -- 组织简称
    ,nvl(n.shortname2, o.shortname2) as shortname2 -- 组织简称2
    ,nvl(n.shortname3, o.shortname3) as shortname3 -- 组织简称3
    ,nvl(n.shortname4, o.shortname4) as shortname4 -- 组织简称4
    ,nvl(n.shortname5, o.shortname5) as shortname5 -- 组织简称5
    ,nvl(n.shortname6, o.shortname6) as shortname6 -- 组织简称6
    ,nvl(n.tel, o.tel) as tel -- 电话
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.venddate, o.venddate) as venddate -- 版本失效日期
    ,nvl(n.vname, o.vname) as vname -- 版本名称
    ,nvl(n.vname2, o.vname2) as vname2 -- 版本名称2
    ,nvl(n.vname3, o.vname3) as vname3 -- 版本名称3
    ,nvl(n.vname4, o.vname4) as vname4 -- 版本名称4
    ,nvl(n.vname5, o.vname5) as vname5 -- 版本名称5
    ,nvl(n.vname6, o.vname6) as vname6 -- 版本名称6
    ,nvl(n.vno, o.vno) as vno -- 版本号
    ,nvl(n.vstartdate, o.vstartdate) as vstartdate -- 版本生效日期
    ,nvl(n.chargeleader, o.chargeleader) as chargeleader -- 分管领导
    ,nvl(n.entitytype, o.entitytype) as entitytype -- 实体属性
    ,nvl(n.isbalanceunit, o.isbalanceunit) as isbalanceunit -- 差额单位
    ,nvl(n.isretail, o.isretail) as isretail -- 适用零售
    ,nvl(n.pk_accperiodscheme, o.pk_accperiodscheme) as pk_accperiodscheme -- 会计期间方案
    ,nvl(n.pk_controlarea, o.pk_controlarea) as pk_controlarea -- 所属管控范围
    ,nvl(n.pk_corp, o.pk_corp) as pk_corp -- 所属公司
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 本位币
    ,nvl(n.pk_exratescheme, o.pk_exratescheme) as pk_exratescheme -- 外币汇率方案
    ,nvl(n.reportconfirm, o.reportconfirm) as reportconfirm -- 报表确认组织
    ,nvl(n.workcalendar, o.workcalendar) as workcalendar -- 工作日历
    ,case when
            n.pk_org is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_org is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_org is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_org_orgs_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_org_orgs where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_org = n.pk_org
where (
        o.pk_org is null
    )
    or (
        n.pk_org is null
    )
    or (
        o.address <> n.address
        or o.code <> n.code
        or o.countryzone <> n.countryzone
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
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.innercode <> n.innercode
        or o.isbusinessunit <> n.isbusinessunit
        or o.islastversion <> n.islastversion
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
        or o.ncindustry <> n.ncindustry
        or o.organizationcode <> n.organizationcode
        or o.orgtype1 <> n.orgtype1
        or o.orgtype10 <> n.orgtype10
        or o.orgtype11 <> n.orgtype11
        or o.orgtype12 <> n.orgtype12
        or o.orgtype13 <> n.orgtype13
        or o.orgtype14 <> n.orgtype14
        or o.orgtype15 <> n.orgtype15
        or o.orgtype16 <> n.orgtype16
        or o.orgtype17 <> n.orgtype17
        or o.orgtype18 <> n.orgtype18
        or o.orgtype19 <> n.orgtype19
        or o.orgtype2 <> n.orgtype2
        or o.orgtype20 <> n.orgtype20
        or o.orgtype21 <> n.orgtype21
        or o.orgtype22 <> n.orgtype22
        or o.orgtype23 <> n.orgtype23
        or o.orgtype24 <> n.orgtype24
        or o.orgtype25 <> n.orgtype25
        or o.orgtype26 <> n.orgtype26
        or o.orgtype27 <> n.orgtype27
        or o.orgtype28 <> n.orgtype28
        or o.orgtype29 <> n.orgtype29
        or o.orgtype3 <> n.orgtype3
        or o.orgtype30 <> n.orgtype30
        or o.orgtype31 <> n.orgtype31
        or o.orgtype32 <> n.orgtype32
        or o.orgtype33 <> n.orgtype33
        or o.orgtype34 <> n.orgtype34
        or o.orgtype35 <> n.orgtype35
        or o.orgtype36 <> n.orgtype36
        or o.orgtype37 <> n.orgtype37
        or o.orgtype38 <> n.orgtype38
        or o.orgtype39 <> n.orgtype39
        or o.orgtype4 <> n.orgtype4
        or o.orgtype40 <> n.orgtype40
        or o.orgtype41 <> n.orgtype41
        or o.orgtype42 <> n.orgtype42
        or o.orgtype43 <> n.orgtype43
        or o.orgtype44 <> n.orgtype44
        or o.orgtype45 <> n.orgtype45
        or o.orgtype46 <> n.orgtype46
        or o.orgtype47 <> n.orgtype47
        or o.orgtype48 <> n.orgtype48
        or o.orgtype49 <> n.orgtype49
        or o.orgtype5 <> n.orgtype5
        or o.orgtype50 <> n.orgtype50
        or o.orgtype6 <> n.orgtype6
        or o.orgtype7 <> n.orgtype7
        or o.orgtype8 <> n.orgtype8
        or o.orgtype9 <> n.orgtype9
        or o.pk_fatherorg <> n.pk_fatherorg
        or o.pk_format <> n.pk_format
        or o.pk_group <> n.pk_group
        or o.pk_ownorg <> n.pk_ownorg
        or o.pk_timezone <> n.pk_timezone
        or o.pk_vid <> n.pk_vid
        or o.principal <> n.principal
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
        or o.entitytype <> n.entitytype
        or o.isbalanceunit <> n.isbalanceunit
        or o.isretail <> n.isretail
        or o.pk_accperiodscheme <> n.pk_accperiodscheme
        or o.pk_controlarea <> n.pk_controlarea
        or o.pk_corp <> n.pk_corp
        or o.pk_currtype <> n.pk_currtype
        or o.pk_exratescheme <> n.pk_exratescheme
        or o.reportconfirm <> n.reportconfirm
        or o.workcalendar <> n.workcalendar
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_org_orgs_cl(
            address -- 地址
            ,code -- 组织编码
            ,countryzone -- 国家地区
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
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,isbusinessunit -- 是否业务单元数据
            ,islastversion -- 是否最近版本
            ,memo -- 说明
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 组织名称
            ,name2 -- 组织名称2
            ,name3 -- 组织名称3
            ,name4 -- 组织名称4
            ,name5 -- 组织名称5
            ,name6 -- 组织名称6
            ,ncindustry -- 所属NC行业
            ,organizationcode -- 组织机构代码
            ,orgtype1 -- 组织类型1
            ,orgtype10 -- 组织类型10
            ,orgtype11 -- 组织类型11
            ,orgtype12 -- 组织类型12
            ,orgtype13 -- 组织类型13
            ,orgtype14 -- 组织类型14
            ,orgtype15 -- 组织类型15
            ,orgtype16 -- 组织类型16
            ,orgtype17 -- 组织类型17
            ,orgtype18 -- 组织类型18
            ,orgtype19 -- 组织类型19
            ,orgtype2 -- 法人公司
            ,orgtype20 -- 组织类型20
            ,orgtype21 -- 组织类型21
            ,orgtype22 -- 组织类型22
            ,orgtype23 -- 组织类型23
            ,orgtype24 -- 组织类型24
            ,orgtype25 -- 组织类型25
            ,orgtype26 -- 组织类型26
            ,orgtype27 -- 组织类型27
            ,orgtype28 -- 组织类型28
            ,orgtype29 -- 行政组织
            ,orgtype3 -- 组织类型3
            ,orgtype30 -- 组织类型30
            ,orgtype31 -- 组织类型31
            ,orgtype32 -- 组织类型32
            ,orgtype33 -- 组织类型33
            ,orgtype34 -- 组织类型34
            ,orgtype35 -- 组织类型35
            ,orgtype36 -- 组织类型36
            ,orgtype37 -- 组织类型37
            ,orgtype38 -- 组织类型38
            ,orgtype39 -- 组织类型39
            ,orgtype4 -- 人力资源
            ,orgtype40 -- 组织类型40
            ,orgtype41 -- 组织类型41
            ,orgtype42 -- 组织类型42
            ,orgtype43 -- 组织类型43
            ,orgtype44 -- 组织类型44
            ,orgtype45 -- 组织类型45
            ,orgtype46 -- 组织类型46
            ,orgtype47 -- 组织类型47
            ,orgtype48 -- 组织类型48
            ,orgtype49 -- 组织类型49
            ,orgtype5 -- 财务组织
            ,orgtype50 -- 组织类型50
            ,orgtype6 -- 组织类型6
            ,orgtype7 -- 组织类型7
            ,orgtype8 -- 组织类型8
            ,orgtype9 -- 组织类型9
            ,pk_fatherorg -- 上级组织
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_org -- 组织主键
            ,pk_ownorg -- 对应业务单元主键
            ,pk_timezone -- 时区
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,shortname -- 组织简称
            ,shortname2 -- 组织简称2
            ,shortname3 -- 组织简称3
            ,shortname4 -- 组织简称4
            ,shortname5 -- 组织简称5
            ,shortname6 -- 组织简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效日期
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效日期
            ,chargeleader -- 分管领导
            ,entitytype -- 实体属性
            ,isbalanceunit -- 差额单位
            ,isretail -- 适用零售
            ,pk_accperiodscheme -- 会计期间方案
            ,pk_controlarea -- 所属管控范围
            ,pk_corp -- 所属公司
            ,pk_currtype -- 本位币
            ,pk_exratescheme -- 外币汇率方案
            ,reportconfirm -- 报表确认组织
            ,workcalendar -- 工作日历
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_org_orgs_op(
            address -- 地址
            ,code -- 组织编码
            ,countryzone -- 国家地区
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
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,isbusinessunit -- 是否业务单元数据
            ,islastversion -- 是否最近版本
            ,memo -- 说明
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 组织名称
            ,name2 -- 组织名称2
            ,name3 -- 组织名称3
            ,name4 -- 组织名称4
            ,name5 -- 组织名称5
            ,name6 -- 组织名称6
            ,ncindustry -- 所属NC行业
            ,organizationcode -- 组织机构代码
            ,orgtype1 -- 组织类型1
            ,orgtype10 -- 组织类型10
            ,orgtype11 -- 组织类型11
            ,orgtype12 -- 组织类型12
            ,orgtype13 -- 组织类型13
            ,orgtype14 -- 组织类型14
            ,orgtype15 -- 组织类型15
            ,orgtype16 -- 组织类型16
            ,orgtype17 -- 组织类型17
            ,orgtype18 -- 组织类型18
            ,orgtype19 -- 组织类型19
            ,orgtype2 -- 法人公司
            ,orgtype20 -- 组织类型20
            ,orgtype21 -- 组织类型21
            ,orgtype22 -- 组织类型22
            ,orgtype23 -- 组织类型23
            ,orgtype24 -- 组织类型24
            ,orgtype25 -- 组织类型25
            ,orgtype26 -- 组织类型26
            ,orgtype27 -- 组织类型27
            ,orgtype28 -- 组织类型28
            ,orgtype29 -- 行政组织
            ,orgtype3 -- 组织类型3
            ,orgtype30 -- 组织类型30
            ,orgtype31 -- 组织类型31
            ,orgtype32 -- 组织类型32
            ,orgtype33 -- 组织类型33
            ,orgtype34 -- 组织类型34
            ,orgtype35 -- 组织类型35
            ,orgtype36 -- 组织类型36
            ,orgtype37 -- 组织类型37
            ,orgtype38 -- 组织类型38
            ,orgtype39 -- 组织类型39
            ,orgtype4 -- 人力资源
            ,orgtype40 -- 组织类型40
            ,orgtype41 -- 组织类型41
            ,orgtype42 -- 组织类型42
            ,orgtype43 -- 组织类型43
            ,orgtype44 -- 组织类型44
            ,orgtype45 -- 组织类型45
            ,orgtype46 -- 组织类型46
            ,orgtype47 -- 组织类型47
            ,orgtype48 -- 组织类型48
            ,orgtype49 -- 组织类型49
            ,orgtype5 -- 财务组织
            ,orgtype50 -- 组织类型50
            ,orgtype6 -- 组织类型6
            ,orgtype7 -- 组织类型7
            ,orgtype8 -- 组织类型8
            ,orgtype9 -- 组织类型9
            ,pk_fatherorg -- 上级组织
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_org -- 组织主键
            ,pk_ownorg -- 对应业务单元主键
            ,pk_timezone -- 时区
            ,pk_vid -- 版本主键
            ,principal -- 负责人
            ,shortname -- 组织简称
            ,shortname2 -- 组织简称2
            ,shortname3 -- 组织简称3
            ,shortname4 -- 组织简称4
            ,shortname5 -- 组织简称5
            ,shortname6 -- 组织简称6
            ,tel -- 电话
            ,ts -- 时间戳
            ,venddate -- 版本失效日期
            ,vname -- 版本名称
            ,vname2 -- 版本名称2
            ,vname3 -- 版本名称3
            ,vname4 -- 版本名称4
            ,vname5 -- 版本名称5
            ,vname6 -- 版本名称6
            ,vno -- 版本号
            ,vstartdate -- 版本生效日期
            ,chargeleader -- 分管领导
            ,entitytype -- 实体属性
            ,isbalanceunit -- 差额单位
            ,isretail -- 适用零售
            ,pk_accperiodscheme -- 会计期间方案
            ,pk_controlarea -- 所属管控范围
            ,pk_corp -- 所属公司
            ,pk_currtype -- 本位币
            ,pk_exratescheme -- 外币汇率方案
            ,reportconfirm -- 报表确认组织
            ,workcalendar -- 工作日历
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.address -- 地址
    ,o.code -- 组织编码
    ,o.countryzone -- 国家地区
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
    ,o.dr -- 删除标志
    ,o.enablestate -- 启用状态
    ,o.innercode -- 内部编码
    ,o.isbusinessunit -- 是否业务单元数据
    ,o.islastversion -- 是否最近版本
    ,o.memo -- 说明
    ,o.mnecode -- 助记码
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 组织名称
    ,o.name2 -- 组织名称2
    ,o.name3 -- 组织名称3
    ,o.name4 -- 组织名称4
    ,o.name5 -- 组织名称5
    ,o.name6 -- 组织名称6
    ,o.ncindustry -- 所属NC行业
    ,o.organizationcode -- 组织机构代码
    ,o.orgtype1 -- 组织类型1
    ,o.orgtype10 -- 组织类型10
    ,o.orgtype11 -- 组织类型11
    ,o.orgtype12 -- 组织类型12
    ,o.orgtype13 -- 组织类型13
    ,o.orgtype14 -- 组织类型14
    ,o.orgtype15 -- 组织类型15
    ,o.orgtype16 -- 组织类型16
    ,o.orgtype17 -- 组织类型17
    ,o.orgtype18 -- 组织类型18
    ,o.orgtype19 -- 组织类型19
    ,o.orgtype2 -- 法人公司
    ,o.orgtype20 -- 组织类型20
    ,o.orgtype21 -- 组织类型21
    ,o.orgtype22 -- 组织类型22
    ,o.orgtype23 -- 组织类型23
    ,o.orgtype24 -- 组织类型24
    ,o.orgtype25 -- 组织类型25
    ,o.orgtype26 -- 组织类型26
    ,o.orgtype27 -- 组织类型27
    ,o.orgtype28 -- 组织类型28
    ,o.orgtype29 -- 行政组织
    ,o.orgtype3 -- 组织类型3
    ,o.orgtype30 -- 组织类型30
    ,o.orgtype31 -- 组织类型31
    ,o.orgtype32 -- 组织类型32
    ,o.orgtype33 -- 组织类型33
    ,o.orgtype34 -- 组织类型34
    ,o.orgtype35 -- 组织类型35
    ,o.orgtype36 -- 组织类型36
    ,o.orgtype37 -- 组织类型37
    ,o.orgtype38 -- 组织类型38
    ,o.orgtype39 -- 组织类型39
    ,o.orgtype4 -- 人力资源
    ,o.orgtype40 -- 组织类型40
    ,o.orgtype41 -- 组织类型41
    ,o.orgtype42 -- 组织类型42
    ,o.orgtype43 -- 组织类型43
    ,o.orgtype44 -- 组织类型44
    ,o.orgtype45 -- 组织类型45
    ,o.orgtype46 -- 组织类型46
    ,o.orgtype47 -- 组织类型47
    ,o.orgtype48 -- 组织类型48
    ,o.orgtype49 -- 组织类型49
    ,o.orgtype5 -- 财务组织
    ,o.orgtype50 -- 组织类型50
    ,o.orgtype6 -- 组织类型6
    ,o.orgtype7 -- 组织类型7
    ,o.orgtype8 -- 组织类型8
    ,o.orgtype9 -- 组织类型9
    ,o.pk_fatherorg -- 上级组织
    ,o.pk_format -- 数据格式
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 组织主键
    ,o.pk_ownorg -- 对应业务单元主键
    ,o.pk_timezone -- 时区
    ,o.pk_vid -- 版本主键
    ,o.principal -- 负责人
    ,o.shortname -- 组织简称
    ,o.shortname2 -- 组织简称2
    ,o.shortname3 -- 组织简称3
    ,o.shortname4 -- 组织简称4
    ,o.shortname5 -- 组织简称5
    ,o.shortname6 -- 组织简称6
    ,o.tel -- 电话
    ,o.ts -- 时间戳
    ,o.venddate -- 版本失效日期
    ,o.vname -- 版本名称
    ,o.vname2 -- 版本名称2
    ,o.vname3 -- 版本名称3
    ,o.vname4 -- 版本名称4
    ,o.vname5 -- 版本名称5
    ,o.vname6 -- 版本名称6
    ,o.vno -- 版本号
    ,o.vstartdate -- 版本生效日期
    ,o.chargeleader -- 分管领导
    ,o.entitytype -- 实体属性
    ,o.isbalanceunit -- 差额单位
    ,o.isretail -- 适用零售
    ,o.pk_accperiodscheme -- 会计期间方案
    ,o.pk_controlarea -- 所属管控范围
    ,o.pk_corp -- 所属公司
    ,o.pk_currtype -- 本位币
    ,o.pk_exratescheme -- 外币汇率方案
    ,o.reportconfirm -- 报表确认组织
    ,o.workcalendar -- 工作日历
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
from ${iol_schema}.iers_org_orgs_bk o
    left join ${iol_schema}.iers_org_orgs_op n
        on
            o.pk_org = n.pk_org
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_org_orgs_cl d
        on
            o.pk_org = d.pk_org
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_org_orgs;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_org_orgs') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_org_orgs drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_org_orgs add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_org_orgs exchange partition p_${batch_date} with table ${iol_schema}.iers_org_orgs_cl;
alter table ${iol_schema}.iers_org_orgs exchange partition p_20991231 with table ${iol_schema}.iers_org_orgs_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_org_orgs to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_org_orgs_op purge;
drop table ${iol_schema}.iers_org_orgs_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_org_orgs_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_org_orgs',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
