/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_impoversee_detail_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_impoversee_detail_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_impoversee_detail_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_impoversee_detail_apply(
    serialno varchar2(64) -- 流水号
    ,exposurebalance number(24,6) -- 敞口余额
    ,updateuserid varchar2(64) -- 更新人
    ,inputdate date -- 登记时间
    ,approvecreditsum number(24,6) -- 批复额度
    ,creditmarutity date -- 额度到期日
    ,approveexposuresum number(24,6) -- 批复敞口
    ,creditcontractno varchar2(64) -- 额度合同编号
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,creditstartdate date -- 额度开始日期
    ,objecttype varchar2(64) -- 申请类型
    ,inputorgid varchar2(64) -- 登记机构
    ,impoverseeserialno varchar2(64) -- 监测流水号
    ,credittype varchar2(64) -- 额度品种
    ,usedbalance number(24,6) -- 使用余额
    ,updatedate date -- 更新时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_impoversee_detail_apply to ${iml_schema};
grant select on ${iol_schema}.icms_impoversee_detail_apply to ${icl_schema};
grant select on ${iol_schema}.icms_impoversee_detail_apply to ${idl_schema};
grant select on ${iol_schema}.icms_impoversee_detail_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_impoversee_detail_apply is '重点监测客户详情-授信信息';
comment on column ${iol_schema}.icms_impoversee_detail_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_impoversee_detail_apply.exposurebalance is '敞口余额';
comment on column ${iol_schema}.icms_impoversee_detail_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_impoversee_detail_apply.inputdate is '登记时间';
comment on column ${iol_schema}.icms_impoversee_detail_apply.approvecreditsum is '批复额度';
comment on column ${iol_schema}.icms_impoversee_detail_apply.creditmarutity is '额度到期日';
comment on column ${iol_schema}.icms_impoversee_detail_apply.approveexposuresum is '批复敞口';
comment on column ${iol_schema}.icms_impoversee_detail_apply.creditcontractno is '额度合同编号';
comment on column ${iol_schema}.icms_impoversee_detail_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_impoversee_detail_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_impoversee_detail_apply.creditstartdate is '额度开始日期';
comment on column ${iol_schema}.icms_impoversee_detail_apply.objecttype is '申请类型';
comment on column ${iol_schema}.icms_impoversee_detail_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_impoversee_detail_apply.impoverseeserialno is '监测流水号';
comment on column ${iol_schema}.icms_impoversee_detail_apply.credittype is '额度品种';
comment on column ${iol_schema}.icms_impoversee_detail_apply.usedbalance is '使用余额';
comment on column ${iol_schema}.icms_impoversee_detail_apply.updatedate is '更新时间';
comment on column ${iol_schema}.icms_impoversee_detail_apply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_impoversee_detail_apply.etl_timestamp is 'ETL处理时间戳';
