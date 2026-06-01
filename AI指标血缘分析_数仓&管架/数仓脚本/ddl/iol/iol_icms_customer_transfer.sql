/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_transfer(
    serialno varchar2(64) -- 流水号
    ,affirmorgid varchar2(64) -- 确认机构
    ,operatetype varchar2(36) -- 操作类型
    ,customerid varchar2(16) -- 客户编号
    ,refusedate date -- 拒绝接收日期
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,righttype varchar2(36) -- 权限类型
    ,affirmdate date -- 确认日期
    ,transfertype varchar2(36) -- 转让状态
    ,updateorgid varchar2(64) -- 更新机构
    ,affirmuserid varchar2(64) -- 确认人
    ,remark varchar2(1000) -- 备注
    ,unoperatetype varchar2(36) -- 相反操作类型
    ,inputorgid varchar2(64) -- 登记机构
    ,receiveuserid varchar2(64) -- 接受用户号
    ,receiveorgid varchar2(64) -- 接受用户所属机构
    ,afrightflag varchar2(2) -- 业务管户权转移标志
    ,maintaintime date -- 维护权期限
    ,updateuserid varchar2(64) -- 更新人
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_customer_transfer to ${iml_schema};
grant select on ${iol_schema}.icms_customer_transfer to ${icl_schema};
grant select on ${iol_schema}.icms_customer_transfer to ${idl_schema};
grant select on ${iol_schema}.icms_customer_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_transfer is '客户转让信息表客户转让信息表';
comment on column ${iol_schema}.icms_customer_transfer.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_transfer.affirmorgid is '确认机构';
comment on column ${iol_schema}.icms_customer_transfer.operatetype is '操作类型';
comment on column ${iol_schema}.icms_customer_transfer.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_transfer.refusedate is '拒绝接收日期';
comment on column ${iol_schema}.icms_customer_transfer.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_transfer.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_transfer.righttype is '权限类型';
comment on column ${iol_schema}.icms_customer_transfer.affirmdate is '确认日期';
comment on column ${iol_schema}.icms_customer_transfer.transfertype is '转让状态';
comment on column ${iol_schema}.icms_customer_transfer.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_transfer.affirmuserid is '确认人';
comment on column ${iol_schema}.icms_customer_transfer.remark is '备注';
comment on column ${iol_schema}.icms_customer_transfer.unoperatetype is '相反操作类型';
comment on column ${iol_schema}.icms_customer_transfer.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_transfer.receiveuserid is '接受用户号';
comment on column ${iol_schema}.icms_customer_transfer.receiveorgid is '接受用户所属机构';
comment on column ${iol_schema}.icms_customer_transfer.afrightflag is '业务管户权转移标志';
comment on column ${iol_schema}.icms_customer_transfer.maintaintime is '维护权期限';
comment on column ${iol_schema}.icms_customer_transfer.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_transfer.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_transfer.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_transfer.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_transfer.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_transfer.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_transfer.etl_timestamp is 'ETL处理时间戳';
