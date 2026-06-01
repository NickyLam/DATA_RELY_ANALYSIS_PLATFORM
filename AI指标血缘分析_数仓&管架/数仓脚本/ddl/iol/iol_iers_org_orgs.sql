/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_org_orgs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_org_orgs
whenever sqlerror continue none;
drop table ${iol_schema}.iers_org_orgs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_org_orgs(
    address varchar2(45) -- 地址
    ,code varchar2(60) -- 组织编码
    ,countryzone varchar2(30) -- 国家地区
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dataoriginflag number(38,0) -- 分布式
    ,def1 varchar2(152) -- 自定义项1
    ,def10 varchar2(152) -- 自定义项10
    ,def11 varchar2(152) -- 自定义项11
    ,def12 varchar2(152) -- 自定义项12
    ,def13 varchar2(152) -- 自定义项13
    ,def14 varchar2(152) -- 自定义项14
    ,def15 varchar2(152) -- 自定义项15
    ,def16 varchar2(152) -- 自定义项16
    ,def17 varchar2(152) -- 自定义项17
    ,def18 varchar2(152) -- 自定义项18
    ,def19 varchar2(152) -- 自定义项19
    ,def2 varchar2(152) -- 自定义项2
    ,def20 varchar2(152) -- 自定义项20
    ,def3 varchar2(152) -- 自定义项3
    ,def4 varchar2(152) -- 自定义项4
    ,def5 varchar2(152) -- 自定义项5
    ,def6 varchar2(152) -- 自定义项6
    ,def7 varchar2(152) -- 自定义项7
    ,def8 varchar2(152) -- 自定义项8
    ,def9 varchar2(152) -- 自定义项9
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 启用状态
    ,innercode varchar2(300) -- 内部编码
    ,isbusinessunit varchar2(2) -- 是否业务单元数据
    ,islastversion varchar2(2) -- 是否最近版本
    ,memo varchar2(450) -- 说明
    ,mnecode varchar2(113) -- 助记码
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 组织名称
    ,name2 varchar2(450) -- 组织名称2
    ,name3 varchar2(450) -- 组织名称3
    ,name4 varchar2(450) -- 组织名称4
    ,name5 varchar2(450) -- 组织名称5
    ,name6 varchar2(450) -- 组织名称6
    ,ncindustry varchar2(30) -- 所属nc行业
    ,organizationcode varchar2(75) -- 组织机构代码
    ,orgtype1 varchar2(2) -- 组织类型1
    ,orgtype10 varchar2(2) -- 组织类型10
    ,orgtype11 varchar2(2) -- 组织类型11
    ,orgtype12 varchar2(2) -- 组织类型12
    ,orgtype13 varchar2(2) -- 组织类型13
    ,orgtype14 varchar2(2) -- 组织类型14
    ,orgtype15 varchar2(2) -- 组织类型15
    ,orgtype16 varchar2(2) -- 组织类型16
    ,orgtype17 varchar2(2) -- 组织类型17
    ,orgtype18 varchar2(2) -- 组织类型18
    ,orgtype19 varchar2(2) -- 组织类型19
    ,orgtype2 varchar2(2) -- 法人公司
    ,orgtype20 varchar2(2) -- 组织类型20
    ,orgtype21 varchar2(2) -- 组织类型21
    ,orgtype22 varchar2(2) -- 组织类型22
    ,orgtype23 varchar2(2) -- 组织类型23
    ,orgtype24 varchar2(2) -- 组织类型24
    ,orgtype25 varchar2(2) -- 组织类型25
    ,orgtype26 varchar2(2) -- 组织类型26
    ,orgtype27 varchar2(2) -- 组织类型27
    ,orgtype28 varchar2(2) -- 组织类型28
    ,orgtype29 varchar2(2) -- 行政组织
    ,orgtype3 varchar2(2) -- 组织类型3
    ,orgtype30 varchar2(2) -- 组织类型30
    ,orgtype31 varchar2(2) -- 组织类型31
    ,orgtype32 varchar2(2) -- 组织类型32
    ,orgtype33 varchar2(2) -- 组织类型33
    ,orgtype34 varchar2(2) -- 组织类型34
    ,orgtype35 varchar2(2) -- 组织类型35
    ,orgtype36 varchar2(2) -- 组织类型36
    ,orgtype37 varchar2(2) -- 组织类型37
    ,orgtype38 varchar2(2) -- 组织类型38
    ,orgtype39 varchar2(2) -- 组织类型39
    ,orgtype4 varchar2(2) -- 人力资源
    ,orgtype40 varchar2(2) -- 组织类型40
    ,orgtype41 varchar2(2) -- 组织类型41
    ,orgtype42 varchar2(2) -- 组织类型42
    ,orgtype43 varchar2(2) -- 组织类型43
    ,orgtype44 varchar2(2) -- 组织类型44
    ,orgtype45 varchar2(2) -- 组织类型45
    ,orgtype46 varchar2(2) -- 组织类型46
    ,orgtype47 varchar2(2) -- 组织类型47
    ,orgtype48 varchar2(2) -- 组织类型48
    ,orgtype49 varchar2(2) -- 组织类型49
    ,orgtype5 varchar2(2) -- 财务组织
    ,orgtype50 varchar2(2) -- 组织类型50
    ,orgtype6 varchar2(2) -- 组织类型6
    ,orgtype7 varchar2(2) -- 组织类型7
    ,orgtype8 varchar2(2) -- 组织类型8
    ,orgtype9 varchar2(2) -- 组织类型9
    ,pk_fatherorg varchar2(30) -- 上级组织
    ,pk_format varchar2(30) -- 数据格式
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 组织主键
    ,pk_ownorg varchar2(30) -- 对应业务单元主键
    ,pk_timezone varchar2(30) -- 时区
    ,pk_vid varchar2(30) -- 版本主键
    ,principal varchar2(30) -- 负责人
    ,shortname varchar2(450) -- 组织简称
    ,shortname2 varchar2(450) -- 组织简称2
    ,shortname3 varchar2(450) -- 组织简称3
    ,shortname4 varchar2(450) -- 组织简称4
    ,shortname5 varchar2(450) -- 组织简称5
    ,shortname6 varchar2(450) -- 组织简称6
    ,tel varchar2(150) -- 电话
    ,ts varchar2(29) -- 时间戳
    ,venddate varchar2(29) -- 版本失效日期
    ,vname varchar2(450) -- 版本名称
    ,vname2 varchar2(450) -- 版本名称2
    ,vname3 varchar2(450) -- 版本名称3
    ,vname4 varchar2(450) -- 版本名称4
    ,vname5 varchar2(450) -- 版本名称5
    ,vname6 varchar2(450) -- 版本名称6
    ,vno varchar2(75) -- 版本号
    ,vstartdate varchar2(29) -- 版本生效日期
    ,chargeleader varchar2(30) -- 分管领导
    ,entitytype varchar2(30) -- 实体属性
    ,isbalanceunit varchar2(2) -- 差额单位
    ,isretail varchar2(2) -- 适用零售
    ,pk_accperiodscheme varchar2(30) -- 会计期间方案
    ,pk_controlarea varchar2(30) -- 所属管控范围
    ,pk_corp varchar2(30) -- 所属公司
    ,pk_currtype varchar2(30) -- 本位币
    ,pk_exratescheme varchar2(30) -- 外币汇率方案
    ,reportconfirm varchar2(2) -- 报表确认组织
    ,workcalendar varchar2(30) -- 工作日历
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iers_org_orgs to ${iml_schema};
grant select on ${iol_schema}.iers_org_orgs to ${icl_schema};
grant select on ${iol_schema}.iers_org_orgs to ${idl_schema};
grant select on ${iol_schema}.iers_org_orgs to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_org_orgs is '组织信息表';
comment on column ${iol_schema}.iers_org_orgs.address is '地址';
comment on column ${iol_schema}.iers_org_orgs.code is '组织编码';
comment on column ${iol_schema}.iers_org_orgs.countryzone is '国家地区';
comment on column ${iol_schema}.iers_org_orgs.creationtime is '创建时间';
comment on column ${iol_schema}.iers_org_orgs.creator is '创建人';
comment on column ${iol_schema}.iers_org_orgs.dataoriginflag is '分布式';
comment on column ${iol_schema}.iers_org_orgs.def1 is '自定义项1';
comment on column ${iol_schema}.iers_org_orgs.def10 is '自定义项10';
comment on column ${iol_schema}.iers_org_orgs.def11 is '自定义项11';
comment on column ${iol_schema}.iers_org_orgs.def12 is '自定义项12';
comment on column ${iol_schema}.iers_org_orgs.def13 is '自定义项13';
comment on column ${iol_schema}.iers_org_orgs.def14 is '自定义项14';
comment on column ${iol_schema}.iers_org_orgs.def15 is '自定义项15';
comment on column ${iol_schema}.iers_org_orgs.def16 is '自定义项16';
comment on column ${iol_schema}.iers_org_orgs.def17 is '自定义项17';
comment on column ${iol_schema}.iers_org_orgs.def18 is '自定义项18';
comment on column ${iol_schema}.iers_org_orgs.def19 is '自定义项19';
comment on column ${iol_schema}.iers_org_orgs.def2 is '自定义项2';
comment on column ${iol_schema}.iers_org_orgs.def20 is '自定义项20';
comment on column ${iol_schema}.iers_org_orgs.def3 is '自定义项3';
comment on column ${iol_schema}.iers_org_orgs.def4 is '自定义项4';
comment on column ${iol_schema}.iers_org_orgs.def5 is '自定义项5';
comment on column ${iol_schema}.iers_org_orgs.def6 is '自定义项6';
comment on column ${iol_schema}.iers_org_orgs.def7 is '自定义项7';
comment on column ${iol_schema}.iers_org_orgs.def8 is '自定义项8';
comment on column ${iol_schema}.iers_org_orgs.def9 is '自定义项9';
comment on column ${iol_schema}.iers_org_orgs.dr is '删除标志';
comment on column ${iol_schema}.iers_org_orgs.enablestate is '启用状态';
comment on column ${iol_schema}.iers_org_orgs.innercode is '内部编码';
comment on column ${iol_schema}.iers_org_orgs.isbusinessunit is '是否业务单元数据';
comment on column ${iol_schema}.iers_org_orgs.islastversion is '是否最近版本';
comment on column ${iol_schema}.iers_org_orgs.memo is '说明';
comment on column ${iol_schema}.iers_org_orgs.mnecode is '助记码';
comment on column ${iol_schema}.iers_org_orgs.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_org_orgs.modifier is '最后修改人';
comment on column ${iol_schema}.iers_org_orgs.name is '组织名称';
comment on column ${iol_schema}.iers_org_orgs.name2 is '组织名称2';
comment on column ${iol_schema}.iers_org_orgs.name3 is '组织名称3';
comment on column ${iol_schema}.iers_org_orgs.name4 is '组织名称4';
comment on column ${iol_schema}.iers_org_orgs.name5 is '组织名称5';
comment on column ${iol_schema}.iers_org_orgs.name6 is '组织名称6';
comment on column ${iol_schema}.iers_org_orgs.ncindustry is '所属nc行业';
comment on column ${iol_schema}.iers_org_orgs.organizationcode is '组织机构代码';
comment on column ${iol_schema}.iers_org_orgs.orgtype1 is '组织类型1';
comment on column ${iol_schema}.iers_org_orgs.orgtype10 is '组织类型10';
comment on column ${iol_schema}.iers_org_orgs.orgtype11 is '组织类型11';
comment on column ${iol_schema}.iers_org_orgs.orgtype12 is '组织类型12';
comment on column ${iol_schema}.iers_org_orgs.orgtype13 is '组织类型13';
comment on column ${iol_schema}.iers_org_orgs.orgtype14 is '组织类型14';
comment on column ${iol_schema}.iers_org_orgs.orgtype15 is '组织类型15';
comment on column ${iol_schema}.iers_org_orgs.orgtype16 is '组织类型16';
comment on column ${iol_schema}.iers_org_orgs.orgtype17 is '组织类型17';
comment on column ${iol_schema}.iers_org_orgs.orgtype18 is '组织类型18';
comment on column ${iol_schema}.iers_org_orgs.orgtype19 is '组织类型19';
comment on column ${iol_schema}.iers_org_orgs.orgtype2 is '法人公司';
comment on column ${iol_schema}.iers_org_orgs.orgtype20 is '组织类型20';
comment on column ${iol_schema}.iers_org_orgs.orgtype21 is '组织类型21';
comment on column ${iol_schema}.iers_org_orgs.orgtype22 is '组织类型22';
comment on column ${iol_schema}.iers_org_orgs.orgtype23 is '组织类型23';
comment on column ${iol_schema}.iers_org_orgs.orgtype24 is '组织类型24';
comment on column ${iol_schema}.iers_org_orgs.orgtype25 is '组织类型25';
comment on column ${iol_schema}.iers_org_orgs.orgtype26 is '组织类型26';
comment on column ${iol_schema}.iers_org_orgs.orgtype27 is '组织类型27';
comment on column ${iol_schema}.iers_org_orgs.orgtype28 is '组织类型28';
comment on column ${iol_schema}.iers_org_orgs.orgtype29 is '行政组织';
comment on column ${iol_schema}.iers_org_orgs.orgtype3 is '组织类型3';
comment on column ${iol_schema}.iers_org_orgs.orgtype30 is '组织类型30';
comment on column ${iol_schema}.iers_org_orgs.orgtype31 is '组织类型31';
comment on column ${iol_schema}.iers_org_orgs.orgtype32 is '组织类型32';
comment on column ${iol_schema}.iers_org_orgs.orgtype33 is '组织类型33';
comment on column ${iol_schema}.iers_org_orgs.orgtype34 is '组织类型34';
comment on column ${iol_schema}.iers_org_orgs.orgtype35 is '组织类型35';
comment on column ${iol_schema}.iers_org_orgs.orgtype36 is '组织类型36';
comment on column ${iol_schema}.iers_org_orgs.orgtype37 is '组织类型37';
comment on column ${iol_schema}.iers_org_orgs.orgtype38 is '组织类型38';
comment on column ${iol_schema}.iers_org_orgs.orgtype39 is '组织类型39';
comment on column ${iol_schema}.iers_org_orgs.orgtype4 is '人力资源';
comment on column ${iol_schema}.iers_org_orgs.orgtype40 is '组织类型40';
comment on column ${iol_schema}.iers_org_orgs.orgtype41 is '组织类型41';
comment on column ${iol_schema}.iers_org_orgs.orgtype42 is '组织类型42';
comment on column ${iol_schema}.iers_org_orgs.orgtype43 is '组织类型43';
comment on column ${iol_schema}.iers_org_orgs.orgtype44 is '组织类型44';
comment on column ${iol_schema}.iers_org_orgs.orgtype45 is '组织类型45';
comment on column ${iol_schema}.iers_org_orgs.orgtype46 is '组织类型46';
comment on column ${iol_schema}.iers_org_orgs.orgtype47 is '组织类型47';
comment on column ${iol_schema}.iers_org_orgs.orgtype48 is '组织类型48';
comment on column ${iol_schema}.iers_org_orgs.orgtype49 is '组织类型49';
comment on column ${iol_schema}.iers_org_orgs.orgtype5 is '财务组织';
comment on column ${iol_schema}.iers_org_orgs.orgtype50 is '组织类型50';
comment on column ${iol_schema}.iers_org_orgs.orgtype6 is '组织类型6';
comment on column ${iol_schema}.iers_org_orgs.orgtype7 is '组织类型7';
comment on column ${iol_schema}.iers_org_orgs.orgtype8 is '组织类型8';
comment on column ${iol_schema}.iers_org_orgs.orgtype9 is '组织类型9';
comment on column ${iol_schema}.iers_org_orgs.pk_fatherorg is '上级组织';
comment on column ${iol_schema}.iers_org_orgs.pk_format is '数据格式';
comment on column ${iol_schema}.iers_org_orgs.pk_group is '所属集团';
comment on column ${iol_schema}.iers_org_orgs.pk_org is '组织主键';
comment on column ${iol_schema}.iers_org_orgs.pk_ownorg is '对应业务单元主键';
comment on column ${iol_schema}.iers_org_orgs.pk_timezone is '时区';
comment on column ${iol_schema}.iers_org_orgs.pk_vid is '版本主键';
comment on column ${iol_schema}.iers_org_orgs.principal is '负责人';
comment on column ${iol_schema}.iers_org_orgs.shortname is '组织简称';
comment on column ${iol_schema}.iers_org_orgs.shortname2 is '组织简称2';
comment on column ${iol_schema}.iers_org_orgs.shortname3 is '组织简称3';
comment on column ${iol_schema}.iers_org_orgs.shortname4 is '组织简称4';
comment on column ${iol_schema}.iers_org_orgs.shortname5 is '组织简称5';
comment on column ${iol_schema}.iers_org_orgs.shortname6 is '组织简称6';
comment on column ${iol_schema}.iers_org_orgs.tel is '电话';
comment on column ${iol_schema}.iers_org_orgs.ts is '时间戳';
comment on column ${iol_schema}.iers_org_orgs.venddate is '版本失效日期';
comment on column ${iol_schema}.iers_org_orgs.vname is '版本名称';
comment on column ${iol_schema}.iers_org_orgs.vname2 is '版本名称2';
comment on column ${iol_schema}.iers_org_orgs.vname3 is '版本名称3';
comment on column ${iol_schema}.iers_org_orgs.vname4 is '版本名称4';
comment on column ${iol_schema}.iers_org_orgs.vname5 is '版本名称5';
comment on column ${iol_schema}.iers_org_orgs.vname6 is '版本名称6';
comment on column ${iol_schema}.iers_org_orgs.vno is '版本号';
comment on column ${iol_schema}.iers_org_orgs.vstartdate is '版本生效日期';
comment on column ${iol_schema}.iers_org_orgs.chargeleader is '分管领导';
comment on column ${iol_schema}.iers_org_orgs.entitytype is '实体属性';
comment on column ${iol_schema}.iers_org_orgs.isbalanceunit is '差额单位';
comment on column ${iol_schema}.iers_org_orgs.isretail is '适用零售';
comment on column ${iol_schema}.iers_org_orgs.pk_accperiodscheme is '会计期间方案';
comment on column ${iol_schema}.iers_org_orgs.pk_controlarea is '所属管控范围';
comment on column ${iol_schema}.iers_org_orgs.pk_corp is '所属公司';
comment on column ${iol_schema}.iers_org_orgs.pk_currtype is '本位币';
comment on column ${iol_schema}.iers_org_orgs.pk_exratescheme is '外币汇率方案';
comment on column ${iol_schema}.iers_org_orgs.reportconfirm is '报表确认组织';
comment on column ${iol_schema}.iers_org_orgs.workcalendar is '工作日历';
comment on column ${iol_schema}.iers_org_orgs.start_dt is '开始时间';
comment on column ${iol_schema}.iers_org_orgs.end_dt is '结束时间';
comment on column ${iol_schema}.iers_org_orgs.id_mark is '增删标志';
comment on column ${iol_schema}.iers_org_orgs.etl_timestamp is 'ETL处理时间戳';
