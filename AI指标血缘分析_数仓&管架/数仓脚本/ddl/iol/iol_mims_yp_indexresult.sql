/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_indexresult
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_indexresult
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_indexresult purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_indexresult(
    datecode varchar2(15) -- 期次 yyyy-mm-dd
    ,indextype varchar2(3) -- 预警类型 字典indextype
    ,objectcode varchar2(300) -- 预警对象
    ,indexcode varchar2(15) -- 指标编号
    ,indexname varchar2(750) -- 指标名称
    ,indexvalue varchar2(75) -- 指标值
    ,sccode varchar2(48) -- 押品编号
    ,remark1 varchar2(75) -- 备用1
    ,remark2 varchar2(75) -- 备用2
    ,remark3 varchar2(75) -- 备用3
    ,remark4 varchar2(75) -- 备用4
    ,remark5 varchar2(75) -- 备用5
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
grant select on ${iol_schema}.mims_yp_indexresult to ${iml_schema};
grant select on ${iol_schema}.mims_yp_indexresult to ${icl_schema};
grant select on ${iol_schema}.mims_yp_indexresult to ${idl_schema};
grant select on ${iol_schema}.mims_yp_indexresult to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_indexresult is '风险预警结果';
comment on column ${iol_schema}.mims_yp_indexresult.datecode is '期次 yyyy-mm-dd';
comment on column ${iol_schema}.mims_yp_indexresult.indextype is '预警类型 字典indextype';
comment on column ${iol_schema}.mims_yp_indexresult.objectcode is '预警对象';
comment on column ${iol_schema}.mims_yp_indexresult.indexcode is '指标编号';
comment on column ${iol_schema}.mims_yp_indexresult.indexname is '指标名称';
comment on column ${iol_schema}.mims_yp_indexresult.indexvalue is '指标值';
comment on column ${iol_schema}.mims_yp_indexresult.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_indexresult.remark1 is '备用1';
comment on column ${iol_schema}.mims_yp_indexresult.remark2 is '备用2';
comment on column ${iol_schema}.mims_yp_indexresult.remark3 is '备用3';
comment on column ${iol_schema}.mims_yp_indexresult.remark4 is '备用4';
comment on column ${iol_schema}.mims_yp_indexresult.remark5 is '备用5';
comment on column ${iol_schema}.mims_yp_indexresult.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_indexresult.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_indexresult.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_indexresult.etl_timestamp is 'ETL处理时间戳';
