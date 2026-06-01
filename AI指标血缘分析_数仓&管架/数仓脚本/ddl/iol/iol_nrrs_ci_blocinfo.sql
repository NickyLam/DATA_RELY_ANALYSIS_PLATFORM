/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_blocinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_blocinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_blocinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_blocinfo(
    bloccustid varchar2(30) -- 集团客户号
    ,blocname varchar2(100) -- 总部客户名称
    ,custid varchar2(30) -- 建立日期
    ,homename varchar2(100) -- 创建人
    ,leveltype varchar2(4) -- 客户经理
    ,scalecode varchar2(1) -- 集团层级标识
    ,areacode varchar2(10) -- 集团客户名称
    ,createman varchar2(20) -- 所属机构
    ,createdate varchar2(10) -- 所在地区
    ,custmanage varchar2(20) -- 集团牵头行
    ,custorg varchar2(20) -- 规模
    ,leadbank varchar2(100) -- 集团本部编号
    ,state varchar2(1) -- 1-有效 0-无效
    ,certtype varchar2(10) -- 证件类型
    ,certid varchar2(42) -- 证件号码
    ,custtype varchar2(2) -- 客户类型
    ,comcorptype varchar2(2) -- 客户所有制类型
    ,country varchar2(10) -- 所属国家
    ,deptcode varchar2(30) -- 部门
    ,inputuser varchar2(100) -- 登记人
    ,firstbusi varchar2(20) -- 第一主营业务
    ,secondbusi varchar2(20) -- 第二主营业务
    ,thirdbusi varchar2(20) -- 第三主营业务
    ,certificatecode varchar2(42) -- 组织机构代码
    ,firstbusirate number(10,6) -- 第一主营业务占比
    ,secondbusirate number(10,6) -- 第二主营业务占比
    ,thirdbusirate number(10,6) -- 第三主营业务占比
    ,mfcustomerid varchar2(40) -- 核心客户号
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
grant select on ${iol_schema}.nrrs_ci_blocinfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_blocinfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_blocinfo to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_blocinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_blocinfo is '集团客户信息';
comment on column ${iol_schema}.nrrs_ci_blocinfo.bloccustid is '集团客户号';
comment on column ${iol_schema}.nrrs_ci_blocinfo.blocname is '总部客户名称';
comment on column ${iol_schema}.nrrs_ci_blocinfo.custid is '建立日期';
comment on column ${iol_schema}.nrrs_ci_blocinfo.homename is '创建人';
comment on column ${iol_schema}.nrrs_ci_blocinfo.leveltype is '客户经理';
comment on column ${iol_schema}.nrrs_ci_blocinfo.scalecode is '集团层级标识';
comment on column ${iol_schema}.nrrs_ci_blocinfo.areacode is '集团客户名称';
comment on column ${iol_schema}.nrrs_ci_blocinfo.createman is '所属机构';
comment on column ${iol_schema}.nrrs_ci_blocinfo.createdate is '所在地区';
comment on column ${iol_schema}.nrrs_ci_blocinfo.custmanage is '集团牵头行';
comment on column ${iol_schema}.nrrs_ci_blocinfo.custorg is '规模';
comment on column ${iol_schema}.nrrs_ci_blocinfo.leadbank is '集团本部编号';
comment on column ${iol_schema}.nrrs_ci_blocinfo.state is '1-有效 0-无效';
comment on column ${iol_schema}.nrrs_ci_blocinfo.certtype is '证件类型';
comment on column ${iol_schema}.nrrs_ci_blocinfo.certid is '证件号码';
comment on column ${iol_schema}.nrrs_ci_blocinfo.custtype is '客户类型';
comment on column ${iol_schema}.nrrs_ci_blocinfo.comcorptype is '客户所有制类型';
comment on column ${iol_schema}.nrrs_ci_blocinfo.country is '所属国家';
comment on column ${iol_schema}.nrrs_ci_blocinfo.deptcode is '部门';
comment on column ${iol_schema}.nrrs_ci_blocinfo.inputuser is '登记人';
comment on column ${iol_schema}.nrrs_ci_blocinfo.firstbusi is '第一主营业务';
comment on column ${iol_schema}.nrrs_ci_blocinfo.secondbusi is '第二主营业务';
comment on column ${iol_schema}.nrrs_ci_blocinfo.thirdbusi is '第三主营业务';
comment on column ${iol_schema}.nrrs_ci_blocinfo.certificatecode is '组织机构代码';
comment on column ${iol_schema}.nrrs_ci_blocinfo.firstbusirate is '第一主营业务占比';
comment on column ${iol_schema}.nrrs_ci_blocinfo.secondbusirate is '第二主营业务占比';
comment on column ${iol_schema}.nrrs_ci_blocinfo.thirdbusirate is '第三主营业务占比';
comment on column ${iol_schema}.nrrs_ci_blocinfo.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.nrrs_ci_blocinfo.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_blocinfo.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_blocinfo.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_blocinfo.etl_timestamp is 'ETL处理时间戳';
