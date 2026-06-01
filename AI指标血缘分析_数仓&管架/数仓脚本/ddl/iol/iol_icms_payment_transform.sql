/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_payment_transform
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_payment_transform
whenever sqlerror continue none;
drop table ${iol_schema}.icms_payment_transform purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_transform(
    serialno varchar2(32) -- 支付清单变更申请流水号
    ,inputorgid varchar2(32) -- 登记机构
    ,entrustedsealno varchar2(4000) -- 受托变更验印编号（用分割）
    ,transtatus varchar2(20) -- 新增时交易执行状态:null-未执行done-已执行
    ,inputuserid varchar2(8) -- 登记人
    ,putoutserialno varchar2(32) -- 关联的出账流水号
    ,objecttype varchar2(32) -- 对象类型
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,operateuserid varchar2(32) -- 经办人
    ,operatedate date -- 经办日期
    ,operateorgid varchar2(32) -- 经办机构
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_payment_transform to ${iml_schema};
grant select on ${iol_schema}.icms_payment_transform to ${icl_schema};
grant select on ${iol_schema}.icms_payment_transform to ${idl_schema};
grant select on ${iol_schema}.icms_payment_transform to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_payment_transform is '支付清单变更申请表';
comment on column ${iol_schema}.icms_payment_transform.serialno is '支付清单变更申请流水号';
comment on column ${iol_schema}.icms_payment_transform.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_payment_transform.entrustedsealno is '受托变更验印编号（用分割）';
comment on column ${iol_schema}.icms_payment_transform.transtatus is '新增时交易执行状态:null-未执行done-已执行';
comment on column ${iol_schema}.icms_payment_transform.inputuserid is '登记人';
comment on column ${iol_schema}.icms_payment_transform.putoutserialno is '关联的出账流水号';
comment on column ${iol_schema}.icms_payment_transform.objecttype is '对象类型';
comment on column ${iol_schema}.icms_payment_transform.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_payment_transform.operateuserid is '经办人';
comment on column ${iol_schema}.icms_payment_transform.operatedate is '经办日期';
comment on column ${iol_schema}.icms_payment_transform.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_payment_transform.inputdate is '登记日期';
comment on column ${iol_schema}.icms_payment_transform.start_dt is '开始时间';
comment on column ${iol_schema}.icms_payment_transform.end_dt is '结束时间';
comment on column ${iol_schema}.icms_payment_transform.id_mark is '增删标志';
comment on column ${iol_schema}.icms_payment_transform.etl_timestamp is 'ETL处理时间戳';
