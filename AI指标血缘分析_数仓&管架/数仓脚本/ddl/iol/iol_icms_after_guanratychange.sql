/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_after_guanratychange
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_after_guanratychange
whenever sqlerror continue none;
drop table ${iol_schema}.icms_after_guanratychange purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_after_guanratychange(
    serialno varchar2(64) -- 流水号
    ,exceptiontype varchar2(1000) -- 异常情况(风险信号)
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记单位
    ,migtflag varchar2(80) -- 
    ,otherexception varchar2(3000) -- 其他异常情况(押品监测情况说明)
    ,yorn varchar2(1) -- 与前期相比本次联系有无发现下列异常情况
    ,updateuserid varchar2(64) -- 更新人编号
    ,objectno varchar2(64) -- 对象号(风险监测流水号)
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(64) -- 更新人机构编号
    ,saveflag varchar2(1) -- 保存标志（YesNo）
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
grant select on ${iol_schema}.icms_after_guanratychange to ${iml_schema};
grant select on ${iol_schema}.icms_after_guanratychange to ${icl_schema};
grant select on ${iol_schema}.icms_after_guanratychange to ${idl_schema};
grant select on ${iol_schema}.icms_after_guanratychange to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_after_guanratychange is '风险监测-押品监测';
comment on column ${iol_schema}.icms_after_guanratychange.serialno is '流水号';
comment on column ${iol_schema}.icms_after_guanratychange.exceptiontype is '异常情况(风险信号)';
comment on column ${iol_schema}.icms_after_guanratychange.inputuserid is '登记人';
comment on column ${iol_schema}.icms_after_guanratychange.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_after_guanratychange.migtflag is '';
comment on column ${iol_schema}.icms_after_guanratychange.otherexception is '其他异常情况(押品监测情况说明)';
comment on column ${iol_schema}.icms_after_guanratychange.yorn is '与前期相比本次联系有无发现下列异常情况';
comment on column ${iol_schema}.icms_after_guanratychange.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_after_guanratychange.objectno is '对象号(风险监测流水号)';
comment on column ${iol_schema}.icms_after_guanratychange.inputdate is '登记日期';
comment on column ${iol_schema}.icms_after_guanratychange.updatedate is '更新日期';
comment on column ${iol_schema}.icms_after_guanratychange.updateorgid is '更新人机构编号';
comment on column ${iol_schema}.icms_after_guanratychange.saveflag is '保存标志（YesNo）';
comment on column ${iol_schema}.icms_after_guanratychange.start_dt is '开始时间';
comment on column ${iol_schema}.icms_after_guanratychange.end_dt is '结束时间';
comment on column ${iol_schema}.icms_after_guanratychange.id_mark is '增删标志';
comment on column ${iol_schema}.icms_after_guanratychange.etl_timestamp is 'ETL处理时间戳';
