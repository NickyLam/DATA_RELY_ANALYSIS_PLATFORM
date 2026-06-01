/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_rating_firm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_rating_firm
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_rating_firm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rating_firm(
    firm_id varchar2(24) -- 评级公司ID
    ,status varchar2(2) -- 状态
    ,firm_name_zh varchar2(96) -- 评级公司中文名
    ,firm_name_en varchar2(96) -- 评级公司英文名
    ,modify_date date -- 修改时间
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
grant select on ${iol_schema}.ctms_tbs_v_rating_firm to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_rating_firm to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rating_firm to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rating_firm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_rating_firm is '评级公司视图';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.firm_id is '评级公司ID';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.status is '状态';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.firm_name_zh is '评级公司中文名';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.firm_name_en is '评级公司英文名';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.modify_date is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_rating_firm.etl_timestamp is 'ETL处理时间戳';
