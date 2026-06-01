/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_info_change_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_info_change_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_info_change_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_info_change_apply(
    serialno varchar2(32) -- 流水号
    ,inputorgid varchar2(12) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,certtype varchar2(36) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,indtype varchar2(36) -- 客户性质
    ,updatedate date -- 更新日期
    ,approvestatus varchar2(36) -- 审批状态
    ,completeflag varchar2(4) -- 九要素是否齐全
    ,manageuserid varchar2(64) -- 主办客户经理
    ,updateuserid varchar2(64) -- 更新人
    ,managerright varchar2(64) -- 客户权限
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,updateorgid varchar2(64) -- 更新机构
    ,customertype varchar2(18) -- 客户类型
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_ind_info_change_apply to ${iml_schema};
grant select on ${iol_schema}.icms_ind_info_change_apply to ${icl_schema};
grant select on ${iol_schema}.icms_ind_info_change_apply to ${idl_schema};
grant select on ${iol_schema}.icms_ind_info_change_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_info_change_apply is '个人客户信息维护申请表';
comment on column ${iol_schema}.icms_ind_info_change_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_info_change_apply.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ind_info_change_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_info_change_apply.certtype is '证件类型';
comment on column ${iol_schema}.icms_ind_info_change_apply.certid is '证件号码';
comment on column ${iol_schema}.icms_ind_info_change_apply.indtype is '客户性质';
comment on column ${iol_schema}.icms_ind_info_change_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_info_change_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ind_info_change_apply.completeflag is '九要素是否齐全';
comment on column ${iol_schema}.icms_ind_info_change_apply.manageuserid is '主办客户经理';
comment on column ${iol_schema}.icms_ind_info_change_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_info_change_apply.managerright is '客户权限';
comment on column ${iol_schema}.icms_ind_info_change_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_info_change_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_ind_info_change_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_info_change_apply.customertype is '客户类型';
comment on column ${iol_schema}.icms_ind_info_change_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_info_change_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_info_change_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_info_change_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_info_change_apply.etl_timestamp is 'ETL处理时间戳';
