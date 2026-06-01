/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_iqp_bill_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_iqp_bill_rel
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_iqp_bill_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_iqp_bill_rel(
    serno varchar2(32) -- 审批流水号
    ,billno varchar2(32) -- 借据号
    ,packageno varchar2(32) -- 批次包编号
    ,inpoolflag varchar2(2) -- 入池标识：申请： 1二级批次包： 2后补 3
    ,inpoolorgid varchar2(64) -- 入池机构 01：总行 02：分行 与码值OrgLevel保持一致
    ,practicalstartdate date -- 实际贷款发放日期
    ,practicalenddate date -- 实际贷款终止日期
    ,loandtype varchar2(10) -- 贷款划型
    ,compsize varchar2(10) -- 企业规模
    ,operreve number(24,6) -- 上年末营业收入(元)
    ,totalassets number(24,6) -- 资产总额(元)
    ,workersnum number(22) -- 企业人数
    ,executerate number(24,8) -- 执行年利率(%)
    ,purpose varchar2(200) -- 贷款用途
    ,zxzindustry varchar2(36) -- 支小再所属行业
    ,remark varchar2(2000) -- 备注
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,economiccertid varchar2(32) -- 经营主体信用代码
    ,zxzmapindustry varchar2(10) -- 支小再所属行业（映射给下游使用）
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
grant select on ${iol_schema}.icms_zxz_iqp_bill_rel to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_iqp_bill_rel to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_bill_rel to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_iqp_bill_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_iqp_bill_rel is '支小再申请借据关联关系表';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.serno is '审批流水号';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.billno is '借据号';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.packageno is '批次包编号';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.inpoolflag is '入池标识：申请： 1二级批次包： 2后补 3';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.inpoolorgid is '入池机构 01：总行 02：分行 与码值OrgLevel保持一致';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.practicalstartdate is '实际贷款发放日期';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.practicalenddate is '实际贷款终止日期';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.loandtype is '贷款划型';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.compsize is '企业规模';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.operreve is '上年末营业收入(元)';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.totalassets is '资产总额(元)';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.workersnum is '企业人数';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.executerate is '执行年利率(%)';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.purpose is '贷款用途';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.zxzindustry is '支小再所属行业';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.remark is '备注';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.economiccertid is '经营主体信用代码';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.zxzmapindustry is '支小再所属行业（映射给下游使用）';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_iqp_bill_rel.etl_timestamp is 'ETL处理时间戳';
