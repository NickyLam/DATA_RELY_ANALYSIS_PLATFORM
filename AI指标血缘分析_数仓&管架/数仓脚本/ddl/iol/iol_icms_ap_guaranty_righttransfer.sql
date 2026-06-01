/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_guaranty_righttransfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_guaranty_righttransfer
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_righttransfer(
    recordno varchar2(64) -- 记录编号
    ,rightname varchar2(160) -- 过户后权证名称
    ,updateorgid varchar2(64) -- 更新机构
    ,custodian varchar2(160) -- 权证保管机构
    ,updateuserid varchar2(64) -- 更新人
    ,guarantyid varchar2(64) -- 抵债资产编号
    ,transferflag varchar2(12) -- 是否办理权属转移过户）手续
    ,rightid varchar2(64) -- 过户后权证编号
    ,inputorgid varchar2(64) -- 登记机构
    ,ownername varchar2(160) -- 过户后所有权人名称
    ,remark varchar2(1000) -- 备注
    ,updatedate date -- 更新日期
    ,rightdate date -- 取得权证日期
    ,objectno varchar2(64) -- 对象编号
    ,condition1 varchar2(2000) -- 办理权属转移过户）手续的情况
    ,transorgid varchar2(160) -- 过户登记机构
    ,transdate date -- 过户登记日期
    ,objecttype varchar2(64) -- 对象类型
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,deleteflag varchar2(12) -- 删除标识
    ,tempsaveflag varchar2(12) -- 暂存标记
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
grant select on ${iol_schema}.icms_ap_guaranty_righttransfer to ${iml_schema};
grant select on ${iol_schema}.icms_ap_guaranty_righttransfer to ${icl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_righttransfer to ${idl_schema};
grant select on ${iol_schema}.icms_ap_guaranty_righttransfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_guaranty_righttransfer is '权属转移信息记录表';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.recordno is '记录编号';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.rightname is '过户后权证名称';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.custodian is '权证保管机构';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.guarantyid is '抵债资产编号';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.transferflag is '是否办理权属转移过户）手续';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.rightid is '过户后权证编号';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.ownername is '过户后所有权人名称';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.remark is '备注';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.rightdate is '取得权证日期';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.objectno is '对象编号';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.condition1 is '办理权属转移过户）手续的情况';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.transorgid is '过户登记机构';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.transdate is '过户登记日期';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.objecttype is '对象类型';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.tempsaveflag is '暂存标记';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_guaranty_righttransfer.etl_timestamp is 'ETL处理时间戳';
