/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_house_deail_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_house_deail_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_house_deail_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_house_deail_list(
    serialno varchar2(32) -- 主键
    ,relativeserialno varchar2(33) -- 业务流水号
    ,houseamt number(17,2) -- 房产现值
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,houseaddr varchar2(500) -- 房产地址
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
grant select on ${iol_schema}.icms_fkd_house_deail_list to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_house_deail_list to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_house_deail_list to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_house_deail_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_house_deail_list is '房产明细列表';
comment on column ${iol_schema}.icms_fkd_house_deail_list.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_house_deail_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_house_deail_list.houseamt is '房产现值';
comment on column ${iol_schema}.icms_fkd_house_deail_list.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_fkd_house_deail_list.houseaddr is '房产地址';
comment on column ${iol_schema}.icms_fkd_house_deail_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_house_deail_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_house_deail_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_house_deail_list.etl_timestamp is 'ETL处理时间戳';
