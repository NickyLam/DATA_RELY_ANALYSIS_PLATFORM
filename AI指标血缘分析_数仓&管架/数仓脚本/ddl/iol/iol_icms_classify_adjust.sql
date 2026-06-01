/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_adjust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_adjust
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_adjust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_adjust(
    serialno varchar2(64) -- 流水号
    ,objecttype varchar2(64) -- 对象类型对象类型(合同/借据)
    ,productid varchar2(64) -- 业务品种
    ,adjustdate date -- 调整申请日期
    ,adjustapplyer varchar2(64) -- 调整申请人
    ,customername varchar2(200) -- 客户名称
    ,adjustorgid varchar2(64) -- 调整申请机构
    ,approvestatus varchar2(64) -- 审批状态
    ,operatedate date -- 经办日期
    ,inputdate date -- 登记日期
    ,adjusttype varchar2(36) -- 调整类型调整类型(分类结果调整/分类方式调整)
    ,belongdept varchar2(64) -- 所属条线
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,objectno varchar2(64) -- 对象编号借据编号（借据编号/合同编号）
    ,operateorgid varchar2(64) -- 经办机构
    ,customerid varchar2(16) -- 客户编号
    ,adjustreason varchar2(1000) -- 分类调整原因
    ,updateorgid varchar2(64) -- 更新机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,adjustclassifyresult varchar2(36) -- 调整分类结果
    ,currclassifytype varchar2(36) -- 当前分类方式
    ,updateuserid varchar2(64) -- 更新人
    ,adjustfinishdate date -- 认定完成时间
    ,accountmonth varchar2(64) -- 期次
    ,inputorgid varchar2(64) -- 登记机构
    ,relativeserialno varchar2(64) -- 原分类编号
    ,operateuserid varchar2(64) -- 经办人
    ,currclassifyresult varchar2(64) -- 当前分类结果
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
grant select on ${iol_schema}.icms_classify_adjust to ${iml_schema};
grant select on ${iol_schema}.icms_classify_adjust to ${icl_schema};
grant select on ${iol_schema}.icms_classify_adjust to ${idl_schema};
grant select on ${iol_schema}.icms_classify_adjust to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_adjust is '风险分类调整风险分类调整';
comment on column ${iol_schema}.icms_classify_adjust.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_adjust.objecttype is '对象类型对象类型(合同/借据)';
comment on column ${iol_schema}.icms_classify_adjust.productid is '业务品种';
comment on column ${iol_schema}.icms_classify_adjust.adjustdate is '调整申请日期';
comment on column ${iol_schema}.icms_classify_adjust.adjustapplyer is '调整申请人';
comment on column ${iol_schema}.icms_classify_adjust.customername is '客户名称';
comment on column ${iol_schema}.icms_classify_adjust.adjustorgid is '调整申请机构';
comment on column ${iol_schema}.icms_classify_adjust.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_classify_adjust.operatedate is '经办日期';
comment on column ${iol_schema}.icms_classify_adjust.inputdate is '登记日期';
comment on column ${iol_schema}.icms_classify_adjust.adjusttype is '调整类型调整类型(分类结果调整/分类方式调整)';
comment on column ${iol_schema}.icms_classify_adjust.belongdept is '所属条线';
comment on column ${iol_schema}.icms_classify_adjust.inputuserid is '登记人';
comment on column ${iol_schema}.icms_classify_adjust.updatedate is '更新日期';
comment on column ${iol_schema}.icms_classify_adjust.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_classify_adjust.objectno is '对象编号借据编号（借据编号/合同编号）';
comment on column ${iol_schema}.icms_classify_adjust.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_classify_adjust.customerid is '客户编号';
comment on column ${iol_schema}.icms_classify_adjust.adjustreason is '分类调整原因';
comment on column ${iol_schema}.icms_classify_adjust.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_classify_adjust.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_classify_adjust.adjustclassifyresult is '调整分类结果';
comment on column ${iol_schema}.icms_classify_adjust.currclassifytype is '当前分类方式';
comment on column ${iol_schema}.icms_classify_adjust.updateuserid is '更新人';
comment on column ${iol_schema}.icms_classify_adjust.adjustfinishdate is '认定完成时间';
comment on column ${iol_schema}.icms_classify_adjust.accountmonth is '期次';
comment on column ${iol_schema}.icms_classify_adjust.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_classify_adjust.relativeserialno is '原分类编号';
comment on column ${iol_schema}.icms_classify_adjust.operateuserid is '经办人';
comment on column ${iol_schema}.icms_classify_adjust.currclassifyresult is '当前分类结果';
comment on column ${iol_schema}.icms_classify_adjust.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_adjust.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_adjust.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_adjust.etl_timestamp is 'ETL处理时间戳';
