/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_guaranty_verify
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_guaranty_verify
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_guaranty_verify purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_verify(
    recordno varchar2(64) -- 记录编号
    ,verifier varchar2(64) -- 抵债资产核实人
    ,inputuserid varchar2(64) -- 登记人
    ,plandetailno varchar2(64) -- 收取抵债资产明细编号
    ,deleteflag varchar2(36) -- 删除标识
    ,buildingdate date -- 建成日期
    ,image varchar2(2000) -- 相关影像资料
    ,rightid varchar2(64) -- 权证号
    ,landtype varchar2(1000) -- 用地性质
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,scale number(18,2) -- 面积
    ,buildingstructure varchar2(1000) -- 建筑结构
    ,updateorgid varchar2(64) -- 更新机构
    ,treatystatus varchar2(36) -- 协议抵债日资产状态
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,location varchar2(1000) -- 抵债资产地址
    ,decisionstatus varchar2(36) -- 裁定抵债日资产状态
    ,remark varchar2(1000) -- 备注
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
grant select on ${iol_schema}.icms_ap_guaranty_verify to ${iml_schema};
grant select on ${iol_schema}.icms_ap_guaranty_verify to ${icl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_verify to ${idl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_verify to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_guaranty_verify is '抵债资产核实记录表';
comment on column ${iol_schema}.icms_ap_guaranty_verify.recordno is '记录编号';
comment on column ${iol_schema}.icms_ap_guaranty_verify.verifier is '抵债资产核实人';
comment on column ${iol_schema}.icms_ap_guaranty_verify.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_guaranty_verify.plandetailno is '收取抵债资产明细编号';
comment on column ${iol_schema}.icms_ap_guaranty_verify.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_guaranty_verify.buildingdate is '建成日期';
comment on column ${iol_schema}.icms_ap_guaranty_verify.image is '相关影像资料';
comment on column ${iol_schema}.icms_ap_guaranty_verify.rightid is '权证号';
comment on column ${iol_schema}.icms_ap_guaranty_verify.landtype is '用地性质';
comment on column ${iol_schema}.icms_ap_guaranty_verify.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_guaranty_verify.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_guaranty_verify.scale is '面积';
comment on column ${iol_schema}.icms_ap_guaranty_verify.buildingstructure is '建筑结构';
comment on column ${iol_schema}.icms_ap_guaranty_verify.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_guaranty_verify.treatystatus is '协议抵债日资产状态';
comment on column ${iol_schema}.icms_ap_guaranty_verify.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_guaranty_verify.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_guaranty_verify.location is '抵债资产地址';
comment on column ${iol_schema}.icms_ap_guaranty_verify.decisionstatus is '裁定抵债日资产状态';
comment on column ${iol_schema}.icms_ap_guaranty_verify.remark is '备注';
comment on column ${iol_schema}.icms_ap_guaranty_verify.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_guaranty_verify.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_guaranty_verify.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_guaranty_verify.etl_timestamp is 'ETL处理时间戳';
