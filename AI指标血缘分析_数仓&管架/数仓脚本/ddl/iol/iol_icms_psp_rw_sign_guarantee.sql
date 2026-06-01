/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_rw_sign_guarantee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_rw_sign_guarantee
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rw_sign_guarantee(
    serno varchar2(32) -- 流水号
    ,sign_serno varchar2(32) -- 预警信号流水号
    ,main_business varchar2(100) -- 主营业务
    ,credit_desc varchar2(200) -- 当前授信情况
    ,migtflag varchar2(80) -- 
    ,borrower_relation varchar2(5) -- 与授信人关系
    ,cus_name varchar2(200) -- 保证人名称
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
grant select on ${iol_schema}.icms_psp_rw_sign_guarantee to ${iml_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_guarantee to ${icl_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_guarantee to ${idl_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_guarantee to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_rw_sign_guarantee is '风险预警信号保证人信息';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.serno is '流水号';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.sign_serno is '预警信号流水号';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.main_business is '主营业务';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.credit_desc is '当前授信情况';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.migtflag is '';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.borrower_relation is '与授信人关系';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.cus_name is '保证人名称';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_rw_sign_guarantee.etl_timestamp is 'ETL处理时间戳';
