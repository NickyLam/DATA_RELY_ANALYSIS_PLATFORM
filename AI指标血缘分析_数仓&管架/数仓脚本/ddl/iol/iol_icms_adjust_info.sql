/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_adjust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_adjust_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_adjust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_adjust_info(
    serialno varchar2(64) -- 流水号
    ,signname varchar2(500) -- 标注名称
    ,migtflag varchar2(80) -- 
    ,adjustlevel varchar2(20) -- 调整层级
    ,signid varchar2(18) -- 关联借据号
    ,inputorgid varchar2(64) -- 登记机构
    ,remark varchar2(400) -- 备注
    ,updateuserid varchar2(64) -- 更新人
    ,inputdate date -- 登记时间
    ,type varchar2(20) -- 更改类型
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,relativeserialno varchar2(64) -- 关联流水号
    ,reason varchar2(600) -- 更改原因
    ,coverage varchar2(10) -- 覆盖范围
    ,adjusttype varchar2(40) -- 调整类型
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_adjust_info to ${iml_schema};
grant select on ${iol_schema}.icms_adjust_info to ${icl_schema};
grant select on ${iol_schema}.icms_adjust_info to ${idl_schema};
grant select on ${iol_schema}.icms_adjust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_adjust_info is '风险分类信息调整表';
comment on column ${iol_schema}.icms_adjust_info.serialno is '流水号';
comment on column ${iol_schema}.icms_adjust_info.signname is '标注名称';
comment on column ${iol_schema}.icms_adjust_info.migtflag is '';
comment on column ${iol_schema}.icms_adjust_info.adjustlevel is '调整层级';
comment on column ${iol_schema}.icms_adjust_info.signid is '关联借据号';
comment on column ${iol_schema}.icms_adjust_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_adjust_info.remark is '备注';
comment on column ${iol_schema}.icms_adjust_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_adjust_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_adjust_info.type is '更改类型';
comment on column ${iol_schema}.icms_adjust_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_adjust_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_adjust_info.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_adjust_info.reason is '更改原因';
comment on column ${iol_schema}.icms_adjust_info.coverage is '覆盖范围';
comment on column ${iol_schema}.icms_adjust_info.adjusttype is '调整类型';
comment on column ${iol_schema}.icms_adjust_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_adjust_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_adjust_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_adjust_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_adjust_info.etl_timestamp is 'ETL处理时间戳';
