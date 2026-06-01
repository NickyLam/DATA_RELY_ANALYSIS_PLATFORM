/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ty_otherlimit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ty_otherlimit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ty_otherlimit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ty_otherlimit_info(
    objecttype varchar2(32) -- 占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据
    ,objectno varchar2(32) -- 对象编号
    ,creditcontno varchar2(32) -- (他用额度的)额度合同号
    ,relacceptbankid varchar2(40) -- 银票贴现承兑行总行行号
    ,updateuserid varchar2(32) -- 更新员工编号
    ,acceptbankid varchar2(40) -- 银票贴现承兑行行号
    ,updateorgid varchar2(32) -- 更新机构编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputorgid varchar2(32) -- 新增机构编号
    ,businesstype varchar2(32) -- 业务合同的产品类型或押品类型
    ,inputuserid varchar2(32) -- 新增员工编号
    ,updatedate date -- 更新时间
    ,batchno varchar2(40) -- 银票贴现批次号
    ,relacceptbankcustid varchar2(40) -- 银票贴现承兑行总行行客户号
    ,inputdate date -- 新增时间
    ,relbusinesstype varchar2(32) -- 他用额度类型
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
grant select on ${iol_schema}.icms_ty_otherlimit_info to ${iml_schema};
grant select on ${iol_schema}.icms_ty_otherlimit_info to ${icl_schema};
grant select on ${iol_schema}.icms_ty_otherlimit_info to ${idl_schema};
grant select on ${iol_schema}.icms_ty_otherlimit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ty_otherlimit_info is '他用额度占用记录表';
comment on column ${iol_schema}.icms_ty_otherlimit_info.objecttype is '占用他用额度的业务对象：Guaranty-押品Contract-合同占用TXBill-银票贴现票据';
comment on column ${iol_schema}.icms_ty_otherlimit_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.creditcontno is '(他用额度的)额度合同号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.relacceptbankid is '银票贴现承兑行总行行号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.updateuserid is '更新员工编号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.acceptbankid is '银票贴现承兑行行号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ty_otherlimit_info.inputorgid is '新增机构编号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.businesstype is '业务合同的产品类型或押品类型';
comment on column ${iol_schema}.icms_ty_otherlimit_info.inputuserid is '新增员工编号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_ty_otherlimit_info.batchno is '银票贴现批次号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.relacceptbankcustid is '银票贴现承兑行总行行客户号';
comment on column ${iol_schema}.icms_ty_otherlimit_info.inputdate is '新增时间';
comment on column ${iol_schema}.icms_ty_otherlimit_info.relbusinesstype is '他用额度类型';
comment on column ${iol_schema}.icms_ty_otherlimit_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ty_otherlimit_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ty_otherlimit_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ty_otherlimit_info.etl_timestamp is 'ETL处理时间戳';
