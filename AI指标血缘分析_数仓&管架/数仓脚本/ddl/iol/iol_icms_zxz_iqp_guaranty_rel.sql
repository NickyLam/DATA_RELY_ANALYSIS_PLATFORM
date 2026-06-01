/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_iqp_guaranty_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_iqp_guaranty_rel
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_iqp_guaranty_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_iqp_guaranty_rel(
    serialno varchar2(32) -- 流水号
    ,guarantyid varchar2(32) -- 抵质押物账号（抵质押合同号)
    ,serno varchar2(32) -- 申请流水号
    ,guarantytype varchar2(200) -- 抵质押物类型
    ,evaluatenetvalue number(24,6) -- 抵质押物金额（估值）
    ,packageno varchar2(32) -- 批次包编号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
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
grant select on ${iol_schema}.icms_zxz_iqp_guaranty_rel to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_iqp_guaranty_rel to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_guaranty_rel to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_guaranty_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_iqp_guaranty_rel is '支小再申请抵质押物关系表';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.serialno is '流水号';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.guarantyid is '抵质押物账号（抵质押合同号)';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.serno is '申请流水号';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.guarantytype is '抵质押物类型';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.evaluatenetvalue is '抵质押物金额（估值）';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.packageno is '批次包编号';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_iqp_guaranty_rel.etl_timestamp is 'ETL处理时间戳';
