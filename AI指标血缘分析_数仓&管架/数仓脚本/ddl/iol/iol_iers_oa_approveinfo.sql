/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_oa_approveinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_oa_approveinfo
whenever sqlerror continue none;
drop table ${iol_schema}.iers_oa_approveinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_oa_approveinfo(
    rela_traninfo varchar2(4000) -- 
    ,pk_dept varchar2(300) -- 主键
    ,relation_info varchar2(4000) -- 
    ,rela_amount number(28,8) -- 
    ,rela_tranprise varchar2(4000) -- 
    ,pk_approveinfo varchar2(30) -- 主键
    ,dr number(10,0) -- 删除标志
    ,ts varchar2(29) -- 时间戳
    ,billno varchar2(4000) -- 单据号
    ,tradeopp varchar2(4000) -- 
    ,busicode varchar2(4000) -- 编码
    ,rela_amount_analyse varchar2(4000) -- 
    ,exist_bljl varchar2(4000) -- 
    ,exist_fljf varchar2(4000) -- 
    ,memo varchar2(4000) -- 助记码
    ,rela_tranflag varchar2(4000) -- 标志
    ,rela_balance_amount number(28,8) -- 余额
    ,user_code varchar2(3000) -- 用户编号
    ,user_id varchar2(3000) -- 用户pk
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
grant select on ${iol_schema}.iers_oa_approveinfo to ${iml_schema};
grant select on ${iol_schema}.iers_oa_approveinfo to ${icl_schema};
grant select on ${iol_schema}.iers_oa_approveinfo to ${idl_schema};
grant select on ${iol_schema}.iers_oa_approveinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_oa_approveinfo is '关联方审批单表';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_traninfo is '';
comment on column ${iol_schema}.iers_oa_approveinfo.pk_dept is '主键';
comment on column ${iol_schema}.iers_oa_approveinfo.relation_info is '';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_amount is '';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_tranprise is '';
comment on column ${iol_schema}.iers_oa_approveinfo.pk_approveinfo is '主键';
comment on column ${iol_schema}.iers_oa_approveinfo.dr is '删除标志';
comment on column ${iol_schema}.iers_oa_approveinfo.ts is '时间戳';
comment on column ${iol_schema}.iers_oa_approveinfo.billno is '单据号';
comment on column ${iol_schema}.iers_oa_approveinfo.tradeopp is '';
comment on column ${iol_schema}.iers_oa_approveinfo.busicode is '编码';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_amount_analyse is '';
comment on column ${iol_schema}.iers_oa_approveinfo.exist_bljl is '';
comment on column ${iol_schema}.iers_oa_approveinfo.exist_fljf is '';
comment on column ${iol_schema}.iers_oa_approveinfo.memo is '助记码';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_tranflag is '标志';
comment on column ${iol_schema}.iers_oa_approveinfo.rela_balance_amount is '余额';
comment on column ${iol_schema}.iers_oa_approveinfo.user_code is '用户编号';
comment on column ${iol_schema}.iers_oa_approveinfo.user_id is '用户pk';
comment on column ${iol_schema}.iers_oa_approveinfo.start_dt is '开始时间';
comment on column ${iol_schema}.iers_oa_approveinfo.end_dt is '结束时间';
comment on column ${iol_schema}.iers_oa_approveinfo.id_mark is '增删标志';
comment on column ${iol_schema}.iers_oa_approveinfo.etl_timestamp is 'ETL处理时间戳';
