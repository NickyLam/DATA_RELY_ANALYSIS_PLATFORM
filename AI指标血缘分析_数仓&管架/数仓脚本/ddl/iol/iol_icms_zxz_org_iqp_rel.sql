/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_org_iqp_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_org_iqp_rel
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_org_iqp_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_org_iqp_rel(
    serno_zh varchar2(32) -- 总行审批流水号
    ,serno_fh varchar2(32) -- 分行审批流水号
    ,approve_status varchar2(3) -- 总行审批状态
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
grant select on ${iol_schema}.icms_zxz_org_iqp_rel to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_org_iqp_rel to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_org_iqp_rel to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_org_iqp_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_org_iqp_rel is '支小再总行支行申请关系表';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.serno_zh is '总行审批流水号';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.serno_fh is '分行审批流水号';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.approve_status is '总行审批状态';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_org_iqp_rel.etl_timestamp is 'ETL处理时间戳';
