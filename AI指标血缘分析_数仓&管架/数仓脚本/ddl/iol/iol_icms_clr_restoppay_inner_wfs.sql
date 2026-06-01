/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_restoppay_inner_wfs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_restoppay_inner_wfs
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_restoppay_inner_wfs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_restoppay_inner_wfs(
    serialno varchar2(64) -- 解止付流水号
    ,approvestatus varchar2(10) -- 审批状态
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputtime date -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatetime date -- 更新时间
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,applytype varchar2(32) -- 申请类型
    ,remark varchar2(200) -- 备注
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
grant select on ${iol_schema}.icms_clr_restoppay_inner_wfs to ${iml_schema};
grant select on ${iol_schema}.icms_clr_restoppay_inner_wfs to ${icl_schema};
grant select on ${iol_schema}.icms_clr_restoppay_inner_wfs to ${idl_schema};
grant select on ${iol_schema}.icms_clr_restoppay_inner_wfs to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_restoppay_inner_wfs is '理财/存单解止付流程表';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.serialno is '解止付流水号';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.inputtime is '登记机构';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.updatetime is '更新时间';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.applytype is '申请类型';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.remark is '备注';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_restoppay_inner_wfs.etl_timestamp is 'ETL处理时间戳';
