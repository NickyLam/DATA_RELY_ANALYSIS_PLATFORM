/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_qywfwzxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_qywfwzxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_qywfwzxx(
    id varchar2(32) -- 主键
    ,xgzt varchar2(20) -- 限改状态
    ,wfwzlxdm varchar2(50) -- 违法违章类型代码
    ,wfwzztmc varchar2(3) -- 违法违章状态
    ,zywfwzsddm varchar2(50) -- 违法违章手段代码
    ,zywfwzss varchar2(1000) -- 违法违章事实
    ,serno varchar2(32) -- 业务流水号
    ,larq date -- 立案日期
    ,migtflag varchar2(80) -- 
    ,djrq date -- 登记日期
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
grant select on ${iol_schema}.icms_sxd_company_qywfwzxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_qywfwzxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_qywfwzxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_qywfwzxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_qywfwzxx is '税兴贷企业涉税违法违章信息';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.xgzt is '限改状态';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.wfwzlxdm is '违法违章类型代码';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.wfwzztmc is '违法违章状态';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.zywfwzsddm is '违法违章手段代码';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.zywfwzss is '违法违章事实';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.larq is '立案日期';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.migtflag is '';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.djrq is '登记日期';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_qywfwzxx.etl_timestamp is 'ETL处理时间戳';
