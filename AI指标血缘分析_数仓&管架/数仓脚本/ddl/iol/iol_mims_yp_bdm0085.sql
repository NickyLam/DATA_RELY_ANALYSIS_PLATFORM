/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_bdm0085
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_bdm0085
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_bdm0085 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_bdm0085(
    sccode varchar2(48) -- 押品编号
    ,collztnno varchar2(150) -- 信贷合同号
    ,bailaccount varchar2(60) -- 保证金号
    ,customerno varchar2(48) -- 客户号
    ,creditcustno varchar2(48) -- 授信占用方客户号
    ,collztntlrcd varchar2(48) -- 信贷客户经理柜员号
    ,collztnbranchid varchar2(48) -- 信贷客户经理所属机构名称
    ,swtbizid varchar2(150) -- 业务流水号
    ,flag varchar2(2) -- 冻结标识
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
grant select on ${iol_schema}.mims_yp_bdm0085 to ${iml_schema};
grant select on ${iol_schema}.mims_yp_bdm0085 to ${icl_schema};
grant select on ${iol_schema}.mims_yp_bdm0085 to ${idl_schema};
grant select on ${iol_schema}.mims_yp_bdm0085 to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_bdm0085 is '票据额度占用信息表';
comment on column ${iol_schema}.mims_yp_bdm0085.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_bdm0085.collztnno is '信贷合同号';
comment on column ${iol_schema}.mims_yp_bdm0085.bailaccount is '保证金号';
comment on column ${iol_schema}.mims_yp_bdm0085.customerno is '客户号';
comment on column ${iol_schema}.mims_yp_bdm0085.creditcustno is '授信占用方客户号';
comment on column ${iol_schema}.mims_yp_bdm0085.collztntlrcd is '信贷客户经理柜员号';
comment on column ${iol_schema}.mims_yp_bdm0085.collztnbranchid is '信贷客户经理所属机构名称';
comment on column ${iol_schema}.mims_yp_bdm0085.swtbizid is '业务流水号';
comment on column ${iol_schema}.mims_yp_bdm0085.flag is '冻结标识';
comment on column ${iol_schema}.mims_yp_bdm0085.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_bdm0085.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_bdm0085.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_bdm0085.etl_timestamp is 'ETL处理时间戳';
