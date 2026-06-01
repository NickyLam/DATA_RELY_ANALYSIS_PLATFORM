/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_octpninfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_octpninfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_octpninfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_octpninfsgmt(
    industry varchar2(4) -- 单位所属行业
    ,cpntype varchar2(4) -- 单位性质
    ,cpnpc varchar2(6) -- 单位所在地邮编
    ,cpnname varchar2(80) -- 单位名称
    ,cpnaddr varchar2(100) -- 单位详细地址
    ,create_time varchar2(19) -- 入库时间
    ,empstatus varchar2(4) -- 就业状况
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,cust_no varchar2(32) -- 客户号码
    ,workstartdate varchar2(4) -- 本单位工作起始年份
    ,techtitle varchar2(4) -- 职称
    ,octpninfoupdate varchar2(19) -- 信息更新日期
    ,cpndist varchar2(6) -- 单位所在地行政区划
    ,cpntel varchar2(25) -- 单位电话
    ,occupation varchar2(4) -- 职业
    ,deptcode varchar2(14) -- 征信机构代码
    ,title varchar2(4) -- 职务
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_credit_octpninfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_octpninfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_octpninfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_octpninfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_octpninfsgmt is '个人基本信息记录-职业信息段';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.industry is '单位所属行业';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpntype is '单位性质';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpnpc is '单位所在地邮编';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpnname is '单位名称';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpnaddr is '单位详细地址';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.empstatus is '就业状况';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.workstartdate is '本单位工作起始年份';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.techtitle is '职称';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.octpninfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpndist is '单位所在地行政区划';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.cpntel is '单位电话';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.occupation is '职业';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.title is '职务';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_octpninfsgmt.etl_timestamp is 'ETL处理时间戳';
