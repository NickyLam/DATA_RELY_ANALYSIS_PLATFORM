/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_costinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_costinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_costinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_costinfo(
    serialno varchar2(40) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,inputdate varchar2(10) -- 输入日期
    ,feebilltype varchar2(32) -- 水电单据类型
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,feebilldate varchar2(32) -- 水电单据日期
    ,updatedate varchar2(10) -- 更新日期
    ,num varchar2(32) -- 水电数量
    ,inputuserid varchar2(32) -- 申请客户编号
    ,inputorgid varchar2(32) -- 申请机构
    ,customername varchar2(200) -- 客户名称
    ,sum number(24,6) -- 水电总量
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
grant select on ${iol_schema}.icms_ind_costinfo to ${iml_schema};
grant select on ${iol_schema}.icms_ind_costinfo to ${icl_schema};
grant select on ${iol_schema}.icms_ind_costinfo to ${idl_schema};
grant select on ${iol_schema}.icms_ind_costinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_costinfo is '水电相关税单情况列表';
comment on column ${iol_schema}.icms_ind_costinfo.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_costinfo.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_costinfo.inputdate is '输入日期';
comment on column ${iol_schema}.icms_ind_costinfo.feebilltype is '水电单据类型';
comment on column ${iol_schema}.icms_ind_costinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_costinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_costinfo.feebilldate is '水电单据日期';
comment on column ${iol_schema}.icms_ind_costinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_costinfo.num is '水电数量';
comment on column ${iol_schema}.icms_ind_costinfo.inputuserid is '申请客户编号';
comment on column ${iol_schema}.icms_ind_costinfo.inputorgid is '申请机构';
comment on column ${iol_schema}.icms_ind_costinfo.customername is '客户名称';
comment on column ${iol_schema}.icms_ind_costinfo.sum is '水电总量';
comment on column ${iol_schema}.icms_ind_costinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_costinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_costinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_costinfo.etl_timestamp is 'ETL处理时间戳';
