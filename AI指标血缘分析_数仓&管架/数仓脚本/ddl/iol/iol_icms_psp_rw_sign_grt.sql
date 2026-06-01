/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_rw_sign_grt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_rw_sign_grt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_rw_sign_grt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rw_sign_grt(
    serno varchar2(32) -- 流水号
    ,evalamt number(16,2) -- 当时评估单价
    ,migtflag varchar2(80) -- 
    ,signserno varchar2(32) -- 风险预警信号流水号
    ,isfull varchar2(1) -- 现时是否足值
    ,buildamt number(16,2) -- 建构价款
    ,evalnetamt number(16,2) -- 当时评估净值
    ,gagename varchar2(120) -- 名称
    ,realamt number(16,2) -- 现时实际价值
    ,realrate number(16,4) -- 现时抵质押率
    ,floorarea number(16,2) -- 建筑面积
    ,grtaddr varchar2(80) -- 地址
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
grant select on ${iol_schema}.icms_psp_rw_sign_grt to ${iml_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_grt to ${icl_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_grt to ${idl_schema};
grant select on ${iol_schema}.icms_psp_rw_sign_grt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_rw_sign_grt is '风险预警信号抵质押物信息';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.serno is '流水号';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.evalamt is '当时评估单价';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.migtflag is '';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.signserno is '风险预警信号流水号';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.isfull is '现时是否足值';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.buildamt is '建构价款';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.evalnetamt is '当时评估净值';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.gagename is '名称';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.realamt is '现时实际价值';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.realrate is '现时抵质押率';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.floorarea is '建筑面积';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.grtaddr is '地址';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_rw_sign_grt.etl_timestamp is 'ETL处理时间戳';
