/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_iqp_loan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_iqp_loan_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_iqp_loan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_iqp_loan_info(
    serno varchar2(32) -- 流水号
    ,failreason varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,manageorg varchar2(10) -- 处理机构：总行、分行
    ,packageno varchar2(32) -- 批次包编号
    ,approvestatus varchar2(32) -- 分行审批状态
    ,inputuserid varchar2(64) -- 登记人
    ,applytype varchar2(64) -- 申请类型
    ,flowtype varchar2(64) -- 流程类型
    ,inputorgid varchar2(64) -- 登记机构
    ,managetype varchar2(10) -- 操作类型：新增01、后补02
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_zxz_iqp_loan_info to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_iqp_loan_info to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_loan_info to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_loan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_iqp_loan_info is '支小再申请信息表';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.serno is '流水号';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.failreason is '备注';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.manageorg is '处理机构：总行、分行';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.packageno is '批次包编号';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.approvestatus is '分行审批状态';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.applytype is '申请类型';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.flowtype is '流程类型';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.managetype is '操作类型：新增01、后补02';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_iqp_loan_info.etl_timestamp is 'ETL处理时间戳';
