/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_inflexion_bd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_inflexion_bd
whenever sqlerror continue none;
drop table ${iol_schema}.icms_inflexion_bd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_inflexion_bd(
    serialno varchar2(32) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,oldobjecttype varchar2(32) -- 原对象类型
    ,oldobjectno varchar2(80) -- 原对象编号
    ,inputuserid varchar2(32) -- 登记人
    ,updateorgid varchar2(32) -- 更新机构
    ,inputdate date -- 登记日期
    ,objectno varchar2(32) -- 对象编号
    ,ifbeads varchar2(4) -- 是否串用
    ,linesource varchar2(10) -- 额度来源
    ,approveserialno varchar2(32) -- 被动转授信集团批复号
    ,updateuserid varchar2(32) -- 更新人
    ,objecttype varchar2(32) -- 对象类型
    ,inputorgid varchar2(32) -- 登记机构
    ,cycleflag varchar2(4) -- 是否循环
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
grant select on ${iol_schema}.icms_inflexion_bd to ${iml_schema};
grant select on ${iol_schema}.icms_inflexion_bd to ${icl_schema};
grant select on ${iol_schema}.icms_inflexion_bd to ${idl_schema};
grant select on ${iol_schema}.icms_inflexion_bd to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_inflexion_bd is '转授信信息表';
comment on column ${iol_schema}.icms_inflexion_bd.serialno is '流水号';
comment on column ${iol_schema}.icms_inflexion_bd.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_inflexion_bd.updatedate is '更新日期';
comment on column ${iol_schema}.icms_inflexion_bd.oldobjecttype is '原对象类型';
comment on column ${iol_schema}.icms_inflexion_bd.oldobjectno is '原对象编号';
comment on column ${iol_schema}.icms_inflexion_bd.inputuserid is '登记人';
comment on column ${iol_schema}.icms_inflexion_bd.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_inflexion_bd.inputdate is '登记日期';
comment on column ${iol_schema}.icms_inflexion_bd.objectno is '对象编号';
comment on column ${iol_schema}.icms_inflexion_bd.ifbeads is '是否串用';
comment on column ${iol_schema}.icms_inflexion_bd.linesource is '额度来源';
comment on column ${iol_schema}.icms_inflexion_bd.approveserialno is '被动转授信集团批复号';
comment on column ${iol_schema}.icms_inflexion_bd.updateuserid is '更新人';
comment on column ${iol_schema}.icms_inflexion_bd.objecttype is '对象类型';
comment on column ${iol_schema}.icms_inflexion_bd.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_inflexion_bd.cycleflag is '是否循环';
comment on column ${iol_schema}.icms_inflexion_bd.start_dt is '开始时间';
comment on column ${iol_schema}.icms_inflexion_bd.end_dt is '结束时间';
comment on column ${iol_schema}.icms_inflexion_bd.id_mark is '增删标志';
comment on column ${iol_schema}.icms_inflexion_bd.etl_timestamp is 'ETL处理时间戳';
