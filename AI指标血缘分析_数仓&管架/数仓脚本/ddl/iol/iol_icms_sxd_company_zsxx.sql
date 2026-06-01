/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_zsxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_zsxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_zsxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_zsxx(
    id varchar2(32) -- 主键
    ,jkqx varchar2(10) -- 缴款截至日期
    ,skzl varchar2(3) -- 税款种类
    ,zsxm varchar2(3) -- 征收项目
    ,sl number(22,6) -- 税率
    ,xssr number(22,6) -- 计税金额
    ,serno varchar2(32) -- 业务流水号
    ,skzt varchar2(3) -- 税款状态
    ,se number(22,6) -- 实缴金额
    ,migtflag varchar2(80) -- 
    ,sssq_q varchar2(10) -- 所属日期起
    ,sssq_z varchar2(10) -- 所属日期止
    ,jkfsrq varchar2(10) -- 缴款发生日期
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
grant select on ${iol_schema}.icms_sxd_company_zsxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_zsxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_zsxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_zsxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_zsxx is '税兴贷企业税款征收信息';
comment on column ${iol_schema}.icms_sxd_company_zsxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_zsxx.jkqx is '缴款截至日期';
comment on column ${iol_schema}.icms_sxd_company_zsxx.skzl is '税款种类';
comment on column ${iol_schema}.icms_sxd_company_zsxx.zsxm is '征收项目';
comment on column ${iol_schema}.icms_sxd_company_zsxx.sl is '税率';
comment on column ${iol_schema}.icms_sxd_company_zsxx.xssr is '计税金额';
comment on column ${iol_schema}.icms_sxd_company_zsxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_zsxx.skzt is '税款状态';
comment on column ${iol_schema}.icms_sxd_company_zsxx.se is '实缴金额';
comment on column ${iol_schema}.icms_sxd_company_zsxx.migtflag is '';
comment on column ${iol_schema}.icms_sxd_company_zsxx.sssq_q is '所属日期起';
comment on column ${iol_schema}.icms_sxd_company_zsxx.sssq_z is '所属日期止';
comment on column ${iol_schema}.icms_sxd_company_zsxx.jkfsrq is '缴款发生日期';
comment on column ${iol_schema}.icms_sxd_company_zsxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_zsxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_zsxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_zsxx.etl_timestamp is 'ETL处理时间戳';
