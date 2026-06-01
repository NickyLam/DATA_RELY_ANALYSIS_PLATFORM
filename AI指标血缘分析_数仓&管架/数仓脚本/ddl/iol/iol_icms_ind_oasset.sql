/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_oasset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_oasset
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_oasset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_oasset(
    serialno varchar2(64) -- 流水号
    ,updateuserid varchar2(64) -- 更新人
    ,corporgid varchar2(64) -- 法人机构编号
    ,assetdescribe varchar2(1000) -- 资产描述
    ,updatedate date -- 更新日期
    ,remark varchar2(200) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,customerid varchar2(16) -- 客户编号
    ,assetvalue number(24,6) -- 价值金额
    ,migtflag varchar2(80) -- 
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,assettype varchar2(36) -- 资产类别资产类别（代码：1-现钞2-基金3-期货4-短期票券5-个人借贷(借出)6-遗产7-赠与8-赡养费9-收藏品10-家用电器11-家具12-其他）
    ,uptodate date -- 统计截止时间
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
grant select on ${iol_schema}.icms_ind_oasset to ${iml_schema};
grant select on ${iol_schema}.icms_ind_oasset to ${icl_schema};
grant select on ${iol_schema}.icms_ind_oasset to ${idl_schema};
grant select on ${iol_schema}.icms_ind_oasset to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_oasset is '其他资产情况其他资产情况';
comment on column ${iol_schema}.icms_ind_oasset.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_oasset.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_oasset.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_oasset.assetdescribe is '资产描述';
comment on column ${iol_schema}.icms_ind_oasset.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_oasset.remark is '备注';
comment on column ${iol_schema}.icms_ind_oasset.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_oasset.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_oasset.assetvalue is '价值金额';
comment on column ${iol_schema}.icms_ind_oasset.migtflag is '';
comment on column ${iol_schema}.icms_ind_oasset.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_oasset.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_oasset.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_oasset.assettype is '资产类别资产类别（代码：1-现钞2-基金3-期货4-短期票券5-个人借贷(借出)6-遗产7-赠与8-赡养费9-收藏品10-家用电器11-家具12-其他）';
comment on column ${iol_schema}.icms_ind_oasset.uptodate is '统计截止时间';
comment on column ${iol_schema}.icms_ind_oasset.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_oasset.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_oasset.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_oasset.etl_timestamp is 'ETL处理时间戳';
