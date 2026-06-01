/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_blocmeminfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_blocmeminfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_blocmeminfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_blocmeminfo(
    bloccustid varchar2(30) -- 第三主营业务
    ,custid varchar2(30) -- 集团客户状态:1-有效 0-无效
    ,memcustid varchar2(30) -- 部门
    ,memregioncode varchar2(4) -- 客户所有制类型
    ,memcusttype varchar2(1) -- 第一主营业务占比
    ,subbloccustid varchar2(30) -- 组织机构代码
    ,custlevel number(22) -- 客户类型
    ,upcustid varchar2(30) -- 证件号码
    ,upregioncode varchar2(4) -- 第一主营业务
    ,inputdate varchar2(10) -- 登记人
    ,outdate varchar2(10) -- 证件类型
    ,inputorg varchar2(20) -- 所属国家
    ,state varchar2(1) -- 1-有效 0-无效
    ,havelower varchar2(1) -- 第二主营业务
    ,ishead varchar2(1) -- 是否母公司
    ,inputusername varchar2(100) -- 登记人名称
    ,inputorgname varchar2(100) -- 登记机构名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_ci_blocmeminfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_blocmeminfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_blocmeminfo to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_blocmeminfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_blocmeminfo is '集团从属关系';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.bloccustid is '第三主营业务';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.custid is '集团客户状态:1-有效 0-无效';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.memcustid is '部门';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.memregioncode is '客户所有制类型';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.memcusttype is '第一主营业务占比';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.subbloccustid is '组织机构代码';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.custlevel is '客户类型';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.upcustid is '证件号码';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.upregioncode is '第一主营业务';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.inputdate is '登记人';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.outdate is '证件类型';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.inputorg is '所属国家';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.state is '1-有效 0-无效';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.havelower is '第二主营业务';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.ishead is '是否母公司';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.inputusername is '登记人名称';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.inputorgname is '登记机构名称';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_blocmeminfo.etl_timestamp is 'ETL处理时间戳';
