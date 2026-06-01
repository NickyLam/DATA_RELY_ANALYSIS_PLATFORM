/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_repdata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_repdata
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_repdata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_repdata(
    custid varchar2(30) -- 客户号
    ,repno varchar2(8) -- 报表期数
    ,caliber varchar2(6) -- 报表口径
    ,frepcode varchar2(4) -- 报表编号
    ,rowno number(22) -- 行号
    ,colno number(22) -- 列号
    ,coursecode varchar2(10) -- 科目代码
    ,fstcoldata number(24,6) -- 第一列数据
    ,sndcoldata number(24,6) -- 第二列数据
    ,showname varchar2(150) -- 展示名称
    ,regioncode varchar2(4) -- 地区号
    ,repperiod varchar2(1) -- 报表周期
    ,reptype varchar2(1) -- 财务报表类型
    ,isaudit varchar2(1) -- 是否审计
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
grant select on ${iol_schema}.nrrs_ci_repdata to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_repdata to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_repdata to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_repdata to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_repdata is '财务报表数据存放';
comment on column ${iol_schema}.nrrs_ci_repdata.custid is '客户号';
comment on column ${iol_schema}.nrrs_ci_repdata.repno is '报表期数';
comment on column ${iol_schema}.nrrs_ci_repdata.caliber is '报表口径';
comment on column ${iol_schema}.nrrs_ci_repdata.frepcode is '报表编号';
comment on column ${iol_schema}.nrrs_ci_repdata.rowno is '行号';
comment on column ${iol_schema}.nrrs_ci_repdata.colno is '列号';
comment on column ${iol_schema}.nrrs_ci_repdata.coursecode is '科目代码';
comment on column ${iol_schema}.nrrs_ci_repdata.fstcoldata is '第一列数据';
comment on column ${iol_schema}.nrrs_ci_repdata.sndcoldata is '第二列数据';
comment on column ${iol_schema}.nrrs_ci_repdata.showname is '展示名称';
comment on column ${iol_schema}.nrrs_ci_repdata.regioncode is '地区号';
comment on column ${iol_schema}.nrrs_ci_repdata.repperiod is '报表周期';
comment on column ${iol_schema}.nrrs_ci_repdata.reptype is '财务报表类型';
comment on column ${iol_schema}.nrrs_ci_repdata.isaudit is '是否审计';
comment on column ${iol_schema}.nrrs_ci_repdata.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_repdata.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_repdata.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_repdata.etl_timestamp is 'ETL处理时间戳';
