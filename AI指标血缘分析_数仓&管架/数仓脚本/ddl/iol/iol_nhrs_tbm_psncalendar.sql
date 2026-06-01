/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_tbm_psncalendar
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_tbm_psncalendar
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_tbm_psncalendar purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_tbm_psncalendar(
    awaydatacostatus varchar2(2) -- 出差数据是否汇总
    ,calendar varchar2(15) -- 日历
    ,cancelflag varchar2(2) -- 当日排班遇假日取消、保留的标志
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,datacreatestatus varchar2(2) -- 考勤数据是否生成
    ,dataimportstatus varchar2(2) -- 考勤机数据是否导入
    ,dr number(10,0) -- 备用dr
    ,gzsj number(16,4) -- 工作时长
    ,if_rest varchar2(2) -- 是否休假
    ,isflexiblefinal varchar2(2) -- 最终是否弹性
    ,isfromteam varchar2(2) -- 是否来源于班组
    ,issolidifywhencalculation varchar2(2) -- 是否生成考勤数据时固化
    ,iswtrecreate varchar2(2) -- 工作时间段重新生成标志
    ,kqdatacostatus varchar2(2) -- 考勤数据是否汇总
    ,leavedatacostatus varchar2(2) -- 休假数据是否汇总
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,original_shift_b4cut varchar2(30) -- 假日切割前原班次
    ,original_shift_b4exg varchar2(30) -- 假日对调前原班次
    ,overtimedatacostatus varchar2(2) -- 加班数据是否汇总
    ,pk_group varchar2(30) -- 集团主键
    ,pk_org varchar2(30) -- 组织主键
    ,pk_psncalendar varchar2(30) -- 人员工作日历主键
    ,pk_psndoc varchar2(30) -- 人员基本信息
    ,pk_shift varchar2(30) -- 班次主键
    ,ts varchar2(29) -- 备用ts
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
grant select on ${iol_schema}.nhrs_tbm_psncalendar to ${iml_schema};
grant select on ${iol_schema}.nhrs_tbm_psncalendar to ${icl_schema};
grant select on ${iol_schema}.nhrs_tbm_psncalendar to ${idl_schema};
grant select on ${iol_schema}.nhrs_tbm_psncalendar to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_tbm_psncalendar is '员工工作日历';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.awaydatacostatus is '出差数据是否汇总';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.calendar is '日历';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.cancelflag is '当日排班遇假日取消、保留的标志';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.creator is '创建人';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.datacreatestatus is '考勤数据是否生成';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.dataimportstatus is '考勤机数据是否导入';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.dr is '备用dr';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.gzsj is '工作时长';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.if_rest is '是否休假';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.isflexiblefinal is '最终是否弹性';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.isfromteam is '是否来源于班组';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.issolidifywhencalculation is '是否生成考勤数据时固化';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.iswtrecreate is '工作时间段重新生成标志';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.kqdatacostatus is '考勤数据是否汇总';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.leavedatacostatus is '休假数据是否汇总';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.modifier is '最后修改人';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.original_shift_b4cut is '假日切割前原班次';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.original_shift_b4exg is '假日对调前原班次';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.overtimedatacostatus is '加班数据是否汇总';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.pk_group is '集团主键';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.pk_org is '组织主键';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.pk_psncalendar is '人员工作日历主键';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.pk_psndoc is '人员基本信息';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.pk_shift is '班次主键';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.ts is '备用ts';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_tbm_psncalendar.etl_timestamp is 'ETL处理时间戳';
