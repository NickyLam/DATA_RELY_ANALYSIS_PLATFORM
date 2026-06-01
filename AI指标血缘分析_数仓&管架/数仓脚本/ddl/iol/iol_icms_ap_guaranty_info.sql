/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_guaranty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_guaranty_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_guaranty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_info(
    guarantyid varchar2(64) -- 抵债资产编号
    ,guarantytype varchar2(36) -- 抵债物类型
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,evalorgid varchar2(64) -- 评估公司ID
    ,guarantymanager varchar2(1000) -- 抵债资产管理人
    ,guarantyownerid varchar2(64) -- 抵债资产所有人ID
    ,firstevalorgid varchar2(64) -- 授信时评估公司ID
    ,debtassetstatus varchar2(36) -- 抵债资产状态
    ,evalorgname varchar2(400) -- 评估公司名称
    ,firstevalcurrency varchar2(3) -- 授信时评估币种
    ,evaldate varchar2(64) -- 评估日期
    ,evalcurrency varchar2(3) -- 评估币种
    ,tmsp varchar2(64) -- 时间戳
    ,deleteflag varchar2(12) -- 删除标志
    ,guapreparesum number(24,6) -- 抵债资产的减值准备
    ,guaacctsum number(24,6) -- 抵债资产入账价值
    ,firstevalorgname varchar2(400) -- 授信时评估公司名称
    ,updateorgid varchar2(64) -- 更新机构
    ,guarantyname varchar2(1000) -- 抵债资产名称
    ,guarantylist varchar2(160) -- 押品细类
    ,guarantylocation varchar2(2000) -- 抵债资产存放地点
    ,guarantymanagerid varchar2(64) -- 抵债资产管理人ID
    ,transferflag varchar2(12) -- 是否已经过户
    ,guarantyvalue number(24,6) -- 抵债资产价值
    ,guarantyrightid varchar2(1000) -- 产权证书编号
    ,assetsource varchar2(36) -- 抵债资产来源
    ,guadebitsum number(24,6) -- 回收抵债资产金额
    ,resourcesystem varchar2(36) -- 数据来源系统
    ,quickcashprice number(24,6) -- 快速变现价
    ,guarantybalance number(24,6) -- 抵债资产余额
    ,updatedate varchar2(64) -- 更新时间
    ,subjectno varchar2(64) -- 抵债资产入账科目
    ,guarantyownername varchar2(1000) -- 抵债资产所有人
    ,evalvalue number(24,6) -- 评估价值
    ,payedvalue number(24,6) -- 抵债金额
    ,guarantycondition varchar2(1000) -- 抵债资产目前的状况
    ,inputdate varchar2(64) -- 登记时间
    ,assetcategory varchar2(36) -- 资产分类
    ,firstevalvalue number(24,6) -- 授信时评估价值
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
grant select on ${iol_schema}.icms_ap_guaranty_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_guaranty_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_guaranty_info is '抵债资产信息表';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyid is '抵债资产编号';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantytype is '抵债物类型';
comment on column ${iol_schema}.icms_ap_guaranty_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_guaranty_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_guaranty_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_guaranty_info.evalorgid is '评估公司ID';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantymanager is '抵债资产管理人';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyownerid is '抵债资产所有人ID';
comment on column ${iol_schema}.icms_ap_guaranty_info.firstevalorgid is '授信时评估公司ID';
comment on column ${iol_schema}.icms_ap_guaranty_info.debtassetstatus is '抵债资产状态';
comment on column ${iol_schema}.icms_ap_guaranty_info.evalorgname is '评估公司名称';
comment on column ${iol_schema}.icms_ap_guaranty_info.firstevalcurrency is '授信时评估币种';
comment on column ${iol_schema}.icms_ap_guaranty_info.evaldate is '评估日期';
comment on column ${iol_schema}.icms_ap_guaranty_info.evalcurrency is '评估币种';
comment on column ${iol_schema}.icms_ap_guaranty_info.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_guaranty_info.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_guaranty_info.guapreparesum is '抵债资产的减值准备';
comment on column ${iol_schema}.icms_ap_guaranty_info.guaacctsum is '抵债资产入账价值';
comment on column ${iol_schema}.icms_ap_guaranty_info.firstevalorgname is '授信时评估公司名称';
comment on column ${iol_schema}.icms_ap_guaranty_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyname is '抵债资产名称';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantylist is '押品细类';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantylocation is '抵债资产存放地点';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantymanagerid is '抵债资产管理人ID';
comment on column ${iol_schema}.icms_ap_guaranty_info.transferflag is '是否已经过户';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyvalue is '抵债资产价值';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyrightid is '产权证书编号';
comment on column ${iol_schema}.icms_ap_guaranty_info.assetsource is '抵债资产来源';
comment on column ${iol_schema}.icms_ap_guaranty_info.guadebitsum is '回收抵债资产金额';
comment on column ${iol_schema}.icms_ap_guaranty_info.resourcesystem is '数据来源系统';
comment on column ${iol_schema}.icms_ap_guaranty_info.quickcashprice is '快速变现价';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantybalance is '抵债资产余额';
comment on column ${iol_schema}.icms_ap_guaranty_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_ap_guaranty_info.subjectno is '抵债资产入账科目';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantyownername is '抵债资产所有人';
comment on column ${iol_schema}.icms_ap_guaranty_info.evalvalue is '评估价值';
comment on column ${iol_schema}.icms_ap_guaranty_info.payedvalue is '抵债金额';
comment on column ${iol_schema}.icms_ap_guaranty_info.guarantycondition is '抵债资产目前的状况';
comment on column ${iol_schema}.icms_ap_guaranty_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_ap_guaranty_info.assetcategory is '资产分类';
comment on column ${iol_schema}.icms_ap_guaranty_info.firstevalvalue is '授信时评估价值';
comment on column ${iol_schema}.icms_ap_guaranty_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_guaranty_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_guaranty_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_guaranty_info.etl_timestamp is 'ETL处理时间戳';
