/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_org_orgs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_org_orgs
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_org_orgs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_org_orgs(
    address varchar2(400) -- 地址
    ,code varchar2(40) -- 机构编号
    ,countryzone varchar2(20) -- 国家地区
    ,creationtime varchar2(19) -- 创建时间
    ,creator varchar2(20) -- 创建人
    ,dataoriginflag number(38,0) -- 分布式
    ,def1 varchar2(101) -- 自定义项1
    ,def10 varchar2(101) -- 自定义项10
    ,def11 varchar2(101) -- 自定义项11
    ,def12 varchar2(101) -- 自定义项12
    ,def13 varchar2(101) -- 自定义项13
    ,def14 varchar2(101) -- 自定义项14
    ,def15 varchar2(101) -- 自定义项15
    ,def16 varchar2(101) -- 自定义项16
    ,def17 varchar2(101) -- 自定义项17
    ,def18 varchar2(101) -- 自定义项18
    ,def19 varchar2(101) -- 自定义项19
    ,def2 varchar2(101) -- 自定义项2
    ,def20 varchar2(101) -- 自定义项20
    ,def3 varchar2(101) -- 自定义项3
    ,def4 varchar2(101) -- 自定义项4
    ,def5 varchar2(101) -- 自定义项5
    ,def6 varchar2(101) -- 自定义项6
    ,def7 varchar2(101) -- 自定义项7
    ,def8 varchar2(101) -- 自定义项8
    ,def9 varchar2(101) -- 自定义项9
    ,dr number(10,0) -- 备用DR
    ,enablestate number(38,0) -- 机构状态
    ,entitytype varchar2(20) -- 备用ENTITYTYPE
    ,innercode varchar2(200) -- 内部编码
    ,isbusinessunit varchar2(1) -- 是否业务单元数据
    ,islastversion varchar2(1) -- 是否最新版本
    ,isretail varchar2(1) -- 备用ISRETAIL
    ,memo varchar2(200) -- 说明
    ,mnecode varchar2(50) -- 助记码
    ,modifiedtime varchar2(19) -- 最后修改时间
    ,modifier varchar2(20) -- 最后修改人
    ,name varchar2(200) -- 机构名称
    ,name2 varchar2(200) -- 备用NAME2
    ,name3 varchar2(200) -- 备用NAME3
    ,name4 varchar2(200) -- 备用NAME4
    ,name5 varchar2(200) -- 备用NAME5
    ,name6 varchar2(200) -- 备用NAME6
    ,ncindustry varchar2(20) -- 所属UAP行业
    ,organizationcode varchar2(50) -- 组织机构码
    ,orgtype1 varchar2(1) -- 组织类型1
    ,orgtype10 varchar2(1) -- 组织类型10
    ,orgtype11 varchar2(1) -- 组织类型11
    ,orgtype12 varchar2(1) -- 组织类型12
    ,orgtype13 varchar2(1) -- 组织类型13
    ,orgtype14 varchar2(1) -- 组织类型14
    ,orgtype15 varchar2(1) -- 组织类型15
    ,orgtype16 varchar2(1) -- 组织类型16
    ,orgtype17 varchar2(1) -- 组织类型17
    ,orgtype18 varchar2(1) -- 组织类型18
    ,orgtype19 varchar2(1) -- 组织类型19
    ,orgtype2 varchar2(1) -- 组织类型2
    ,orgtype20 varchar2(1) -- 组织类型20
    ,orgtype21 varchar2(1) -- 组织类型21
    ,orgtype22 varchar2(1) -- 组织类型22
    ,orgtype23 varchar2(1) -- 组织类型23
    ,orgtype24 varchar2(1) -- 组织类型24
    ,orgtype25 varchar2(1) -- 组织类型25
    ,orgtype26 varchar2(1) -- 组织类型26
    ,orgtype27 varchar2(1) -- 组织类型27
    ,orgtype28 varchar2(1) -- 组织类型28
    ,orgtype29 varchar2(1) -- 组织类型29
    ,orgtype3 varchar2(1) -- 组织类型3
    ,orgtype30 varchar2(1) -- 组织类型30
    ,orgtype31 varchar2(1) -- 组织类型31
    ,orgtype32 varchar2(1) -- 组织类型32
    ,orgtype33 varchar2(1) -- 组织类型33
    ,orgtype34 varchar2(1) -- 组织类型34
    ,orgtype35 varchar2(1) -- 组织类型35
    ,orgtype36 varchar2(1) -- 组织类型36
    ,orgtype37 varchar2(1) -- 组织类型37
    ,orgtype38 varchar2(1) -- 组织类型38
    ,orgtype39 varchar2(1) -- 组织类型39
    ,orgtype4 varchar2(1) -- 组织类型4
    ,orgtype40 varchar2(1) -- 组织类型40
    ,orgtype5 varchar2(1) -- 组织类型5
    ,orgtype6 varchar2(1) -- 组织类型6
    ,orgtype7 varchar2(1) -- 组织类型7
    ,orgtype8 varchar2(1) -- 组织类型8
    ,orgtype9 varchar2(1) -- 组织类型9
    ,pk_accperiodscheme varchar2(20) -- 备用PK_ACCPERIODSCHEME
    ,pk_controlarea varchar2(20) -- 备用PK_CONTROLAREA
    ,pk_corp varchar2(20) -- 备用PK_CORP
    ,pk_currtype varchar2(20) -- 备用PK_CURRTYPE
    ,pk_exratescheme varchar2(20) -- 备用PK_EXRATESCHEME
    ,pk_fatherorg varchar2(20) -- 上级业务单元
    ,pk_format varchar2(20) -- 数据格式
    ,pk_group varchar2(20) -- 所属集团
    ,pk_org varchar2(20) -- 组织主键
    ,pk_timezone varchar2(20) -- 时区
    ,pk_vid varchar2(20) -- 版本主键
    ,principal varchar2(20) -- 负责人
    ,reportconfirm varchar2(1) -- 备用REPORTCONFIRM
    ,shortname varchar2(200) -- 简称
    ,shortname2 varchar2(200) -- 备用SHORTNAME2
    ,shortname3 varchar2(200) -- 备用SHORTNAME3
    ,shortname4 varchar2(200) -- 备用SHORTNAME4
    ,shortname5 varchar2(200) -- 备用SHORTNAME5
    ,shortname6 varchar2(200) -- 备用SHORTNAME6
    ,tel varchar2(30) -- 电话
    ,ts varchar2(19) -- 备用TS
    ,venddate varchar2(19) -- 版本失效日期
    ,vname varchar2(200) -- 版本名称
    ,vname2 varchar2(200) -- 备用VNAME2
    ,vname3 varchar2(200) -- 备用VNAME3
    ,vname4 varchar2(200) -- 备用VNAME4
    ,vname5 varchar2(200) -- 备用VNAME5
    ,vname6 varchar2(200) -- 备用VNAME6
    ,vno varchar2(50) -- 版本号
    ,vstartdate varchar2(19) -- 版本生效日期
    ,workcalendar varchar2(20) -- 备用WORKCALENDAR
    ,orgtype60 varchar2(1) -- 备用ORGTYPE60
    ,virtual varchar2(50) -- 备用VIRTUAL
    ,glbdef1 varchar2(128) -- 备用GLBDEF1
    ,glbdef2 varchar2(20) -- 备用GLBDEF2
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
grant select on ${iol_schema}.nhrs_org_orgs to ${iml_schema};
grant select on ${iol_schema}.nhrs_org_orgs to ${icl_schema};
grant select on ${iol_schema}.nhrs_org_orgs to ${idl_schema};
grant select on ${iol_schema}.nhrs_org_orgs to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_org_orgs is '组织信息';
comment on column ${iol_schema}.nhrs_org_orgs.address is '地址';
comment on column ${iol_schema}.nhrs_org_orgs.code is '机构编号';
comment on column ${iol_schema}.nhrs_org_orgs.countryzone is '国家地区';
comment on column ${iol_schema}.nhrs_org_orgs.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_org_orgs.creator is '创建人';
comment on column ${iol_schema}.nhrs_org_orgs.dataoriginflag is '分布式';
comment on column ${iol_schema}.nhrs_org_orgs.def1 is '自定义项1';
comment on column ${iol_schema}.nhrs_org_orgs.def10 is '自定义项10';
comment on column ${iol_schema}.nhrs_org_orgs.def11 is '自定义项11';
comment on column ${iol_schema}.nhrs_org_orgs.def12 is '自定义项12';
comment on column ${iol_schema}.nhrs_org_orgs.def13 is '自定义项13';
comment on column ${iol_schema}.nhrs_org_orgs.def14 is '自定义项14';
comment on column ${iol_schema}.nhrs_org_orgs.def15 is '自定义项15';
comment on column ${iol_schema}.nhrs_org_orgs.def16 is '自定义项16';
comment on column ${iol_schema}.nhrs_org_orgs.def17 is '自定义项17';
comment on column ${iol_schema}.nhrs_org_orgs.def18 is '自定义项18';
comment on column ${iol_schema}.nhrs_org_orgs.def19 is '自定义项19';
comment on column ${iol_schema}.nhrs_org_orgs.def2 is '自定义项2';
comment on column ${iol_schema}.nhrs_org_orgs.def20 is '自定义项20';
comment on column ${iol_schema}.nhrs_org_orgs.def3 is '自定义项3';
comment on column ${iol_schema}.nhrs_org_orgs.def4 is '自定义项4';
comment on column ${iol_schema}.nhrs_org_orgs.def5 is '自定义项5';
comment on column ${iol_schema}.nhrs_org_orgs.def6 is '自定义项6';
comment on column ${iol_schema}.nhrs_org_orgs.def7 is '自定义项7';
comment on column ${iol_schema}.nhrs_org_orgs.def8 is '自定义项8';
comment on column ${iol_schema}.nhrs_org_orgs.def9 is '自定义项9';
comment on column ${iol_schema}.nhrs_org_orgs.dr is '备用DR';
comment on column ${iol_schema}.nhrs_org_orgs.enablestate is '机构状态';
comment on column ${iol_schema}.nhrs_org_orgs.entitytype is '备用ENTITYTYPE';
comment on column ${iol_schema}.nhrs_org_orgs.innercode is '内部编码';
comment on column ${iol_schema}.nhrs_org_orgs.isbusinessunit is '是否业务单元数据';
comment on column ${iol_schema}.nhrs_org_orgs.islastversion is '是否最新版本';
comment on column ${iol_schema}.nhrs_org_orgs.isretail is '备用ISRETAIL';
comment on column ${iol_schema}.nhrs_org_orgs.memo is '说明';
comment on column ${iol_schema}.nhrs_org_orgs.mnecode is '助记码';
comment on column ${iol_schema}.nhrs_org_orgs.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.nhrs_org_orgs.modifier is '最后修改人';
comment on column ${iol_schema}.nhrs_org_orgs.name is '机构名称';
comment on column ${iol_schema}.nhrs_org_orgs.name2 is '备用NAME2';
comment on column ${iol_schema}.nhrs_org_orgs.name3 is '备用NAME3';
comment on column ${iol_schema}.nhrs_org_orgs.name4 is '备用NAME4';
comment on column ${iol_schema}.nhrs_org_orgs.name5 is '备用NAME5';
comment on column ${iol_schema}.nhrs_org_orgs.name6 is '备用NAME6';
comment on column ${iol_schema}.nhrs_org_orgs.ncindustry is '所属UAP行业';
comment on column ${iol_schema}.nhrs_org_orgs.organizationcode is '组织机构码';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype1 is '组织类型1';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype10 is '组织类型10';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype11 is '组织类型11';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype12 is '组织类型12';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype13 is '组织类型13';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype14 is '组织类型14';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype15 is '组织类型15';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype16 is '组织类型16';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype17 is '组织类型17';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype18 is '组织类型18';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype19 is '组织类型19';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype2 is '组织类型2';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype20 is '组织类型20';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype21 is '组织类型21';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype22 is '组织类型22';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype23 is '组织类型23';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype24 is '组织类型24';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype25 is '组织类型25';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype26 is '组织类型26';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype27 is '组织类型27';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype28 is '组织类型28';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype29 is '组织类型29';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype3 is '组织类型3';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype30 is '组织类型30';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype31 is '组织类型31';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype32 is '组织类型32';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype33 is '组织类型33';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype34 is '组织类型34';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype35 is '组织类型35';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype36 is '组织类型36';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype37 is '组织类型37';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype38 is '组织类型38';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype39 is '组织类型39';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype4 is '组织类型4';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype40 is '组织类型40';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype5 is '组织类型5';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype6 is '组织类型6';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype7 is '组织类型7';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype8 is '组织类型8';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype9 is '组织类型9';
comment on column ${iol_schema}.nhrs_org_orgs.pk_accperiodscheme is '备用PK_ACCPERIODSCHEME';
comment on column ${iol_schema}.nhrs_org_orgs.pk_controlarea is '备用PK_CONTROLAREA';
comment on column ${iol_schema}.nhrs_org_orgs.pk_corp is '备用PK_CORP';
comment on column ${iol_schema}.nhrs_org_orgs.pk_currtype is '备用PK_CURRTYPE';
comment on column ${iol_schema}.nhrs_org_orgs.pk_exratescheme is '备用PK_EXRATESCHEME';
comment on column ${iol_schema}.nhrs_org_orgs.pk_fatherorg is '上级业务单元';
comment on column ${iol_schema}.nhrs_org_orgs.pk_format is '数据格式';
comment on column ${iol_schema}.nhrs_org_orgs.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_org_orgs.pk_org is '组织主键';
comment on column ${iol_schema}.nhrs_org_orgs.pk_timezone is '时区';
comment on column ${iol_schema}.nhrs_org_orgs.pk_vid is '版本主键';
comment on column ${iol_schema}.nhrs_org_orgs.principal is '负责人';
comment on column ${iol_schema}.nhrs_org_orgs.reportconfirm is '备用REPORTCONFIRM';
comment on column ${iol_schema}.nhrs_org_orgs.shortname is '简称';
comment on column ${iol_schema}.nhrs_org_orgs.shortname2 is '备用SHORTNAME2';
comment on column ${iol_schema}.nhrs_org_orgs.shortname3 is '备用SHORTNAME3';
comment on column ${iol_schema}.nhrs_org_orgs.shortname4 is '备用SHORTNAME4';
comment on column ${iol_schema}.nhrs_org_orgs.shortname5 is '备用SHORTNAME5';
comment on column ${iol_schema}.nhrs_org_orgs.shortname6 is '备用SHORTNAME6';
comment on column ${iol_schema}.nhrs_org_orgs.tel is '电话';
comment on column ${iol_schema}.nhrs_org_orgs.ts is '备用TS';
comment on column ${iol_schema}.nhrs_org_orgs.venddate is '版本失效日期';
comment on column ${iol_schema}.nhrs_org_orgs.vname is '版本名称';
comment on column ${iol_schema}.nhrs_org_orgs.vname2 is '备用VNAME2';
comment on column ${iol_schema}.nhrs_org_orgs.vname3 is '备用VNAME3';
comment on column ${iol_schema}.nhrs_org_orgs.vname4 is '备用VNAME4';
comment on column ${iol_schema}.nhrs_org_orgs.vname5 is '备用VNAME5';
comment on column ${iol_schema}.nhrs_org_orgs.vname6 is '备用VNAME6';
comment on column ${iol_schema}.nhrs_org_orgs.vno is '版本号';
comment on column ${iol_schema}.nhrs_org_orgs.vstartdate is '版本生效日期';
comment on column ${iol_schema}.nhrs_org_orgs.workcalendar is '备用WORKCALENDAR';
comment on column ${iol_schema}.nhrs_org_orgs.orgtype60 is '备用ORGTYPE60';
comment on column ${iol_schema}.nhrs_org_orgs.virtual is '备用VIRTUAL';
comment on column ${iol_schema}.nhrs_org_orgs.glbdef1 is '备用GLBDEF1';
comment on column ${iol_schema}.nhrs_org_orgs.glbdef2 is '备用GLBDEF2';
comment on column ${iol_schema}.nhrs_org_orgs.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_org_orgs.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_org_orgs.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_org_orgs.etl_timestamp is 'ETL处理时间戳';
