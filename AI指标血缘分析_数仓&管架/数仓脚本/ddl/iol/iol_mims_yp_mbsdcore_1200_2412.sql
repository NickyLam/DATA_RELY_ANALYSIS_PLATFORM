/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_mbsdcore_1200_2412
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_mbsdcore_1200_2412
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_mbsdcore_1200_2412 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_mbsdcore_1200_2412(
    sccode varchar2(48) -- 押品编号
    ,flag varchar2(3) -- 冻结标识
    ,confmamt number(20,2) -- 记账金额
    ,curreny varchar2(5) -- 币种
    ,inputorg varchar2(30) -- 记账机构
    ,pldgtp varchar2(3) -- 抵质押方式
    ,datasourceflag varchar2(6) -- 系统标识
    ,inacno varchar2(12) -- 记账内部户
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
grant select on ${iol_schema}.mims_yp_mbsdcore_1200_2412 to ${iml_schema};
grant select on ${iol_schema}.mims_yp_mbsdcore_1200_2412 to ${icl_schema};
grant select on ${iol_schema}.mims_yp_mbsdcore_1200_2412 to ${idl_schema};
grant select on ${iol_schema}.mims_yp_mbsdcore_1200_2412 to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_mbsdcore_1200_2412 is '核心记账记录表';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.flag is '冻结标识';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.confmamt is '记账金额';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.curreny is '币种';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.inputorg is '记账机构';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.pldgtp is '抵质押方式';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.datasourceflag is '系统标识';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.inacno is '记账内部户';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_mbsdcore_1200_2412.etl_timestamp is 'ETL处理时间戳';
