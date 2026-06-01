/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbprdpublisher
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbprdpublisher
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbprdpublisher purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdpublisher(
    publisher_type varchar2(3) -- 发行人类型
    ,publisher_code varchar2(27) -- 发行人代码
    ,publisher_name varchar2(150) -- 发行人名称
    ,reserve1 varchar2(383) -- 备注1
    ,reserve2 varchar2(383) -- 备注2
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
grant select on ${iol_schema}.nfss_tbprdpublisher to ${iml_schema};
grant select on ${iol_schema}.nfss_tbprdpublisher to ${icl_schema};
grant select on ${iol_schema}.nfss_tbprdpublisher to ${idl_schema};
grant select on ${iol_schema}.nfss_tbprdpublisher to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbprdpublisher is '产品发行人表';
comment on column ${iol_schema}.nfss_tbprdpublisher.publisher_type is '发行人类型';
comment on column ${iol_schema}.nfss_tbprdpublisher.publisher_code is '发行人代码';
comment on column ${iol_schema}.nfss_tbprdpublisher.publisher_name is '发行人名称';
comment on column ${iol_schema}.nfss_tbprdpublisher.reserve1 is '备注1';
comment on column ${iol_schema}.nfss_tbprdpublisher.reserve2 is '备注2';
comment on column ${iol_schema}.nfss_tbprdpublisher.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbprdpublisher.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbprdpublisher.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbprdpublisher.etl_timestamp is 'ETL处理时间戳';
