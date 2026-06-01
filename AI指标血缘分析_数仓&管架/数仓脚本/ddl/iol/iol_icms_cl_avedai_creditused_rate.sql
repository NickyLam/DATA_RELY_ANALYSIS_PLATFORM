/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_avedai_creditused_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_avedai_creditused_rate
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_avedai_creditused_rate(
    datadate timestamp -- 数据日期
    ,updateuserid varchar2(64) -- 最后更新人
    ,updatedate timestamp -- 最后更新日期
    ,lmecreditusedrate number(24,6) -- 大中客户日均用信率
    ,updateorgid varchar2(64) -- 最后更新机构
    ,individualcreditusedrate number(24,6) -- 个人客户日均用信率
    ,smecreditusedrate number(24,6) -- 小微客户日均用信率
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate timestamp -- 登记日期
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
grant select on ${iol_schema}.icms_cl_avedai_creditused_rate to ${iml_schema};
grant select on ${iol_schema}.icms_cl_avedai_creditused_rate to ${icl_schema};
grant select on ${iol_schema}.icms_cl_avedai_creditused_rate to ${idl_schema};
grant select on ${iol_schema}.icms_cl_avedai_creditused_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_avedai_creditused_rate is '全行日均用信率';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.datadate is '数据日期';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.lmecreditusedrate is '大中客户日均用信率';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.individualcreditusedrate is '个人客户日均用信率';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.smecreditusedrate is '小微客户日均用信率';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_avedai_creditused_rate.etl_timestamp is 'ETL处理时间戳';
