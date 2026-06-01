/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lg_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lg_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lg_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lg_info(
    serialno varchar2(32) -- 流水号
    ,objecttype varchar2(32) -- 对象类型
    ,objectno varchar2(18) -- 对象编号
    ,guaramt number(20,6) -- 担保金额
    ,inputuserid varchar2(32) -- 登记人
    ,lgtype varchar2(18) -- 保函类型
    ,beneficiary varchar2(120) -- 受益人
    ,maturity varchar2(10) -- 到期日期
    ,term varchar2(80) -- 期限
    ,inputdate varchar2(10) -- 登记日期
    ,lgcurrency varchar2(18) -- 币种
    ,lgsum number(24,6) -- 金额
    ,updatedate varchar2(10) -- 更新日期
    ,issueorgname varchar2(200) -- 担保机构名称
    ,issuebank varchar2(80) -- 开立银行
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,issueorgtype varchar2(10) -- 担保机构类型
    ,purpose varchar2(200) -- 用途
    ,remark varchar2(200) -- 备注
    ,lgno varchar2(32) -- 保函号码
    ,applicant varchar2(80) -- 申请人
    ,writedate varchar2(10) -- 开立日期
    ,inputorgid varchar2(32) -- 登记机构
    ,otherpromise varchar2(150) -- 其他约定
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
grant select on ${iol_schema}.icms_lg_info to ${iml_schema};
grant select on ${iol_schema}.icms_lg_info to ${icl_schema};
grant select on ${iol_schema}.icms_lg_info to ${idl_schema};
grant select on ${iol_schema}.icms_lg_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lg_info is '保函信息';
comment on column ${iol_schema}.icms_lg_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lg_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_lg_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_lg_info.guaramt is '担保金额';
comment on column ${iol_schema}.icms_lg_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lg_info.lgtype is '保函类型';
comment on column ${iol_schema}.icms_lg_info.beneficiary is '受益人';
comment on column ${iol_schema}.icms_lg_info.maturity is '到期日期';
comment on column ${iol_schema}.icms_lg_info.term is '期限';
comment on column ${iol_schema}.icms_lg_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lg_info.lgcurrency is '币种';
comment on column ${iol_schema}.icms_lg_info.lgsum is '金额';
comment on column ${iol_schema}.icms_lg_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lg_info.issueorgname is '担保机构名称';
comment on column ${iol_schema}.icms_lg_info.issuebank is '开立银行';
comment on column ${iol_schema}.icms_lg_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_lg_info.issueorgtype is '担保机构类型';
comment on column ${iol_schema}.icms_lg_info.purpose is '用途';
comment on column ${iol_schema}.icms_lg_info.remark is '备注';
comment on column ${iol_schema}.icms_lg_info.lgno is '保函号码';
comment on column ${iol_schema}.icms_lg_info.applicant is '申请人';
comment on column ${iol_schema}.icms_lg_info.writedate is '开立日期';
comment on column ${iol_schema}.icms_lg_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lg_info.otherpromise is '其他约定';
comment on column ${iol_schema}.icms_lg_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lg_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lg_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lg_info.etl_timestamp is 'ETL处理时间戳';
