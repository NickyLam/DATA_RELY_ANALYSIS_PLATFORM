/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_accountingsubjecta
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_accountingsubjecta
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_accountingsubjecta purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_accountingsubjecta(
    accountingsubjecta_id number -- 自定义会计科目ID
    ,aspclient_id number -- 机构ID
    ,accountingcode varchar2(150) -- 会计科目层次码
    ,accountingdesc varchar2(300) -- 会计科目名称
    ,iseditable varchar2(2) -- 是否可编辑
    ,accountingsubjecta_id_parent number -- 父自定义会计科目ID
    ,lastmodified timestamp -- 最后修改时间
    ,controlfactor varchar2(15) -- 科目属性
    ,tax_rate number -- 税率
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
grant select on ${iol_schema}.ctms_tbs_v_accountingsubjecta to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_accountingsubjecta to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_accountingsubjecta to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_accountingsubjecta to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_accountingsubjecta is '自定义会计科目';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.accountingsubjecta_id is '自定义会计科目ID';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.aspclient_id is '机构ID';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.accountingcode is '会计科目层次码';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.accountingdesc is '会计科目名称';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.iseditable is '是否可编辑';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.accountingsubjecta_id_parent is '父自定义会计科目ID';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.controlfactor is '科目属性';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.tax_rate is '税率';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_accountingsubjecta.etl_timestamp is 'ETL处理时间戳';
