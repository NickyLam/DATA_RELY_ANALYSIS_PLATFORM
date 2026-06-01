/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_t21_kri_warresult
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_t21_kri_warresult
whenever sqlerror continue none;
drop table ${iol_schema}.orms_t21_kri_warresult purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_kri_warresult(
    waringid varchar2(48) -- 预警结果编号物理主键
    ,dataid varchar2(48) -- 数据id
    ,kriid varchar2(48) -- 指标id
    ,waringunitid varchar2(48) -- 预警机构编号
    ,waringvalue number(30,10) -- 预警值
    ,startdate varchar2(15) -- 数据起始日期
    ,enddate varchar2(15) -- 数据结束日期
    ,krirangeid varchar2(48) -- 预警关联的指标阈值id
    ,waringrange varchar2(150) -- 预警区间（关联的指标阈值）
    ,waringdate varchar2(15) -- 预警日期
    ,notifistaffid varchar2(48) -- 通知对象
    ,notifimode varchar2(3) -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,kricolorid varchar2(48) -- 与容忍度参数表关联
    ,kricolorrgb varchar2(11) -- 容忍度颜色值
    ,orgid varchar2(48) -- 纬度机构id
    ,blid varchar2(48) -- 纬度业务条线id
    ,warstatus varchar2(2) -- 预警状态
    ,anadesc varchar2(3000) -- 分析说明
    ,isact varchar2(15) -- 是否发起整改
    ,recordversion number(22) -- 记录版本号
    ,createdtime varchar2(29) -- 创建时间
    ,lastmodid varchar2(48) -- 最近修改人id
    ,lastmodtime varchar2(29) -- 最近修改时间
    ,delflag varchar2(2) -- 删除标志
    ,toleranceid varchar2(48) -- 容忍度id
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
grant select on ${iol_schema}.orms_t21_kri_warresult to ${iml_schema};
grant select on ${iol_schema}.orms_t21_kri_warresult to ${icl_schema};
grant select on ${iol_schema}.orms_t21_kri_warresult to ${idl_schema};
grant select on ${iol_schema}.orms_t21_kri_warresult to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_t21_kri_warresult is '指标预警信息结果表，该表用于记录KRI预警数据';
comment on column ${iol_schema}.orms_t21_kri_warresult.waringid is '预警结果编号物理主键';
comment on column ${iol_schema}.orms_t21_kri_warresult.dataid is '数据id';
comment on column ${iol_schema}.orms_t21_kri_warresult.kriid is '指标id';
comment on column ${iol_schema}.orms_t21_kri_warresult.waringunitid is '预警机构编号';
comment on column ${iol_schema}.orms_t21_kri_warresult.waringvalue is '预警值';
comment on column ${iol_schema}.orms_t21_kri_warresult.startdate is '数据起始日期';
comment on column ${iol_schema}.orms_t21_kri_warresult.enddate is '数据结束日期';
comment on column ${iol_schema}.orms_t21_kri_warresult.krirangeid is '预警关联的指标阈值id';
comment on column ${iol_schema}.orms_t21_kri_warresult.waringrange is '预警区间（关联的指标阈值）';
comment on column ${iol_schema}.orms_t21_kri_warresult.waringdate is '预警日期';
comment on column ${iol_schema}.orms_t21_kri_warresult.notifistaffid is '通知对象';
comment on column ${iol_schema}.orms_t21_kri_warresult.notifimode is '通知方式：0：短信，1：邮件，2：邮件+短信';
comment on column ${iol_schema}.orms_t21_kri_warresult.kricolorid is '与容忍度参数表关联';
comment on column ${iol_schema}.orms_t21_kri_warresult.kricolorrgb is '容忍度颜色值';
comment on column ${iol_schema}.orms_t21_kri_warresult.orgid is '纬度机构id';
comment on column ${iol_schema}.orms_t21_kri_warresult.blid is '纬度业务条线id';
comment on column ${iol_schema}.orms_t21_kri_warresult.warstatus is '预警状态';
comment on column ${iol_schema}.orms_t21_kri_warresult.anadesc is '分析说明';
comment on column ${iol_schema}.orms_t21_kri_warresult.isact is '是否发起整改';
comment on column ${iol_schema}.orms_t21_kri_warresult.recordversion is '记录版本号';
comment on column ${iol_schema}.orms_t21_kri_warresult.createdtime is '创建时间';
comment on column ${iol_schema}.orms_t21_kri_warresult.lastmodid is '最近修改人id';
comment on column ${iol_schema}.orms_t21_kri_warresult.lastmodtime is '最近修改时间';
comment on column ${iol_schema}.orms_t21_kri_warresult.delflag is '删除标志';
comment on column ${iol_schema}.orms_t21_kri_warresult.toleranceid is '容忍度id';
comment on column ${iol_schema}.orms_t21_kri_warresult.start_dt is '开始时间';
comment on column ${iol_schema}.orms_t21_kri_warresult.end_dt is '结束时间';
comment on column ${iol_schema}.orms_t21_kri_warresult.id_mark is '增删标志';
comment on column ${iol_schema}.orms_t21_kri_warresult.etl_timestamp is 'ETL处理时间戳';
