/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_owner
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_owner
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_owner purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_owner(
    clrownerid varchar2(96) -- 流水号
    ,clrid varchar2(96) -- 押品编号
    ,ecifcustomerid varchar2(96) -- 权利人客户编号
    ,clrownername varchar2(240) -- 权属人名称
    ,clrownertype varchar2(18) -- 权属人类别
    ,clrownercerttype varchar2(54) -- 权属人证件类型
    ,clrownercertid varchar2(96) -- 权属人证件号码
    ,percentage number(16,6) -- 分摊比例
    ,relationship varchar2(54) -- 权属人与借款人关系
    ,inputuserid varchar2(96) -- 登记人
    ,inputorgid varchar2(96) -- 登记机构
    ,inputdate timestamp -- 登记时间
    ,updateuserid varchar2(96) -- 更新人
    ,updateorgid varchar2(96) -- 更新机构
    ,updatedate timestamp -- 更新时间
    ,corporgid varchar2(96) -- 法人机构编号
    ,oldclrid varchar2(3000) -- 合并前押品编号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_owner to ${iml_schema};
grant select on ${iol_schema}.icms_clr_owner to ${icl_schema};
grant select on ${iol_schema}.icms_clr_owner to ${idl_schema};
grant select on ${iol_schema}.icms_clr_owner to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_owner is '押品权属人';
comment on column ${iol_schema}.icms_clr_owner.clrownerid is '流水号';
comment on column ${iol_schema}.icms_clr_owner.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_owner.ecifcustomerid is '权利人客户编号';
comment on column ${iol_schema}.icms_clr_owner.clrownername is '权属人名称';
comment on column ${iol_schema}.icms_clr_owner.clrownertype is '权属人类别';
comment on column ${iol_schema}.icms_clr_owner.clrownercerttype is '权属人证件类型';
comment on column ${iol_schema}.icms_clr_owner.clrownercertid is '权属人证件号码';
comment on column ${iol_schema}.icms_clr_owner.percentage is '分摊比例';
comment on column ${iol_schema}.icms_clr_owner.relationship is '权属人与借款人关系';
comment on column ${iol_schema}.icms_clr_owner.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_owner.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_owner.inputdate is '登记时间';
comment on column ${iol_schema}.icms_clr_owner.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_owner.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_owner.updatedate is '更新时间';
comment on column ${iol_schema}.icms_clr_owner.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_clr_owner.oldclrid is '合并前押品编号';
comment on column ${iol_schema}.icms_clr_owner.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_owner.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_owner.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_owner.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_owner.etl_timestamp is 'ETL处理时间戳';
