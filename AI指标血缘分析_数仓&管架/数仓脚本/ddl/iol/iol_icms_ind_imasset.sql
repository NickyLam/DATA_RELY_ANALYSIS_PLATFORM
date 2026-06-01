/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_imasset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_imasset
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_imasset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_imasset(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,authdate date -- 认证时间
    ,assetdescribe varchar2(1000) -- 资产阐述
    ,authorg varchar2(160) -- 认证机构
    ,remark varchar2(1000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记时间
    ,assetname varchar2(160) -- 资产名称
    ,updateorgid varchar2(64) -- 更新机构
    ,uptodate date -- 统计截止日期
    ,updateuserid varchar2(64) -- 更新人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,assettype varchar2(36) -- 资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）
    ,evaluatevalue number(24,6) -- 评估价值
    ,corporgid varchar2(64) -- 法人机构编号
    ,certid varchar2(18) -- 证书编号
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_ind_imasset to ${iml_schema};
grant select on ${iol_schema}.icms_ind_imasset to ${icl_schema};
grant select on ${iol_schema}.icms_ind_imasset to ${idl_schema};
grant select on ${iol_schema}.icms_ind_imasset to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_imasset is '无形资产信息无形资产信息';
comment on column ${iol_schema}.icms_ind_imasset.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_imasset.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_imasset.authdate is '认证时间';
comment on column ${iol_schema}.icms_ind_imasset.assetdescribe is '资产阐述';
comment on column ${iol_schema}.icms_ind_imasset.authorg is '认证机构';
comment on column ${iol_schema}.icms_ind_imasset.remark is '备注';
comment on column ${iol_schema}.icms_ind_imasset.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_imasset.inputdate is '登记时间';
comment on column ${iol_schema}.icms_ind_imasset.assetname is '资产名称';
comment on column ${iol_schema}.icms_ind_imasset.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_imasset.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_imasset.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_imasset.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ind_imasset.assettype is '资产类型资产类型(（代码：1-专利权2-商标权3-著作权4-其他）';
comment on column ${iol_schema}.icms_ind_imasset.evaluatevalue is '评估价值';
comment on column ${iol_schema}.icms_ind_imasset.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_imasset.certid is '证书编号';
comment on column ${iol_schema}.icms_ind_imasset.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_imasset.updatedate is '更新时间';
comment on column ${iol_schema}.icms_ind_imasset.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_imasset.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_imasset.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_imasset.etl_timestamp is 'ETL处理时间戳';
