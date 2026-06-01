/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_asdebtrateindex
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_asdebtrateindex
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_asdebtrateindex purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_asdebtrateindex(
    workdate varchar2(15) -- 供数日期
    ,custid varchar2(45) -- 保证人编号
    ,qualification varchar2(3) -- 保证合格性(1-合格 0-不合格)
    ,independence varchar2(3) -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
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
grant select on ${iol_schema}.mims_yp_asdebtrateindex to ${iml_schema};
grant select on ${iol_schema}.mims_yp_asdebtrateindex to ${icl_schema};
grant select on ${iol_schema}.mims_yp_asdebtrateindex to ${idl_schema};
grant select on ${iol_schema}.mims_yp_asdebtrateindex to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_asdebtrateindex is '押品给内评系统供保证信息债项评级数据表';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.workdate is '供数日期';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.custid is '保证人编号';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.qualification is '保证合格性(1-合格 0-不合格)';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.independence is '保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_asdebtrateindex.etl_timestamp is 'ETL处理时间戳';
