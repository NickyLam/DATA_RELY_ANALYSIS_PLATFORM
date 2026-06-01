/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ufinancier_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ufinancier_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ufinancier_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ufinancier_info(
    serialno varchar2(64) -- 流水号
    ,customername varchar2(100) -- 客户名称
    ,certtype varchar2(4) -- 证件类型
    ,certcode varchar2(20) -- 证件号码
    ,classifylevel varchar2(64) -- 主体评级
    ,mainlevelorg varchar2(64) -- 评级机构
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,inputuserid varchar2(64) -- 登记人
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
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
grant select on ${iol_schema}.icms_ufinancier_info to ${iml_schema};
grant select on ${iol_schema}.icms_ufinancier_info to ${icl_schema};
grant select on ${iol_schema}.icms_ufinancier_info to ${idl_schema};
grant select on ${iol_schema}.icms_ufinancier_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ufinancier_info is '底层融资人信息表';
comment on column ${iol_schema}.icms_ufinancier_info.serialno is '流水号';
comment on column ${iol_schema}.icms_ufinancier_info.customername is '客户名称';
comment on column ${iol_schema}.icms_ufinancier_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_ufinancier_info.certcode is '证件号码';
comment on column ${iol_schema}.icms_ufinancier_info.classifylevel is '主体评级';
comment on column ${iol_schema}.icms_ufinancier_info.mainlevelorg is '评级机构';
comment on column ${iol_schema}.icms_ufinancier_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ufinancier_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ufinancier_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ufinancier_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_ufinancier_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_ufinancier_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ufinancier_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ufinancier_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ufinancier_info.etl_timestamp is 'ETL处理时间戳';
