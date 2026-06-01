/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_org_dept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_org_dept
whenever sqlerror continue none;
drop table ${iol_schema}.iers_org_dept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_org_dept(
    address varchar2(30) -- 地址
    ,code varchar2(60) -- 编码
    ,createdate varchar2(15) -- 部门成立时间
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
    ,deptcanceldate varchar2(15) -- 部门撤销日期
    ,depttype number(38,0) -- 部门类型
    ,displayorder number(38,0) -- 显示顺序
    ,dr number(10,0) -- 删除标志
    ,enablestate number(38,0) -- 启用状态
    ,hrcanceled varchar2(2) -- hr撤销标志
    ,innercode varchar2(300) -- 内部编码
    ,islastversion varchar2(2) -- 是否最近版本
    ,isretail varchar2(2) -- 适用零售
    ,memo varchar2(450) -- 备注
    ,mnecode varchar2(75) -- 助记码
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 名称
    ,name2 varchar2(450) -- 名称2
    ,name3 varchar2(450) -- 名称3
    ,name4 varchar2(450) -- 名称4
    ,name5 varchar2(450) -- 名称5
    ,name6 varchar2(450) -- 名称6
    ,pk_dept varchar2(30) -- 部门主键
    ,pk_fatherorg varchar2(30) -- 上级部门
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_vid varchar2(30) -- 版本主键
    ,principal varchar2(30) -- 负责人
    ,resposition varchar2(30) -- 负责岗位
    ,shortname varchar2(450) -- 简称
    ,shortname2 varchar2(450) -- 简称2
    ,shortname3 varchar2(450) -- 简称3
    ,shortname4 varchar2(450) -- 简称4
    ,shortname5 varchar2(450) -- 简称5
    ,shortname6 varchar2(450) -- 简称6
    ,tel varchar2(150) -- 电话
    ,ts varchar2(29) -- 时间戳
    ,venddate varchar2(29) -- 版本失效时间
    ,vname varchar2(450) -- 版本名称
    ,vname2 varchar2(450) -- 版本名称2
    ,vname3 varchar2(450) -- 版本名称3
    ,vname4 varchar2(450) -- 版本名称4
    ,vname5 varchar2(450) -- 版本名称5
    ,vname6 varchar2(450) -- 版本名称6
    ,vno varchar2(75) -- 版本号
    ,vstartdate varchar2(29) -- 版本生效时间
    ,chargeleader varchar2(30) -- 分管领导
    ,deptlevel varchar2(30) -- 部门级别
    ,orgtype13 varchar2(2) -- 报表
    ,orgtype17 varchar2(2) -- 预算
    ,deptduty varchar2(2304) -- 
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
grant select on ${iol_schema}.iers_org_dept to ${iml_schema};
grant select on ${iol_schema}.iers_org_dept to ${icl_schema};
grant select on ${iol_schema}.iers_org_dept to ${idl_schema};
grant select on ${iol_schema}.iers_org_dept to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_org_dept is '部门信息表';
comment on column ${iol_schema}.iers_org_dept.address is '地址';
comment on column ${iol_schema}.iers_org_dept.code is '编码';
comment on column ${iol_schema}.iers_org_dept.createdate is '部门成立时间';
comment on column ${iol_schema}.iers_org_dept.creationtime is '创建时间';
comment on column ${iol_schema}.iers_org_dept.creator is '创建人';
comment on column ${iol_schema}.iers_org_dept.dataoriginflag is '分布式';
comment on column ${iol_schema}.iers_org_dept.def1 is '自定义项1';
comment on column ${iol_schema}.iers_org_dept.def10 is '自定义项10';
comment on column ${iol_schema}.iers_org_dept.def11 is '自定义项11';
comment on column ${iol_schema}.iers_org_dept.def12 is '自定义项12';
comment on column ${iol_schema}.iers_org_dept.def13 is '自定义项13';
comment on column ${iol_schema}.iers_org_dept.def14 is '自定义项14';
comment on column ${iol_schema}.iers_org_dept.def15 is '自定义项15';
comment on column ${iol_schema}.iers_org_dept.def16 is '自定义项16';
comment on column ${iol_schema}.iers_org_dept.def17 is '自定义项17';
comment on column ${iol_schema}.iers_org_dept.def18 is '自定义项18';
comment on column ${iol_schema}.iers_org_dept.def19 is '自定义项19';
comment on column ${iol_schema}.iers_org_dept.def2 is '自定义项2';
comment on column ${iol_schema}.iers_org_dept.def20 is '自定义项20';
comment on column ${iol_schema}.iers_org_dept.def3 is '自定义项3';
comment on column ${iol_schema}.iers_org_dept.def4 is '自定义项4';
comment on column ${iol_schema}.iers_org_dept.def5 is '自定义项5';
comment on column ${iol_schema}.iers_org_dept.def6 is '自定义项6';
comment on column ${iol_schema}.iers_org_dept.def7 is '自定义项7';
comment on column ${iol_schema}.iers_org_dept.def8 is '自定义项8';
comment on column ${iol_schema}.iers_org_dept.def9 is '自定义项9';
comment on column ${iol_schema}.iers_org_dept.deptcanceldate is '部门撤销日期';
comment on column ${iol_schema}.iers_org_dept.depttype is '部门类型';
comment on column ${iol_schema}.iers_org_dept.displayorder is '显示顺序';
comment on column ${iol_schema}.iers_org_dept.dr is '删除标志';
comment on column ${iol_schema}.iers_org_dept.enablestate is '启用状态';
comment on column ${iol_schema}.iers_org_dept.hrcanceled is 'hr撤销标志';
comment on column ${iol_schema}.iers_org_dept.innercode is '内部编码';
comment on column ${iol_schema}.iers_org_dept.islastversion is '是否最近版本';
comment on column ${iol_schema}.iers_org_dept.isretail is '适用零售';
comment on column ${iol_schema}.iers_org_dept.memo is '备注';
comment on column ${iol_schema}.iers_org_dept.mnecode is '助记码';
comment on column ${iol_schema}.iers_org_dept.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_org_dept.modifier is '最后修改人';
comment on column ${iol_schema}.iers_org_dept.name is '名称';
comment on column ${iol_schema}.iers_org_dept.name2 is '名称2';
comment on column ${iol_schema}.iers_org_dept.name3 is '名称3';
comment on column ${iol_schema}.iers_org_dept.name4 is '名称4';
comment on column ${iol_schema}.iers_org_dept.name5 is '名称5';
comment on column ${iol_schema}.iers_org_dept.name6 is '名称6';
comment on column ${iol_schema}.iers_org_dept.pk_dept is '部门主键';
comment on column ${iol_schema}.iers_org_dept.pk_fatherorg is '上级部门';
comment on column ${iol_schema}.iers_org_dept.pk_group is '所属集团';
comment on column ${iol_schema}.iers_org_dept.pk_org is '所属组织';
comment on column ${iol_schema}.iers_org_dept.pk_vid is '版本主键';
comment on column ${iol_schema}.iers_org_dept.principal is '负责人';
comment on column ${iol_schema}.iers_org_dept.resposition is '负责岗位';
comment on column ${iol_schema}.iers_org_dept.shortname is '简称';
comment on column ${iol_schema}.iers_org_dept.shortname2 is '简称2';
comment on column ${iol_schema}.iers_org_dept.shortname3 is '简称3';
comment on column ${iol_schema}.iers_org_dept.shortname4 is '简称4';
comment on column ${iol_schema}.iers_org_dept.shortname5 is '简称5';
comment on column ${iol_schema}.iers_org_dept.shortname6 is '简称6';
comment on column ${iol_schema}.iers_org_dept.tel is '电话';
comment on column ${iol_schema}.iers_org_dept.ts is '时间戳';
comment on column ${iol_schema}.iers_org_dept.venddate is '版本失效时间';
comment on column ${iol_schema}.iers_org_dept.vname is '版本名称';
comment on column ${iol_schema}.iers_org_dept.vname2 is '版本名称2';
comment on column ${iol_schema}.iers_org_dept.vname3 is '版本名称3';
comment on column ${iol_schema}.iers_org_dept.vname4 is '版本名称4';
comment on column ${iol_schema}.iers_org_dept.vname5 is '版本名称5';
comment on column ${iol_schema}.iers_org_dept.vname6 is '版本名称6';
comment on column ${iol_schema}.iers_org_dept.vno is '版本号';
comment on column ${iol_schema}.iers_org_dept.vstartdate is '版本生效时间';
comment on column ${iol_schema}.iers_org_dept.chargeleader is '分管领导';
comment on column ${iol_schema}.iers_org_dept.deptlevel is '部门级别';
comment on column ${iol_schema}.iers_org_dept.orgtype13 is '报表';
comment on column ${iol_schema}.iers_org_dept.orgtype17 is '预算';
comment on column ${iol_schema}.iers_org_dept.deptduty is '';
comment on column ${iol_schema}.iers_org_dept.start_dt is '开始时间';
comment on column ${iol_schema}.iers_org_dept.end_dt is '结束时间';
comment on column ${iol_schema}.iers_org_dept.id_mark is '增删标志';
comment on column ${iol_schema}.iers_org_dept.etl_timestamp is 'ETL处理时间戳';
